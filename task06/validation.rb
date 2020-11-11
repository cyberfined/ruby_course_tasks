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
      validation_types = Validation.validation_types
      raise "undefined validation type #{type}" unless validation_types.member? type
      attr_validations[at] << ValidationEntry.new(at, validation_types[type], params)
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue
      false
    end

    private

    def validate!
      self.class.attr_validations.each_value do |entries|
        entries.each do |entry|
          val = self.instance_variable_get("@#{entry.at}")
          entry.validate(val)
        end
      end
    end
  end

  def self.validation_types
    @validation_types ||= {
      presense: method(:validate_presense),
      format:   method(:validate_format),
      type:     method(:validate_type)
    }
  end

  private

  class ValidationEntry
    attr_reader :at

    def initialize(at, validate, params)
      @at = at
      @validate = validate
      @params = params
    end

    def validate(val)
      @validate.call(@at, val, *@params)
    end
  end

  def self.validate_presense(at, val)
    raise ArgumentError, "#{at} must be non nil" if val == nil
    raise ArgumentError, "#{at} must be non empty string" if val == ""
  end

  def self.validate_format(at, val, format)
    raise ArgumentError, "#{at} has a wrong format" if val !~ format
  end

  def self.validate_type(at, val, type)
    return if val.class == type
    raise ArgumentError, "#{at} has a wrong type: expected #{type} but given #{val.class}"
  end
end
