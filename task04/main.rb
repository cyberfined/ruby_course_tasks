#!/usr/bin/env ruby

require_relative("station")
require_relative("route")
require_relative("cargo_train")
require_relative("passenger_train")
require_relative("cargo_car")
require_relative("passenger_car")
require_relative("menu")

class App
  def initialize
    @stations = []
    @routes = []
    @trains = []
    create_menus
  end

  def run
    @main_menu.run
  end

  private

  def create_menus
    stations_menu = Menu.new
    stations_menu.add_element("Create new station", method(:create_station_handler))
    stations_menu.add_element("Show all stations", method(:show_stations_handler))
    stations_menu.add_element("Show trains on station", method(:trains_on_station_handler))

    routes_menu = Menu.new
    routes_menu.add_element("Create new route", method(:create_route_handler))
    routes_menu.add_element("Show all routes", method(:show_routes_handler))
    routes_menu.add_element("Append station", method(:append_route_station_handler))
    routes_menu.add_element("Remove station", method(:remove_route_station_handler))

    new_train_menu = Menu.new
    new_train_menu.add_element("Create cargo train", method(:create_cargo_train_handler))
    new_train_menu.add_element("Create passenger train", method(:create_pass_train_handler))

    trains_menu = Menu.new
    trains_menu.add_element("Create new train", new_train_menu.method(:run))
    trains_menu.add_element("Show trains", method(:show_trains_handler))
    trains_menu.add_element("Show manufacturer", method(:show_train_manufacturer))
    trains_menu.add_element("Set manufacturer", method(:set_train_manufacturer))
    trains_menu.add_element("Attach car", method(:attach_car_handler))
    trains_menu.add_element("Detach car", method(:detach_car_handler))
    trains_menu.add_element("Show cars", method(:show_cars_handler))
    trains_menu.add_element("Set route", method(:set_route_train_handler))
    trains_menu.add_element("Move forward", method(:move_forward_handler))
    trains_menu.add_element("Move backward", method(:move_backward_handler))
    trains_menu.add_element("Show current station", method(:show_current_station_handler))

    @main_menu = Menu.new
    @main_menu.add_element("Stations management", stations_menu.method(:run))
    @main_menu.add_element("Routes management", routes_menu.method(:run))
    @main_menu.add_element("Trains management", trains_menu.method(:run))
  end

  def select_menu(choices)
    menu = Menu.new
    choices.each {|c| menu.add_element(c.to_s, nil)}
    menu
  end

  def input(query)
    $stdout.write(query)
    gets.strip
  end

  # Station handlers
  def create_station_handler
    station_name = input("Enter station name: ")
    @stations << Station.new(station_name)
    puts "Station #{station_name} was created"
  rescue ArgumentError => e
    puts e.message.capitalize
    retry
  end

  def show_stations_handler
    puts @stations
  end

  def trains_on_station_handler
    puts "Select station:"
    select_menu(@stations).run(false) do |st_id|
      @stations[st_id].trains.each {|tr| puts tr.id}
    end
  end

  # Route handlers
  def create_route_handler
    puts "Select start station"
    select_menu(@stations).run(false) do |st1_id|
      puts "Select end station"
      unselected_stations = @stations.dup
      unselected_stations.delete_at(st1_id)
      select_menu(unselected_stations).run(false) do |st2_id|
        @routes << Route.new(@stations[st1_id], unselected_stations[st2_id])
      end
    end
  end

  def show_routes_handler
    puts @routes
  end

  def append_route_station_handler
    puts "Select route:"
    select_menu(@routes).run(false) do |ro_id|
      puts "Select station:"
      route = @routes[ro_id]
      unselected_stations = @stations.reject {|st| route.stations.member? st}
      select_menu(unselected_stations).run(false) do |st_id|
        route.append_station(unselected_stations[st_id])
      end
    end
  end

  def remove_route_station_handler
    puts "Select route:"
    select_menu(@routes).run(false) do |ro_id|
      stations = @routes[ro_id].stations[1..-2]
      puts "Select station:"
      select_menu(stations).run(false) do |st_id|
        @routes[ro_id].remove_station(@stations[st_id])
      end
    end
  end

  # Train handlers
  def create_cargo_train_handler
    tr_id = input("Enter train id: ")
    @trains << CargoTrain.new(tr_id)
    puts "Cargo train #{tr_id} was created"
  rescue ArgumentError => e
    puts e.message.capitalize
    retry
  end

  def create_pass_train_handler
    tr_id = input("Enter train id: ")
    @trains << PassengerTrain.new(tr_id)
    puts "Passenger train #{tr_id} was created"
  rescue ArgumentError => e
    puts e.message.capitalize
    retry
  end

  def show_trains_handler
    @trains.each {|tr| puts "#{tr.id}: #{tr.type}"}
  end

  def set_train_manufacturer
    select_menu(@trains).run(false) do |tr_id|
      manufacturer = input("Enter manufacturer: ")
      @trains[tr_id].manufacturer = manufacturer
    end
  end

  def show_train_manufacturer
    select_menu(@trains).run(false) do |tr_id|
      puts @trains[tr_id].manufacturer
    end
  end

  def attach_car_handler
    puts "Select train:"
    select_menu(@trains).run(false) do |tr_id|
      tr = @trains[tr_id]
      car = if tr.type == :cargo
              CargoCar.new
            else
              PassengerCar.new
            end
      tr.attach_car(car)
    end
  end

  def detach_car_handler
    puts "Select train:"
    select_menu(@trains).run(false) {|tr_id| @trains[tr_id].detach_car}
  rescue RuntimeError => e
    puts e.message.capitalize
  end

  def show_cars_handler
    puts "Select train:"
    select_menu(@trains).run(false) {|tr_id| puts "Number of cars #{@trains[tr_id].cars.length}"}
  end

  def set_route_train_handler
    puts "Select train:"
    select_menu(@trains).run(false) do |tr_id|
      puts "Select route:"
      select_menu(@routes).run(false) {|ro_id| @trains[tr_id].set_route(@routes[ro_id])}
    end
  end

  def move_forward_handler
    puts "Select train:"
    select_menu(@trains).run(false) {|tr_id| @trains[tr_id].move_next_station}
  rescue RuntimeError => e
    puts e.message.capitalize
  end

  def move_backward_handler
    puts "Select train:"
    select_menu(@trains).run(false) {|tr_id| @trains[tr_id].move_prev_station}
  rescue RuntimeError => e
    puts e.message.capitalize
  end

  def show_current_station_handler
    puts "Select train:"
    select_menu(@trains).run(false) do |tr_id|
      tr = @trains[tr_id]
      ps = tr.prev_station
      cs = tr.cur_station
      ns = tr.next_station
      puts "Previous station is: #{ps.title}" if ps
      puts "Current station is: #{cs.title}" if cs
      puts "Next station is: #{ns.title}" if ns
    end
  end
end

app = App.new
app.run
