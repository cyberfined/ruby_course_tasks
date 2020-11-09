require_relative("manufacturer")
require_relative("instance_counter")

class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :id, :type, :cars, :speed

  ID_REGEXP = /^[\da-z]{3}(-[\da-z]{2})?$/i

  def self.find(id)
    self.class.instances.find {|tr| tr.id == id}
  end

  def initialize(id)
    @id = id
    @speed = 0
    @cars = []
    validate!
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def start_movement
    @speed = 90
  end

  def stop_movement
    @speed = 0
  end

  def attach_car(car)
    raise "you can't attach car to the moving train" unless @speed == 0
    raise "unsuitable car type" unless car.type == @type
    @cars << car
  end

  def detach_car
    raise "you can't detach car from the moving train" unless @speed == 0
    raise "you can't detach car from the empty train" if @cars.length == 0
    @cars.delete_at(0)
  end

  def each_car(&block)
    @cars.each {|car| block.call(car)}
  end

  def each_car_with_index(&block)
    @cars.each_with_index {|car,index| block.call(car, index)}
  end

  def set_route(route)
    @route = route.dup
    @cur_station_index = 0
    @route.stations[@cur_station_index].pass_train(self)
  end

  def move_next_station
    raise "you can't move to the next station from the end one" unless next_station
    move_station(@cur_station_index+1)
  end

  def move_prev_station
    raise "you can't move to the previous station from the start one" unless prev_station
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
    "type: #{@type}, num cars: #{@cars.length}"
  end

  protected

  def validate!
    raise ArgumentError, "wrong train id format" if @id !~ ID_REGEXP
  end

  # Made it protected because user can pass incorrect index
  # to it. This method assumes that passed index is correct.
  # This methos is only for internal usage.
  def move_station(next_station_index)
    @route.stations[@cur_station_index].send_train(self)
    @route.stations[next_station_index].pass_train(self)
    @cur_station_index = next_station_index
  end
end
