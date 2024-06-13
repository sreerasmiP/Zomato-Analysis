#olist E-commerce Analysis project / MYSQL

#KPI 1 TOP 5 STATES ACCORDING TO SELLER AND CUSTOMERS

select customer_state, count(customer_id ) as Total_customers from 
    olist_customers_dataset   group by customer_state order by Total_customers desc limit 5 ;
    
select seller_state, count(seller_id ) as Total_sellers from 
    olist_sellers_dataset   group by seller_state order by Total_sellers desc limit 5 ;     
    
#KPI 2 TOP 5 VS BOTTOM 5 PRODUCT CATEGORIES

select pdtr.product_category_name_english as "Product Category Name", round(sum(pmt.payment_value),2) as "Total Amount" from olist_products_dataset prd 
    join olist_order_items_dataset ord using(product_id)
	join olist_order_payments_dataset pmt  using(order_id) 
	join product_category_name_translation pdtr on pdtr.ï»¿product_category_name = prd.product_category_name
	group by pdtr.product_category_name_english order by sum(pmt.payment_value) desc limit 5;
    
select pdtr.product_category_name_english as "Product Category Name", round(sum(pmt.payment_value),2) as "Total Amount" from olist_products_dataset prd 
    join olist_order_items_dataset ord using(product_id)
	join olist_order_payments_dataset pmt  using(order_id) 
	join product_category_name_translation pdtr on pdtr.ï»¿product_category_name = prd.product_category_name
	group by pdtr.product_category_name_english order by sum(pmt.payment_value) limit 5; 
    
#KPI 3  RELATIONSHIP BETWEEN SHIPPING DAYS(ORDER_DELIVERED_CUSTOMER_DATE-ORDER_PURCHASE_TIMESTAMP) VS REVIEW SCORES 

SELECT
    REW.REVIEW_SCORE,
    ROUND(AVG(DATEDIFF(ORD.ORDER_DELIVERED_CUSTOMER_DATE, ORD.ORDER_PURCHASE_TIMESTAMP)), 0) AS "AVG SHIPPING DAYS"
FROM
    OLIST_ORDERS_dataset AS ORD
JOIN
olist_order_reviews_dataset AS REW ON REW.ORDER_ID = ORD.ORDER_ID
GROUP BY
    REW.REVIEW_SCORE
ORDER BY
    REW.REVIEW_SCORE;

#KPI 4 WEEKDAY VS WEEKEND (ORDER_PURCHASE_TIMESTAMP) PAYMENT STATISTICS

SELECT 
  KPI1.DAY_END,
  CONCAT(round(KPI1.TOTAL_PAYMENTS / (SELECT SUM(PAYMENT_VALUE) FROM OLIST_ORDER_PAYMENTS_DATASET) * 100, 2), '%') as PERCENTAGE_VALUES
FROM 
  (SELECT 
    ORD.DAY_END,
    SUM(PMT.PAYMENT_VALUE) AS TOTAL_PAYMENTS
  FROM 
    project.olist_order_payments_dataset AS PMT 
  JOIN
    (SELECT 
      DISTINCT ORDER_ID,
      CASE
        WHEN WEEKDAY(order_purchase_timestamp) IN (5,6) THEN "weekend"
        ELSE "weekday"
      END AS DAY_END
    FROM 
      olist_orders_dataset) AS ORD
  ON 
    ORD.ORDER_ID = PMT.ORDER_ID
  GROUP BY 
    ORD.DAY_END
  ) AS KPI1;
  
    
#KPI 5 AVERAGE NUMBER OF DAYS TAKEN FOR ORDER_DELIVERED_CUSTOMER_DATE FOR PET_SHOP
 
select product_category_name as "Product Category" , round(avg(datediff(order_delivered_customer_date,order_purchase_timestamp))) as avg_day from olist_orders_dataset
join olist_order_items_dataset using (order_id)
join olist_products_dataset  using (product_id)
where product_category_name ='pet_shop'; 

#KPI 6 AVERAGE PRICE AND PAYMENT VALUES FOR CUSTOMERS OF SAO PAULO CITY

SELECT 
    cust.customer_city as City,
    ROUND(AVG(item.price), 2) AS "Avg order item price",
    ROUND(AVG(pmt.payment_value), 2) AS "Avg payment value"
FROM
    olist_order_items_dataset item
JOIN
    olist_orders_dataset ord ON item.order_id = ord.order_id
JOIN
    olist_customers_dataset cust ON ord.customer_id = cust.customer_id
JOIN
    olist_order_payments_dataset pmt ON ord.order_id = pmt.order_id
WHERE
    cust.customer_city = "sao paulo"
GROUP BY
    cust.customer_city;
 
    

    
   
