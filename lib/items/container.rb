class Container < Item
  def storage
    @storage ||= []
  end

  def put(thing)
    storage << thing
    after_put_callback
  end

  def contains?(item_class)
    storage.any?{ |item| item.is_a? item_class }
  end

  def get_something
    storage.shift
  end

  def after_put_callback
  end
end
