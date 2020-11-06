require_relative("instance_counter")

class Station
  include InstanceCounter
  attr_reader :title

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(title)
    @title = title
    @trains = []
    @@instances << self
    register_instance
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
