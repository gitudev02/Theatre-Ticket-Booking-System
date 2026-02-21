package com.theatre.controller;

import com.theatre.dao.BookingDAO;
import com.theatre.dao.ShowDAO;
import com.theatre.model.Booking;
import com.theatre.model.Show;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/booking")
public class BookingServlet extends HttpServlet {

    private ShowDAO showDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() throws ServletException {
        showDAO = new ShowDAO();
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String showIdParam = request.getParameter("showId");

        if (showIdParam == null || showIdParam.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/movieList");
            return;
        }

        try {
            int showId = Integer.parseInt(showIdParam);
            Show show = showDAO.getShowById(showId);

            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/movieList");
                return;
            }

            if (show.getAvailableSeats() <= 0) {
                request.setAttribute("error", "Sorry, this show is sold out!");
                request.getRequestDispatcher("movieList").forward(request, response);
                return;
            }

            request.setAttribute("show", show);
            request.getRequestDispatcher("booking.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/movieList");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String showIdParam = request.getParameter("showId");
        String numTicketsParam = request.getParameter("numTickets");

        if (showIdParam == null || numTicketsParam == null) {
            response.sendRedirect(request.getContextPath() + "/movieList");
            return;
        }

        try {
            int showId = Integer.parseInt(showIdParam);
            int numTickets = Integer.parseInt(numTicketsParam);

            // Validate
            if (numTickets < 1 || numTickets > 10) {
                Show show = showDAO.getShowById(showId);
                request.setAttribute("error", "Please select between 1 and 10 tickets");
                request.setAttribute("show", show);
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // Get show
            Show show = showDAO.getShowById(showId);
            if (show == null) {
                response.sendRedirect(request.getContextPath() + "/movieList");
                return;
            }

            // Check seats
            if (show.getAvailableSeats() < numTickets) {
                request.setAttribute("error", "Not enough seats! Only " + show.getAvailableSeats() + " left.");
                request.setAttribute("show", show);
                request.getRequestDispatcher("booking.jsp").forward(request, response);
                return;
            }

            // Calculate amount
            double totalAmount = show.getPrice() * numTickets;

            // Create booking - SIMPLIFIED VERSION
            Booking booking = new Booking(userId, showId, numTickets, totalAmount);
            boolean success = bookingDAO.createBookingSimple(booking);

            if (success) {
                session.setAttribute("bookingSuccess", true);
                session.setAttribute("bookingDetails",
                        "Successfully booked " + numTickets + " ticket(s) for " +
                                show.getMovieTitle() + " - Total: ₹" + totalAmount);
                response.sendRedirect(request.getContextPath() + "/myBookings");
            } else {
                request.setAttribute("error", "Booking failed. Please try again.");
                request.setAttribute("show", show);
                request.getRequestDispatcher("booking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/movieList");
        }
    }
}