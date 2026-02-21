package com.theatre.dao;

import com.theatre.model.Movie;
import com.theatre.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MovieDAO {

    // Get all movies
    public List<Movie> getAllMovies() {
        List<Movie> movies = new ArrayList<>();
        String query = "SELECT * FROM movies ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(query)) {

            while (rs.next()) {
                movies.add(extractMovieFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    // Get movie by ID
    public Movie getMovieById(int movieId) {
        String query = "SELECT * FROM movies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, movieId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return extractMovieFromResultSet(rs);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Search movies by title or genre
    public List<Movie> searchMovies(String keyword) {
        List<Movie> movies = new ArrayList<>();
        String query = "SELECT * FROM movies WHERE title LIKE ? OR genre LIKE ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            String searchPattern = "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                movies.add(extractMovieFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    // Add new movie (Admin)
    public boolean addMovie(Movie movie) {
        String query = "INSERT INTO movies (title, description, duration, genre, poster_url) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getDescription());
            pstmt.setInt(3, movie.getDuration());
            pstmt.setString(4, movie.getGenre());
            pstmt.setString(5, movie.getPosterUrl());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update movie (Admin)
    public boolean updateMovie(Movie movie) {
        String query = "UPDATE movies SET title = ?, description = ?, duration = ?, genre = ?, poster_url = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, movie.getTitle());
            pstmt.setString(2, movie.getDescription());
            pstmt.setInt(3, movie.getDuration());
            pstmt.setString(4, movie.getGenre());
            pstmt.setString(5, movie.getPosterUrl());
            pstmt.setInt(6, movie.getId());

            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete movie (Admin)
    public boolean deleteMovie(int movieId) {
        String query = "DELETE FROM movies WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setInt(1, movieId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get movies by genre
    public List<Movie> getMoviesByGenre(String genre) {
        List<Movie> movies = new ArrayList<>();
        String query = "SELECT * FROM movies WHERE genre = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(query)) {

            pstmt.setString(1, genre);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                movies.add(extractMovieFromResultSet(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return movies;
    }

    // Helper method to extract Movie from ResultSet
    private Movie extractMovieFromResultSet(ResultSet rs) throws SQLException {
        Movie movie = new Movie();
        movie.setId(rs.getInt("id"));
        movie.setTitle(rs.getString("title"));
        movie.setDescription(rs.getString("description"));
        movie.setDuration(rs.getInt("duration"));
        movie.setGenre(rs.getString("genre"));
        movie.setPosterUrl(rs.getString("poster_url"));
        movie.setCreatedAt(rs.getTimestamp("created_at"));
        return movie;
    }
}