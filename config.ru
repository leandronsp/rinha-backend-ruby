if ENV['FRAMEWORK'] == 'chespirito'
  puts "Using Chespirito"
  load 'chespirito.rb'
else 
  puts "Using Roda"
  load 'roda.rb'
end
