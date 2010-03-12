<% required = fields.find_all { |f| !f.column.null }.map { |f| ":#{f.name}"}.join(', ') -%>
<% unique = fields.find_all { |f| !f.unique }.map { |f| ":#{f.name}"}.join(', ') -%>
require 'test_helper'

class <%= class_name %>Test < ActiveSupport::TestCase
  context 'a <%= class_name %> instance' do
    <%= "should_validate_presence_of #{required}" unless required.empty? %>
    <%= "should_validate_uniqueness_of #{unique}" unless unique.empty? %>
  end
end