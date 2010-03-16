require "rexml/document"
require "#{File.dirname(__FILE__)}/lib/domain"

class DomainGenerator < Rails::Generator::Base
  default_options :skip_timestamps => false, :skip_migration => false, :skip_fixture => true
  
  def manifest
    record do |m|
      # Create directories.
      m.directory 'app/models'
#      m.directory File.join('app/models', class_path)
#      m.directory File.join('test/unit', class_path)

      # Load SQL specification
      doc = REXML::Document.new(File.open(args.shift))
      domain = MyDomainGenerator::Domain.new(doc)
      
      # Generate files for each table
      domain.tables.values.each do |table|

        # Check for class naming collisions.
        m.class_collisions table.class_name, "#{table.class_name}Test"

        # Apply templates
        m.template 'model.rb', File.join('app/models', "#{table.file_name}.rb"), :assigns => { :table => table }
        
#        m.template 'model.rb', File.join('app/models', class_path, "#{table.file_name}.rb"), :assigns => table
#        m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{domain.file_name}_test.rb"), :assigns => domain.to_hash
      end
      
#      tables = get_table_names(doc, ARGV)
#      puts "Generating model(s) for #{tables.join(', ')}"
#
#      # Generate files for each table
#      tables.each do |table|
#        domain = Domain.new(doc, table)
#        show_info(domain)
#        
#        # Check for class naming collisions.
#        m.class_collisions domain.class_name, "#{domain.class_name}Test"
#        
#        # Apply templates
#        m.template 'model.rb', File.join('app/models', class_path, "#{domain.file_name}.rb"), :assigns => domain.to_hash
#        m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{domain.file_name}_test.rb"), :assigns => domain.to_hash
#
#        # Migration
#        migration_file_path = domain.migration_file_path
#        migration_name = domain.class_name
#        if ActiveRecord::Base.pluralize_table_names
#          migration_name = migration_name.pluralize
#          migration_file_path = migration_file_path.pluralize
#        end
#
#        unless options[:skip_migration]
#          locals = domain.to_hash.merge(:migration_name => "Create#{migration_name.gsub(/::/, '')}")
#          m.migration_template 'migration.rb', 'db/migrate', :assigns => locals, :migration_file_name => "create_#{migration_file_path}"
#        end
#      end
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} InputFile [Models]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end
    
  private
  
  def get_table_names(doc, args)
    # Use all tables in the spec file unless specfic tables are given
    tables = []
    if args.empty?
      doc.root.elements.each("SQLTable") { |e| tables << e.elements["name"].text }
    else
      tables = args.map { |arg| arg.pluralize }
    end
    tables
  end
  
  def show_info(domain)
    puts <<-INFO

Generating #{domain.class_name} Model
     Class Name:  #{domain.class_name}
     File Name:   #{domain.file_name}
     Description: #{domain.description}

     Fields:
        #{domain.fields.map { |f| "#{f.to_s}\n\t" } }
INFO
  end
end