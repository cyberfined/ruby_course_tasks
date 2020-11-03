#!/usr/bin/env ruby

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
end

class Route
  attr_reader :stations
  def initialize(start_station, end_station)
    @stations = [start_station, end_station]
  end

  def append_station(station)
    @stations.insert(-2,station)
  end

  def remove_station(st)
    @stations.delete(st) unless st == @stations[0] || st == @stations[-1]
  end

  def print
    @stations.each {|st| puts st.title}
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
    @num_cars += 1 if @speed == 0
  end

  def detach_car
    @num_cars -= 1 if @speed == 0 && @num_cars > 0
  end

  def set_route(route)
    @route = route
    @cur_station = 0
  end

  def move_next_station
    @cur_station += 1 unless @route == nil || @cur_station >= @route.stations.length-1
  end

  def move_prev_station
    @cur_station -= 1 unless @route == nil || @cur_station <= 0
  end

  def next_station
    @route.stations[@cur_station+1] unless @route == nil || @cur_station >= @route.stations.length-1
  end

  def cur_station
    @route.stations[@cur_station] unless @route == nil
  end

  def prev_station
    @route.stations[@cur_station-1] unless @route == nil || @cur_station <= 0
  end
end

# Station tests
st = Station.new("st1")
tr1 = Train.new("tr1", :cargo, 10)
tr2 = Train.new("tr2", :cargo, 15)
tr3 = Train.new("tr3", :pass, 20)
st.pass_train(tr1)
st.pass_train(tr2)
st.pass_train(tr3)

puts "All trains at st1"
st.trains.each {|tr| puts tr.id}
puts "All cargo trains at st1"
st.trains(:cargo).each {|tr| puts tr.id}
puts "All passenger's trains at st1"
st.trains(:pass).each {|tr| puts tr.id}
st.send_train(tr2)
puts "All trains at st1 after tr2 was sent away"
st.trains.each {|tr| puts tr.id}

# Route tests
rt = Route.new(Station.new("st1"), Station.new("st5"))
puts "\nRoute after creation is"
rt.print

st2 = Station.new("st2")
rt.append_station(st2)
puts "Route after appending st2"
rt.print

rt.append_station(Station.new("st3"))
puts "Route after appending st3"
rt.print

rt.remove_station(st2)
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
puts "Train speed after stopping #{tr.speed}"

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
