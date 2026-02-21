CREATE DATABASE IF NOT EXISTS theatre_booking;
USE theatre_booking;

-- Users table
CREATE TABLE users (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       name VARCHAR(100) NOT NULL,
                       email VARCHAR(100) UNIQUE NOT NULL,
                       password VARCHAR(255) NOT NULL,
                       phone VARCHAR(15),
                       role ENUM('user', 'admin') DEFAULT 'user',
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movies table
CREATE TABLE movies (
                        id INT PRIMARY KEY AUTO_INCREMENT,
                        title VARCHAR(200) NOT NULL,
                        description TEXT,
                        duration INT NOT NULL COMMENT 'Duration in minutes',
                        genre VARCHAR(100),
                        poster_url VARCHAR(500),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Shows table
CREATE TABLE shows (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       movie_id INT NOT NULL,
                       show_date DATE NOT NULL,
                       show_time TIME NOT NULL,
                       total_seats INT NOT NULL DEFAULT 100,
                       available_seats INT NOT NULL DEFAULT 100,
                       price DECIMAL(10,2) NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (movie_id) REFERENCES movies(id) ON DELETE CASCADE
);

-- Bookings table
CREATE TABLE bookings (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          user_id INT NOT NULL,
                          show_id INT NOT NULL,
                          num_tickets INT NOT NULL,
                          total_amount DECIMAL(10,2) NOT NULL,
                          booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          status ENUM('confirmed', 'cancelled') DEFAULT 'confirmed',
                          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                          FOREIGN KEY (show_id) REFERENCES shows(id) ON DELETE CASCADE
);

-- Insert default admin user (password: admin123)
INSERT INTO users (name, email, password, role)
VALUES ('Admin', 'admin@theatre.com', 'admin123', 'admin');

-- Insert sample movies
INSERT INTO movies (title, description, duration, genre, poster_url) VALUES
                                                                         ('The Dark Knight', 'When the menace known as the Joker wreaks havoc on Gotham, Batman must accept one of the greatest tests.', 152, 'Action', 'https://image.tmdb.org/t/p/w500/qJ2tW6WMUDux911r6m7haRef0WH.jpg'),
                                                                         ('Inception', 'A thief who steals corporate secrets through dream-sharing technology is given the inverse task.', 148, 'Sci-Fi', 'https://image.tmdb.org/t/p/w500/9gk7adHYeDvHkCSEqAvQNLV5Uge.jpg'),
                                                                         ('Interstellar', 'A team of explorers travel through a wormhole in space in an attempt to ensure humanity survival.', 169, 'Sci-Fi', 'https://image.tmdb.org/t/p/w500/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg');

-- Insert sample shows (upcoming dates)
INSERT INTO shows (movie_id, show_date, show_time, total_seats, available_seats, price) VALUES
                                                                                            (1, '2024-02-05', '14:00:00', 100, 100, 250.00),
                                                                                            (1, '2024-02-05', '18:00:00', 100, 100, 300.00),
                                                                                            (1, '2024-02-06', '21:00:00', 100, 100, 350.00),
                                                                                            (2, '2024-02-05', '15:00:00', 100, 100, 250.00),
                                                                                            (2, '2024-02-06', '19:00:00', 100, 100, 300.00),
                                                                                            (3, '2024-02-05', '17:00:00', 100, 100, 280.00),
                                                                                            (3, '2024-02-06', '20:00:00', 100, 100, 320.00);