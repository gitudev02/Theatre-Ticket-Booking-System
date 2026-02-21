package com.theatre.dao;

import com.theatre.model.Booking;
import com.theatre.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // Create new booking
    // SIMPLIFIED VERSION - No complex transaction handling
    public boolean createBookingSimple(Booking booking) {
        // Step 1: Insert booking
        String insertQuery = "INSERT INTO bookings (user_id, show_id, num_tickets, total_amount, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(insertQuery)) {

            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getShowId());
            pstmt.setInt(3, booking.getNumTickets());
            pstmt.setDouble(4, booking.getTotalAmount());
            pstmt.setString(5, "confirmed");

            int result = pstmt.executeUpdate();

            if (result > 0) {
                // Step 2: Update seats
                String updateQuery = "UPDATE shows SET available_seats = available_seats - ? WHERE id = ?";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateQuery)) {
                    updateStmt.setInt(1, booking.getNumTickets());
                    updateStmt.setInt(2, booking.getShowId());
                    updateStmt.executeUpdate();
                }
                return true;
            }

            return false;

        } catch (SQLException e) {
            System.out.println("Booking Error: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean createBooking(Booking booking) {
        String query = "INSERT INTO bookings (user_id, show_id, num_tickets, total_amount, status) " +
                "VALUES (?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start transaction

            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, booking.getUserId());
            pstmt.setInt(2, booking.getShowId());
            pstmt.setInt(3, booking.getNumTickets());
            pstmt.setDouble(4, booking.getTotalAmount());
            pstmt.setString(5, booking.getStatus());

            int rowsAffected = pstmt.executeUpdate();

            if (rowsAffected > 0) {
                // Update available seats in shows table
                ShowDAO showDAO = new ShowDAO();
                boolean seatsUpdated = showDAO.updateAvailableSeats(booking.getShowId(), booking.getNumTickets());

                if (seatsUpdated) {
                    conn.commit(); // Commit transaction
                    return true;
                } else {
                    conn.rollback(); // Rollback if seats update fails
                    return false;
                }
            }

            conn.rollback();
            return false;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    // Get bookings by user ID
    public List<Booking> getBookingsByUserId(int userId) {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.name as user_name, u.email as user_email, " +
                "m.title as movie_title, s.show_date, s.show_time " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN shows s ON b.show_id = s.id " +
                "JOIN movies m ON s.movie_id = m.id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Get all bookings (Admin)
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String query = "SELECT b.*, u.name as user_name, u.email as user_email, " +
                "m.title as movie_title, s.show_date, s.show_time " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN shows s ON b.show_id = s.id " +
                "JOIN movies m ON s.movie_id = m.id " +
                "ORDER BY b.booking_date DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                bookings.add(extractBookingFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Get booking by ID
    public Booking getBookingById(int bookingId) {
        String query = "SELECT b.*, u.name as user_name, u.email as user_email, " +
                "m.title as movie_title, s.show_date, s.show_time " +
                "FROM bookings b " +
                "JOIN users u ON b.user_id = u.id " +
                "JOIN shows s ON b.show_id = s.id " +
                "JOIN movies m ON s.movie_id = m.id " +
                "WHERE b.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, bookingId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractBookingFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cancel booking
    public boolean cancelBooking(int bookingId) {
        String query = "UPDATE bookings SET status = 'cancelled' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, bookingId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get total revenue (Admin)
    public double getTotalRevenue() {
        String query = "SELECT SUM(total_amount) as revenue FROM bookings WHERE status = 'confirmed'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                return rs.getDouble("revenue");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    // Get booking count (Admin)
    public int getTotalBookingsCount() {
        String query = "SELECT COUNT(*) as count FROM bookings WHERE status = 'confirmed'";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            if (rs.next()) {
                return rs.getInt("count");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Helper method to extract Booking from ResultSet
    private Booking extractBookingFromResultSet(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setId(rs.getInt("id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setShowId(rs.getInt("show_id"));
        booking.setNumTickets(rs.getInt("num_tickets"));
        booking.setTotalAmount(rs.getDouble("total_amount"));
        booking.setBookingDate(rs.getTimestamp("booking_date"));
        booking.setStatus(rs.getString("status"));

        // Set joined data if available
        try {
            booking.setUserName(rs.getString("user_name"));
            booking.setUserEmail(rs.getString("user_email"));
            booking.setMovieTitle(rs.getString("movie_title"));
            booking.setShowDate(rs.getDate("show_date"));
            booking.setShowTime(rs.getTime("show_time"));
        } catch (SQLException e) {
            // Columns might not be present in all queries
        }

        return booking;
    }
}