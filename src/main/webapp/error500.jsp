<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Server Error</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-container {
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 2rem;
        }

        .error-code {
            font-size: 8rem;
            font-weight: bold;
            background: linear-gradient(135deg, #e50914, #ff6b6b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .error-message {
            font-size: 1.5rem;
            color: #ccc;
            margin: 1rem 0 2rem;
        }
    </style>
</head>
<body>
<div class="error-container">
    <div class="error-code">500</div>
    <h2 style="color: var(--text-light); margin-bottom: 1rem;">Internal Server Error</h2>
    <p class="error-message">Something went wrong on our end. Please try again later.</p>
    <a href="${pageContext.request.contextPath}/index.jsp" class="btn">Go to Home</a>
</div>
</body>
</html>