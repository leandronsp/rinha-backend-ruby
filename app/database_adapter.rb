require_relative 'pg_pool'

class DatabaseAdapter
  def execute_with_params(sql, params)
    instrument do
      PgPool.primary.with do |conn|
        conn.exec_params(sql, params).to_a
      end
    end
  end

  def execute_with_params_ro(sql, params)
    instrument do
      PgPool.replica.with do |conn|
        conn.exec_params(sql, params).to_a
      end
    end
  end

  def instrument
    return unless block_given?

    initial = Time.now
    result = yield
    total = (Time.now - initial).to_f * 1000

    if total > 50
      msg = "Query took #{total} ms"
      puts msg
      #File.open('slow_queries.log', 'a') { |f| f.puts(msg) }
    end

    result
  end
end
