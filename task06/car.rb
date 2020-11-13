require_relative("manufacturer")

class Car
  include Manufacturer
  attr_reader :type

  protected

  def validate_positive(at, val)
    raise ArgumentError, "#{at} must be non-negative" if val < 0
  end
end
