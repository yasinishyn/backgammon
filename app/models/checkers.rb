class Checkers < ActiveRecord::Base
  serialize :checkers, ActiveRecord::Coders::Hstore
  attr_accessible :checkers
  

end
