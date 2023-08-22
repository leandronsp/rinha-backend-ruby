if ENV['FRAMEWORK'] == 'chespirito'
  load 'chespirito.rb'
elsif ENV['FRAMEWORK'] == 'roda'
  load 'roda.rb'
end
