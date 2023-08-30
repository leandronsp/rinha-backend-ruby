require 'securerandom'
require 'date'
require 'async'

require_relative 'database_adapter'

class PeopleRepository
  class ValidationError < StandardError; end;

  def search(term)
    Async do 
      sql = <<~SQL
        SELECT id, name, nickname, birth_date, stack
        FROM people WHERE search LIKE $1
        LIMIT 50
      SQL

      execute_with_params(sql, ["%#{term.downcase}%"])
    end
  end

  def find(id)
    Async do 
      sql = <<~SQL
        SELECT id, name, nickname, birth_date, stack
        FROM people WHERE id = $1
      SQL

      execute_with_params(sql, [id]).first
    end
  end

  def create_person(nickname, name, birth_date, stack)
    Async do
      SecureRandom.uuid.tap do |uuid|
        validate_str!(nickname)
        validate_str!(name)
        validate_date!(birth_date)

        validate_length!(nickname, 32)
        validate_length!(name, 100)

        sql = <<~SQL
          INSERT INTO people (id, nickname, name, birth_date, stack)
          VALUES ($1, $2, $3, $4, $5)
        SQL

        execute_with_params(sql, 
          [uuid, nickname, name, birth_date, cast_stack(stack)],
        )
      end
    end
  end

  def count 
    Async do 
      execute_with_params("SELECT COUNT(*) FROM people", [])
        .first['count']
        .to_i
    end
  end

  private

  def cast_stack(stack) 
    return unless stack
    return unless stack.respond_to?(:map)

    stack.join(' ')
  end

  def validate_str!(str)
    raise ValidationError unless str.is_a?(String)
  end

  def validate_date!(date)
    Date.parse(date) rescue raise ValidationError
  end

  def validate_array_of_str!(arr)
    raise ValidationError unless arr.respond_to?(:each)

    arr.each do |str|
      validate_str!(str)
      validate_length!(str, 32)
    end
  end

  def validate_length!(str, length)
    raise ValidationError if str.length > length
  end

  def execute_with_params(sql, params)
    DatabaseAdapter.pool.with do |conn|
      conn.send_query_params(sql, params)

      conn.get_result.to_a.tap do
        conn.discard_results
      end
    end
  end
end
