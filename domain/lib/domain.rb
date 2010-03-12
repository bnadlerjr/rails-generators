require "#{File.dirname(__FILE__)}/rails-ext/generated_attribute_extended"

# == Description
# A model for a table domain.
class Domain
  
  # +doc+: An XML document that contains domain information.
  # +table+: The name of the table to extract information from.
  def initialize(doc, table)
    @table = table
    @table_node = doc.root.elements["SQLTable[name='#{table}']"]
  end
  
  # A description of the table.
  def description
    @table_node.elements["comment"].text if @table_node.elements["comment"]        
  end
  
  # Class name for the table.
  def class_name
    @table.singularize
  end
  
  # File name for the table.
  def file_name
    class_name.dasherize.downcase
  end

  # Array of fields for the table. Does not include 'ID' field if one is present in the XML
  # document. Returns an array of +GeneratedAttributeExtended+ objects.
  def fields
    fields = []
    @table_node.elements.each("SQLField") do |e|
      unless 'id' == e.elements["name"].text # Skip id column
        # Required
        name = e.elements["name"].text.downcase
        type = e.elements["type"].text.downcase

        # Optional
        e.elements["defaultValue"] ? default = e.elements["defaultValue"].text : default = ''
        e.elements["notNull"] && e.elements["notNull"].text == '1' ? nullable = false : nullable = true
        e.elements["indexed"] && e.elements["indexed"].text == '1' ? indexed = true : indexed = false
        e.elements["unique"] && e.elements["unique"].text == '1' ? unique = false : unique = true
        fields << Rails::Generator::GeneratedAttributeExtended.new(name, type, default, nullable, indexed, unique)
      end
    end
    fields
  end
  
  # Path to migration file for the table.
  def migration_file_path
    file_name.underscore.downcase
  end
  
  # A convenience method for converting a +Domain+ to a hash. It makes is easier to pass this hash as a local
  # variable to the ERB templates.
  def to_hash
    returning Hash.new do |h|
      h[:description] = description
      h[:class_name] = class_name
      h[:file_name] = file_name
      h[:fields] = fields
      h[:migration_file_path] = migration_file_path      
    end
  end
end