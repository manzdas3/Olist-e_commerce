use olist_store_analysis;
SELECT * FROM olist_customers_dataset;
SELECT * FROM olist_order_items_dataset;
SELECT * FROM olist_order_payments_dataset;
SELECT * FROM olist_order_reviews_dataset;
SELECT * FROM olist_orders_dataset;
select* FROM olist_products_dataset;
SELECT * FROM product_category_name_translation;
-- #Weekday Vs Weekend (order_purchase_timestamp) Payment Statistics
SELECT 
    CASE 
        WHEN DAYOFWEEK(o.order_purchase_timestamp) IN (1, 7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type,
    COUNT(*) AS Total_orders,
    ROUND(SUM(p.payment_value), 2) AS Total_Payment,
    ROUND(AVG(p.payment_value), 2) AS Avg_payment,
    CONCAT(ROUND((SUM(p.payment_value) * 100.0) / SUM(SUM(p.payment_value)) OVER(), 2), '%') AS Payment_Percentage
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id
GROUP BY 
    day_type;
    
-- ## Number of Orders with review score 5 and payment type as credit card.

SELECT 
    COUNT(*) AS Total_orders
FROM 
    olist_order_reviews_dataset r
JOIN 
    olist_order_payments_dataset p ON r.order_id = p.order_id
WHERE 
    r.review_score = 5 
    AND p.payment_type = 'credit_card';
    
-- ## Average number of days taken for order_delivered_customer_date for pet_shop

SELECT 
    ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)), 0) AS Avg_delivery_days
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset i ON o.order_id = i.order_id
JOIN 
    olist_products_dataset p ON i.product_id = p.product_id
WHERE 
    p.product_category_name = 'pet_shop';
   
##Average price and payment values from customers of sao paulo city

    SELECT 
    ROUND(AVG(i.price), 2) AS Avg_price,
    ROUND(AVG(p.payment_value), 2) AS Avg_payment_value
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_items_dataset i ON o.order_id = i.order_id
JOIN 
    olist_order_payments_dataset p ON o.order_id = p.order_id
JOIN 
    olist_customers_dataset c ON o.customer_id = c.customer_id
WHERE 
    c.customer_city = 'sao paulo';

## Relationship between shipping days (order_delivered_customer_date - order_purchase_timestamp) Vs review scores

SELECT 
    r.review_score,
    ROUND(AVG(TIMESTAMPDIFF(DAY, o.order_purchase_timestamp, o.order_delivered_customer_date)), 0) AS Avg_shipping_days
FROM 
    olist_orders_dataset o
JOIN 
    olist_order_reviews_dataset r ON o.order_id = r.order_id
WHERE 
    o.order_status = 'delivered'
GROUP BY 
    r.review_score
ORDER BY 
    r.review_score;

