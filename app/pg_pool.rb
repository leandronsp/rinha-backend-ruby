require 'pg'
require 'connection_pool'

class PgPool
  POOL_SIZE = ENV['DB_POOL_SIZE'] || 10

  def self.primary
    @master_pool ||= ConnectionPool.new(size: POOL_SIZE) do
      PG.connect({
        host: ENV['PG_PRIMARY_HOST'] || 'pgprimary',
        dbname: 'postgres',
        user: 'postgres',
        password: 'postgres'
      })
    end
  end

  def self.replica
    @slave_pool ||= ConnectionPool.new(size: POOL_SIZE) do
      PG.connect({
        host: ENV['PG_REPLICA_HOST'] || 'pgreplica',
        dbname: 'postgres',
        user: 'postgres',
        password: 'postgres'
      })
    end
  end
end
