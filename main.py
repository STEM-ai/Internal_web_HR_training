import os
from dotenv import load_dotenv
from fastapi import FastAPI, Request
import uvicorn
from langchain_openai import ChatOpenAI
from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_openai import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain_core.runnables import RunnablePassthrough

# Load environment variables
load_dotenv()

# Set up the language model (using GPT-3.5-turbo)
llm = ChatOpenAI(model="gpt-3.5-turbo", temperature=0)


# Function to load and ingest documents
def ingest_docs():
    loader = UnstructuredPDFLoader("docs/Solar_guide.pdf")
    docs = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000,
                                                   chunk_overlap=200)
    chunks = text_splitter.split_documents(docs)

    vectorstore = FAISS.from_documents(documents=chunks,
                                       embedding=OpenAIEmbeddings())
    vectorstore.save_local("faiss_vector_db")
    print("Document successfully ingested into knowledge base")


if not os.path.isdir("faiss_vector_db"):
    print("Vector database not found. Ingesting documents...")
    ingest_docs()

vectorstore = FAISS.load_local("faiss_vector_db",
                               OpenAIEmbeddings(),
                               allow_dangerous_deserialization=True)
retriever = vectorstore.as_retriever()

# Initialize FastAPI application
app = FastAPI(
    title="LangChain Server with Knowledge Base",
    version="1.0",
    description=
    "A knowledge-based API server using LangChain and Solar Guide as a knowledge source",
)

# Define the persona/behavior prompt
persona_prompt = (
    "You are an expert on solar energy systems and installations from Kay Soley"
    "Your responses from questions should be detailed, convincing, brief and aligned with Kay Soley's informations."
    "If asked questions beyond the Solar Guide, provide advice that is consistent with best practices in the industry."
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
