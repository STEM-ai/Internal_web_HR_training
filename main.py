import os
from dotenv import load_dotenv
from fastapi import FastAPI, Request
import uvicorn
import hashlib
from langchain_openai import ChatOpenAI
from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_openai import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_core.runnables import RunnablePassthrough
from langchain.chains.conversation.memory import ConversationBufferMemory
from langchain.chains import ConversationChain
import asyncio
import logging

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

DOCUMENT_PATH = "docs/Template_pitch.pdf"
HASH_FILE = "document_hash.txt"
VECTOR_STORE_PATH = "faiss_vector_db"

# Function to calculate the hash of the document
def calculate_file_hash(filepath):
    hash_algo = hashlib.sha256()
    with open(filepath, 'rb') as file:
        while chunk := file.read(8192):
            hash_algo.update(chunk)
    return hash_algo.hexdigest()

# Function to check if the document has changed
def document_changed():
    new_hash = calculate_file_hash(DOCUMENT_PATH)

    if os.path.exists(HASH_FILE):
        with open(HASH_FILE, 'r') as f:
            old_hash = f.read()

        if new_hash == old_hash:
            return False  # Document hasn't changed

    # Document has changed or HASH_FILE doesn't exist
    with open(HASH_FILE, 'w') as f:
        f.write(new_hash)

    return True

# Function to load and ingest documents
def ingest_docs():
    loader = UnstructuredPDFLoader(DOCUMENT_PATH)
    docs = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
    chunks = text_splitter.split_documents(docs)

    # Create or overwrite the vector store
    vectorstore = FAISS.from_documents(documents=chunks, embedding=OpenAIEmbeddings())
    vectorstore.save_local(VECTOR_STORE_PATH)
    print("Document successfully ingested into knowledge base")

# Check if document has changed and ingest if needed
if document_changed():
    print("Document changed. Ingesting new document...")
    conversation_memory.clear()
    ingest_docs()
else:
    print("Document unchanged. Loading existing vector store.")

# Load the vector store
vectorstore = FAISS.load_local(VECTOR_STORE_PATH, OpenAIEmbeddings(), allow_dangerous_deserialization=True)
retriever = vectorstore.as_retriever()

# Initialize Conversation Buffer Memory
conversation_memory = ConversationBufferMemory()

# Initialize the Conversation Chain with memory
conversation_chain = ConversationChain(
    llm=llm,
    memory=conversation_memory,
)

# Initialize FastAPI application
app = FastAPI(
    title="LangChain Server with Knowledge Base",
    version="1.0",
    description="A knowledge-based API server using LangChain and Victoria_Productions_Guide.pdf as a knowledge source",
)

# Define the persona/behavior prompt
persona_prompt = ("""Context: You are a virtual assistant at Vocality, a company specializing in developing AI-driven communication tools for individuals with speech or language disorders. Answer in the same language that the user uses. Your main role is to engage users in a friendly and professional manner, providing valuable information about Vocality’s solutions and guiding them through understanding how the app can meet their specific needs, by answering with short and concise answers.
    General Instructions:
    - Building Trust: Focus on building trust by explaining Vocality’s expertise in AI-powered communication tools and their mission to enhance communication for those with disabilities.
    - Compassion and Clarity: Be empathetic, as the users or their loved ones may be dealing with communication challenges. Your answers should be clear, concise, and supportive.
    Specific Guidelines:
    - Reference to Documents: Do not invent information; refer to Vocality’s app features, technology, or research when answering questions.
    - Accuracy: If unsure of information or lacking details, encourage the user to contact Vocality’s expert team for more precise assistance.
    Your Expertise:
    As a customer support expert, you have experience managing interactions with clients facing communication difficulties. Your goal is to understand the user's specific challenges, highlight how Vocality’s AI solutions can help, and ensure they feel supported and informed throughout their experience.
    """)


@app.get("/")
async def read_root():
    return {
        "message": "Welcome to the LangChain Server with a knowledge base!"
    }

# Function to reset conversation memory
def reset_conversation_memory():
    global conversation_memory
    conversation_memory.clear()
    logger.info("Conversation memory has been cleared.")

# Background task to reset conversation memory every 20 minutes
async def periodic_memory_reset():
    while True:
        await asyncio.sleep(20 * 60)  # Wait for 20 minutes
        reset_conversation_memory()

@app.on_event("startup")
async def startup_event():
    # Start the background task when the FastAPI app starts
    asyncio.create_task(periodic_memory_reset())
    logger.info("Started background task to reset conversation memory every 20 minutes.")


@app.post("/chat")
async def chat(request: Request):
    input_data = await request.json()
    input_text = input_data.get("input")

    if not input_text:
        return {"error": "No input provided"}

    print(f"Query received: {input_text}")

    try:
        # Retrieve relevant knowledge from the vectorstore
        context = retriever.get_relevant_documents(input_text)
        context_text = "\n\n".join([doc.page_content for doc in context])

        # Print the context_text for debugging
        print(f"Context retrieved: {context_text}")

        # Combine the persona prompt, context, and user query
        question_with_context = f"{persona_prompt}\n\nContext:\n{context_text}\n\nQuestion: {input_text}"

        # Get the response from the LLM using the conversation chain
        result = conversation_chain.run(question_with_context)
        print(f"LLM response: {result}")

        # Return the LLM's response
        return {"answer": result}
    except Exception as e:
        print(f"Error during chat invocation: {e}")
        return {"error": str(e)}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
