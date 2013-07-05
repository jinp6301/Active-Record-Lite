class MassObject

  def self.set_attrs(*attributes)
    @attributes = []
    attributes.each do |attribute|
      attr_accessor attribute.to_sym
      @attributes << attribute
    end
  end

  def self.attributes
    @attributes
  end

  def self.parse_all(results)
    all_results = []
    results.each do |result|
      all_results << self.new(result)
    end
    all_results
  end


  def initialize(params = {})
    params.each do |key,value|
      if self.class.attributes.include?(key.to_sym)
        self.instance_variable_set("@#{key}", value)
      else
        raise 'Not an available attribute'
      end
    end
  end

end

class Kitty < MassObject
  set_attrs :hurty, :nicer
end

Kitty.new(:hurty => 'yes', :nicer => 'no')