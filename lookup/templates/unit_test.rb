require 'test_helper'
load "#{Rails.root}/db/seeds.rb"
class <%= class_name %>Test < ActiveSupport::TestCase
  <%= class_name %>.caches_constants # HACK: See http://www.pragprog.com/titles/fr_arr/errata

  should_validate_presence_of :name
  should_validate_uniqueness_of :name

  should "have cached constants" do
    [<%= attributes.map { |a| "'#{a.name}'" }.join(', ') %>].each do |name|
      assert_equal name, "<%= class_name %>::#{name.gsub(/ /, '').underscore.upcase}".constantize.name
    end
  end
end