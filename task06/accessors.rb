module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attrs_history
      @attrs_history ||= Hash.new {|hash, key| hash[key] = []}
    end

    def attr_accessor_with_history(*attrs)
      attrs.each do |at|
        self.define_method(at) {self.instance_variable_get("@#{at}")}
        self.define_method("#{at}=") do |new_val|
          self.class.attrs_history[at] << new_val
          self.instance_variable_set("@#{at}", new_val)
        end
        self.define_method("#{at}_history") {self.class.attrs_history[at]}
      end
    end

    def strong_attr_accessor(at, cls)
      self.define_method(at) {self.instance_variable_get("@#{at}")}
      self.define_method("#{at}=") do |new_val|
        raise "expected value of type #{cls} but given #{new_val.class}" unless new_val.class == cls
        self.instance_variable_set("@#{at}", new_val)
      end
    end
  end
end
