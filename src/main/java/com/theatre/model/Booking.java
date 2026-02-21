package com.theatre.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Booking {
    private int id;
    private int userId;
    private int showId;
    private int numTickets;
    private double totalAmount;
    private Timestamp bookingDate;
    private String status; // 'confirmed' or 'cancelled'

    // Additional fields for joined data
    private String userName;
    private String userEmail;
    private String movieTitle;
    private Date showDate;
    private Time showTime;

    // Constructors
    public Booking() {
    }

    public Booking(int userId, int showId, int numTickets, double totalAmount) {
        this.userId = userId;
        this.showId = showId;
        this.numTickets = numTickets;
        this.totalAmount = totalAmount;
        this.status = "confirmed";
    }

    public Booking(int id, int userId, int showId, int numTickets, double totalAmount,
                   Timestamp bookingDate, String status) {
        this.id = id;
        this.userId = userId;
        this.showId = showId;
        this.numTickets = numTickets;
        this.totalAmount = totalAmount;
        this.bookingDate = bookingDate;
        this.status = status;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getShowId() {
        return showId;
    }

    public void setShowId(int showId) {
        this.showId = showId;
    }

    public int getNumTickets() {
        return numTickets;
    }

    public void setNumTickets(int numTickets) {
        this.numTickets = numTickets;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getBookingDate() {
        return bookingDate;
    }

    public void setBookingDate(Timestamp bookingDate) {
        this.bookingDate = bookingDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public Date getShowDate() {
        return showDate;
    }

    public void setShowDate(Date showDate) {
        this.showDate = showDate;
    }

    public Time getShowTime() {
        return showTime;
    }

    public void setShowTime(Time showTime) {
        this.showTime = showTime;
    }

    // Helper methods
    public String getFormattedBookingDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy hh:mm a");
        return sdf.format(bookingDate);
    }

    public String getFormattedShowDate() {
        if (showDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("EEE, MMM dd, yyyy");
            return sdf.format(showDate);
        }
        return "";
    }

    public String getFormattedShowTime() {
        if (showTime != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
            return sdf.format(showTime);
        }
        return "";
    }
    public boolean isConfirmed() {
        return "confirmed".equalsIgnoreCase(status);
    }
    public boolean isCancelled() {
        return "cancelled".equalsIgnoreCase(status);
    }
    @Override
    public String toString() {
        return "Booking{" +
                "id=" + id +
                ", userId=" + userId +
                ", showId=" + showId +
                ", numTickets=" + numTickets +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                '}';
    }
}