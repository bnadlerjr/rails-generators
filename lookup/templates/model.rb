# Lookup table. Uses the caches_constants gem to provide constants for 
# lookup names.
class <%= class_name %> < ActiveRecord::Base
  caches_constants
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
