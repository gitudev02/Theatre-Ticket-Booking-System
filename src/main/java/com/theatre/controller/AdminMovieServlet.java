package com.theatre.controller;

import com.theatre.dao.MovieDAO;
import com.theatre.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/adminMovie")
public class AdminMovieServlet extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() throws ServletException {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addMovie(request, response);
        } else if ("update".equals(action)) {
            updateMovie(request, response);
        } else if ("delete".equals(action)) {
            deleteMovie(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/adminMovies.jsp");
        }
    }

    private void addMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String durationStr = request.getParameter("duration");
        String genre = request.getParameter("genre");
        String posterUrl = request.getParameter("posterUrl");

        try {
            int duration = Integer.parseInt(durationStr);

            Movie movie = new Movie(title, description, duration, genre, posterUrl);
            boolean success = movieDAO.addMovie(movie);

            if (success) {
                request.getSession().setAttribute("successMessage", "Movie added successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add movie.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid duration value.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminMovies.jsp");
    }

    private void updateMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String durationStr = request.getParameter("duration");
        String genre = request.getParameter("genre");
        String posterUrl = request.getParameter("posterUrl");

        try {
            int id = Integer.parseInt(idStr);
            int duration = Integer.parseInt(durationStr);

            Movie movie = new Movie(title, description, duration, genre, posterUrl);
            movie.setId(id);

            boolean success = movieDAO.updateMovie(movie);

            if (success) {
                request.getSession().setAttribute("successMessage", "Movie updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update movie.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid input values.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminMovies.jsp");
    }

    private void deleteMovie(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        try {
            int id = Integer.parseInt(idStr);
            boolean success = movieDAO.deleteMovie(id);

            if (success) {
                request.getSession().setAttribute("successMessage", "Movie deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete movie.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid movie ID.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminMovies.jsp");
    }
}