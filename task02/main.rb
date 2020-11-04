#!/usr/bin/env ruby

require_relative("station")
require_relative("route")
require_relative("cargo_train")
require_relative("passenger_train")
require_relative("cargo_car")
require_relative("passenger_car")
require_relative("menu")

def select_menu(choices)
  menu = Menu.new
  choices.each {|c| menu.add_element(c.to_s, nil)}
  menu
end

# Station handlers
def create_station_handler(stations)
  Proc.new do
    $stdout.write('Enter station name: ')
    station_name = gets.strip
    stations << Station.new(station_name)
  end
end

def show_stations_handler(stations)
  Proc.new {puts stations}
end

def trains_on_station_handler(stations)
  Proc.new do
    puts "Select station:"
    select_menu(stations).run(false) do |st_id|
      stations[st_id].trains.each {|tr| puts tr.id}
    end
  end
end

# Route handlers
def create_route_handler(stations, routes)
  Proc.new do
    puts "Select start station"
    select_menu(stations).run(false) do |st1_id|
      puts "Select end station"
      unselected_stations = stations.dup
      unselected_stations.delete_at(st1_id)
      select_menu(unselected_stations).run(false) do |st2_id|
        routes << Route.new(stations[st1_id], unselected_stations[st2_id])
      end
    end
  end
end

def show_routes_handler(routes)
  Proc.new {puts routes}
end

def append_route_station_handler(stations, routes)
  Proc.new do
    puts "Select route:"
    select_menu(routes).run(false) do |ro_id|
      puts "Select station:"
      route = routes[ro_id]
      unselected_stations = stations.reject {|st| route.stations.member? st}
      select_menu(unselected_stations).run(false) do |st_id|
        route.append_station(unselected_stations[st_id])
      end
    end
  end
end

def remove_route_station_handler(routes)
  Proc.new do
    puts "Select route:"
    select_menu(routes).run(false) do |ro_id|
      stations = routes[ro_id].stations[1..-2]
      puts "Select station:"
      select_menu(stations).run(false) do |st_id|
        routes[ro_id].remove_station(stations[st_id])
      end
    end
  end
end

# Train handlers
def create_cargo_train_handler(trains)
  Proc.new do
    $stdout.write("Enter train id: ")
    trains << CargoTrain.new(gets.strip)
  end
end

def create_pass_train_handler(trains)
  Proc.new do
    $stdout.write("Enter train id: ")
    trains << PassengerTrain.new(gets.strip)
  end
end

def show_trains_handler(trains)
  Proc.new do
    trains.each {|tr| puts "#{tr.id}: #{tr.type}"}
  end
end

def set_route_train_handler(routes, trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) do |tr_id|
      puts "Select route:"
      select_menu(routes).run(false) {|ro_id| trains[tr_id].set_route(routes[ro_id])}
    end
  end
end

def attach_car_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) do |tr_id|
      tr = trains[tr_id]
      car = if tr.type == :cargo
              CargoCar.new
            else
              PassengerCar.new
            end
      tr.attach_car(car)
    end
  end
end

def detach_car_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) {|tr_id| trains[tr_id].detach_car}
  end
end

def show_cars_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) {|tr_id| puts "Number of cars #{trains[tr_id].cars.length}"}
  end
end

def move_forward_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) {|tr_id| trains[tr_id].move_next_station}
  end
end

def move_backward_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) {|tr_id| trains[tr_id].move_prev_station}
  end
end

def show_current_station_handler(trains)
  Proc.new do
    puts "Select train:"
    select_menu(trains).run(false) do |tr_id|
      tr = trains[tr_id]
      ps = tr.prev_station
      cs = tr.cur_station
      ns = tr.next_station
      puts "Previous station is: #{ps.title}" if ps
      puts "Current station is: #{cs.title}" if cs
      puts "Next station is: #{ns.title}" if ns
    end
  end
end

stations = []
trains = []
routes = []

stations_menu = Menu.new
stations_menu.add_element("Create new station", create_station_handler(stations))
stations_menu.add_element("Show all stations", show_stations_handler(stations))
stations_menu.add_element("Show trains on station", trains_on_station_handler(stations))

routes_menu = Menu.new
routes_menu.add_element("Create new route", create_route_handler(stations, routes))
routes_menu.add_element("Show all routes", show_routes_handler(routes))
routes_menu.add_element("Append station", append_route_station_handler(stations, routes))
routes_menu.add_element("Remove station", remove_route_station_handler(routes))

new_train_menu = Menu.new
new_train_menu.add_element("Create cargo train", create_cargo_train_handler(trains))
new_train_menu.add_element("Create passenger train", create_pass_train_handler(trains))

trains_menu = Menu.new
trains_menu.add_element("Create new train", Proc.new {new_train_menu.run})
trains_menu.add_element("Show trains", show_trains_handler(trains))
trains_menu.add_element("Set route", set_route_train_handler(routes, trains))
trains_menu.add_element("Attach car", attach_car_handler(trains))
trains_menu.add_element("Detach car", detach_car_handler(trains))
trains_menu.add_element("Show cars", show_cars_handler(trains))
trains_menu.add_element("Move forward", move_forward_handler(trains))
trains_menu.add_element("Move backward", move_backward_handler(trains))
trains_menu.add_element("Show current station", show_current_station_handler(trains))

main_menu = Menu.new
main_menu.add_element("Stations management", Proc.new {stations_menu.run})
main_menu.add_element("Routes management", Proc.new {routes_menu.run})
main_menu.add_element("Trains management", Proc.new {trains_menu.run})
main_menu.run
