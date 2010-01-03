class LookupGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => true, :skip_migration => false, :skip_fixture => true
  
  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions class_name, "#{class_name}Test"
      
      # Create directories,
      m.directory File.join('app/models', class_path)
      m.directory File.join('test/unit', class_path)
      
      # Apply templates
      m.template 'model.rb', File.join('app/models', class_path, "#{file_name}.rb")
      m.template 'unit_test.rb',  File.join('test/unit', class_path, "#{file_name}_test.rb")
      
      # Seeds
      puts 'Adding seed data to db/seeds.rb'
      file = File.open(source_path('seed.rb'))
      seed_data = ERB.new(file.read, nil, '-').result(binding)
      File.open('db/seeds.rb', 'a') {|f| f.write(seed_data) }
      
      # Migration
      migration_file_path = file_path.gsub(/\//, '_')
      migration_name = class_name
      if ActiveRecord::Base.pluralize_table_names
        migration_name = migration_name.pluralize
        migration_file_path = migration_file_path.pluralize
      end

      unless options[:skip_migration]
        m.migration_template 'migration.rb', 'db/migrate', :assigns => {
          :migration_name => "Create#{migration_name.gsub(/::/, '')}"
        }, :migration_file_name => "create_#{migration_file_path}"
      end      
    end
  end

  protected
    def banner
      "Usage: #{$0} #{spec.name} ModelName [name, name]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration", 
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
    end
end