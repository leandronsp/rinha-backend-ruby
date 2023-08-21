require 'pg'
require 'connection_pool'

class PgPool
  POOL_SIZE = ENV['DB_POOL_SIZE'] || 10

  def self.instance
    @instance ||= ConnectionPool.new(size: POOL_SIZE) do
      PG.connect(configuration)
    end
  end

  #def self.instance
  #  @instance = PG.connect(configuration)
  #end

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
