require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'

class Main
  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def menu
    loop do
      puts "1. Создать станцию"
      puts "2. Создать поезд"
      puts "3. Создать маршрут"
      puts "4. Добавить станцию в маршрут"
      puts "5. Удалить станцию из маршрута"
      puts "6. Назначить маршрут поезду"
      puts "7. Добавить вагон к поезду"
      puts "8. Отцепить вагон от поезда"
      puts "9. Переместить поезд по маршруту"
      puts "10. Просмотреть список станций и поездов"
      puts "0. Выход"
      print "Выберите действие: "
      choice = gets.chomp.to_i

      case choice
      when 1 then create_station
      when 2 then create_train
      when 3 then create_route
      when 4 then add_station_to_route
      when 5 then remove_station_from_route
      when 6 then assign_route_to_train
      when 7 then add_wagon_to_train
      when 8 then remove_wagon_from_train
      when 9 then move_train
      when 10 then show_info
      when 0 then break
      else puts "Неверный выбор, попробуйте снова"
      end
    end
  end

  private

  def create_station
    print "Введите название станции: "
    name = gets.chomp
    @stations << Station.new(name)
  end

  def create_train
    print "Введите номер поезда: "
    number = gets.chomp
    print "Выберите тип (1 - пассажирский, 2 - грузовой): "
    type = gets.chomp.to_i

    if(type == 1)
      train = PassengerTrain.new(number)
    else
      train = CargoTrain.new(number)
    end

    @trains << train
  end

  def create_route
    print "Введите номер начальной станции: "
    first_index = gets.chomp.to_i - 1
    print "Введите номер конечной станции: "
    last_index = gets.chomp.to_i - 1

    route = Route.new(@stations[first_index], @stations[last_index])
    @routes << route
  end

  def add_station_to_route
    select_route
    print "Введите номер станции для добавления: "
    station_index = gets.chomp.to_i - 1
    print "Введите позицию (по умолчанию предпоследняя): "
    position = gets.chomp.to_i

    @selected_route.add_station(@stations[station_index], position)
  end

  def remove_station_from_route
    select_route
    print "Введите номер станции для удаления: "
    station_index = gets.chomp.to_i - 1

    @selected_route.remove_station(@selected_route.stations[station_index])
  end

  def assign_route_to_train
    select_train
    select_route
    @selected_train.assign_route(@selected_route)
  end

  def add_wagon_to_train
    select_train
    wagon = Wagon.new(@selected_train.type)
    @selected_train.add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagon_from_train
    select_train
    return if @selected_train.wagons.empty?

    wagon = @selected_train.wagons.last
    @selected_train.remove_wagon(wagon)
  end

  def move_train
    select_train
    print "Выберите направление (1 - вперед, 2 - назад): "
    direction = gets.chomp.to_i

    if(direction == 1)
      @selected_train.go_forward
    else
      @selected_train.go_backward
    end
  end

  def show_info
    @stations.each do |station|
      puts "\nСтанция #{station.title}:\n"
      if station.trains.empty?
        puts "Поездов нет"
      else
        station.trains.each do |train|
          puts "Поезд №#{train.number} (#{train.type}), вагонов: #{train.wagons.size}\n"
        end
      end
    end
  end

  def select_train
    print "Выберите поезд: "
    train_index = gets.chomp.to_i - 1
    @selected_train = @trains[train_index]
  end

  def select_route
    print "Выберите маршрут: "
    route_index = gets.chomp.to_i - 1
    @selected_route = @routes[route_index]
  end
end