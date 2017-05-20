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
      name = values[0..1].join(" ")
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

      sale_date =  Date.strptime(row[3])
      binding.pry

      sale_amount = row[4]
      units = row[5]

      invoice_number = row[6]
      query = "SELECT name FROM employees"
      #how to access specific data from the tables? SELECT (element) FROM (table)<?

      sql = "INSERT into sales VALUES ($1,$2,$3,$4)"
      results = conn.exec_params(sql, [sale_date, sale_amount, units, invoice_number])
    end
  end
end
add_employees
add_customers
add_products
add_frequencies
add_sales
# How to structure this method to work??

# def add_table(row_num, db_name,col_name)
#   CSV.foreach('sales.csv', headers: true) do |row|
#     db_connection do |conn|
#
#       values = row[row_num].split(" ")
#       name = values[0..1].join(" ")
#       user_id = values[1]
#       sql = "SELECT customer_name FROM customers WHERE customer_name=$1"
#       results = conn.exec_params(sql, [name])
#       if results.to_a.empty?
#         sql = "INSERT INTO customers (customer_name, account_no) VALUES ($1, $2)"
#         results = conn.exec(sql, [name, user_id])
#       end
#     end
#   end
# end
