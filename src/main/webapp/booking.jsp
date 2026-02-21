<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Tickets - CineBook</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .booking-container {
            max-width: 800px;
            margin: 0 auto;
        }

        .booking-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            padding: 2.5rem;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .booking-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 2rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .booking-header h2 {
            font-size: 2rem;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .show-details {
            background: rgba(229, 9, 20, 0.1);
            padding: 1.5rem;
            border-radius: 10px;
            margin-bottom: 2rem;
            border-left: 4px solid var(--primary-color);
        }

        .show-details-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-top: 1rem;
        }

        .detail-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            color: #ccc;
            font-size: 1.1rem;
        }

        .detail-item strong {
            color: var(--text-light);
        }

        .ticket-selector {
            margin: 2rem 0;
        }

        .ticket-selector label {
            display: block;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: var(--text-light);
        }

        .ticket-input-group {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .ticket-input {
            flex: 1;
            padding: 1rem;
            font-size: 1.2rem;
            background: rgba(255, 255, 255, 0.1);
            border: 2px solid rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            color: white;
            text-align: center;
        }

        .ticket-input:focus {
            outline: none;
            border-color: var(--primary-color);
            background: rgba(255, 255, 255, 0.15);
        }

        .price-summary {
            background: rgba(255, 255, 255, 0.05);
            padding: 1.5rem;
            border-radius: 10px;
            margin: 2rem 0;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            padding: 0.8rem 0;
            font-size: 1.1rem;
        }

        .price-row.total {
            border-top: 2px solid rgba(255, 255, 255, 0.2);
            margin-top: 1rem;
            padding-top: 1rem;
            font-size: 1.5rem;
            font-weight: bold;
            color: var(--primary-color);
        }

        .booking-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .booking-actions .btn {
            flex: 1;
        }

        .info-box {
            background: rgba(255, 193, 7, 0.1);
            border-left: 4px solid var(--warning-color);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 2rem;
            color: #fff3cd;
        }

        @media (max-width: 768px) {
            .show-details-grid {
                grid-template-columns: 1fr;
            }

            .booking-actions {
                flex-direction: column;
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
    <div class="booking-container">
        <div class="booking-card">
            <div class="booking-header">
                <h2>🎟️ Book Your Tickets</h2>
                <p style="color: #aaa;">Complete your booking in seconds</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                        ${error}
                </div>
            </c:if>

            <!-- Show Details -->
            <div class="show-details">
                <h3 style="margin-bottom: 1rem; color: var(--text-light);">${show.movieTitle}</h3>
                <div class="show-details-grid">
                    <div class="detail-item">
                        <span>📅</span>
                        <span><strong>Date:</strong> ${show.formattedDate}</span>
                    </div>
                    <div class="detail-item">
                        <span>🕐</span>
                        <span><strong>Time:</strong> ${show.formattedTime}</span>
                    </div>
                    <div class="detail-item">
                        <span>💰</span>
                        <span><strong>Price:</strong> ₹${show.price} per ticket</span>
                    </div>
                    <div class="detail-item">
                        <span>💺</span>
                        <span><strong>Available:</strong> ${show.availableSeats} seats</span>
                    </div>
                </div>
            </div>

            <!-- Booking Form -->
            <form action="${pageContext.request.contextPath}/booking" method="post" id="bookingForm">
                <input type="hidden" name="showId" value="${show.id}">

                <div class="ticket-selector">
                    <label for="numTickets">Number of Tickets</label>
                    <div class="ticket-input-group">
                        <button type="button"
                                class="btn btn-secondary"
                                onclick="decrementTickets()"
                                style="width: 50px;">
                            -
                        </button>
                        <input type="number"
                               id="numTickets"
                               name="numTickets"
                               class="ticket-input"
                               value="1"
                               min="1"
                               max="${show.availableSeats > 10 ? 10 : show.availableSeats}"
                               onchange="updatePrice()"
                               required>
                        <button type="button"
                                class="btn btn-secondary"
                                onclick="incrementTickets()"
                                style="width: 50px;">
                            +
                        </button>
                    </div>
                    <small style="color: #aaa;">Maximum 10 tickets per booking</small>
                </div>

                <!-- Price Summary -->
                <div class="price-summary">
                    <div class="price-row">
                        <span>Ticket Price:</span>
                        <span>₹<span id="ticketPrice">${show.price}</span></span>
                    </div>
                    <div class="price-row">
                        <span>Number of Tickets:</span>
                        <span id="ticketCount">1</span>
                    </div>
                    <div class="price-row total">
                        <span>Total Amount:</span>
                        <span>₹<span id="totalAmount">${show.price}</span></span>
                    </div>
                </div>

                <!-- Booking Actions -->
                <div class="booking-actions">
                    <a href="${pageContext.request.contextPath}/showList?movieId=${show.movieId}"
                       class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn">
                        Confirm Booking
                    </button>
                </div>
            </form>

            <!-- Info Box -->
            <div class="info-box">
                <strong>📌 Note:</strong> Please review your booking details before confirming.
                Bookings once confirmed cannot be modified.
            </div>
        </div>
    </div>
</div>

<!-- Footer -->
<div class="footer">
    <p>&copy; 2024 CineBook - Theatre Booking System. All rights reserved.</p>
</div>

<script>
    const pricePerTicket = ${show.price};
    const maxTickets = Math.min(10, ${show.availableSeats});

    function updatePrice() {
        const numTickets = parseInt(document.getElementById('numTickets').value) || 1;
        const validTickets = Math.min(Math.max(1, numTickets), maxTickets);

        document.getElementById('numTickets').value = validTickets;
        document.getElementById('ticketCount').textContent = validTickets;
        document.getElementById('totalAmount').textContent = (pricePerTicket * validTickets).toFixed(2);
    }

    function incrementTickets() {
        const input = document.getElementById('numTickets');
        const currentValue = parseInt(input.value) || 1;
        if (currentValue < maxTickets) {
            input.value = currentValue + 1;
            updatePrice();
        }
    }

    function decrementTickets() {
        const input = document.getElementById('numTickets');
        const currentValue = parseInt(input.value) || 1;
        if (currentValue > 1) {
            input.value = currentValue - 1;
            updatePrice();
        }
    }

    // Form validation
    document.getElementById('bookingForm').addEventListener('submit', function(e) {
        const numTickets = parseInt(document.getElementById('numTickets').value);
        if (numTickets < 1 || numTickets > maxTickets) {
            e.preventDefault();
            alert('Please select between 1 and ' + maxTickets + ' tickets');
        }
    });
</script>
</body>
</html>