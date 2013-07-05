
class Object
	def self.new_attr_accessor(*args)
		args.each do |arg|
      define_method(arg.to_sym) do
        self.instance_variable_get("@#{arg}".to_sym)
      end
		  define_method("#{arg}=".to_sym) do |value|
        self.instance_variable_set("@#{arg}".to_sym, value)
      end
    end	
	end
end

class Kitty

new_attr_accessor(:nice, :hurty)

  def initialize
   
  end

end