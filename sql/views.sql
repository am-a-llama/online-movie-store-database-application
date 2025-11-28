---------------------------------------------------------
-- VW_MOVIE_RATINGS
---------------------------------------------------------
CREATE OR REPLACE VIEW VW_MOVIE_RATINGS AS
SELECT 
    m.Movie_id,
    m.Movie_name,
    AVG(r.Rating) AS Avg_Rating,
    COUNT(r.Review_no) AS Review_Count
FROM MOVIE m
LEFT JOIN REVIEW r ON m.Movie_id = r.Movie_id
GROUP BY m.Movie_id, m.Movie_name;

---------------------------------------------------------
-- VW_MOVIE_DETAILS
---------------------------------------------------------
CREATE OR REPLACE VIEW VW_MOVIE_DETAILS AS
SELECT
    m.Movie_id,
    m.Movie_name,
    mi.Genre,
    m.Director,
    m.Language,
    m.Release_year
FROM MOVIE m
LEFT JOIN MOVIE_INFO mi ON m.Movie_id = mi.Movie_id;

---------------------------------------------------------
-- VW_TRANSACTION_SUMMARY
---------------------------------------------------------
CREATE OR REPLACE VIEW VW_TRANSACTION_SUMMARY AS
SELECT
    t.Transaction_id,
    t.Order_id,
    t.Transaction_date,
    t.Payment_status,
    o.Movie_id,
    o.Quantity,
    o.Price,
    (o.Price * o.Quantity) AS Total_Cost,
    p.Payment_method,
    p.Amount
FROM TRANSACTION_FINAL t
JOIN ORDER_FINAL o ON t.Order_id = o.Order_id
LEFT JOIN ORDER_PAYMENT p ON p.Order_id = t.Order_id;

---------------------------------------------------------
-- VW_MOVIE_REVIEWS
---------------------------------------------------------
CREATE OR REPLACE VIEW VW_MOVIE_REVIEWS AS
SELECT 
    m.Movie_id,
    m.Movie_name,
    r.Review_no,
    r.Rating,
    r.Comments,
    r.Review_date,
    c.Customer_id,
    c.First_name,
    c.Last_name
FROM MOVIE m
LEFT JOIN REVIEW r ON m.Movie_id = r.Movie_id
LEFT JOIN CUSTOMER c ON r.Customer_id = c.Customer_id;

---------------------------------------------------------
-- VW_SALES_SUMMARY
---------------------------------------------------------
CREATE OR REPLACE VIEW VW_SALES_SUMMARY AS
SELECT
    o.Movie_id,
    m.Movie_name,
    SUM(o.Quantity) AS Total_Units_Sold,
    SUM(o.Price * o.Quantity) AS Total_Revenue
FROM ORDER_FINAL o
JOIN MOVIE m ON m.Movie_id = o.Movie_id
GROUP BY o.Movie_id, m.Movie_name;
