require_relative("manufacturer")
require_relative("instance_counter")

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :id, :type, :cars, :speed

  @@instances = []

  def self.find(id)
    @@instances.find {|tr| tr.id == id}
  end

  def initialize(id)
    @id = id
    @speed = 0
    @cars = []
    @type = nil
    @@instances << self
    register_instance
  end

  def start_movement
    @speed = 90
  end

  def stop_movement
    @speed = 0
  end

  def attach_car(car)
    @cars << car if car.type == @type && @speed == 0
  end

  def detach_car
    @cars.delete_at(0) if @speed == 0
  end

  def set_route(route)
    @route = route.dup
    @cur_station_index = 0
    @route.stations[@cur_station_index].pass_train(self)
  end

  def move_next_station
    return unless next_station
    move_station(@cur_station_index+1)
  end

  def move_prev_station
    return unless prev_station
    move_station(@cur_station_index-1)
  end

  def next_station
    @route.stations[@cur_station_index+1] unless @route == nil || 
                                                 @cur_station_index >= @route.stations.length-1
  end

  def cur_station
    @route.stations[@cur_station_index] unless @route == nil
  end

  def prev_station
    @route.stations[@cur_station_index-1] unless @route == nil || @cur_station_index <= 0
  end

  def to_s
    @id
  end

  protected

  # Made it protected because user can pass incorrect index
  # to it. This method assumes that passed index is correct.
  # This methos is only for internal usage.
  def move_station(next_station_index)
    @route.stations[@cur_station_index].send_train(self)
    @route.stations[next_station_index].pass_train(self)
    @cur_station_index = next_station_index
  end
end
