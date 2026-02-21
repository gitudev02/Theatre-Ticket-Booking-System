<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CineBook - Theatre Booking System</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero-section {
            min-height: 90vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            text-align: center;
            padding: 2rem;
            background: linear-gradient(135deg, rgba(229, 9, 20, 0.1) 0%, rgba(0, 0, 0, 0.8) 100%),
            url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover;
            position: relative;
        }

        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.6);
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            max-width: 800px;
        }

        .hero-title {
            font-size: 4rem;
            font-weight: bold;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #e50914, #ff6b6b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: fadeInUp 1s ease-out;
        }

        .hero-subtitle {
            font-size: 1.5rem;
            color: #f5f5f1;
            margin-bottom: 2rem;
            animation: fadeInUp 1s ease-out 0.2s backwards;
        }

        .hero-buttons {
            display: flex;
            gap: 1.5rem;
            justify-content: center;
            flex-wrap: wrap;
            animation: fadeInUp 1s ease-out 0.4s backwards;
        }

        .btn-hero {
            padding: 1rem 3rem;
            font-size: 1.2rem;
            border-radius: 50px;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
            display: inline-block;
        }

        .btn-primary-hero {
            background: linear-gradient(135deg, #e50914, #b20710);
            color: white;
            box-shadow: 0 4px 15px rgba(229, 9, 20, 0.4);
        }

        .btn-primary-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(229, 9, 20, 0.6);
        }

        .btn-secondary-hero {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            color: white;
            border: 2px solid rgba(255, 255, 255, 0.3);
        }

        .btn-secondary-hero:hover {
            background: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.5);
            transform: translateY(-3px);
        }

        .features-section {
            padding: 5rem 2rem;
            background: rgba(255, 255, 255, 0.02);
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 3rem;
            max-width: 1200px;
            margin: 0 auto;
        }

        .feature-card {
            text-align: center;
            padding: 2rem;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
            background: rgba(255, 255, 255, 0.08);
            border-color: var(--primary-color);
            box-shadow: 0 10px 30px rgba(229, 9, 20, 0.3);
        }

        .feature-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .feature-title {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }

        .feature-description {
            color: #ccc;
            line-height: 1.6;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @media (max-width: 768px) {
            .hero-title {
                font-size: 2.5rem;
            }
            .hero-subtitle {
                font-size: 1.2rem;
            }
            .btn-hero {
                padding: 0.8rem 2rem;
                font-size: 1rem;
            }
        }
    </style>
</head>
<body>
<!-- Hero Section -->
<div class="hero-section">
    <div class="hero-content">
        <h1 class="hero-title">🎬 CineBook</h1>
        <p class="hero-subtitle">
            Your ultimate destination for booking movie tickets online.<br>
            Fast, easy, and hassle-free!
        </p>
        <div class="hero-buttons">
            <a href="login.jsp" class="btn-hero btn-primary-hero">Get Started</a>
            <a href="register.jsp" class="btn-hero btn-secondary-hero">Sign Up</a>
        </div>
    </div>
</div>

<!-- Features Section -->
<div class="features-section">
    <div class="page-header">
        <h1>Why Choose CineBook?</h1>
        <p>Experience the best movie booking platform</p>
    </div>
    <div class="features-grid">
        <div class="feature-card">
            <div class="feature-icon">🎟️</div>
            <h3 class="feature-title">Easy Booking</h3>
            <p class="feature-description">
                Book your favorite movie tickets in just a few clicks. Simple and straightforward process.
            </p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">🍿</div>
            <h3 class="feature-title">Latest Movies</h3>
            <p class="feature-description">
                Access to all the latest blockbusters and upcoming releases in one place.
            </p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">💺</div>
            <h3 class="feature-title">Best Seats</h3>
            <p class="feature-description">
                Choose from available seats and get the best view for your movie experience.
            </p>
        </div>
        <div class="feature-card">
            <div class="feature-icon">⚡</div>
            <h3 class="feature-title">Instant Confirmation</h3>
            <p class="feature-description">
                Get instant booking confirmation and access to your tickets immediately.
            </p>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 CineBook - Theatre Booking System. All rights reserved.</p>
    <p>Made with ❤️ for movie lovers</p>
</div>
</body>
</html>