     
require 'sinatra'
require 'pry'
require 'soda/client'
require 'sinatra/reloader'
require_relative 'models/sensor'

def melbourne_soda address, query
  client = SODA::Client.new({:domain => "data.melbourne.vic.gov.au"})
  client.get(address, query)
end

def get_locations
  results = melbourne_soda("xbm5-bb4n", :$limit => 5000)
  arr = []
  results.each do |result|
    arr[result.sensorid.to_i] = result
  end
  arr

end

def get_traffic time, locations
  results = melbourne_soda("mxb8-wn4w", {:$limit => 5000, 
    :year => 2017,
    :time => time,
    :day => "Wednesday",
    :month => "August"
    })
  # data structure. We need id, name, array of traffics, average traffic. Fuck
  sensors = {}
  results.each do |result|
    id = result.sensor_id.to_i
    pcount = result.qv_market_peel_st
    sensor_name = result.sensor_name
    if sensors[id]
      sensors[id].add_pedestrian_count pcount
    else
      if locations[id]
        new_sensor = Sensor.new id, sensor_name, pcount 
        new_sensor.lat = locations[id].latitude
        new_sensor.long = locations[id].longitude
        sensors.store(id, new_sensor)
      end
    end
  end
  sorted_results = sensors.sort_by { |k, v| v.average.to_i }.reverse
  return sorted_results
end



get '/' do
  time = 19
  if params[:time]
    time = params[:time]
  end
  locations = get_locations
  @results = get_traffic time, locations
  erb :index
end





