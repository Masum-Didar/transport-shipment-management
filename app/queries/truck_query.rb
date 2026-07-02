class TruckQuery
  def initialize(relation = Truck.kept)
    @relation = relation
  end

  def by_status(status)
    @relation = @relation.where(status: status) if status.present?
    self
  end

  def by_type(type)
    @relation = @relation.where(truck_type: type) if type.present?
    self
  end

  def available
    @relation = @relation.where(status: "available")
    self
  end

  def result
    @relation.order(:truck_number)
  end
end
