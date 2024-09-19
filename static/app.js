document.getElementById('chat-form').addEventListener('submit', async function (event) {
    event.preventDefault();
    const chatInput = document.getElementById('chat_input').value;

    // Extract session_id from cookies
    const sessionId = document.cookie
        .split('; ')
        .find(row => row.startsWith('session_token='))
        ?.split('=')[1]; 

    if (!sessionId) {
        console.error("Session ID is missing!");
        return;
    }

    const chatBox = document.getElementById('chat-box');

    // Display user message
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

        // Display AI message
        const aiMessage = document.createElement('div');
        aiMessage.classList.add('ai-message');
        aiMessage.textContent = result.answer || "Error: No response from AI";
        chatBox.appendChild(aiMessage);

        // Scroll to the bottom of the chat box
        chatBox.scrollTop = chatBox.scrollHeight;
    } catch (error) {
        console.error("Error sending chat request:", error);
    }
});
