class Station
  attr_reader :title
  def initialize(title)
    @title = title
    @trains = []
  end

  def trains(type=nil)
    if type == nil
      @trains
    else
      @trains.select {|tr| tr.type == type}
    end
  end

  def pass_train(train)
    @trains << train
  end

  def send_train(train)
    @trains.delete(train)
  end

  def to_s
    @title
  end
end
