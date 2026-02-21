package com.theatre.model;

import java.sql.Timestamp;

public class Movie {
    private int id;
    private String title;
    private String description;
    private int duration; // in minutes
    private String genre;
    private String posterUrl;
    private Timestamp createdAt;

    // Constructors
    public Movie() {
    }

    public Movie(String title, String description, int duration, String genre, String posterUrl) {
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.genre = genre;
        this.posterUrl = posterUrl;
    }

    public Movie(int id, String title, String description, int duration, String genre, String posterUrl, Timestamp createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.duration = duration;
        this.genre = genre;
        this.posterUrl = posterUrl;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public String getGenre() {
        return genre;
    }

    public void setGenre(String genre) {
        this.genre = genre;
    }

    public String getPosterUrl() {
        return posterUrl;
    }

    public void setPosterUrl(String posterUrl) {
        this.posterUrl = posterUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    // Helper method to format duration
    public String getFormattedDuration() {
        int hours = duration / 60;
        int mins = duration % 60;
        return hours + "h " + mins + "m";
    }

    @Override
    public String toString() {
        return "Movie{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", genre='" + genre + '\'' +
                ", duration=" + duration +
                '}';
    }
}