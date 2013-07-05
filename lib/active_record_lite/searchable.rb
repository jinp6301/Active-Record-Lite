require_relative './db_connection'

module Searchable
  def where(params)
    where_str = []
    params.each do |key, value|
      where_str << "#{key} = '#{value}'"
    end
    query = <<-SQL
      SELECT *
      FROM #{self}s
      WHERE #{where_str.join(' AND ')}
    SQL
    DBConnection.execute(query)
  end
end