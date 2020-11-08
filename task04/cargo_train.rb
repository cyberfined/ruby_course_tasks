require_relative("train")

class CargoTrain < Train
  def initialize(id)
    super(id)
    @type = :cargo
  end
end
