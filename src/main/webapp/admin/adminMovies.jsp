<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.theatre.dao.MovieDAO" %>
<%@ page import="com.theatre.model.Movie" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Check if user is admin
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    MovieDAO movieDAO = new MovieDAO();
    List<Movie> movies = movieDAO.getAllMovies();
    request.setAttribute("movies", movies);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Movies - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .admin-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            overflow-y: auto;
        }

        .modal-content {
            background: rgba(20, 20, 20, 0.95);
            margin: 5% auto;
            padding: 2rem;
            border-radius: 15px;
            max-width: 600px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }

        .close:hover {
            color: var(--primary-color);
        }

        .admin-table {
            width: 100%;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            overflow: hidden;
        }

        .admin-table th {
            background: rgba(229, 9, 20, 0.2);
            padding: 1rem;
            text-align: left;
            font-weight: 600;
        }

        .admin-table td {
            padding: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .admin-table tr:hover {
            background: rgba(255, 255, 255, 0.05);
        }

        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }

        .btn-small {
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<!-- Navigation Bar -->
<nav class="navbar">
    <div class="navbar-container">
        <a href="${pageContext.request.contextPath}/admin/adminMovies.jsp" class="navbar-brand">
            🎬 CineBook Admin
        </a>
        <ul class="navbar-menu">
            <li><a href="${pageContext.request.contextPath}/admin/adminMovies.jsp">Movies</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/adminShows.jsp">Shows</a></li>
            <li><a href="${pageContext.request.contextPath}/admin/adminBookings.jsp">Bookings</a></li>
            <li><span style="color: #aaa;">Admin: ${sessionScope.userName}</span></li>
            <li>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                    <button type="submit" class="btn-logout">Logout</button>
                </form>
            </li>
        </ul>
    </div>
</nav>

<!-- Main Container -->
<div class="container admin-container">
    <div class="admin-header">
        <div class="page-header" style="margin-bottom: 0;">
            <h1>Manage Movies</h1>
            <p>Add, edit, or delete movies</p>
        </div>
        <button onclick="openAddModal()" class="btn">+ Add Movie</button>
    </div>

    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert alert-success">
                ${sessionScope.successMessage}
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert alert-danger">
                ${sessionScope.errorMessage}
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Movies Table -->
    <div class="table-container">
        <table class="admin-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Poster</th>
                <th>Title</th>
                <th>Genre</th>
                <th>Duration</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="movie" items="${movies}">
                <tr>
                    <td>${movie.id}</td>
                    <td>
                        <img src="${movie.posterUrl}"
                             alt="${movie.title}"
                             style="width: 50px; height: 75px; object-fit: cover; border-radius: 5px;"
                             onerror="this.src='https://via.placeholder.com/50x75'">
                    </td>
                    <td><strong>${movie.title}</strong></td>
                    <td>${movie.genre}</td>
                    <td>${movie.formattedDuration}</td>
                    <td>
                        <div class="action-buttons">
                            <button onclick='openEditModal(${movie.id}, "${movie.title}", "${movie.description}", ${movie.duration}, "${movie.genre}", "${movie.posterUrl}")'
                                    class="btn btn-small btn-secondary">
                                Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/admin/adminMovie" method="post" style="display: inline;"
                                  onsubmit="return confirm('Are you sure you want to delete this movie?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${movie.id}">
                                <button type="submit" class="btn btn-small" style="background: var(--danger-color);">
                                    Delete
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Add Movie Modal -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddModal()">&times;</span>
        <h2 style="margin-bottom: 2rem; color: var(--primary-color);">Add New Movie</h2>
        <form action="${pageContext.request.contextPath}/admin/adminMovie" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label class="form-label">Title</label>
                <input type="text" name="title" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label class="form-label">Duration (minutes)</label>
                <input type="number" name="duration" class="form-control" min="1" required>
            </div>

            <div class="form-group">
                <label class="form-label">Genre</label>
                <input type="text" name="genre" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Poster URL</label>
                <input type="url" name="posterUrl" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-block">Add Movie</button>
        </form>
    </div>
</div>

<!-- Edit Movie Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2 style="margin-bottom: 2rem; color: var(--primary-color);">Edit Movie</h2>
        <form action="${pageContext.request.contextPath}/admin/adminMovie" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">

            <div class="form-group">
                <label class="form-label">Title</label>
                <input type="text" name="title" id="editTitle" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Description</label>
                <textarea name="description" id="editDescription" class="form-control" rows="3" required></textarea>
            </div>

            <div class="form-group">
                <label class="form-label">Duration (minutes)</label>
                <input type="number" name="duration" id="editDuration" class="form-control" min="1" required>
            </div>

            <div class="form-group">
                <label class="form-label">Genre</label>
                <input type="text" name="genre" id="editGenre" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Poster URL</label>
                <input type="url" name="posterUrl" id="editPosterUrl" class="form-control" required>
            </div>

            <button type="submit" class="btn btn-block">Update Movie</button>
        </form>
    </div>
</div>

<script>
    function openAddModal() {
        document.getElementById('addModal').style.display = 'block';
    }

    function closeAddModal() {
        document.getElementById('addModal').style.display = 'none';
    }

    function openEditModal(id, title, description, duration, genre, posterUrl) {
        document.getElementById('editId').value = id;
        document.getElementById('editTitle').value = title;
        document.getElementById('editDescription').value = description;
        document.getElementById('editDuration').value = duration;
        document.getElementById('editGenre').value = genre;
        document.getElementById('editPosterUrl').value = posterUrl;
        document.getElementById('editModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    // Close modal when clicking outside
    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>