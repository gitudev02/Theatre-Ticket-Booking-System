<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${movie.title} - Select Show</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .movie-header {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
            background: rgba(255, 255, 255, 0.05);
            padding: 2rem;
            border-radius: 15px;
        }

        .movie-poster-large {
            width: 100%;
            border-radius: 10px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
        }

        .movie-details h1 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
            color: var(--primary-color);
        }

        .movie-details .meta {
            display: flex;
            gap: 2rem;
            margin-bottom: 1.5rem;
            font-size: 1.1rem;
            color: #aaa;
        }

        .movie-details .description {
            line-height: 1.8;
            color: #ccc;
            font-size: 1.1rem;
        }

        .shows-container {
            display: grid;
            gap: 2rem;
        }

        .show-card {
            background: rgba(255, 255, 255, 0.05);
            padding: 2rem;
            border-radius: 15px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .show-card:hover {
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.08);
            transform: translateX(10px);
        }

        .show-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .show-datetime {
            display: flex;
            gap: 2rem;
            font-size: 1.2rem;
        }

        .show-datetime span {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .show-price {
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .show-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-top: 1rem;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
        }

        .seats-info {
            color: #aaa;
        }

        .seats-available {
            color: var(--success-color);
            font-weight: 600;
        }

        .seats-limited {
            color: var(--warning-color);
            font-weight: 600;
        }

        .seats-full {
            color: var(--danger-color);
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .movie-header {
                grid-template-columns: 1fr;
            }

            .show-header {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar">
    <div class="navbar-container">
        <a href="${pageContext.request.contextPath}/movieList" class="navbar-brand">
            🎬 CineBook
        </a>
        <ul class="navbar-menu">
            <li><a href="${pageContext.request.contextPath}/movieList">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/myBookings">My Bookings</a></li>
            <li><span style="color: #aaa;">Hello, ${sessionScope.userName}</span></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                    <button type="submit" class="btn-logout">Logout</button>
                </form>
            </li>
        </ul>
    </div>
</nav>

<!-- Main Container -->
<div class="container">
    <!-- Movie Header -->
    <div class="movie-header">
        <img src="${movie.posterUrl}"
             alt="${movie.title}"
             class="movie-poster-large"
             onerror="this.src='https://via.placeholder.com/300x450?text=No+Image'">
        <div class="movie-details">
            <h1>${movie.title}</h1>
            <div class="meta">
                <span>⏱️ ${movie.formattedDuration}</span>
                <span>🎭 ${movie.genre}</span>
            </div>
            <p class="description">${movie.description}</p>
        </div>
    </div>

    <!-- Page Header -->
    <div class="page-header">
        <h1>Select Show Time</h1>
        <p>Choose your preferred date and time</p>
    </div>

    <!-- Shows List -->
    <c:choose>
        <c:when test="${empty shows}">
            <div class="empty-state">
                <h3>No shows available</h3>
                <p>There are currently no upcoming shows for this movie.</p>
                <a href="${pageContext.request.contextPath}/movieList" class="btn" style="margin-top: 1rem;">
                    Back to Movies
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="shows-container">
                <c:forEach var="show" items="${shows}">
                    <div class="show-card">
                        <div class="show-header">
                            <div class="show-datetime">
                                <span>📅 ${show.formattedDate}</span>
                                <span>🕐 ${show.formattedTime}</span>
                            </div>
                            <div class="show-price">₹${show.price}</div>
                        </div>
                        <div class="show-footer">
                            <div class="seats-info">
                                <c:choose>
                                    <c:when test="${show.availableSeats == 0}">
                                        <span class="seats-full">● Sold Out</span>
                                    </c:when>
                                    <c:when test="${show.availableSeats <= 20}">
                                        <span class="seats-limited">● ${show.availableSeats} seats left</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="seats-available">● ${show.availableSeats} seats available</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <c:choose>
                                <c:when test="${show.availableSeats > 0}">
                                    <a href="${pageContext.request.contextPath}/booking?showId=${show.id}"
                                       class="btn">
                                        Book Tickets
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <button class="btn" disabled style="opacity: 0.5; cursor: not-allowed;">
                                        Sold Out
                                    </button>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <div style="text-align: center; margin-top: 3rem;">
        <a href="${pageContext.request.contextPath}/movieList" class="btn btn-secondary">
            ← Back to Movies
        </a>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 CineBook - Theatre Booking System. All rights reserved.</p>
</div>
</body>
</html>