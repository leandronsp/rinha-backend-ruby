require 'json'
require 'roda'

require 'puma'
require 'rack/handler/puma'

require 'falcon'
require 'rack/handler/falcon'

require_relative 'app/people_repository'
require_relative 'app/person_serializer'

PG_EXCEPTIONS = [
  PG::StringDataRightTruncation,
  PG::InvalidDatetimeFormat,
  PG::DatetimeFieldOverflow,
  PG::NotNullViolation,
  PG::UniqueViolation,
  PeopleRepository::ValidationError
].freeze

class RinhaApp < Roda
  route do |r|
    r.get 'pessoas' do
      if term = request.params['t']
        repository = PeopleRepository.new
        results = repository.search(term)

        serialized = results.map do |person|
          PersonSerializer.new(person).serialize
        end

        response.status = 200
        response.headers['Content-Type'] = 'application/json'
        serialized.to_json
      else 
        response.status = 400
        ''
      end
    end

    r.get 'pessoas', String do |id|
      repository = PeopleRepository.new
      person = repository.find(request.params['id'])

      response.status = 200
      response.headers['Content-Type'] = 'application/json'
      PersonSerializer.new(person).serialize.to_json
    end

    r.get 'contagem-pessoas' do
      repository = PeopleRepository.new

      response.status = 200
      response.headers['Content-Type'] = 'text/plain'
      repository.count.to_s
    end

    r.post 'pessoas' do
      repository = PeopleRepository.new

      body_params = JSON.parse(r.body.read)

      uuid = repository.create_person(
        body_params['apelido'],
        body_params['nome'],
        body_params['nascimento'],
        body_params['stack']
      )

      response.status = 201
      response.headers['Location'] = "/pessoas/#{uuid}"
    rescue *PG_EXCEPTIONS
      response.status = 422
      ''
    end
  end
end

if ENV['SERVER'] == 'puma'
  Rack::Handler::Puma.run(RinhaApp.freeze.app, Port: 3000, Threads: ENV['THREAD_POOL'] || '0:16')
elsif ENV['SERVER'] == 'falcon'
  Rack::Handler::Falcon.run(RinhaApp.freeze.app, Port: 3000, Host: '0.0.0.0')
end
