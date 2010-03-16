$:.unshift(File.dirname(__FILE__) + "/../../rails_generators")

require "test/unit"
require 'rubygems'
require "rails_generator"
require 'rails_generator/scripts/generate'

class TestDomainGenerator < Test::Unit::TestCase
  DELETE_TMP_APP = true # Set to false when debugging generated files
  
  DOMAIN_GENERATOR_ROOT  = File.join(File.dirname(__FILE__), "/../")
  TMP_RAILS_APP_NAME  = "tmp_rails_app"
  TMP_RAILS_APP_ROOT  = File.join(DOMAIN_GENERATOR_ROOT, TMP_RAILS_APP_NAME)

  def setup
    @app_root = TMP_RAILS_APP_ROOT
    
    FileUtils.rm_rf(@app_root) if File.directory?(@app_root)
    FileUtils.mkdir(File.join(@app_root))
    
    Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:plugin, "#{DOMAIN_GENERATOR_ROOT}/rails_generators/"))
  end
  
  def test_generates_model
    run_script(:domain, File.dirname(__FILE__) + "/example.sqs")
    %w[user.rb post.rb category.rb comment.rb].each do |expected|
      assert File.exists? File.join(@app_root, 'app/models', expected)
    end
  end
  
  def run_script(*args)
    options = !args.empty? && args.last.is_a?(Hash) ? args.pop : {}
    options.merge!({:destination => @app_root, :quiet => true})    
    Rails::Generator::Scripts::Generate.new.run(args, options)
  end
  
  def teardown
    FileUtils.rm_rf(@app_root) unless !DELETE_TMP_APP
  end
end