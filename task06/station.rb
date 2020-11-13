require_relative("instance_counter")
require_relative("validation")

class Station
  include InstanceCounter
  include Validation
  attr_reader :title

  validate :title, :type, String
  validate :title, :format, /^[A-Z][a-z]{5,}$/

  def initialize(title)
    @title = title
    @trains = []
    validate!
    register_instance
  end

  def trains(type=nil)
    if type == nil
      @trains
    else
      @trains.select {|tr| tr.type == type}
    end
  end

  def each_train(&block)
    @trains.each {|tr| block.call(tr)}
  end

  def each_train_with_index(&block)
    @trains.each_with_index {|tr,index| block.call(tr, index)}
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
