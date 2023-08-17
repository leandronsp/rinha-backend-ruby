require 'chespirito'
require_relative 'app/people_controller'

App = Chespirito::App.configure do |app|
  app.register_route('GET', '/pessoas', [PeopleController, :search])
  app.register_route('POST', '/pessoas', [PeopleController, :create])
  app.register_route('GET', '/pessoas/:id', [PeopleController, :show])
  app.register_route('GET', '/contagem-pessoas', [PeopleController, :count])
end

run App
