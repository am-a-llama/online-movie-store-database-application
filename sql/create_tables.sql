CREATE TABLE CUSTOMER (
    Customer_id NUMBER PRIMARY KEY,
    First_name VARCHAR2(50) NOT NULL,
    Last_name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Address VARCHAR2(200),
    Phone VARCHAR2(20),
    Points NUMBER DEFAULT 0
);

CREATE TABLE MOVIE (
    Movie_id NUMBER PRIMARY KEY,
    Movie_name VARCHAR2(200) NOT NULL,
    Director VARCHAR2(100),
    Genre VARCHAR2(50),
    Language VARCHAR2(50),
    Release_year NUMBER(4)
);


CREATE TABLE MOVIE_INFO (
    Movie_id NUMBER PRIMARY KEY,
    Movie_name VARCHAR2(200),
    Genre VARCHAR2(50)
);


CREATE TABLE ORDER_FINAL (
    Order_id NUMBER,
    Movie_id NUMBER,
    Quantity NUMBER,
    Price NUMBER(10,2),
    PRIMARY KEY (Order_id, Movie_id),
    CONSTRAINT uq_order_id UNIQUE (Order_id)
);


CREATE TABLE TRANSACTION_FINAL (
    Transaction_id NUMBER PRIMARY KEY,
    Order_id NUMBER NOT NULL,
    Transaction_date DATE DEFAULT SYSDATE,
    Payment_status VARCHAR2(50),
    FOREIGN KEY (Order_id) REFERENCES ORDER_FINAL(Order_id)
);


CREATE TABLE ORDER_PAYMENT (
    Order_id NUMBER PRIMARY KEY,
    Amount NUMBER(10,2),
    Payment_method VARCHAR2(50)
);

CREATE TABLE REVIEW (
    Review_no NUMBER PRIMARY KEY,
    Rating NUMBER CHECK (Rating BETWEEN 1 AND 5),
    Comments VARCHAR2(500),
    Review_date DATE DEFAULT SYSDATE,
    Movie_id NUMBER NOT NULL,
    Customer_id NUMBER NOT NULL,
    FOREIGN KEY (Movie_id) REFERENCES MOVIE(Movie_id),
    FOREIGN KEY (Customer_id) REFERENCES CUSTOMER(Customer_id)
);
