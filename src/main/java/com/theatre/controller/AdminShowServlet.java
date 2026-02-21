package com.theatre.controller;

import com.theatre.dao.ShowDAO;
import com.theatre.model.Show;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;

@WebServlet("/admin/adminShow")
public class AdminShowServlet extends HttpServlet {

    private ShowDAO showDAO;

    @Override
    public void init() throws ServletException {
        showDAO = new ShowDAO();
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
            addShow(request, response);
        } else if ("update".equals(action)) {
            updateShow(request, response);
        } else if ("delete".equals(action)) {
            deleteShow(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/admin/adminShows.jsp");
        }
    }

    private void addShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            Date showDate = Date.valueOf(request.getParameter("showDate"));
            Time showTime = Time.valueOf(request.getParameter("showTime") + ":00");
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            double price = Double.parseDouble(request.getParameter("price"));

            Show show = new Show(movieId, showDate, showTime, totalSeats, totalSeats, price);
            boolean success = showDAO.addShow(show);

            if (success) {
                request.getSession().setAttribute("successMessage", "Show added successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add show.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Invalid input: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminShows.jsp");
    }

    private void updateShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            int movieId = Integer.parseInt(request.getParameter("movieId"));
            Date showDate = Date.valueOf(request.getParameter("showDate"));
            Time showTime = Time.valueOf(request.getParameter("showTime") + ":00");
            int totalSeats = Integer.parseInt(request.getParameter("totalSeats"));
            int availableSeats = Integer.parseInt(request.getParameter("availableSeats"));
            double price = Double.parseDouble(request.getParameter("price"));

            Show show = new Show(id, movieId, showDate, showTime, totalSeats, availableSeats, price, null);
            boolean success = showDAO.updateShow(show);

            if (success) {
                request.getSession().setAttribute("successMessage", "Show updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update show.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Invalid input: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminShows.jsp");
    }

    private void deleteShow(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean success = showDAO.deleteShow(id);

            if (success) {
                request.getSession().setAttribute("successMessage", "Show deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete show.");
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Invalid show ID.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/adminShows.jsp");
    }
}