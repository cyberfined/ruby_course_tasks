class Route
  attr_reader :stations

  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def initialize_copy(orig)
    @stations = orig.stations.dup
  end

  def append_station(station)
    @stations.insert(-2,station)
  end

  def remove_station(st)
    @stations.delete(st) unless st == @stations[0] || st == @stations[-1]
  end

  def print
    @stations.each {|st| puts st.title}
  end

  def to_s
    @stations.map(&:to_s).join(", ")
  end
end
