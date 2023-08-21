require 'securerandom'
require 'date'

require_relative 'database_adapter'

class PeopleRepository
  class ValidationError < StandardError; end;

  def initialize
    @database = DatabaseAdapter.new
  end

  def search(term)
    sql = <<~SQL
      SELECT id, name, nickname, birth_date, array_to_string(stack, ',') AS stack
      FROM people
      WHERE array_ts(stack || ARRAY[name, nickname]) ILIKE '%' || $1 || '%'
    SQL

    @database.execute_with_params(sql, [term]).to_a
  end

  def find(id)
    sql = <<~SQL
      SELECT id, name, nickname, birth_date, array_to_string(stack, ',') AS stack
      FROM people
      WHERE id = $1
    SQL

    @database.execute_with_params(sql, [id]).first
  end

  def create_person(nickname, name, birth_date, stack)
    uuid = SecureRandom.uuid

    validate_str!(nickname)
    validate_str!(name)
    validate_date!(birth_date)
    validate_array_of_str!(stack)

    validate_length!(nickname, 32)
    validate_length!(name, 100)

    sql = <<~SQL
      INSERT INTO people (id, nickname, name, birth_date, stack)
      VALUES ($1, $2, $3, $4, $5)
    SQL

    @database.execute_with_params(
      sql, 
      [uuid, nickname, name, birth_date, cast_stack_to_array(stack)]
    )
    
    uuid
  end

  def count 
    sql = "SELECT COUNT(*) FROM people"
    @database.execute_with_params(sql, []).first['count'].to_i
  end

  private

  def cast_stack_to_array(stack) 
    return "{}" unless stack
    return "{}" unless stack.respond_to?(:map)

    "{#{stack.map { |s| "'#{s}'" }.join(',')}}"
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
end
