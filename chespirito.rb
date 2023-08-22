require 'json'
require 'chespirito'

require 'puma'
require 'rack/handler/puma'

require 'falcon'
require 'rack/handler/falcon'

require_relative 'app/people_repository'
require_relative 'app/person_serializer'

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
    if term = request.params['t']
      repository = PeopleRepository.new
      results = repository.search(term)

      serialized = results.map do |person|
        PersonSerializer.new(person).serialize
      end

      response.body = serialized.to_json
      response.status = 200
      response.headers['Content-Type'] = 'application/json'
    else 
      response.status = 400
    end
  end

  def show 
    repository = PeopleRepository.new
    person = repository.find(request.params['id'])

    response.body = PersonSerializer.new(person).serialize.to_json
    response.status = 200
    response.headers['Content-Type'] = 'application/json'
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

    response.body = repository.count.to_s
    response.status = 200
    response.headers['Content-Type'] = 'text/plain'
  end
end

RinhaApp = Chespirito::App.configure do |app|
  app.register_route('GET', '/pessoas', [PeopleController, :search])
  app.register_route('POST', '/pessoas', [PeopleController, :create])
  app.register_route('GET', '/pessoas/:id', [PeopleController, :show])
  app.register_route('GET', '/contagem-pessoas', [PeopleController, :count])
end

if ENV['SERVER'] == 'falcon'
  Rack::Handler::Falcon.run(RinhaApp, Port: 3000, Host: '0.0.0.0')
else
  Rack::Handler::Puma.run(RinhaApp, Port: 3000, Threads: ENV['THREAD_POOL'] || '0:5')
end
