$:.unshift(File.dirname(__FILE__) + "/../../rails_generators")
$:.unshift(File.dirname(__FILE__) + "/../lib")

require "test/unit"
require 'rubygems'
require 'active_record/connection_adapters/abstract/schema_definitions'
require 'rails_generator'
require 'domain'
require "rexml/document"

class TestDomain < Test::Unit::TestCase
  def setup
    @doc = REXML::Document.new(File.open(File.dirname(__FILE__) + '/example.sqs'))
  end
  
  def test_can_initialize_domain
    domain = DomainGenerator::Domain.new(@doc)
    assert_not_nil domain
    assert_equal 5, domain.tables.size
    assert_equal 'Users', domain.tables[:users].name
    assert_equal 'Posts', domain.tables[:posts].name
    assert_equal 'Comments', domain.tables[:comments].name
    assert_equal 'Categories', domain.tables[:categories].name
    assert_equal 'CategoriesPosts', domain.tables[:categories_posts].name
  end
  
  def test_can_initialize_domain_with_specific_tables
    domain = DomainGenerator::Domain.new(@doc, %w[Users Posts])
    assert_not_nil domain
    assert_equal 2, domain.tables.size
    assert_equal 'Users', domain.tables[:users].name
    assert_equal 'Posts', domain.tables[:posts].name
  end
  
  def test_belongs_to_references_are_created
    domain = DomainGenerator::Domain.new(@doc, %w[Users Posts])
    assert_equal [:users], domain.tables[:posts].references[:belongs_to]
    assert_equal [], domain.tables[:users].references[:belongs_to]
  end
  
  def test_has_many_references_are_created
    domain = DomainGenerator::Domain.new(@doc, %w[Users Posts])
    assert_equal [:posts], domain.tables[:users].references[:has_many]
    assert_equal [], domain.tables[:posts].references[:has_many]
  end
end