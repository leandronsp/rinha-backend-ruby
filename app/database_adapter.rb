require 'pg'
require 'connection_pool'

class DatabaseAdapter
  POOL_SIZE = ENV['DB_POOL_SIZE'] || 5

  def self.pool
    @pool ||= ConnectionPool.new(size: POOL_SIZE) do
      PG.connect(configuration)
    end
  end

  def self.new_connection
    PG.connect(configuration)
  end

  def self.configuration
    base_config = {
      host: 'postgres',
      dbname: 'postgres',
      user: 'postgres',
      password: 'postgres'
    }

    return base_config unless ENV['PGBOUNCER_ENABLED']

    base_config.merge({
      host: 'pgbouncer',
      port: 6432
    })
  end
end
