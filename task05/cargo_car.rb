require_relative("car")

class CargoCar < Car
  attr_reader :utilized_capacity

  def initialize(capacity)
    @type = :cargo
    @capacity = capacity
    @utilized_capacity = 0
    raise ArgumentError, "carrying must be positive" if @capacity < 0
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
