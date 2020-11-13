require_relative("car")
require_relative("validation")

class PassengerCar < Car
  include Validation
  attr_reader :occupied_places

  validate :num_places, :type, Integer
  validate :num_places, :positive

  def initialize(num_places)
    @type = :passenger
    @num_places = num_places
    @occupied_places = 0
    validate!
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
