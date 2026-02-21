<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.theatre.dao.BookingDAO" %>
<%@ page import="com.theatre.model.Booking" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    // Check if user is admin
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> bookings = bookingDAO.getAllBookings();
    double totalRevenue = bookingDAO.getTotalRevenue();
    int totalBookings = bookingDAO.getTotalBookingsCount();

    request.setAttribute("bookings", bookings);
    request.setAttribute("totalRevenue", totalRevenue);
    request.setAttribute("totalBookings", totalBookings);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings - Admin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: rgba(229, 9, 20, 0.1);
            padding: 2rem;
            border-radius: 10px;
            border-left: 4px solid var(--primary-color);
            text-align: center;
        }

        .stat-value {
            font-size: 2.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .stat-label {
            color: #aaa;
            margin-top: 0.5rem;
            font-size: 1.1rem;
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

        .status-badge {
            padding: 0.4rem 0.8rem;
            border-radius: 15px;
            font-size: 0.85rem;
            font-weight: 600;
        }

        .status-confirmed {
            background: rgba(40, 167, 69, 0.2);
            color: var(--success-color);
        }

        .status-cancelled {
            background: rgba(220, 53, 69, 0.2);
            color: var(--danger-color);
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
    <div class="page-header">
        <h1>All Bookings</h1>
        <p>View and manage all ticket bookings</p>
    </div>

    <!-- Statistics -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-value">${totalBookings}</div>
            <div class="stat-label">Total Bookings</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">₹${totalRevenue}</div>
            <div class="stat-label">Total Revenue</div>
        </div>
        <div class="stat-card">
            <div class="stat-value">${bookings.size()}</div>
            <div class="stat-label">All Transactions</div>
        </div>
    </div>

    <!-- Bookings Table -->
    <div class="table-container">
        <table class="admin-table">
            <thead>
            <tr>
                <th>Booking ID</th>
                <th>User</th>
                <th>Movie</th>
                <th>Show Date</th>
                <th>Show Time</th>
                <th>Tickets</th>
                <th>Amount</th>
                <th>Booked On</th>
                <th>Status</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="booking" items="${bookings}">
                <tr>
                    <td><strong>#${booking.id}</strong></td>
                    <td>
                            ${booking.userName}<br>
                        <small style="color: #aaa;">${booking.userEmail}</small>
                    </td>
                    <td><strong>${booking.movieTitle}</strong></td>
                    <td>${booking.formattedShowDate}</td>
                    <td>${booking.formattedShowTime}</td>
                    <td>${booking.numTickets}</td>
                    <td><strong>₹${booking.totalAmount}</strong></td>
                    <td>${booking.formattedBookingDate}</td>
                    <td>
                                <span class="status-badge ${booking.status == 'confirmed' ? 'status-confirmed' : 'status-cancelled'}">
                                        ${booking.status}
                                </span>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 CineBook - Theatre Booking System. All rights reserved.</p>
</div>
</body>
</html>