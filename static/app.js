document.addEventListener("DOMContentLoaded", () => {
    const chatForm = document.getElementById("chat-form");
    const chatBox = document.getElementById("chat-box");

    // Generate a unique session ID for each user session
    let sessionId = localStorage.getItem("session_id");
    if (!sessionId) {
        sessionId = generateSessionId();
        localStorage.setItem("session_id", sessionId);
    }

    function generateSessionId() {
        return 'session_' + Math.random().toString(36).substr(2, 9);
    }

    // Handle chat form submission
    chatForm.addEventListener("submit", async (e) => {
        e.preventDefault();
        const userInput = document.getElementById("user-input").value;

        // Display user message in chatbox
        const userMessage = `<div class="user-message">${userInput}</div>`;
        chatBox.innerHTML += userMessage;

        // Clear the input field after submission
        document.getElementById("user-input").value = "";

        // Send the user input to the backend along with the session ID
        const response = await fetch("/chat", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                session_id: sessionId,  // Correctly pass the session_id
                input_text: userInput    // Correctly pass the input_text
            })
        });

        const result = await response.json();

        // Display the bot's response in the chatbox
        const botMessage = `<div class="bot-message">${result.answer}</div>`;
        chatBox.innerHTML += botMessage;
    });
});
