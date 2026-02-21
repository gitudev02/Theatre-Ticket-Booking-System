package com.theatre.controller;

import com.theatre.dao.MovieDAO;
import com.theatre.model.Movie;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/movieList")
public class MovieListServlet extends HttpServlet {

    private MovieDAO movieDAO;

    @Override
    public void init() throws ServletException {
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String searchQuery = request.getParameter("search");
        List<Movie> movies;

        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            movies = movieDAO.searchMovies(searchQuery.trim());
            request.setAttribute("searchQuery", searchQuery);
        } else {
            movies = movieDAO.getAllMovies();
        }

        request.setAttribute("movies", movies);
        request.getRequestDispatcher("movieList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}