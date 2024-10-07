import os
import random
import requests
import asyncio
import hashlib
import logging
import uuid  # For generating unique session IDs
import time
from openai import OpenAI
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
from transformers import pipeline
from transformers import WhisperProcessor, WhisperForConditionalGeneration
from melo.api import TTS

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

llm = ChatOpenAI(model="gpt-4o-mini", temperature=0)

DOCUMENT_PATH = "docs/airzoon.pdf"
HASH_FILE = "document_hash.txt"
VECTOR_STORE_PATH = "faiss_vector_db"

# Password for security
PASSWORD = "test"  #PASSWORD = os.getenv('ACCESS_PASSWORD', 'securepassword') # = test

# Store conversation memories and last active time keyed by session_id
session_memories = {}
last_active_time = {}
session_personas = {}
session_transcripts = {}
banned_phrase_tracker = {}
session_exchange_counts = {}

processor = WhisperProcessor.from_pretrained("openai/whisper-small")
model = WhisperForConditionalGeneration.from_pretrained("openai/whisper-small")
forced_decoder_ids = processor.get_decoder_prompt_ids(language="french",
                                                      task="transcribe")

# Anglais

# speech_recognition_pipeline = pipeline("automatic-speech-recognition",
#                                        model="openai/whisper-base")

# Define persona prompts based on the PDF    
personas = {
    "Marie":
    "Marie, Propriétaire de Restaurant. Traditionnelle, sceptique envers les nouvelles technologies, budget serré. Son objectif est d'attirer plus de clients locaux tout en maintenant un service client de qualité.",
    "Paul":
    "Paul, Gérant de Bar. Ouvert aux innovations mais prudent, préoccupé par la gestion des données clients. Son objectif est de créer une ambiance connectée, fidéliser les clients réguliers, et augmenter la durée des visites.",
    "Sophie":
    "Sophie, Propriétaire de Salon d'Esthétique. Innovante, soucieuse de l'expérience client, préoccupée par le ROI. Son objectif est d'augmenter les ventes de produits, attirer une clientèle jeune et technophile, et différencier son salon de la concurrence.",
    "Jean":
    "Jean, Gérant de Salon de Coiffure. Expérimenté, prudent avec les nouvelles technologies, préoccupé par les coûts. Son objectif est de fidéliser les clients existants, offrir des promotions attractives, et améliorer le bouche-à-oreille."
}

persona_objectives = {
    "Marie": "Vente d'une solution marketing WIFI à un restaurant. L'objectif est de convaincre le propriétaire de souscrire à votre service de marketing WIFI pour attirer plus de clients et augmenter leur fidélité.",
    "Paul": "Vente d'une solution marketing WIFI à un bar. L'objectif est de vendre la solution pour créer une ambiance connectée et recueillir des données sur les clients pour des campagnes marketing ciblées.",
    "Sophie": "Vente d'une solution marketing WIFI à un salon d'esthétique. L'objectif est de proposer des services de marketing pour améliorer l'expérience client et promouvoir des offres spéciales via le WIFI.",
    "Jean": "Vente d'une solution marketing WIFI à un salon de coiffure. L'objectif est de vendre le service pour fidéliser les clients existants et attirer de nouveaux clients grâce à des promotions et des publicités ciblées."
}

def select_or_get_persona_and_objective(session_id):
    """Select a random persona and its objective if not already assigned to the session."""
    if session_id not in session_personas:
        persona_name = random.choice(list(personas.keys()))
        session_personas[session_id] = persona_name
        logger.info(f"Assigned persona '{persona_name}' to session: {session_id}")
    else:
        persona_name = session_personas[session_id]

    persona_prompt = personas[persona_name]
    objective = persona_objectives[persona_name]

    return persona_name, persona_prompt, objective

def check_session_progress(session_id):
    """Increase the exchange count for a session and return whether the test is completed."""
    if session_id not in session_exchange_counts:
        session_exchange_counts[session_id] = 0
    session_exchange_counts[session_id] += 1

    # Check if the exchange count reaches 
    if session_exchange_counts[session_id] >= 10:
        return True
    return False
    
UPLOAD_DIRECTORY = "temp_files"

if not os.path.exists(UPLOAD_DIRECTORY):
    os.makedirs(UPLOAD_DIRECTORY)


def generate_voice_response(text: str) -> bytes:
    # ElevenLabs Code (English)
    # elevenlabs_api_key = os.getenv("ELEVENLABS_API_KEY")
    # voice_id = os.getenv("ELEVENLABS_VOICE_ID")
    # url = f"https://api.elevenlabs.io/v1/text-to-speech/{voice_id}"

    # headers = {
    #     "Content-Type": "application/json",
    #     "xi-api-key": elevenlabs_api_key,
    # }

    # payload = {
    #     "text": text,
    #     "voice_settings": {
    #         "stability": 0.5,
    #         "similarity_boost": 0.75
    #     }
    # }

    # response = requests.post(url, headers=headers, json=payload)

    # if response.status_code != 200:
    #     raise Exception(f"Failed to generate speech: {response.text}")

    # return response.content

    # MeloTTS-French Code
    speed = 1.2  # Speed is adjustable
    device = 'cpu'  # or 'cuda:0' for GPU usage

    model = TTS(language='FR', device=device)
    speaker_ids = model.hps.data.spk2id

    output_path = 'fr.wav'  # Path to save the generated speech

    model.tts_to_file(text, speaker_ids['FR'], output_path, speed=speed)

    with open(output_path, 'rb') as audio_file:
        return audio_file.read()


banned_phrases = [
    "J’ai une petite question", "Pas de soucis", "Sincèrement", "Mais",
    "Par contre", "Dis toi que", "Dites-vous que", "Quasiment", "Sachez que",
    "airZoon c’est du WIFI"
]

def check_banned_phrases(user_input, session_id):
    """Check if the user input contains any banned phrases and update the tracker for the session."""
    triggered_phrases = []
    if session_id not in banned_phrase_tracker:
        banned_phrase_tracker[session_id] = {}

    for phrase in banned_phrases:
        if phrase.lower() in user_input.lower():
            triggered_phrases.append(phrase)
            # Increment the count or add the phrase to the session's tracker
            if phrase not in banned_phrase_tracker[session_id]:
                banned_phrase_tracker[session_id][phrase] = 1
            else:
                banned_phrase_tracker[session_id][phrase] += 1

    return triggered_phrases

def store_exchange_in_transcript(session_id, user_input, ai_response):
    """Store the user input and AI response in the session's transcript."""
    if session_id not in session_transcripts:
        session_transcripts[session_id] = []
    session_transcripts[session_id].append(f"User: {user_input}\nAI: {ai_response}")

def submit_transcript_to_analysis_llm(session_id):
    """Submit the transcript of the session to a separate LLM for analysis or summary."""
    transcript = "\n\n".join(session_transcripts[session_id])
    logger.info(f"Submitting transcript for session {session_id} to analysis LLM.")

    # Initialize the OpenAI client
    client = OpenAI()

    # Prepare the analysis prompt in French
    analysis_prompt = (
        "Vous allez recevoir une transcription d'une session de jeu de rôle entre un stagiaire et un client simulé intéressé par les services d'Airzoon. "
        "Votre tâche est d'évaluer dans quelle mesure le stagiaire a suivi les meilleures pratiques de vente et de traitement des objections, en vous basant sur les critères suivants :\n\n"

        "1. **Traitement des objections lors de l’entretien commerciales** : Le stagiaire a-t-il géré efficacement les objections ? Évaluez spécifiquement s'il/elle a :\n"
        "- Accueilli les objections avec patience (par exemple, en reconnaissant l'objection sans interrompre).\n"
        "- Accusé réception de la préoccupation sans jugement (par exemple, 'Je comprends').\n"
        "- Isolé l'objection pour voir si elle est la seule préoccupation (par exemple, 'Hormis ce point, est-ce que globalement l’offre vous convient ?').\n"
        "- Creusé ou découvert la cause profonde de l'objection.\n"
        "- Pratiqué l'écoute active, reformulé l'objection, et clarifié avec des questions si nécessaire.\n"
        "- Offert des solutions ou des réponses à l'objection en mettant en avant des avantages et des preuves.\n"
        "- Récapitulé les avantages et validé la compréhension du client (par exemple, 'Cela répond à votre question ?').\n\n"

        "2. **Offres commerciales spéciales en cours** : Le stagiaire a-t-il utilisé efficacement les offres commerciales spéciales ? Évaluez spécifiquement s'il/elle a :\n"
        "- Proposé des offres spéciales de manière appropriée lorsque le client n’avait pas d’objection mais hésitait à s’engager.\n"
        "- Expliqué clairement les conditions des offres, telles que l’éligibilité, le timing, et les types de campagnes (par exemple, campagnes de communication par e-mail ou SMS).\n"
        "- Adapté l’offre aux besoins de l'entreprise du client et a apporté un sens d’urgence ou de valeur à l’offre.\n\n"

        "3. **Étapes clés de l’entretien de vente** : Le stagiaire a-t-il respecté les étapes clés de la conversation de vente ? Évaluez s'il/elle a :\n"
        "- Ouvert la conversation en établissant un lien et en définissant le cadre du rendez-vous (par exemple, en brisant la glace).\n"
        "- Posé des questions ouvertes pour découvrir les besoins du client et identifié au moins trois besoins principaux.\n"
        "- Répondu aux besoins identifiés avec des arguments et a traité efficacement les objections.\n"
        "- Présenté une démonstration ou un exemple, soit en direct, soit en se référant au succès d’un client existant.\n"
        "- Conclu l’entretien en confirmant les prochaines étapes, en obtenant un accord, ou en planifiant des actions de suivi.\n\n"

        "Après avoir analysé la transcription selon ces critères, veuillez fournir une évaluation détaillée. Mettez en avant les points forts et les axes d'amélioration, et donnez une appréciation globale de la performance du stagiaire dans cet exercice de jeu de rôle.\n\n"

        "Transcription :\n\n" + transcript
    )

    # Make the API call to OpenAI to get the analysis
    completion = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": "Vous êtes un assistant analysant des transcriptions de sessions de jeu de rôle pour la formation des ventes."},
            {"role": "user", "content": analysis_prompt}
        ]
    )

    # Extract the response
    response = completion.choices[0].message

    # Log the analysis result
    logger.info(f"Analysis response for session {session_id}: {response}")

    return response

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

    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000,
                                                   chunk_overlap=200)
    chunks = text_splitter.split_documents(docs)
    logger.info(f"Split documents into {len(chunks)} chunks.")

    embeddings = OpenAIEmbeddings()
    vectorstore = FAISS.from_documents(documents=chunks, embedding=embeddings)
    vectorstore.save_local(VECTOR_STORE_PATH)
    logger.info(
        "Document successfully ingested and stored in the vector database.")
    return vectorstore


# Load or initialize the document vector store
if document_changed():
    vectorstore = ingest_docs()
    retriever = vectorstore.as_retriever()
else:
    logger.info("Loading existing vector store.")
    vectorstore = FAISS.load_local(VECTOR_STORE_PATH,
                                   OpenAIEmbeddings(),
                                   allow_dangerous_deserialization=True)
    retriever = vectorstore.as_retriever()


# Function to get memory for a session, creating it if it doesn't exist
def get_conversation_memory(session_id):
    if session_id not in session_memories:
        logger.info(
            f"Creating new conversation memory for session: {session_id}")
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
        session_personas.pop(session_id, None)
        session_transcripts.pop(session_id, None)
        banned_phrase_tracker.pop(session_id, None)
        session_exchange_counts.pop(session_id, None)
        
        logger.info(
            f"Session {session_id} has been cleaned up due to inactivity.")


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
app.mount("/temp_files",
          StaticFiles(directory="temp_files"),
          name="temp_files")
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
            secure=False,  # Set to True in production with HTTPS
            path=
            "/"  # Set the cookie for the root path so it's accessible everywhere
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

# Global dictionary to store filenames for each session
uploaded_files = {}

@app.post("/upload")
async def upload_pdf(request: Request, file: UploadFile = File(...)):
    session_token = request.cookies.get("session_token")
    if not session_token:
        raise HTTPException(status_code=403, detail="Unauthorized")

    logger.info(f"Received file upload request: {file.filename}")

    try:
        # Save the file to the upload directory
        file_location = f"{UPLOAD_DIRECTORY}/{file.filename}"
        with open(file_location, "wb") as f:
            f.write(await file.read())
        logger.info(
            f"File '{file.filename}' saved successfully at {file_location}.")

        # Ingest the uploaded PDF into the vector store for this session
        loader = UnstructuredPDFLoader(file_location)
        docs = loader.load()
        logger.info(f"Loaded {len(docs)} documents from the uploaded PDF.")

        # Split the documents into chunks for embedding
        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000,
                                                       chunk_overlap=200)
        chunks = text_splitter.split_documents(docs)
        logger.info(f"Split the uploaded PDF into {len(chunks)} chunks.")

        # Create embeddings and add them to the vector store for this session
        embeddings = OpenAIEmbeddings()

        # Check if this session already has a vectorstore
        session_vectorstore_path = f"faiss_vectorstore_{session_token}"
        if os.path.exists(session_vectorstore_path):
            # Load the existing vectorstore for this session
            vectorstore = FAISS.load_local(
                session_vectorstore_path,
                embeddings,
                allow_dangerous_deserialization=True)
            logger.info(
                f"Loaded existing vectorstore for session {session_token}.")
        else:
            # Create a new vectorstore if it doesn't exist for this session
            vectorstore = FAISS.from_documents(documents=chunks,
                                               embedding=embeddings)
            logger.info(
                f"Created new vectorstore for session {session_token}.")

        # Update the vectorstore with the new document chunks
        vectorstore.add_documents(chunks)
        vectorstore.save_local(session_vectorstore_path)
        logger.info(
            f"Updated vectorstore for session {session_token} with the new document."
        )

        # Store the uploaded filename for this session
        uploaded_files[session_token] = file.filename

        return {
            "message":
            f"File '{file.filename}' uploaded and ingested successfully!"
        }

    except Exception as e:
        logger.error(f"Error during file upload and ingestion: {e}")
        return {"error": str(e)}

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

    # Check the progress of the session and if the test is complete
    if check_session_progress(session_id):
        analysis_response = submit_transcript_to_analysis_llm(session_id)
        return {"answer": "Test completed, thank you for your participation!"}

    # Get or select the persona and objective for this session
    persona_name, persona_prompt, objective = select_or_get_persona_and_objective(session_id)
    logger.info(f"Using persona '{persona_name}' for session {session_id} with objective: {objective}")

    # Ensure that the persona prompt emphasizes role-playing and includes the objective
    role_play_instruction = (
        f"You are {persona_name}, a potential client interested in Airzoon's services. "
        f"Your goal is to learn more about how Airzoon can help you achieve your business objectives based on your situation: {objective}. "
        "Throughout the conversation, ask relevant questions and share your needs as a client inquiring about the Airzoon services, evolving based on the user's responses."
        " Remember, you are role-playing as {persona_name} and must not reveal you are an AI. "
    )

    full_persona_prompt = f"{role_play_instruction}\n\n{persona_prompt}"

    # Check for banned phrases in user input
    triggered_phrases = check_banned_phrases(input_text, session_id)
    if triggered_phrases:
        logger.info(f"Triggered banned phrases for session {session_id}: {triggered_phrases}")

    # Get or create conversation memory for this session
    memory = get_conversation_memory(session_id)

    try:
        # Retrieve relevant knowledge from the vectorstore
        context = retriever.invoke(input_text)
        context_text = "\n\n".join([doc.page_content for doc in context])
        logger.info(f"Context retrieved for session {session_id}: {context_text}")

        # Build the question with context and memory, including the persona prompt and objective
        question_with_context = f"{full_persona_prompt}\n\nObjective:\n{objective}\n\nContext:\n{context_text}\n\nQuestion: {input_text}"

        # Use the conversation chain for this session's memory
        conversation_chain = ConversationChain(llm=llm, memory=memory)
        result = conversation_chain.run(question_with_context)
        logger.info(f"Generated response for session {session_id}: {result}")
        
        # Store exchange in session transcript
        store_exchange_in_transcript(session_id, input_text, result)
        
        return {
            "answer": result,
            "triggered_phrases": triggered_phrases
        }
    except Exception as e:
        logger.error(f"Error during chat invocation for session {session_id}: {e}")
        return {"error": "Failed to process request"}

@app.post("/upload-audio")
async def upload_audio(session_id: str, file: UploadFile = File(...)):
    try:
        logger.info(
            f"Received audio file for session {session_id}: {file.filename}")

        # Save the audio file temporarily
        audio_path = f"{UPLOAD_DIRECTORY}/{file.filename}"
        with open(audio_path, "wb") as f:
            f.write(await file.read())
        logger.info(
            f"Audio file '{file.filename}' saved successfully at {audio_path}."
        )

        # Convert speech to text using the whisper model
        asr_pipe = pipeline("automatic-speech-recognition",
                            model=model,
                            feature_extractor=processor.feature_extractor,
                            tokenizer=processor.tokenizer,
                            chunk_length_s=30)
        transcription = asr_pipe(
            audio_path,
            generate_kwargs={"forced_decoder_ids": forced_decoder_ids})["text"]
        #transcription = speech_recognition_pipeline(audio_path)["text"]
        logger.info(f"Transcription for session {session_id}: {transcription}")

        # Generate a response based on the transcription
        memory = get_conversation_memory(session_id)
        context = retriever.invoke(transcription)
        context_text = "\n\n".join([doc.page_content for doc in context])
        question_with_context = f"{persona_prompt}\n\nContext:\n{context_text}\n\nQuestion: {transcription}"
        conversation_chain = ConversationChain(llm=llm, memory=memory)
        result = conversation_chain.run(question_with_context)
        logger.info(
            f"Generated text response for session {session_id}: {result}")

        # Generate voice response from ElevenLabs
        voice_response = generate_voice_response(result)

        # Save the generated audio response
        response_audio_path = f"{UPLOAD_DIRECTORY}/response_{session_id}.mp3"
        with open(response_audio_path, "wb") as audio_file:
            audio_file.write(voice_response)

        logger.info(f"Voice response saved at {response_audio_path}")

        # Return the path of the generated audio, text response, and transcription
        return {
            "answer": result,
            "audio_path": f"/temp_files/response_{session_id}.mp3",
            "transcription": transcription
        }

    except Exception as e:
        logger.error(
            f"Error during audio upload and processing for session {session_id}: {e}"
        )
        return {"error": str(e)}


# Start the background task when the FastAPI app starts
@app.on_event("startup")
async def startup_event():
    asyncio.create_task(periodic_reset())
    logger.info("Started background task to clean up inactive sessions.")


if __name__ == "__main__":
    logger.info("Starting FastAPI server...")
    uvicorn.run(app, host="0.0.0.0", port=8000)
