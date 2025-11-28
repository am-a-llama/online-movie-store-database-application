---------------------------------------------------------
-- ADV_TOP_CUSTOMERS
-- View: Top 10 customers by total spending
---------------------------------------------------------
CREATE OR REPLACE VIEW ADV_TOP_CUSTOMERS AS
SELECT
    c.Customer_id,
    c.First_name,
    c.Last_name,
    SUM(p.Amount) AS Total_Spent
FROM CUSTOMER c
JOIN ORDER_PAYMENT p ON p.Order_id IN (
    SELECT Order_id FROM ORDER_FINAL
)
GROUP BY c.Customer_id, c.First_name, c.Last_name
ORDER BY Total_Spent DESC;

SELECT * FROM ADV_TOP_CUSTOMERS 
FETCH FIRST 10 ROWS ONLY;


---------------------------------------------------------
-- ADV_TOP_MOVIES
-- View: Best-selling movies
---------------------------------------------------------
CREATE OR REPLACE VIEW ADV_TOP_MOVIES AS
SELECT
    m.Movie_id,
    m.Movie_name,
    SUM(o.Quantity) AS Units_Sold,
    SUM(o.Price * o.Quantity) AS Revenue
FROM MOVIE m
JOIN ORDER_FINAL o ON o.Movie_id = m.Movie_id
GROUP BY m.Movie_id, m.Movie_name;

SELECT * FROM ADV_TOP_MOVIES ORDER BY Units_Sold DESC;


---------------------------------------------------------
-- ADV_REVENUE_BY_GENRE
-- View: Revenue grouped by genre
---------------------------------------------------------
CREATE OR REPLACE VIEW ADV_REVENUE_BY_GENRE AS
SELECT
    mi.Genre,
    SUM(o.Quantity * o.Price) AS Total_Revenue
FROM MOVIE_INFO mi
JOIN MOVIE m ON m.Movie_id = mi.Movie_id
JOIN ORDER_FINAL o ON o.Movie_id = m.Movie_id
GROUP BY mi.Genre;

SELECT * FROM ADV_REVENUE_BY_GENRE ORDER BY Total_Revenue DESC;


---------------------------------------------------------
-- ADV_PAYMENT_METHOD_STATS
-- View: Payment method usage summary
---------------------------------------------------------
CREATE OR REPLACE VIEW ADV_PAYMENT_METHOD_STATS AS
SELECT
    p.Payment_method,
    COUNT(*) AS Count_Used,
    SUM(p.Amount) AS Total_Value
FROM ORDER_PAYMENT p
GROUP BY p.Payment_method;

SELECT * FROM ADV_PAYMENT_METHOD_STATS ORDER BY Count_Used DESC;


---------------------------------------------------------
-- ADV_MOVIE_REVIEW_SCOREBOARD
-- View: Movies ranked by rating & review count
---------------------------------------------------------
CREATE OR REPLACE VIEW ADV_MOVIE_REVIEW_SCOREBOARD AS
SELECT
    m.Movie_id,
    m.Movie_name,
    AVG(r.Rating) AS Avg_Rating,
    COUNT(r.Review_no) AS Total_Reviews
FROM MOVIE m
LEFT JOIN REVIEW r ON r.Movie_id = m.Movie_id
GROUP BY m.Movie_id, m.Movie_name;

SELECT * FROM ADV_MOVIE_REVIEW_SCOREBOARD 
ORDER BY Avg_Rating DESC, Total_Reviews DESC;
