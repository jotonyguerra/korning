-- DEFINE YOUR DATABASE SCHEMA HERE
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS frequencies CASCADE;
DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  email VARCHAR(255)
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(255),
  account_no VARCHAR(255)
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

CREATE TABLE frequencies (
  id SERIAL PRIMARY KEY,
  frequency VARCHAR(255)
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  sale_date DATE,
  sale_amount VARCHAR(255),
  units_sold INTEGER,
  invoice_number INTEGER,
  employee_id  INTEGER REFERENCES employees(id),
  customer_and_account_no_id INTEGER REFERENCES customers(id),
  product_id INTEGER REFERENCES products(id),
  frequency_id VARCHAR(255)
);
