# == Description
# Categories for posts.
class Category < ActiveRecord::Base
  
  
  validates_presence_of :name
  validates_uniqueness_of :name
end