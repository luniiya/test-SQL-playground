# northwind

## Tables

customers
- Columns: customer_id (PK), company_name, contact_name, email, phone, country, city, region, created_at

products
- Columns: product_id (PK), product_name, category, unit_price, discontinued

orders
- Columns: order_id (PK), customer_id (FK -> customers.customer_id), order_date, status, ship_country, ship_city, total_amount

order_items
- Columns: order_item_id (PK), order_id (FK -> orders.order_id), product_id (FK -> products.product_id), unit_price, quantity

## Relationships
- orders.customer_id -> customers.customer_id
- order_items.order_id -> orders.order_id
- order_items.product_id -> products.product_id
