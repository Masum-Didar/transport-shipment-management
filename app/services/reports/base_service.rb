module Reports
  class BaseService
    protected

    def date_range(from, to)
      Date.parse(from)..Date.parse(to)
    rescue
      nil
    end
  end
end
