module Validation
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end
  
  module ClassMethods
    attr_writer :attr_validations

    def inherited(subclass)
      subclass.attr_validations = @attr_validations
    end

    def attr_validations
      @attr_validations ||= Hash.new {|hash, key| hash[key] = []}
    end

    def validate(at, type, *params)
      validate_name = "validate_#{type}".to_sym
      attr_validations[at] << ValidationEntry.new(validate_name, params)
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    protected

    def validate!
      self.class.attr_validations.each do |at, entries|
        entries.each do |entry|
          val = self.instance_variable_get("@#{at}")
          self.send(entry.validate_name, at, val, *entry.params)
        end
      end
    end

    def validate_presense(at, val)
      raise ArgumentError, "#{at} must be non nil" if val == nil
      raise ArgumentError, "#{at} must be non empty string" if val == ""
    end

    def validate_format(at, val, format)
      raise ArgumentError, "#{at} has a wrong format" if val !~ format
    end

    def validate_type(at, val, type)
      return if val.class == type
      raise ArgumentError, "#{at} has a wrong type: expected #{type} but given #{val.class}"
    end
  end

  private

  class ValidationEntry
    attr_reader :validate_name, :params

    def initialize(validate_name, params)
      @validate_name = validate_name
      @params = params
    end
  end
end
