class Time
  def hour
    (to_i % 86400) / 3600
  end

  def day?
    self_hour = hour # Only calculate it once, because it's expensive
    self_hour > 6 && self_hour < 18
  end

  def night?
    !day?
  end
end
