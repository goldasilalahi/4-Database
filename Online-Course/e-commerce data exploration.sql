-- 1. Top 3 customers based on total orders
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(o.total_amount) AS total_order_amount
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_order_amount DESC
LIMIT 3;

-- 2. Average order value for each customer
SELECT 
    c.first_name,
    c.last_name,
    AVG(o.total_amount) AS average_order
FROM Customers AS c
JOIN Orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- 3. Employees with more than 4 resolved support tickets
SELECT 
    e.first_name,
    e.last_name,
    COUNT(s.ticket_id) AS resolved_tickets
FROM Employees AS e
JOIN SupportTickets AS s ON e.employee_id = s.employee_id
WHERE s.status = 'resolved'
GROUP BY e.employee_id
HAVING COUNT(s.ticket_id) > 4;

-- 4. Products that have never been ordered
SELECT 
    p.product_name
FROM Products AS p
LEFT JOIN OrderDetails AS od ON od.product_id = p.product_id
WHERE od.order_id IS NULL;

-- 5. Total revenue from all orders
SELECT 
    SUM(quantity * unit_price) AS total_revenue
FROM OrderDetails;

-- 6. Average price of products in each category (above 500)
WITH cte_avg_price AS (
    SELECT 
        category,
        AVG(price) AS average_price
    FROM Products
    GROUP BY category
)
SELECT 
    *
FROM cte_avg_price
WHERE average_price > 500;

-- 7. Customers who made orders exceeding 1000
SELECT customer_id, total_amount
FROM Orders
WHERE total_amount > 1000;

-- 8. Products with stock less than 100 and discount greater than 5%
SELECT 
    product_name,
    category,
    stock_quantity,
    discount
FROM Products
WHERE stock_quantity < 100 AND discount > 5;

-- 9. Average customer purchases by product category
SELECT 
    c.first_name,
    c.last_name,
    p.category,
    AVG(od.quantity * od.unit_price) AS avg_purchase
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.customer_id, p.category;

-- 10. Customers with the most frequently purchased product category
WITH PurchaseCategory AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        p.category,
        COUNT(od.product_id) AS purchase_count
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    LEFT JOIN OrderDetails od ON o.order_id = od.order_id
    LEFT JOIN Products p ON od.product_id = p.product_id
    GROUP BY c.customer_id, p.category
),
FavoriteCategory AS (
    SELECT 
        customer_id,
        first_name,
        last_name,
        category,
        purchase_count,
        RANK() OVER (PARTITION BY customer_id ORDER BY purchase_count DESC) AS ranking
    FROM PurchaseCategory
)
SELECT 
    first_name,
    last_name,
    COALESCE(category, 'No Purchases') AS favorite_category,
    COALESCE(purchase_count, 0) AS purchase_count
FROM FavoriteCategory
WHERE ranking = 1;

-- 11. Employees with the fastest and slowest ticket resolution times
WITH TicketResolution AS (
    SELECT 
        s.employee_id,
        e.first_name,
        e.last_name,
        s.ticket_id,
        DATEDIFF(s.resolved_at, s.created_at) AS resolution_time
    FROM SupportTickets s
    JOIN Employees e ON s.employee_id = e.employee_id
    WHERE s.resolved_at IS NOT NULL
),
ResolutionExtremes AS (
    SELECT 
        employee_id,
        first_name,
        last_name,
        MIN(resolution_time) AS fastest_resolution,
        MAX(resolution_time) AS slowest_resolution
    FROM TicketResolution
    GROUP BY employee_id, first_name, last_name
)
SELECT * FROM ResolutionExtremes;

-- 12. Products with the highest sales in each category
WITH TotalSales AS (
    SELECT 
        p.category,
        od.product_id,
        SUM(od.quantity * od.unit_price) AS total_sales
    FROM OrderDetails od
    JOIN Products p ON od.product_id = p.product_id
    GROUP BY p.category, od.product_id
)
SELECT 
    p.product_name,
    ts.category,
    ts.total_sales
FROM TotalSales ts
JOIN Products p ON ts.product_id = p.product_id
WHERE ts.total_sales = (
    SELECT MAX(total_sales)
    FROM TotalSales
    WHERE category = ts.category
)
ORDER BY ts.category;

-- 13. Average employee salaries by department
SELECT 
    department,
    AVG(salary) AS average_salary,
    CASE 
        WHEN AVG(salary) < 5000 THEN 'Low Income'
        WHEN AVG(salary) BETWEEN 5000 AND 10000 THEN 'Medium Income'
        ELSE 'High Income'
    END AS income_category
FROM Employees
GROUP BY department
ORDER BY average_salary DESC;

-- 14. Categories with the highest average discount
SELECT 
    category,
    AVG(discount) AS average_discount
FROM Products
GROUP BY category
ORDER BY average_discount DESC;

-- 15. Unresolved tickets categorized by open duration
SELECT 
    s.ticket_id,
    c.first_name AS customer_name,
    e.first_name AS employee_name,
    DATEDIFF(CURRENT_DATE, s.created_at) AS open_days,
    CASE 
        WHEN DATEDIFF(CURRENT_DATE, s.created_at) <= 7 THEN 'New'
        WHEN DATEDIFF(CURRENT_DATE, s.created_at) BETWEEN 8 AND 30 THEN 'Medium'
        ELSE 'Old'
    END AS duration_category
FROM SupportTickets s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN Employees e ON s.employee_id = e.employee_id
WHERE s.status = 'open';

-- 16. Year-over-year sales changes by product
WITH AnnualSales AS (
    SELECT 
        p.category,
        p.product_name,
        YEAR(o.order_date) AS year,
        SUM(od.quantity * od.unit_price) AS total_sales
    FROM Products p
    JOIN OrderDetails od ON p.product_id = od.product_id
    JOIN Orders o ON od.order_id = o.order_id
    GROUP BY p.category, p.product_name, YEAR(o.order_date)
)
SELECT 
    category,
    product_name,
    year,
    total_sales,
    total_sales - 
        COALESCE(
            (SELECT total_sales
             FROM AnnualSales t
             WHERE t.category = AnnualSales.category 
             AND t.product_name = AnnualSales.product_name
             AND t.year = AnnualSales.year - 1), 0) AS sales_change
FROM AnnualSales
ORDER BY category, product_name, year;