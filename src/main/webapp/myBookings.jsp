<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings - CineBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .booking-card-item {
            background: rgba(255, 255, 255, 0.05);
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: all 0.3s ease;
        }

        .booking-card-item:hover {
            transform: translateX(10px);
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.08);
        }

        .booking-header-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            flex-wrap: wrap;
            gap: 1rem;
        }

        .booking-title {
            font-size: 1.5rem;
            color: var(--primary-color);
            font-weight: bold;
        }

        .booking-status {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .status-confirmed {
            background: rgba(40, 167, 69, 0.2);
            color: var(--success-color);
            border: 1px solid var(--success-color);
        }

        .status-cancelled {
            background: rgba(220, 53, 69, 0.2);
            color: var(--danger-color);
            border: 1px solid var(--danger-color);
        }

        .booking-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1rem;
        }

        .booking-detail {
            display: flex;
            flex-direction: column;
            gap: 0.3rem;
        }

        .booking-detail-label {
            color: #aaa;
            font-size: 0.9rem;
        }

        .booking-detail-value {
            color: var(--text-light);
            font-size: 1.1rem;
            font-weight: 600;
        }

        .booking-id {
            color: #aaa;
            font-size: 0.85rem;
            margin-top: 1rem;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .stat-card {
            background: rgba(229, 9, 20, 0.1);
            padding: 1.5rem;
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
    <!-- Page Header -->
    <div class="page-header">
        <h1>My Bookings</h1>
        <p>View and manage your ticket bookings</p>
    </div>

    <!-- Success Message -->
    <c:if test="${sessionScope.bookingSuccess}">
        <div class="alert alert-success">
            ✅ ${sessionScope.bookingDetails}
        </div>
        <c:remove var="bookingSuccess" scope="session"/>
        <c:remove var="bookingDetails" scope="session"/>
    </c:if>

    <!-- Bookings Statistics -->
    <c:if test="${not empty bookings}">
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value">${bookings.size()}</div>
                <div class="stat-label">Total Bookings</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="confirmedCount" value="0"/>
                    <c:forEach var="booking" items="${bookings}">
                        <c:if test="${booking.status == 'confirmed'}">
                            <c:set var="confirmedCount" value="${confirmedCount + 1}"/>
                        </c:if>
                    </c:forEach>
                        ${confirmedCount}
                </div>
                <div class="stat-label">Active Bookings</div>
            </div>
            <div class="stat-card">
                <div class="stat-value">
                    <c:set var="totalSpent" value="0"/>
                    <c:forEach var="booking" items="${bookings}">
                        <c:if test="${booking.status == 'confirmed'}">
                            <c:set var="totalSpent" value="${totalSpent + booking.totalAmount}"/>
                        </c:if>
                    </c:forEach>
                    ₹${totalSpent}
                </div>
                <div class="stat-label">Total Spent</div>
            </div>
        </div>
    </c:if>

    <!-- Bookings List -->
    <c:choose>
        <c:when test="${empty bookings}">
            <div class="empty-state">
                <h3>No bookings yet</h3>
                <p>You haven't made any bookings. Start by browsing our latest movies!</p>
                <a href="${pageContext.request.contextPath}/movieList" class="btn" style="margin-top: 1rem;">
                    Browse Movies
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div>
                <c:forEach var="booking" items="${bookings}">
                    <div class="booking-card-item">
                        <div class="booking-header-row">
                            <h3 class="booking-title">${booking.movieTitle}</h3>
                            <span class="booking-status ${booking.status == 'confirmed' ? 'status-confirmed' : 'status-cancelled'}">
                                    ${booking.status == 'confirmed' ? '✓ Confirmed' : '✗ Cancelled'}
                            </span>
                        </div>

                        <div class="booking-details-grid">
                            <div class="booking-detail">
                                <span class="booking-detail-label">📅 Show Date</span>
                                <span class="booking-detail-value">${booking.formattedShowDate}</span>
                            </div>
                            <div class="booking-detail">
                                <span class="booking-detail-label">🕐 Show Time</span>
                                <span class="booking-detail-value">${booking.formattedShowTime}</span>
                            </div>
                            <div class="booking-detail">
                                <span class="booking-detail-label">🎟️ Tickets</span>
                                <span class="booking-detail-value">${booking.numTickets} Ticket(s)</span>
                            </div>
                            <div class="booking-detail">
                                <span class="booking-detail-label">💰 Total Amount</span>
                                <span class="booking-detail-value">₹${booking.totalAmount}</span>
                            </div>
                            <div class="booking-detail">
                                <span class="booking-detail-label">📆 Booked On</span>
                                <span class="booking-detail-value">${booking.formattedBookingDate}</span>
                            </div>
                        </div>

                        <div class="booking-id">
                            Booking ID: #${booking.id}
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