require_relative("car")

class CargoCar < Car
  def initialize
    @type = :cargo
  end
end
