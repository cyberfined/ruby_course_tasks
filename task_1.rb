#!/usr/bin/env ruby

class Station
  attr_reader :title
  def initialize(title)
    @title = title
    @trains = []
  end

  def trains(type=nil)
    if type == nil
      return @trains
    else
      return @trains.select{|tr| tr.type == type}
    end
  end

  def pass_train(train)
    @trains << train
  end

  def send_train(id)
    @trains.delete_if{|tr| tr.id == id}
  end
end

class Route
  attr_reader :stations
  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def append_station(station)
    @stations.insert(-2,station)
  end

  def remove_station(title)
    if title != @stations[0].title and title != @stations[-1].title
      @stations.delete_if{|st| st.title == title}
    end
  end

  def print
    @stations.each{|st| puts st.title}
  end
end

class Train
  attr_reader :id, :type, :num_cars, :speed
  def initialize(id, type, num_cars)
    @id = id
    @type = type
    @num_cars = num_cars
    @speed = 0
  end

  def start_movement
    @speed = 90
  end

  def stop_movement
    @speed = 0
  end

  def attach_car
    if @speed == 0
      @num_cars += 1
    end
  end

  def detach_car
    if @speed == 0 and @num_cars > 0
      @num_cars -= 1
    end
  end

  def set_route(route)
    @route = route
    @cur_station = 0
  end

  def move_next_station
    if @route != nil and @cur_station < @route.stations.length-1
      @cur_station += 1
    end
  end

  def move_prev_station
    if @route != nil and @cur_station > 0
      @cur_station -= 1
    end
  end

  def next_station
    if @route != nil and @cur_station < @route.stations.length-1
      return @route.stations[@cur_station+1]
    end
    return nil
  end

  def cur_station
    if @route != nil
      return @route.stations[@cur_station]
    end
    return nil
  end

  def prev_station
    if @route != nil and @cur_station > 0
      return @route.stations[@cur_station-1]
    end
    return nil
  end
end

# Station tests
st = Station.new("st1")
st.pass_train(Train.new("tr1", :cargo, 10))
st.pass_train(Train.new("tr2", :cargo, 15))
st.pass_train(Train.new("tr3", :pass, 20))

puts "All trains at st1"
puts st.trains.map{|tr| tr.id}
puts "All cargo trains at st1"
puts st.trains(:cargo).map{|tr| tr.id}
puts "All passenger's trains at st1"
puts st.trains(:pass).map{|tr| tr.id}
st.send_train("tr2")
puts "All trains at st1 after tr2 was sent away"
puts st.trains.map{|tr| tr.id}

# Route tests
rt = Route.new(Station.new("st1"), Station.new("st5"))
puts "\nRoute after creation is"
rt.print

rt.append_station(Station.new("st2"))
puts "Route after appending st2"
rt.print

rt.append_station(Station.new("st3"))
puts "Route after appending st3"
rt.print

rt.remove_station("st2")
puts "Route after removing st2"
rt.print

rt.append_station(Station.new("st4"))
puts "Route after appending st4"
rt.print

# Train tests
tr = Train.new("tr1", :cargo, 15)
puts "\nTrain initial speed #{tr.speed}"
tr.start_movement
puts "Train speed after starting engine #{tr.speed}"
tr.stop_movement
puts "Train speed after stopping #{tr.start_movement}"

puts "Num of train's cars #{tr.num_cars}"
tr.attach_car
tr.attach_car
puts "Num of train's cars after two attaching #{tr.num_cars}"
tr.detach_car
puts "Num of train's cars after detaching #{tr.num_cars}"
tr.start_movement
tr.detach_car
tr.detach_car
tr.attach_car
puts "You can't attach or detach cars if train is moving. Num of train's cars is #{tr.num_cars}"

puts "Set route from st1 to st5 to the train"
tr.set_route(rt)
puts "current station is #{tr.cur_station.title}"
puts "next station is #{tr.next_station.title}"
tr.move_next_station
puts "previous station after moving to the next station is #{tr.prev_station.title}"
puts "current station after moving to the next station is #{tr.cur_station.title}"
puts "next station after moving to the next station is #{tr.next_station.title}"
