-- Таблиця для збереження інформації про готелі
CREATE TABLE hotels (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор готелю
    name VARCHAR(255) NOT NULL, -- Назва готелю (обов’язкове поле)
    location VARCHAR(255) NOT NULL, -- Адреса або місцезнаходження готелю (обов’язкове поле)
    rating DECIMAL(3,2), -- Рейтинг готелю (від 0.00 до 9.99)
    description TEXT -- Опис готелю
);
-- Таблиця для номерів у готелях
CREATE TABLE rooms (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор номера
    hotel_id INT REFERENCES hotels(id) ON DELETE CASCADE, -- Посилання на готель, якому належить номер
    room_number VARCHAR(10) NOT NULL, -- Номер кімнати (обов’язкове поле)
    room_type VARCHAR(50), -- Тип кімнати (наприклад, стандарт, люкс тощо)
    price_per_night DECIMAL(10,2), -- Ціна за ніч проживання
    availability BOOLEAN DEFAULT TRUE -- Доступність кімнати (за замовчуванням - доступна)
);
-- Таблиця користувачів (клієнтів)
CREATE TABLE users (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    name VARCHAR(100), -- Ім'я користувача
    email VARCHAR(100) UNIQUE NOT NULL, -- Email (унікальне та обов'язкове поле)
    phone VARCHAR(20), -- Номер телефону
    password VARCHAR(255) NOT NULL -- Хешований пароль (обов’язкове поле)
);
-- Таблиця для бронювання номерів
CREATE TABLE bookings (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор бронювання
    user_id INT REFERENCES users(id) ON DELETE CASCADE, -- Посилання на користувача, який зробив бронювання
    room_id INT REFERENCES rooms(id) ON DELETE CASCADE, -- Посилання на номер, що заброньовано
    check_in_date DATE NOT NULL, -- Дата заїзду (обов’язкове поле)
    check_out_date DATE NOT NULL, -- Дата виїзду (обов’язкове поле)
    status VARCHAR(20) CHECK (status IN ('active', 'cancelled')) NOT NULL -- Статус бронювання (активне або скасоване)
);
-- Таблиця для платежів
CREATE TABLE payments (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор платежу
    booking_id INT REFERENCES bookings(id) ON DELETE CASCADE, -- Посилання на бронювання, за яке зроблено оплату
    amount DECIMAL(10,2) NOT NULL, -- Сума платежу (обов’язкове поле)
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- Дата та час платежу (за замовчуванням - поточний час)
    status VARCHAR(20) CHECK (status IN ('paid', 'pending')) NOT NULL -- Статус платежу (оплачено чи очікує оплату)
);
-- Таблиця для відгуків користувачів про готелі
CREATE TABLE reviews (
    id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор відгуку
    user_id INT REFERENCES users(id) ON DELETE CASCADE, -- Посилання на користувача, який залишив відгук
    hotel_id INT REFERENCES hotels(id) ON DELETE CASCADE, -- Посилання на готель, який оцінюють
    rating INT CHECK (rating BETWEEN 1 AND 5) NOT NULL, -- Оцінка (від 1 до 5, обов’язкове поле)
    comment TEXT -- Коментар користувача
);

-- Додавання готелів
INSERT INTO hotels (name, location, rating, description) VALUES
('Grand Hotel', 'New York, USA', 4.5, 'Luxury hotel in the city center'),
('Sea View Resort', 'Miami, USA', 4.2, 'Resort with a beautiful sea view'),
('Mountain Lodge', 'Denver, USA', 4.7, 'Cozy lodge in the mountains'),
('City Inn', 'Los Angeles, USA', 4.0, 'Affordable and comfortable'),
('Royal Palace', 'Las Vegas, USA', 4.8, 'Five-star luxury experience');

-- Додавання номерів
INSERT INTO rooms (hotel_id, room_number, room_type, price_per_night, availability) VALUES
(1, '101', 'Deluxe', 200.00, TRUE),
(1, '102', 'Standard', 150.00, TRUE),
(2, '201', 'Suite', 300.00, FALSE),
(2, '202', 'Standard', 180.00, TRUE),
(3, '301', 'Luxury', 250.00, FALSE),
(3, '302', 'Standard', 170.00, TRUE),
(4, '401', 'Economy', 100.00, TRUE),
(4, '402', 'Standard', 120.00, FALSE),
(5, '501', 'Royal Suite', 500.00, TRUE),
(5, '502', 'Deluxe', 280.00, TRUE);

-- Додавання користувачів (клієнтів)
INSERT INTO users (name, email, phone, password) VALUES
('John Doe', 'john.doe@example.com', '+1234567890', 'hashedpassword1'),
('Alice Smith', 'alice.smith@example.com', '+0987654321', 'hashedpassword2'),
('Bob Johnson', 'bob.johnson@example.com', '+1122334455', 'hashedpassword3'),
('Emma Brown', 'emma.brown@example.com', '+9988776655', 'hashedpassword4'),
('Michael Davis', 'michael.davis@example.com', '+6677889900', 'hashedpassword5');

-- Додавання бронювань
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, status) VALUES
(1, 1, '2025-04-01', '2025-04-05', 'active'),
(2, 3, '2025-05-10', '2025-05-15', 'cancelled'),
(3, 4, '2025-06-01', '2025-06-07', 'active'),
(4, 7, '2025-07-12', '2025-07-15', 'active'),
(5, 9, '2025-08-05', '2025-08-10', 'cancelled');

-- Додавання платежів
INSERT INTO payments (booking_id, amount, payment_date, status) VALUES
(1, 800.00, '2025-03-25 10:00:00', 'paid'),
(2, 1500.00, '2025-04-15 12:30:00', 'pending'),
(3, 1260.00, '2025-05-28 15:45:00', 'paid'),
(4, 300.00, '2025-06-20 09:00:00', 'paid'),
(5, 2500.00, '2025-07-25 14:15:00', 'pending');

-- Додавання відгуків
INSERT INTO reviews (user_id, hotel_id, rating, comment) VALUES
(1, 1, 5, 'Great service and clean rooms!'),
(2, 2, 4, 'Nice location but a bit expensive.'),
(3, 3, 5, 'Amazing view from the balcony!'),
(4, 4, 3, 'Decent for the price, but could be cleaner.'),
(5, 5, 5, 'Absolutely stunning! Best hotel I have ever stayed at.');

-- Вилучити зовнішній ключ між таблицями rooms і hotels
ALTER TABLE rooms DROP CONSTRAINT rooms_hotel_id_fkey;


-- Вилучити поле description з таблиці hotels
ALTER TABLE hotels DROP COLUMN description;
-- Змінити тип поля rating з DECIMAL(3,2) на DECIMAL(5,2)
ALTER TABLE hotels ALTER COLUMN rating TYPE DECIMAL(5,2);

-- Змінити тип поля phone в таблиці users на VARCHAR(15)
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(15);

-- Змінити тип поля phone в таблиці users на VARCHAR(15)
ALTER TABLE users ALTER COLUMN phone TYPE VARCHAR(15);

-- Додати поле hotel_email в таблицю hotels
ALTER TABLE hotels ADD COLUMN hotel_email VARCHAR(255);
-- Додати унікальне обмеження для поля hotel_email
ALTER TABLE hotels ADD CONSTRAINT unique_hotel_email UNIQUE (hotel_email);

-- Змінити тип обмеження для зв'язку між bookings і rooms
ALTER TABLE bookings DROP CONSTRAINT bookings_room_id_fkey;
ALTER TABLE bookings ADD CONSTRAINT bookings_room_id_fkey FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE SET NULL;

-- UNION
SELECT payment_date AS review_date FROM payments
UNION
SELECT check_in_date FROM bookings;
-- IN
SELECT NAME FROM hotels
WHERE id IN (SELECT id FROM users);
-- NOT IN
SELECT NAME FROM hotels
WHERE id NOT IN (SELECT id FROM users);
-- PRODUCT
SELECT * FROM hotels, users;