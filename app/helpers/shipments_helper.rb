module ShipmentsHelper
  def status_options_for(current_status)
    transitions = {
      "pending"    => %w[loading],
      "loading"    => %w[loaded],
      "loaded"     => %w[on_the_way],
      "on_the_way" => %w[reached],
      "reached"    => %w[unloading],
      "unloading"  => %w[completed]
    }
    next_statuses = transitions[current_status] || []
    next_statuses.map { |s| [s.titleize, s] }
  end
end
