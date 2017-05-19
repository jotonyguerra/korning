# Use this file to import the sales information into the
# the database.
require "pg"
require "pry"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end
@sales = CSV.readlines('sales.csv', headers: true)


CSV.foreach('sales.csv',headers: true) do |row|
  db_connection do |conn|
    sql = "SELECT name FROM employees"
    results = conn.exec(sql)
    if results.to_a.empty?
      sql = "INSERT"
    end
  end
end
