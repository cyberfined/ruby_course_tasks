require_relative("train")

class PassengerTrain < Train
  def initialize(id)
    super(id)
    @type = :passenger
  end
end
