<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Movies - CineBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
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
    <!-- Page Header with Search -->
    <div class="page-header">
        <h1>Now Showing</h1>
        <p>Book your favorite movies now</p>
    </div>

    <!-- Search Bar -->
    <div style="max-width: 600px; margin: 2rem auto 3rem;">
        <form action="${pageContext.request.contextPath}/movieList" method="get">
            <div style="position: relative;">
                <input type="text"
                       name="search"
                       class="form-control"
                       placeholder="Search movies by title or genre..."
                       value="${searchQuery}"
                       style="padding-right: 120px;">
                <button type="submit"
                        class="btn"
                        style="position: absolute; right: 5px; top: 5px; padding: 0.6rem 1.5rem;">
                    Search
                </button>
            </div>
        </form>
        <c:if test="${not empty searchQuery}">
            <div style="text-align: center; margin-top: 1rem;">
                <a href="${pageContext.request.contextPath}/movieList"
                   style="color: #aaa; text-decoration: none;">
                    Clear search
                </a>
            </div>
        </c:if>
    </div>

    <!-- Movies Grid -->
    <c:choose>
        <c:when test="${empty movies}">
            <div class="empty-state">
                <h3>No movies found</h3>
                <p>Try a different search term or check back later for new releases.</p>
                <a href="${pageContext.request.contextPath}/movieList" class="btn" style="margin-top: 1rem;">
                    View All Movies
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="movie-grid">
                <c:forEach var="movie" items="${movies}">
                    <div class="movie-card">
                        <img src="${movie.posterUrl}"
                             alt="${movie.title}"
                             class="movie-poster"
                             onerror="this.src='https://via.placeholder.com/300x450?text=No+Image'">
                        <div class="movie-info">
                            <h3 class="movie-title">${movie.title}</h3>
                            <div class="movie-meta">
                                <span>⏱️ ${movie.formattedDuration}</span>
                                <span>🎭 ${movie.genre}</span>
                            </div>
                            <p class="movie-description">${movie.description}</p>
                            <a href="${pageContext.request.contextPath}/showList?movieId=${movie.id}"
                               class="btn btn-block">
                                Book Now
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 CineBook - Theatre Booking System. All rights reserved.</p>
</div>
</body>
</html>