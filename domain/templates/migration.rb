class <%= migration_name %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name.downcase %> do |t|
<% for field in fields -%>
      <%= field.to_migration('t') %>
<% end -%>
<% unless options[:skip_timestamps] %>
      t.timestamps
<% end -%>
    end

<% for field in indexed_fields -%>
    add_index :<%= table_name.downcase %>, :<%= field.column.name %>
<% end -%>
  end

  def self.down
<% for field in indexed_fields.reverse -%>
    remove_index :<%= table_name.downcase %>, :<%= field.column.name %>
<% end -%>
    drop_table :<%= table_name.downcase %>
  end
end