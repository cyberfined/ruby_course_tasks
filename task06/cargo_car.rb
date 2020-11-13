require_relative("car")
require_relative("validation")

class CargoCar < Car
  include Validation
  attr_reader :utilized_capacity

  validate :capacity, :type, Float
  validate :capacity, :positive

  def initialize(capacity)
    @type = :cargo
    @capacity = capacity
    @utilized_capacity = 0
    validate!
  end

  def utilize_capacity(capacity)
    raise ArgumentError, "capacity must be positive" if capacity < 0
    raise "insufficient free capacity" if capacity > free_capacity
    @utilized_capacity += capacity
  end

  def free_capacity
    @capacity - @utilized_capacity
  end

  def to_s
    "type: #{@type}, free capacity: #{free_capacity}, utilized capacity: #{utilized_capacity}"
  end
end
