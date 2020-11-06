module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_writer :num_instances

    def num_instances
      @num_instances || 0
    end
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.num_instances += 1
    end
  end
end
