module Rails
  module Generator
    # == Description
    # An extended version of +GeneratedAttribute+ that adds support for indicating if the attribute
    # is indexed or unique.
    class GeneratedAttributeExtended < Rails::Generator::GeneratedAttribute
      attr_accessor :indexed, :unique
      
      def initialize(name, type, default=nil, nullable=true, indexed=false, unique=false)
        @name, @type = name, type.to_sym
        @column = ActiveRecord::ConnectionAdapters::Column.new(@name, default, @type, nullable)
        @indexed, @unique = indexed, unique
      end
      
      # Converts attribute fields into a readable string.
      def to_s
        "Name:    #{name}\n\tType:    #{type}\n\tDefault: #{default}\n\tIndexed: #{indexed}\n\tUnique:  #{unique}\n"
      end
    end
  end
end