import os
import asyncio
import hashlib
import logging
import uuid  # For generating unique session IDs
import time
from dotenv import load_dotenv
from fastapi import FastAPI, Form, Request, UploadFile, File, Response
from fastapi.templating import Jinja2Templates
from fastapi.staticfiles import StaticFiles
from fastapi.responses import HTMLResponse, RedirectResponse
from fastapi.exceptions import HTTPException
from pydantic import BaseModel
import uvicorn
from langchain_openai import ChatOpenAI
from langchain_community.document_loaders import UnstructuredPDFLoader
from langchain_openai import OpenAIEmbeddings
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_community.vectorstores import FAISS
from langchain.chains.conversation.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

DOCUMENT_PATH = "docs/Template_pitch.pdf"
HASH_FILE = "document_hash.txt"
VECTOR_STORE_PATH = "faiss_vector_db"

# Password for security
PASSWORD = "test" #PASSWORD = os.getenv('ACCESS_PASSWORD', 'securepassword') # = test

# Store conversation memories and last active time keyed by session_id
session_memories = {}
last_active_time = {}

persona_prompt = (
    "You are a friendly representative of Kay Soley, knowledgeable about solar energy. Answer in the same language as the user. Don't say Hello. Your goal is to engage in a natural conversation, and answer based on the Solar Guide any questions the user may have. Do not ask for personal information at this stage.\n If a question cannot be asnwered by the content of the Solar Guide, say that you are unsure and that the user should ask this question to one of our Technicians during a telephone or home appointment.\n Clarity and Conciseness: Use bullet points or numbered lists for clarity in your responses, and keep responses concise, limited to 2-3 sentences."
)

UPLOAD_DIRECTORY = "temp_files"

if not os.path.exists(UPLOAD_DIRECTORY):
    os.makedirs(UPLOAD_DIRECTORY)

# Function to calculate file hash
def calculate_file_hash(filepath):
    logger.info(f"Calculating hash for file: {filepath}")
    hash_algo = hashlib.sha256()
    with open(filepath, 'rb') as file:
        while chunk := file.read(8192):
            hash_algo.update(chunk)
    return hash_algo.hexdigest()

# Function to check if the document has changed
def document_changed():
    logger.info("Checking if the document has changed.")
    new_hash = calculate_file_hash(DOCUMENT_PATH)
    if os.path.exists(HASH_FILE):
        with open(HASH_FILE, 'r') as f:
            old_hash = f.read()
        if new_hash == old_hash:
            logger.info("Document has not changed.")
            return False
    with open(HASH_FILE, 'w') as f:
        f.write(new_hash)
    logger.info("Document has changed.")
    return True

# Function to load and ingest documents
def ingest_docs():
    logger.info("Starting document ingestion process.")
    loader = UnstructuredPDFLoader(DOCUMENT_PATH)
    docs = loader.load()
    logger.info(f"Loaded {len(docs)} documents.")

    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
    chunks = text_splitter.split_documents(docs)
    logger.info(f"Split documents into {len(chunks)} chunks.")

    embeddings = OpenAIEmbeddings()
    vectorstore = FAISS.from_documents(documents=chunks, embedding=embeddings)
    vectorstore.save_local(VECTOR_STORE_PATH)
    logger.info("Document successfully ingested and stored in the vector database.")
    return vectorstore

# Load or initialize the document vector store
if document_changed():
    vectorstore = ingest_docs()
    retriever = vectorstore.as_retriever()
else:
    logger.info("Loading existing vector store.")
    vectorstore = FAISS.load_local(VECTOR_STORE_PATH, OpenAIEmbeddings(), allow_dangerous_deserialization=True)
    retriever = vectorstore.as_retriever()

# Function to get memory for a session, creating it if it doesn't exist
def get_conversation_memory(session_id):
    if session_id not in session_memories:
        logger.info(f"Creating new conversation memory for session: {session_id}")
        session_memories[session_id] = ConversationBufferMemory()
    last_active_time[session_id] = time.time()  # Update last active time
    return session_memories[session_id]

# Cleanup inactive sessions
def cleanup_sessions(timeout=3600):  # Timeout in seconds (1 hour)
    current_time = time.time()
    to_remove = []
    for session_id, last_active in last_active_time.items():
        if current_time - last_active > timeout:
            to_remove.append(session_id)

    for session_id in to_remove:
        session_memories.pop(session_id, None)
        last_active_time.pop(session_id, None)
        logger.info(f"Session {session_id} has been cleaned up due to inactivity.")

# Function to clear the .cache directory
def clear_cache():
    cache_path = ".cache/*"  # Path to the cache directory
    try:
        os.system(f"rm -rf {cache_path}")
        logger.info(".cache directory has been cleared.")
    except Exception as e:
        logger.error(f"Error while clearing cache: {e}")

# Background task to clear inactive sessions and cache every 20 minutes
async def periodic_reset():
    while True:
        await asyncio.sleep(20 * 60)  # Wait for 20 minutes
        cleanup_sessions()
        clear_cache()

app = FastAPI(title="LangChain Server with Knowledge Base")
app.mount("/static", StaticFiles(directory="static"), name="static")
templates = Jinja2Templates(directory="templates")

UPLOAD_DIRECTORY = "temp_files"

if not os.path.exists(UPLOAD_DIRECTORY):
    os.makedirs(UPLOAD_DIRECTORY)

# Model to handle chat input with session_id
class ChatInput(BaseModel):
    session_id: str
    input_text: str

# Login Page
@app.get("/", response_class=HTMLResponse)
async def root(request: Request):
    return RedirectResponse(url="/login")

# Verify password and set a session cookie
@app.post("/login")
async def login(response: Response, password: str = Form(...)):
    logger.info(f"Password received: {password}")
    if password == PASSWORD:
        session_token = str(uuid.uuid4())
        response = RedirectResponse(url="/chat-page", status_code=303)

        # Set cookie with a path that covers the entire site
        response.set_cookie(
            key="session_token",
            value=session_token,
            httponly=False,  # Allow JavaScript to access the cookie
            secure=False,    # Set to True in production with HTTPS
            path="/"         # Set the cookie for the root path so it's accessible everywhere
        )

        return response
    else:
        raise HTTPException(status_code=403, detail="Invalid password")

@app.get("/login", response_class=HTMLResponse)
async def login_page(request: Request):
    return templates.TemplateResponse("login.html", {"request": request})

# Chat page that requires login
@app.get("/chat-page", response_class=HTMLResponse)
async def get_chat_page(request: Request):
    session_token = request.cookies.get("session_token")
    if session_token:
        return templates.TemplateResponse("chat.html", {"request": request})
    else:
        raise HTTPException(status_code=403, detail="Unauthorized")

# Chat functionality restricted by session
@app.post("/chat")
async def chat(request: Request):
    try:
        # Log raw request body
        body = await request.json()
        logger.info(f"Raw request body: {body}")

        # Validate and extract incoming data
        input_data = ChatInput(**body)
        session_id = input_data.session_id
        input_text = input_data.input_text
        logger.info(f"Received user input for session {session_id}: {input_text}")
    except Exception as e:
        logger.error(f"Error parsing input data: {e}")
        return {"error": "Invalid input data"}

    # Get or create conversation memory for this session
    memory = get_conversation_memory(session_id)

    try:
        # Retrieve relevant knowledge from the vectorstore
        context = retriever.invoke(input_text)
        context_text = "\n\n".join([doc.page_content for doc in context])
        logger.info(f"Context retrieved for session {session_id}: {context_text}")

        # Build the question with context and memory
        question_with_context = f"{persona_prompt}\n\nContext:\n{context_text}\n\nQuestion: {input_text}"

        # Use the conversation chain for this session's memory
        conversation_chain = ConversationChain(llm=llm, memory=memory)
        result = conversation_chain.run(question_with_context)
        logger.info(f"Generated response for session {session_id}: {result}")

        return {"answer": result}
    except Exception as e:
        logger.error(f"Error during chat invocation for session {session_id}: {e}")
        return {"error": "Failed to process request"}



# File upload functionality restricted by session
@app.post("/upload")
async def upload_pdf(request: Request, file: UploadFile = File(...)):
    session_token = request.cookies.get("session_token")
    if not session_token:
        raise HTTPException(status_code=403, detail="Unauthorized")

    logger.info(f"Received file upload request: {file.filename}")
    try:
        file_location = f"{UPLOAD_DIRECTORY}/{file.filename}"
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info(f"File '{file.filename}' saved successfully at {file_location}.")
        return {"message": f"File '{file.filename}' uploaded successfully!"}
    except Exception as e:
        logger.error(f"Error during file upload: {e}")
        return {"error": str(e)}


# Start the background task when the FastAPI app starts
@app.on_event("startup")
async def startup_event():
    asyncio.create_task(periodic_reset())
    logger.info("Started background task to clean up inactive sessions.")


if __name__ == "__main__":
    logger.info("Starting FastAPI server...")
    uvicorn.run(app, host="0.0.0.0", port=8000)
