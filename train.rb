class Train
  attr_reader :number, :type, :wagons, :route, :current_station_index, :speed

  def initialize(number, type, wagons)
    @number = number
    @type = type
    @wagons = wagons
    @speed = 0
    @route = nil
    @current_station_index = nil
  end

  def stopped?
    self.speed.zero?
  end

  def stop
    self.speed = 0 unless stopped?
  end

  def speed_up(speed = 5)
    self.speed += speed
  end

  def speed_down(speed = 5)
    self.speed = [self.speed - speed, 0].max unless stopped?
  end

  def add_wagon
    self.wagons += 1 if stopped?
  end

  def remove_wagon
    self.wagons -= 1 if stopped? && has_wagons?
  end

  def assign_route(route)
    self.route = route
    self.current_station_index = 0
    current_station.add_train(self)
  end

  def current_station
    self.route.stations[self.current_station_index] if has_route?
  end

  def next_station
    self.route.stations[self.current_station_index + 1] unless last_station
  end

  def previous_station
    self.route.stations[self.current_station_index - 1] unless first_station
  end

  def go_forward
    move_to('forward')
  end

  def go_backward
    move_to('backward')
  end

  private

  # прячем прямой доступ к изменению скорости и количеству вагонов
  attr_writer :speed, :wagons, :route, :current_station_index

  # в спецификации не требуется доступ к этим методам, это внутренная логика
  def has_wagons?
    self.wagons > 0
  end

  def has_route?
    self.route
  end

  def last_station?
    has_route? && self.current_station_index == self.route.stations.size - 1
  end

  def first_station?
    has_route? && self.current_station_index > 0
  end

  def move_to(type)
    return if (last_station? && type == 'forward') || (first_station? && type == 'backward')

    current_station.depart_train(self)
    direction = type == 'forward' ? 1 : -1
    self.current_station_index += direction
    current_station.add_train(self)
  end
end