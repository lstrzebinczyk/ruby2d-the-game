class Time
  def day?
    hour > 6 && hour < 18
  end

  def night?
    !day?
  end
end
