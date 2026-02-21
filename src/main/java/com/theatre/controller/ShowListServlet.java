package com.theatre.controller;

import com.theatre.dao.MovieDAO;
import com.theatre.dao.ShowDAO;
import com.theatre.model.Movie;
import com.theatre.model.Show;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/showList")
public class ShowListServlet extends HttpServlet {

    private ShowDAO showDAO;
    private MovieDAO movieDAO;

    @Override
    public void init() throws ServletException {
        showDAO = new ShowDAO();
        movieDAO = new MovieDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String movieIdParam = request.getParameter("movieId");

        if (movieIdParam == null || movieIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movieList");
            return;
        }

        try {
            int movieId = Integer.parseInt(movieIdParam);

            // Get movie details
            Movie movie = movieDAO.getMovieById(movieId);
            if (movie == null) {
                response.sendRedirect(request.getContextPath() + "/movieList");
                return;
            }

            // Get shows for this movie
            List<Show> shows = showDAO.getShowsByMovieId(movieId);

            request.setAttribute("movie", movie);
            request.setAttribute("shows", shows);
            request.getRequestDispatcher("showList.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movieList");
        }
    }
}