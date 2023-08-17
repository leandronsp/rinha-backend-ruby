require 'pg'
require 'json'

require_relative 'people_repository'
require_relative 'person_serializer'

class PeopleController < Chespirito::Controller
  PG_EXCEPTIONS = [
    PG::StringDataRightTruncation,
    PG::InvalidDatetimeFormat,
    PG::DatetimeFieldOverflow,
    PG::NotNullViolation,
    PG::UniqueViolation,
    PeopleRepository::ValidationError
  ].freeze

  def search 
    repository = PeopleRepository.new

    if term = request.params['t']
      response.status = 200
      response.headers['Content-Type'] = 'application/json'

      results = repository.search(term)

      response.body = results.map do |person|
        PersonSerializer.new(person).serialize
      end.to_json
    else 
      response.status = 400
    end 
  end

  def show 
    repository = PeopleRepository.new

    response.status = 200
    response.headers['Content-Type'] = 'application/json'

    person = repository.find(request.params['id'])
    response.body = PersonSerializer.new(person).serialize.to_json
  end

  def create 
    repository = PeopleRepository.new

    uuid = repository.create_person(
      request.params['apelido'],
      request.params['nome'],
      request.params['nascimento'],
      request.params['stack']
    )

    response.status = 201
    response.headers['Location'] = "/pessoas/#{uuid}"
  rescue *PG_EXCEPTIONS
    response.status = 422
  end

  def count 
    repository = PeopleRepository.new

    response.status = 200
    response.headers['Content-Type'] = 'text/plain'

    response.body = repository.count.to_s
  end
end
