class ShipmentQuery
  def initialize(relation = Shipment.kept)
    @relation = relation
  end

  def by_date_range(from, to)
    @relation = @relation.where(shipment_date: from..to)
    self
  end

  def by_type(type)
    @relation = @relation.where(shipment_type: type) if type.present?
    self
  end

  def by_status(status)
    @relation = @relation.where(status: status) if status.present?
    self
  end

  def by_truck(truck_id)
    @relation = @relation.where(truck_id: truck_id) if truck_id.present?
    self
  end

  def search(query)
    @relation = @relation.where("shipment_number ILIKE ?", "%#{query}%") if query.present?
    self
  end

  def recent(limit = 10)
    @relation.order(created_at: :desc).limit(limit)
  end

  def result
    @relation
  end
end
