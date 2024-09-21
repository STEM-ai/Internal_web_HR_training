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

// Handle file upload form submission
document.getElementById('upload-form').addEventListener('submit', async function (event) {
    event.preventDefault();
    const formData = new FormData();
    const fileInput = document.getElementById('file');
    formData.append('file', fileInput.files[0]);

    try {
        const response = await fetch('/upload', {
            method: 'POST',
            body: formData
        });

        const result = await response.json();
        console.log("Upload result:", result);
        alert(result.message || "File uploaded successfully!");
    } catch (error) {
        console.error("Error uploading file:", error);
        alert("Error uploading file");
    }
});
