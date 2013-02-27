class Desk < ActiveRecord::Base
  has_one :dice, :class_name => "Dice", :foreign_key => :desk_id, :dependent => :destroy
  #belongs_to :first_user, :class_name => "User", :foreign_key => :first_player_id
  #belongs_to :second_user, :class_name => "User", :foreign_key => :second_player_id
  serialize :checkers, ActiveRecord::Coders::Hstore
  attr_accessible :checkers, :first_player_id, :second_player_id, :dices
end
