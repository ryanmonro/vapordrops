class Sensor
  attr_accessor :lat, :long
  attr_reader :average, :name, :id
  def initialize id, name, pedestrian_count
    @id = id
    @name = name
    @pedestrian_counts = [pedestrian_count.to_i]
    @average = 0
    @lat = 0.0
    @long = 0.0
  end

  def add_pedestrian_count number
    @pedestrian_counts.push number.to_i
    sum = @pedestrian_counts.sum
    count = @pedestrian_counts.size
    @average = sum / count.to_f
  end

end
