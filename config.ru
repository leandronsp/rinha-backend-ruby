#require 'agoo'
#require 'rack/handler/agoo'
require 'puma'
require 'rack/handler/puma'

require 'chespirito'
require_relative 'app/people_controller'

App = Chespirito::App.configure do |app|
  app.register_route('GET', '/pessoas', [PeopleController, :search])
  app.register_route('POST', '/pessoas', [PeopleController, :create])
  app.register_route('GET', '/pessoas/:id', [PeopleController, :show])
  app.register_route('GET', '/contagem-pessoas', [PeopleController, :count])
end

#Rack::Handler::Agoo.run(App, port: 3000, workers: 3, threads: 5, thread_count: 5, verbose: true)
Rack::Handler::Puma.run(App, Port: 3000)
