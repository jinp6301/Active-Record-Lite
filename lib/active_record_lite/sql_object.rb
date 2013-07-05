require_relative "./associatable"
require_relative "./db_connection"
require_relative "./mass_object"
require_relative "./searchable"
require "active_support/inflector"

class SQLObject < MassObject
  extend Searchable
  extend Associatable
  def self.set_table_name(table_name)
    @table_name = table_name.underscore
  end

  def self.table_name
    @table_name
  end

  def self.all
    all_rows = DBConnection.execute("SELECT * FROM #{@table_name}")
    all_rows.each do |row|
      self.new(row)
    end
  end

  def self.find(id)
    rows = DBConnection.execute("SELECT * FROM #{@table_name} WHERE ?", id).first
    self.new(rows)
  end

  def attr_names
    self.instance_variables.map{|x| x[1..-1].to_s}.join(", ")
  end

   def attr_names_update
    self.instance_variables.map{|x| x[1..-1].to_s + " = ?"}.join(", ")
  end

  def create
    attr_question_marks_string = (["?"] * (self.class.attributes.length - 1)).join(",  ")
    query = <<-SQL
      INSERT INTO #{self.class.table_name} (#{attr_names}) 
      VALUES (#{attr_question_marks_string})
    SQL
    values =  self.instance_variables.map{|i| instance_variable_get(i) }
    DBConnection.execute(query, *values)
    self.id = DBConnection.last_insert_row_id
  end

  def update
    attr_question_marks_string = (["?"] * (self.class.attributes.length - 1)).join(",  ")
    p attr_names
    query = <<-SQL
      UPDATE #{self.class.table_name}  
      SET #{attr_names_update}
      WHERE id = #{self.id}
    SQL
    p query
    
    values =  self.instance_variables.map{|i| instance_variable_get(i) }
    DBConnection.execute(query, *values)

  end

  def save
    if self.id.nil?
      create
    else
      update
    end
  end

  def attribute_values
  end
end
