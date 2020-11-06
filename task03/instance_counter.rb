module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
    base.send :class_variable_set, :@@num_instances, 0
  end

  module ClassMethods
    def num_instances
      class_variable_get :@@num_instances
    end
  end

  module InstanceMethods
    protected
    def register_instance
      self.class.send :class_variable_set, :@@num_instances, self.class.num_instances + 1
    end
  end
end
