require_relative("car")

class PassengerCar < Car
  attr_reader :occupied_places

  def initialize(num_places)
    @type = :passenger
    @num_places = num_places
    @occupied_places = 0
    raise ArgumentError, "num places must be an integer" unless @num_places.is_a? Integer
    raise ArgumentError, "num places must be positive" if @num_places < 0
  end

  def occupy_place
    raise "all places are occupied" if @occupied_places >= @num_places 
    @occupied_places += 1
  end

  def free_places
    @num_places - @occupied_places
  end

  def to_s
    "type: #{@type}, free places: #{free_places}, occupied places: #{occupied_places}"
  end
end
