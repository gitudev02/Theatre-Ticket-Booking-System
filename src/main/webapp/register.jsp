<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - CineBook</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .auth-container {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            background: linear-gradient(135deg, rgba(229, 9, 20, 0.1) 0%, rgba(0, 0, 0, 0.9) 100%),
            url('https://images.unsplash.com/photo-1536440136628-849c177e76a1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover;
        }

        .auth-card {
            background: rgba(20, 20, 20, 0.95);
            backdrop-filter: blur(20px);
            padding: 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
            max-width: 450px;
            width: 100%;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .auth-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .auth-logo {
            font-size: 3rem;
            margin-bottom: 0.5rem;
        }

        .auth-title {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #e50914, #ff6b6b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .auth-subtitle {
            color: #aaa;
            font-size: 1rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-label {
            display: block;
            margin-bottom: 0.5rem;
            color: #f5f5f1;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 1rem;
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid rgba(255, 255, 255, 0.1);
            border-radius: 10px;
            color: white;
            font-size: 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.08);
            box-shadow: 0 0 0 3px rgba(229, 9, 20, 0.1);
        }

        .btn-submit {
            width: 100%;
            padding: 1rem;
            background: linear-gradient(135deg, #e50914, #b20710);
            color: white;
            border: none;
            border-radius: 10px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(229, 9, 20, 0.4);
        }

        .auth-footer {
            text-align: center;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .auth-footer a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .auth-footer a:hover {
            text-decoration: underline;
        }

        .back-home {
            text-align: center;
            margin-bottom: 2rem;
        }

        .back-home a {
            color: #aaa;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.3s ease;
        }

        .back-home a:hover {
            color: var(--primary-color);
        }
    </style>
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <div class="back-home">
            <a href="index.jsp">← Back to Home</a>
        </div>

        <div class="auth-header">
            <div class="auth-logo">🎬</div>
            <h1 class="auth-title">Create Account</h1>
            <p class="auth-subtitle">Join us to start booking</p>
        </div>

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">
            <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <form action="register" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="name" class="form-label">Full Name</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       placeholder="Enter your full name"
                       required>
            </div>

            <div class="form-group">
                <label for="email" class="form-label">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="Enter your email"
                       required>
            </div>

            <div class="form-group">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       class="form-control"
                       placeholder="Enter your phone number"
                       pattern="[0-9]{10}"
                       title="Please enter a valid 10-digit phone number"
                       required>
            </div>

            <div class="form-group">
                <label for="password" class="form-label">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Create a password"
                       minlength="6"
                       required>
            </div>

            <div class="form-group">
                <label for="confirmPassword" class="form-label">Confirm Password</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       class="form-control"
                       placeholder="Confirm your password"
                       required>
            </div>

            <button type="submit" class="btn-submit">Create Account</button>
        </form>

        <div class="auth-footer">
            <p style="color: #aaa;">Already have an account?
                <a href="login.jsp">Login here</a>
            </p>
        </div>
    </div>
</div>

<script>
    function validateForm() {
        var password = document.getElementById("password").value;
        var confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match!");
            return false;
        }

        if (password.length < 6) {
            alert("Password must be at least 6 characters long!");
            return false;
        }

        return true;
    }
</script>
</body>
</html>