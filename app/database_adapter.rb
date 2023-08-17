require 'pg'
require 'connection_pool'

class PgPool
  POOL_SIZE = 50

  def self.instance
    @pool ||= ConnectionPool.new(size: POOL_SIZE) do
      PG.connect(host: 'postgres', dbname: 'postgres', user: 'postgres')
    end
  end
end

class DatabaseAdapter
  def execute(sql)
    PgPool.instance.with do |conn|
      conn.exec(sql).to_a
    end
  end

  def execute_with_params(sql, params)
    PgPool.instance.with do |conn|
      conn.exec_params(sql, params)
    end
  end
end
