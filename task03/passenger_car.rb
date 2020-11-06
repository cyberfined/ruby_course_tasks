require_relative("car")

class PassengerCar < Car
  def initialize
    @type = :passenger
  end
end
