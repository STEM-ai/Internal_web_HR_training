console.log("app.js is loaded");

// Handle chat form submission
document.getElementById('chat-form').addEventListener('submit', async function (event) {
    event.preventDefault();
    const chatInput = document.getElementById('chat_input').value;
    const sessionId = document.cookie.split('; ').find(row => row.startsWith('session_token=')).split('=')[1]; 

    const chatBox = document.getElementById('chat-box');
    const userMessage = document.createElement('div');
    userMessage.classList.add('user-message');
    userMessage.textContent = chatInput;
    chatBox.appendChild(userMessage);

    const chatData = {
        session_id: sessionId,
        input_text: chatInput
    };

    document.getElementById('chat_input').value = ""; // Clear input field

    try {
        const response = await fetch("/chat", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify(chatData),
        });

        const result = await response.json();
        const aiMessage = document.createElement('div');
        aiMessage.classList.add('ai-message');
        aiMessage.textContent = result.answer || "Error: No response from AI";
        chatBox.appendChild(aiMessage);

        chatBox.scrollTop = chatBox.scrollHeight;
    } catch (error) {
        console.error("Error sending chat request:", error);
    }
});

let mediaRecorder;
let audioChunks = [];

document.getElementById('start-recording').addEventListener('click', async () => {
    console.log("Start recording button clicked");

    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        console.error("navigator.mediaDevices.getUserMedia not supported on this browser");
        alert("Your browser does not support audio recording. Please use a different browser.");
    }

    try {
        // Request microphone access
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        console.log("Microphone access granted");

        mediaRecorder = new MediaRecorder(stream);
        console.log("MediaRecorder initialized");

        mediaRecorder.ondataavailable = (event) => {
            console.log("Audio chunk available", event.data);
            audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
            console.log("Recording stopped");
            const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
            const audioUrl = URL.createObjectURL(audioBlob);
            document.getElementById('audio-preview').src = audioUrl;

            // Create FormData to send the audio file to the backend
            const formData = new FormData();
            formData.append('file', audioBlob, 'recording.webm');

            try {
                const sessionId = document.cookie.split('=')[1];
                const response = await fetch(`/upload-audio?session_id=${sessionId}`, {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                console.log("Audio upload result:", result);
            } catch (error) {
                console.error("Error uploading audio:", error);
            }

            // Reset the chunks for the next recording
            audioChunks = [];
        };

        mediaRecorder.start();
        console.log("Recording started");
        document.getElementById('start-recording').disabled = true;
        document.getElementById('stop-recording').disabled = false;
    } catch (err) {
        console.error("Error accessing microphone or setting up MediaRecorder:", err);
        alert("Error accessing the microphone. Please check your browser settings.");
    }
});

document.getElementById('stop-recording').addEventListener('click', async () => {
    console.log("Stop recording button clicked");

    if (mediaRecorder) {
        mediaRecorder.stop();

        document.getElementById('start-recording').disabled = false;
        document.getElementById('stop-recording').disabled = true;

        // Handle the recorded audio after stopping
        mediaRecorder.onstop = async () => {
            const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
            const formData = new FormData();
            formData.append('file', audioBlob, 'recording.webm');
            const sessionId = document.cookie.split('=')[1];

            try {
                const response = await fetch(`/upload-audio?session_id=${sessionId}`, {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();
                console.log("Audio processing result:", result);

                // Display the transcribed message as a user message
                const chatBox = document.getElementById('chat-box');
                const userMessage = document.createElement('div');
                userMessage.classList.add('user-message');
                userMessage.innerText = result.transcription;  // Display the transcription
                chatBox.appendChild(userMessage);

                // Display the AI response as a bot message
                const botMessage = document.createElement('div');
                botMessage.classList.add('ai-message');
                botMessage.innerText = result.answer;
                chatBox.appendChild(botMessage);

                // If audio path is available, play the audio response
                if (result.audio_path) {
                    const audio = new Audio(result.audio_path);
                    audio.play();
                }

                // Scroll to the bottom of the chat box
                chatBox.scrollTop = chatBox.scrollHeight;

            } catch (error) {
                console.error("Error uploading audio:", error);
            }

            // Reset audio chunks
            audioChunks = [];
        };
    }
});