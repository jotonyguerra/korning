# Use this file to import the sales information into the
# the database.
require "pg"
require "pry"
require 'csv'
require 'date'
system "psql korning < schema.sql"
def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

def add_employees
  CSV.foreach('sales.csv', headers: true) do |row|
    db_connection do |conn|
      values = row[0].split(" ")
      name = values[0..1].join(" ")
      email = values[2]
      sql = "SELECT name FROM employees WHERE name=$1"
      results = conn.exec_params(sql, [name])
      if results.to_a.empty?
        sql = "INSERT INTO employees (name, email) VALUES ($1, $2)"
        results = conn.exec_params(sql, [name, email])
      end
    end
  end
end

def add_customers
  CSV.foreach('sales.csv', headers: true) do |row|
    db_connection do |conn|

      values = row[1].split(" ")
      name = values[0]
      user_id = values[1]
      sql = "SELECT customer_name FROM customers WHERE customer_name=$1"
      results = conn.exec_params(sql, [name])
      if results.to_a.empty?
        sql = "INSERT INTO customers (customer_name, account_no) VALUES ($1, $2)"
        results = conn.exec(sql, [name, user_id])
      end
    end
  end
end

def add_products
  CSV.foreach('sales.csv', headers:true) do |row|
    db_connection do |conn|
      name = row[2]
      sql = "SELECT name FROM products WHERE name=$1"
      results = conn.exec_params(sql, [name])

      if results.to_a.empty?
        sql = "INSERT INTO products (name) VALUES  ($1)"
        results = conn.exec(sql, [name])
      end
    end
  end
end

def add_frequencies
  CSV.foreach('sales.csv', headers: true) do |row|
    db_connection do |conn|
      freq = row[-1]
      sql = "SELECT frequency FROM frequencies where frequency=$1"
      results = conn.exec_params(sql, [freq])

      if results.to_a.empty?
        sql = "INSERT into frequencies (frequency) VALUES ($1)"
        results = conn.exec(sql, [freq])
      end
    end
  end
end

def add_sales
  CSV.foreach('sales.csv', headers: true) do |row|
    db_connection do |conn|
      sale_date = Date.strptime(row[3], '%m/%d/%y')
      sale_amount = row[4]
      units = row[5]
      invoice_number = row[6]
      frequency_id = row[-1]

      #i should really refactor this....

      values = row[0].split(" ")
      employee_name = values[0..1].join(" ")

      customer_values = row[1].split(" ")
      customer_name = customer_values[0]
      user_id = customer_values[1]
      employee_id = conn.exec_params("SELECT id FROM employees WHERE name = '#{employee_name}'").to_a
	    employee_id.each do |value|
	      employee_id = value["id"]
	    end
      customer_id = conn.exec_params("SELECT id FROM customers WHERE customer_name = '#{customer_name}'").to_a
      customer_id.each do |value|
        customer_id = value["id"]
      end
      product_name= row[2]
      product_id = conn.exec_params("SELECT id FROM products WHERE name = '#{product_name}'").to_a
      product_id.each do |value|
        product_id = value["id"]
      end

      sql = "INSERT into sales (sale_date, sale_amount, units_sold, invoice_number, employee_id, customer_and_account_no_id, product_id, frequency_id) VALUES ($1,$2,$3,$4,$5,$6,$7, $8)"
      conn.exec_params(sql, [sale_date, sale_amount, units, invoice_number, employee_id, customer_id,product_id,frequency_id])
    end
  end
end
add_employees
add_customers
add_products
add_frequencies
add_sales
#probaly can get rid of each method bloc and do it in one bloc..
