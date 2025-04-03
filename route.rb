class Route
  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]
  end

  def add_station(station, position = -2)
    @stations.insert(position, station)
  end

  def remove_station(station)
    @stations.delete(station)
  end
end