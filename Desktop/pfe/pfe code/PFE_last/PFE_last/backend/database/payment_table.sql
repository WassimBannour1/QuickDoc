CREATE TABLE payments IF NOT EXIST (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    stripe_payment_id VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(id)
);