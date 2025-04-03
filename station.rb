class Station
  attr_reader :title, :trains

  def initialize(title)
    @title = title
    @trains = []
  end

  def add_train(rain)
    @trains << train
  end

  def depart_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.count { |train| train.type == type }
  end
end