
# <%= class_name %> lookup names:
[<%= attributes.map { |a| "'#{a.name}'" }.join(', ') %>].each do |name|
  <%= class_name %>.find_or_create_by_name(:name => name)
end
