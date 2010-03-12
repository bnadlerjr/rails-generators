<% required = fields.find_all { |f| !f.column.null }.map { |f| ":#{f.name}"}.join(', ') -%>
<% unique = fields.find_all { |f| !f.unique }.map { |f| ":#{f.name}"}.join(', ') -%>
# == Description:
# <%= description %>
class <%= class_name %> < ActiveRecord::Base
  <%= "validates_presence_of #{required}" unless required.empty? %>
  <%= "validates_uniqueness_of #{unique}" unless unique.empty? %>
end