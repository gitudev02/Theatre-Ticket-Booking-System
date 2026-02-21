package com.theatre.dao;

import com.theatre.model.Show;
import com.theatre.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ShowDAO {

    // Get all shows
    public List<Show> getAllShows() {
        List<Show> shows = new ArrayList<>();
        String query = "SELECT s.*, m.title as movie_title, m.poster_url as movie_poster " +
                "FROM shows s " +
                "JOIN movies m ON s.movie_id = m.id " +
                "ORDER BY s.show_date, s.show_time";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                shows.add(extractShowFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shows;
    }

    // Get shows by movie ID
    public List<Show> getShowsByMovieId(int movieId) {
        List<Show> shows = new ArrayList<>();
        String query = "SELECT s.*, m.title as movie_title, m.poster_url as movie_poster " +
                "FROM shows s " +
                "JOIN movies m ON s.movie_id = m.id " +
                "WHERE s.movie_id = ? AND s.show_date >= CURDATE() " +
                "ORDER BY s.show_date, s.show_time";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                shows.add(extractShowFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shows;
    }

    // Get show by ID
    public Show getShowById(int showId) {
        String query = "SELECT s.*, m.title as movie_title, m.poster_url as movie_poster " +
                "FROM shows s " +
                "JOIN movies m ON s.movie_id = m.id " +
                "WHERE s.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, showId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractShowFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add new show (Admin)
    public boolean addShow(Show show) {
        String query = "INSERT INTO shows (movie_id, show_date, show_time, total_seats, available_seats, price) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, show.getMovieId());
            pstmt.setDate(2, show.getShowDate());
            pstmt.setTime(3, show.getShowTime());
            pstmt.setInt(4, show.getTotalSeats());
            pstmt.setInt(5, show.getAvailableSeats());
            pstmt.setDouble(6, show.getPrice());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update show (Admin)
    public boolean updateShow(Show show) {
        String query = "UPDATE shows SET movie_id = ?, show_date = ?, show_time = ?, " +
                "total_seats = ?, available_seats = ?, price = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, show.getMovieId());
            pstmt.setDate(2, show.getShowDate());
            pstmt.setTime(3, show.getShowTime());
            pstmt.setInt(4, show.getTotalSeats());
            pstmt.setInt(5, show.getAvailableSeats());
            pstmt.setDouble(6, show.getPrice());
            pstmt.setInt(7, show.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete show (Admin)
    public boolean deleteShow(int showId) {
        String query = "DELETE FROM shows WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, showId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update available seats after booking
    public boolean updateAvailableSeats(int showId, int seatsToBook) {
        String query = "UPDATE shows SET available_seats = available_seats - ? WHERE id = ? AND available_seats >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, seatsToBook);
            pstmt.setInt(2, showId);
            pstmt.setInt(3, seatsToBook);

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get upcoming shows (shows from today onwards)
    public List<Show> getUpcomingShows() {
        List<Show> shows = new ArrayList<>();
        String query = "SELECT s.*, m.title as movie_title, m.poster_url as movie_poster " +
                "FROM shows s " +
                "JOIN movies m ON s.movie_id = m.id " +
                "WHERE s.show_date >= CURDATE() AND s.available_seats > 0 " +
                "ORDER BY s.show_date, s.show_time " +
                "LIMIT 20";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                shows.add(extractShowFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shows;
    }

    // Helper method to extract Show from ResultSet
    private Show extractShowFromResultSet(ResultSet rs) throws SQLException {
        Show show = new Show();
        show.setId(rs.getInt("id"));
        show.setMovieId(rs.getInt("movie_id"));
        show.setShowDate(rs.getDate("show_date"));
        show.setShowTime(rs.getTime("show_time"));
        show.setTotalSeats(rs.getInt("total_seats"));
        show.setAvailableSeats(rs.getInt("available_seats"));
        show.setPrice(rs.getDouble("price"));
        show.setCreatedAt(rs.getTimestamp("created_at"));

        // Set joined data if available
        try {
            show.setMovieTitle(rs.getString("movie_title"));
            show.setMoviePoster(rs.getString("movie_poster"));
        } catch (SQLException e) {
            // Columns might not be present in all queries
        }

        return show;
    }
}