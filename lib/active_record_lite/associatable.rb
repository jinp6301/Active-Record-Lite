require 'active_support/core_ext/object/try'
require 'active_support/inflector'
require_relative './db_connection.rb'

class AssocParams
  def other_class
  end

  def other_table
  end
end

class BelongsToAssocParams < AssocParams
  def initialize(name, params)
  end

  def type
  end
end

class HasManyAssocParams < AssocParams
  def initialize(name, params, self_class)
  end

  def type
  end
end

module Associatable
  def assoc_params
  end

  def belongs_to(name, params = {})
    define_method(name) do 
      other_class_name = params[:class_name]
      primary_key = params[:primary_key]
      foreign_key = params[:foreign_key]
      other_class = other_class_name.constantize
      other_table_name = other_class.table_name
      query= <<-SQL
        SELECT *
        FROM #{self.class}s
        JOIN #{other_table_name}
        ON  #{other_class_name}s.#{primary_key} = #{foreign_key}
      SQL
      p query
      joined_table = DBConnection.execute(query)
      p joined_table
      other_class.parse_all(joined_table)
    end
  end

  def has_many(name, params = {})
  end

  def has_one_through(name, assoc1, assoc2)
  end
end
