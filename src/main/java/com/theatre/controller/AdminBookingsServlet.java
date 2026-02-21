package com.theatre.controller;

import com.theatre.dao.BookingDAO;
import com.theatre.model.Booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/viewBookings")
public class AdminBookingsServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is admin
        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect(request.getContextPath() + "/movieList");
            return;
        }

        // Get all bookings
        List<Booking> bookings = bookingDAO.getAllBookings();

        // Get statistics
        double totalRevenue = bookingDAO.getTotalRevenue();
        int totalBookings = bookingDAO.getTotalBookingsCount();

        request.setAttribute("bookings", bookings);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("totalBookings", totalBookings);

        request.getRequestDispatcher("/admin/adminBookings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}