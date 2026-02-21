<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.theatre.dao.ShowDAO" %>
<%@ page import="com.theatre.dao.MovieDAO" %>
<%@ page import="com.theatre.model.Show" %>
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

    ShowDAO showDAO = new ShowDAO();
    MovieDAO movieDAO = new MovieDAO();
    List<Show> shows = showDAO.getAllShows();
    List<Movie> movies = movieDAO.getAllMovies();
    request.setAttribute("shows", shows);
    request.setAttribute("movies", movies);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Shows - Admin</title>
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
            <h1>Manage Shows</h1>
            <p>Add, edit, or delete show timings</p>
        </div>
        <button onclick="openAddModal()" class="btn">+ Add Show</button>
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

    <!-- Shows Table -->
    <div class="table-container">
        <table class="admin-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Movie</th>
                <th>Date</th>
                <th>Time</th>
                <th>Total Seats</th>
                <th>Available</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="show" items="${shows}">
                <tr>
                    <td>${show.id}</td>
                    <td><strong>${show.movieTitle}</strong></td>
                    <td>${show.formattedDate}</td>
                    <td>${show.formattedTime}</td>
                    <td>${show.totalSeats}</td>
                    <td>
                        <c:choose>
                            <c:when test="${show.availableSeats == 0}">
                                <span style="color: var(--danger-color);">${show.availableSeats}</span>
                            </c:when>
                            <c:when test="${show.availableSeats <= 20}">
                                <span style="color: var(--warning-color);">${show.availableSeats}</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: var(--success-color);">${show.availableSeats}</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>₹${show.price}</td>
                    <td>
                        <div class="action-buttons">
                            <button onclick='openEditModal(${show.id}, ${show.movieId}, "${show.showDate}", "${show.showTime}", ${show.totalSeats}, ${show.availableSeats}, ${show.price})'
                                    class="btn btn-small btn-secondary">
                                Edit
                            </button>
                            <form action="${pageContext.request.contextPath}/admin/adminShow" method="post" style="display: inline;"
                                  onsubmit="return confirm('Are you sure you want to delete this show?');">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="${show.id}">
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

<!-- Add Show Modal -->
<div id="addModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeAddModal()">&times;</span>
        <h2 style="margin-bottom: 2rem; color: var(--primary-color);">Add New Show</h2>
        <form action="${pageContext.request.contextPath}/admin/adminShow" method="post">
            <input type="hidden" name="action" value="add">

            <div class="form-group">
                <label class="form-label">Movie</label>
                <select name="movieId" class="form-control" required>
                    <option value="">Select Movie</option>
                    <c:forEach var="movie" items="${movies}">
                        <option value="${movie.id}">${movie.title}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Show Date</label>
                <input type="date" name="showDate" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Show Time</label>
                <input type="time" name="showTime" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Total Seats</label>
                <input type="number" name="totalSeats" class="form-control" min="1" value="100" required>
            </div>

            <div class="form-group">
                <label class="form-label">Price (₹)</label>
                <input type="number" name="price" class="form-control" min="1" step="0.01" required>
            </div>

            <button type="submit" class="btn btn-block">Add Show</button>
        </form>
    </div>
</div>

<!-- Edit Show Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2 style="margin-bottom: 2rem; color: var(--primary-color);">Edit Show</h2>
        <form action="${pageContext.request.contextPath}/admin/adminShow" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="editId">

            <div class="form-group">
                <label class="form-label">Movie</label>
                <select name="movieId" id="editMovieId" class="form-control" required>
                    <c:forEach var="movie" items="${movies}">
                        <option value="${movie.id}">${movie.title}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Show Date</label>
                <input type="date" name="showDate" id="editShowDate" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Show Time</label>
                <input type="time" name="showTime" id="editShowTime" class="form-control" required>
            </div>

            <div class="form-group">
                <label class="form-label">Total Seats</label>
                <input type="number" name="totalSeats" id="editTotalSeats" class="form-control" min="1" required>
            </div>

            <div class="form-group">
                <label class="form-label">Available Seats</label>
                <input type="number" name="availableSeats" id="editAvailableSeats" class="form-control" min="0" required>
            </div>

            <div class="form-group">
                <label class="form-label">Price (₹)</label>
                <input type="number" name="price" id="editPrice" class="form-control" min="1" step="0.01" required>
            </div>

            <button type="submit" class="btn btn-block">Update Show</button>
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

    function openEditModal(id, movieId, showDate, showTime, totalSeats, availableSeats, price) {
        document.getElementById('editId').value = id;
        document.getElementById('editMovieId').value = movieId;
        document.getElementById('editShowDate').value = showDate;
        document.getElementById('editShowTime').value = showTime.substring(0, 5);
        document.getElementById('editTotalSeats').value = totalSeats;
        document.getElementById('editAvailableSeats').value = availableSeats;
        document.getElementById('editPrice').value = price;
        document.getElementById('editModal').style.display = 'block';
    }

    function closeEditModal() {
        document.getElementById('editModal').style.display = 'none';
    }

    window.onclick = function(event) {
        if (event.target.className === 'modal') {
            event.target.style.display = 'none';
        }
    }
</script>
</body>
</html>