     
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

def fetch_sensor_for_hdmy sensor_id, time, day, month, year
  melbourne_soda("mxb8-wn4w", {:$limit => 5000, 
    :sensor_id => sensor_id,
    :year => year,
    :time => time,
    :day => day,
    :month => month
    })
end

def fetch_all_sensors_for_hdmy time, day, month, year
  melbourne_soda("mxb8-wn4w", {:$limit => 5000, 
    :year => year,
    :time => time,
    :day => day,
    :month => month
    })
end

def get_traffic time, day, month, year
  locations = get_locations
  results = fetch_all_sensors_for_hdmy time, day, month, year
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
  sensors
end

def get_sensor id, day, month, year
  locations = get_locations
end

def sort_by_average sensors
  sorted_results = sensors.sort_by { |k, v| v.average.to_i }.reverse
  return sorted_results
end

def sort_by_proximity sensors, lat, long
  sorted_results = sensors.sort_by { |k, v| proximity v.lat.to_f, v.long.to_f, lat.to_f, long.to_f }
  return sorted_results
end

def proximity lat1, long1, lat2, long2
  Math.sqrt((lat1 - lat2)**2 + (long1 - long2)**2)
end

get '/' do
  # General Assembly location for testing
  ga_lat = '-37.818624299999996'
  ga_long = '144.9593399'
  time = 19
  day = "Monday"
  month = "August"
  year = 2017
  if params[:time]
    time = params[:time]
  end
  if params[:day]
    day = params[:day]
  end
  if params[:month]
    month = params[:month]
  end
  if params[:year]
    year = params[:year]
  end
  sensors = get_traffic time, day, month, year
  @results = sort_by_average sensors
  # long = $ga_long
  # lat = $ga_lat
  if params[:lat] && params[:long]
    lat = params[:lat]
    long = params[:long]
    @results = sort_by_proximity sensors, lat, long
  end
  erb :map
end

get '/sensor/:id' do
  


end




