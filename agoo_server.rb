require 'rack'
require 'agoo'
require 'pg'
require 'json'
require 'byebug'

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

Agoo::Server.init(3000, 'root')

class Request
  attr_reader :verb, :path, :headers, :params, :cookies

  def initialize(verb, path, headers: {}, params: {}, cookies: {})
    @verb = verb
    @path = path

    @headers = headers
    @params  = params
    @cookies = cookies
  end

  def self.build(env)
    request = Rack::Request.new(env)
    body_params = request.post? ? (JSON.parse(request.body.read) rescue {}) : {}
    params = request.params.merge(body_params)

    new(
      request.request_method,
      request.path,
      headers: request.env,
      params: params,
      cookies: request.cookies
    )
  end
end

class MyHandler
  def call(request)
    [200, {}, ['Hello World!']]
  end
end

#class PeopleController < Chespirito::Controller
#
#  def search 
#    repository = PeopleRepository.new
#
#    if term = request.params['t']
#      response.status = 200
#      response.headers['Content-Type'] = 'application/json'
#
#      results = repository.search(term)
#
#      response.body = results.map do |person|
#        PersonSerializer.new(person).serialize
#      end.to_json
#    else 
#      response.status = 400
#    end 
#  end
#
#  def show 
#    repository = PeopleRepository.new
#
#    response.status = 200
#    response.headers['Content-Type'] = 'application/json'
#
#    person = repository.find(request.params['id'])
#    response.body = PersonSerializer.new(person).serialize.to_json
#  end
#
#  def create 
#    repository = PeopleRepository.new
#
#    nickname = repository.create_person(
#      request.params['apelido'],
#      request.params['nome'],
#      request.params['nascimento'],
#      request.params['stack']
#    )
#
#    response.status = 201
#    response.headers['Location'] = "/pessoas/#{nickname}"
#  rescue *PG_EXCEPTIONS
#    response.status = 422
#  end
#
#  def count 
#    repository = PeopleRepository.new
#
#    response.status = 200
#    response.headers['Content-Type'] = 'text/plain'
#
#    response.body = repository.count.to_s
#  end
#end

Agoo::Server.handle(:GET, '/', MyHandler.new)
Agoo::Server.start()
