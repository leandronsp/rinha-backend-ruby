require 'async'
require 'sequel'
require 'pg'
require 'byebug'
require 'json'

#scheduler = Async::Scheduler.new
#Fiber.set_scheduler(scheduler)

Sequel.extension :fiber_concurrency

config = { 
  adapter: 'postgres',
  host: 'postgres',
  dbname: 'postgres',
  user: 'postgres',
  password: 'postgres'
}

DB = Sequel.connect(config)
#byebug

#conn = PG.connect(config)
#conn.setnonblocking(true)

#conn = DB::Postgres::Connection.new(**config)

initial = Time.now

Async do |task|
  1.upto(3).each do |i|
    task.async do 
      puts DB['SELECT 42 AS LIFE, pg_sleep(1)'].first
      byebug
      result = DB[:people]
        .select(:id, :name, :nickname, :birth_date, "array_to_string(stack, ',') AS stack")
        .where(Sequel.lit('search ILIKE ?', '%ruby%'))
        .first
      puts result
    end
    #conn.exec("SELECT 42 AS LIFE, pg_sleep(1)")
  end
end

total = (Time.now - initial).to_f
puts "Total: #{total} s"
