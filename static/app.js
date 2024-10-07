document.addEventListener('DOMContentLoaded', function() {
    console.log("DOM fully loaded and parsed.");

    // Get elements
    const chatForm = document.getElementById('chat-form');
    const chatInput = document.getElementById('chat_input');
    const chatBox = document.getElementById('chat-box');
    const startRecordingButton = document.getElementById('start-recording');
    const stopRecordingButton = document.getElementById('stop-recording');

    // Logging the elements found in the DOM
    console.log("chatForm:", chatForm);
    console.log("chatInput:", chatInput);
    console.log("chatBox:", chatBox);
    console.log("startRecordingButton:", startRecordingButton);
    console.log("stopRecordingButton:", stopRecordingButton);

    // Add event listener for chat form submission
    if (chatForm) {
        chatForm.addEventListener('submit', async function (event) {
            event.preventDefault();
            const chatText = chatInput.value;
            console.log("Chat input submitted:", chatText);

            const sessionId = document.cookie.split('; ').find(row => row.startsWith('session_token=')).split('=')[1];
            console.log("Session ID extracted:", sessionId);

            const userMessage = document.createElement('div');
            userMessage.classList.add('user-message');
            userMessage.textContent = chatText;
            chatBox.appendChild(userMessage);

            const chatData = {
                session_id: sessionId,
                input_text: chatText
            };

            chatInput.value = ""; // Clear input field

            try {
                console.log("Sending chat request to /chat with data:", chatData);
                const response = await fetch("/chat", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json",
                    },
                    body: JSON.stringify(chatData),
                });

                const result = await response.json();
                console.log("Chat response received:", result);

                const aiMessage = document.createElement('div');
                aiMessage.classList.add('ai-message');
                aiMessage.textContent = result.answer || "Error: No response from AI";
                chatBox.appendChild(aiMessage);

                chatBox.scrollTop = chatBox.scrollHeight;
            } catch (error) {
                console.error("Error sending chat request:", error);
            }
        });
    } else {
        console.error("chat-form not found in the DOM.");
    }

    // Add event listeners for start/stop recording buttons
    if (startRecordingButton && stopRecordingButton) {
        startRecordingButton.addEventListener('click', function() {
            console.log("Start recording button clicked.");
            // Start recording logic
            console.log("Recording started...");
            stopRecordingButton.disabled = false;
            startRecordingButton.disabled = true;
        });

        stopRecordingButton.addEventListener('click', function() {
            console.log("Stop recording button clicked.");
            // Stop recording logic
            console.log("Recording stopped...");
            startRecordingButton.disabled = false;
            stopRecordingButton.disabled = true;
        });
    } else {
        console.error("start-recording or stop-recording button not found in the DOM.");
    }

    // Log document body and any other potential issues
    console.log("Document body loaded:", document.body);
});
