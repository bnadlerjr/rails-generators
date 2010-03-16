require "#{File.dirname(__FILE__)}/rails-ext/generated_attribute_extended"

module DomainGenerator
  class Table
    attr_reader :name, :description, :class_name, :file_name, :migration_file_name, :fields, :indexed_fields, :references
    
    # Creates a new +Table+ object.
    #
    # table_node::
    #   An XML node for a table.
    def initialize(table_node)
      @table_node          = table_node
      @name                = @table_node.elements["name"].text
      @description         = @table_node.elements["comment"].text if @table_node.elements["comment"]
      @class_name          = @name.singularize
      @file_name           = class_name.dasherize.downcase
      @migration_file_name = file_name.underscore.downcase
      @references          = Hash.new
      
      extract_fields!
      
      @indexed_fields      = @fields.reject { |f| !f.indexed }
    end
    
#    def belongs_to_references
#      @references.map { |r| ":#{r}"}.join(', ')
#    end
#
#    def add_has_many_reference(table_name)
#      @has_many_references << table_name.to_sym
#    end
#    
#    def has_many_references
#      @has_many_references.join(', ')
#    end
    
    private
    
    def extract_fields!
      @fields = []
      @references[:belongs_to] = Array.new
      @references[:has_many] = Array.new
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

          # Relationships       
          @references[:belongs_to] << e.elements["referencesTable"].text.pluralize.underscore.to_sym if e.elements["referencesTable"]

          @fields << Rails::Generator::GeneratedAttributeExtended.new(name, type, default, nullable, indexed, unique)
        end
      end
    end
  end
end