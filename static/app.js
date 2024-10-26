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
    document.getElementById('recording-indicator').style.display = 'block'; // Show recording indicator
    if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        console.error("navigator.mediaDevices.getUserMedia not supported on this browser");
        alert("Your browser does not support audio recording. Please use a different browser.");
    }

    try {
        const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
        mediaRecorder = new MediaRecorder(stream);

        mediaRecorder.ondataavailable = (event) => {
            audioChunks.push(event.data);
        };

        mediaRecorder.onstop = async () => {
            document.getElementById('recording-indicator').style.display = 'none'; // Hide recording indicator
            const audioBlob = new Blob(audioChunks, { type: 'audio/webm' });
            const audioUrl = URL.createObjectURL(audioBlob);
            document.getElementById('audio-preview').src = audioUrl;

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
            audioChunks = [];
        };

        mediaRecorder.start();
        document.getElementById('start-recording').disabled = true;
        document.getElementById('stop-recording').disabled = false;
    } catch (err) {
        console.error("Error accessing microphone:", err);
        alert("Error accessing the microphone.");
    }
});

document.getElementById('stop-recording').addEventListener('click', async () => {
    console.log("Stop recording button clicked");

    if (mediaRecorder) {
        mediaRecorder.stop();

        // Hide the recording indicator immediately after stopping
        document.getElementById('recording-indicator').style.display = 'none';

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

                // Display transcription as a user message
                const chatBox = document.getElementById('chat-box');
                const userMessage = document.createElement('div');
                userMessage.classList.add('user-message');
                userMessage.innerText = result.transcription;  // Display the transcription
                chatBox.appendChild(userMessage);

                // Display AI response as a bot message
                const botMessage = document.createElement('div');
                botMessage.classList.add('ai-message');
                botMessage.innerText = result.answer;
                chatBox.appendChild(botMessage);

                // If audio path is available, play the audio response
                if (result.audio_path) {
                    const audio = new Audio(result.audio_path);
                    audio.play();
                    audio.addEventListener("play", () => {
                        document.getElementById('playback-indicator').style.display = 'block'; // Show playback indicator
                    });
                    audio.addEventListener("ended", () => {
                        document.getElementById('playback-indicator').style.display = 'none'; // Hide playback indicator
                    });
                }

                chatBox.scrollTop = chatBox.scrollHeight;

            } catch (error) {
                console.error("Error uploading audio:", error);
            }

            // Reset audio chunks
            audioChunks = [];
        };
    }
});

document.getElementById('audio-preview').addEventListener('play', () => {
    document.getElementById('playback-indicator').style.display = 'block'; // Show playback indicator
});

document.getElementById('audio-preview').addEventListener('ended', () => {
    document.getElementById('playback-indicator').style.display = 'none'; // Hide playback indicator
});
