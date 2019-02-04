require 'sinatra/base'
Dir['./lib/*.rb'].each { |f| require f }

class Main < Sinatra::Base
  get '/' do
    dc = Location.from_address("1600 Pennsylvania Avenue NW Washington, D.C. 20500")

    @results = [
      [61.582195, -149.443512],
      [44.775211, -68.774184],
      [25.891297, -97.393349],
      [45.787839, -108.502110],
      [35.109937, -89.959983],
    ].map do |s|
      a = Location.from_coordinates(s[0], s[1])
      Distance.new(a, dc)
    end

    @results.sort_by!(&:dist)
    erb :index
  end
end
