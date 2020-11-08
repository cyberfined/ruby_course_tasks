require_relative("instance_counter")

class Station
  include InstanceCounter
  attr_reader :title

  TITLE_FORMAT = /^[A-Z][a-z]*$/

  def initialize(title)
    @title = title
    @trains = []
    validate!
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
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

  private

  def validate!
    raise ArgumentError, "title length must be at least 6 characters long" if @title.length < 6
    raise ArgumentError, "wrong station title format" if @title !~ TITLE_FORMAT
  end
end
