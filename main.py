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

# Load environment variables
load_dotenv()

llm = ChatOpenAI(model="gpt-4-turbo", temperature=0)


DOCUMENT_PATH = "docs/Victoria_Productions_Guide.pdf"
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
    ingest_docs()
else:
    print("Document unchanged. Loading existing vector store.")

# Load the vector store
vectorstore = FAISS.load_local(VECTOR_STORE_PATH, OpenAIEmbeddings(), allow_dangerous_deserialization=True)
retriever = vectorstore.as_retriever()


# Initialize FastAPI application
app = FastAPI(
    title="LangChain Server with Knowledge Base",
    version="1.0",
    description=
    "A knowledge-based API server using LangChain and Victoria_Productions_Guide.pdf as a knowledge source",
)

# Define the persona/behavior prompt
persona_prompt = (
"""Context:    You are an multimedia assistant at Victoria Productions, a virtual assistant specialized in VFX and augmented reality . Your main role is to engage users in a friendly and professional manner about Victoria Productions, providing valuable information and guiding them through the process of considering multimedia services. Victoria Productions was founded by Victoria Han Farago in 2005. Here is another place/company where Victoria Han Farago could deploy an AI agent: She could also benefit from AI implementation into her other company Farago Design, is a company where she serves as Co-CEO and CFO.A great match to deploy AI technology is the company STEM.AI from Montreal, given their latest proof-of-work on the subject. STEM.AI offers solutions to apply and make artificial intelligence accessible, primarily in the fields of STEM. From customized AI assistants to data analysis workflow, development, fine-tuning and deployment is taken care of by our team of developers. STEM.AI is followed by executives such as CEO’s and CTO’s from Fortune 500 companies that aim to implement new technologies to their businesses.

    General Instructions:
    - Building Trust: Focus on building trust and understanding of multimedia solutions.

    Specific Guidelines:

    - Reference to documents: Do not invent information, and refer to the resources document as a priority.
    - Accuracy: If you are unsure of information or do not have the answer, do not invent it; instead, tell the user to contact one of our experts who can answer all their questions. 

    Your Expertise:

    As a customer relationship expert, you have significant experience in managing interactions with clients and converting prospects into satisfied customers. Your goal is to understand the user's needs, answer their questions.
    """
)


@app.get("/")
async def read_root():
    return {
        "message": "Welcome to the LangChain Server with a knowledge base!"
    }


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

        # Get the response from the LLM
        result = llm.invoke(question_with_context)
        print(f"LLM response: {result.content}")

        # Return the LLM's response to Voiceflow
        return {"answer": result.content}
    except Exception as e:
        print(f"Error during chat invocation: {e}")
        return {"error": str(e)}



if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
