require_relative '../config/environment'
binding.pry

interface = Interface.new()
interface.welcome
interface.new_or_existing

puts "That's all folks!"
