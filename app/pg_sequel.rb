require 'sequel'
require 'connection_pool'

class PgSequel 
  POOL_SIZE = ENV['DB_POOL_SIZE'] || 10

  def self.instance 
    @database ||= 
      if ENV['ASYNC_MODE']
        Sequel.extension(:fiber_concurrency)
      end
    
      ConnectionPool.new(size: POOL_SIZE) do
        Sequel.connect(configuration)
      end
  end

  def self.configuration 
    base_config = { 
      adapter: 'postgres',
      host: 'postgres',
      dbname: 'postgres',
      user: 'postgres',
      password: 'postgres'
    }

    return base_config unless ENV['PGBOUNCER_ENABLED']
    base_config.merge(host: 'pgbouncer', port: 6432)
  end
end
