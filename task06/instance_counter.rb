module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    attr_writer :instances

    def num_instances
      instances.length
    end

    def instances
      @instances ||= []
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instances << self
    end
  end
end
