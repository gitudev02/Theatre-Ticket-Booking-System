package com.theatre.model;

import java.sql.Date;
import java.sql.Time;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;

public class Show {
    private int id;
    private int movieId;
    private Date showDate;
    private Time showTime;
    private int totalSeats;
    private int availableSeats;
    private double price;
    private Timestamp createdAt;

    // Additional fields for joined data
    private String movieTitle;
    private String moviePoster;

    // Constructors
    public Show() {
    }

    public Show(int movieId, Date showDate, Time showTime, int totalSeats, int availableSeats, double price) {
        this.movieId = movieId;
        this.showDate = showDate;
        this.showTime = showTime;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
        this.price = price;
    }

    public Show(int id, int movieId, Date showDate, Time showTime, int totalSeats,
                int availableSeats, double price, Timestamp createdAt) {
        this.id = id;
        this.movieId = movieId;
        this.showDate = showDate;
        this.showTime = showTime;
        this.totalSeats = totalSeats;
        this.availableSeats = availableSeats;
        this.price = price;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMovieId() {
        return movieId;
    }

    public void setMovieId(int movieId) {
        this.movieId = movieId;
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

    public int getTotalSeats() {
        return totalSeats;
    }

    public void setTotalSeats(int totalSeats) {
        this.totalSeats = totalSeats;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public void setAvailableSeats(int availableSeats) {
        this.availableSeats = availableSeats;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getMovieTitle() {
        return movieTitle;
    }

    public void setMovieTitle(String movieTitle) {
        this.movieTitle = movieTitle;
    }

    public String getMoviePoster() {
        return moviePoster;
    }

    public void setMoviePoster(String moviePoster) {
        this.moviePoster = moviePoster;
    }

    // Helper methods
    public String getFormattedDate() {
        SimpleDateFormat sdf = new SimpleDateFormat("EEE, MMM dd, yyyy");
        return sdf.format(showDate);
    }

    public String getFormattedTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("hh:mm a");
        return sdf.format(showTime);
    }

    public int getBookedSeats() {
        return totalSeats - availableSeats;
    }

    public double getOccupancyPercentage() {
        return ((double) getBookedSeats() / totalSeats) * 100;
    }

    public boolean isAvailable() {
        return availableSeats > 0;
    }

    @Override
    public String toString() {
        return "Show{" +
                "id=" + id +
                ", movieId=" + movieId +
                ", showDate=" + showDate +
                ", showTime=" + showTime +
                ", availableSeats=" + availableSeats +
                '}';
    }
}