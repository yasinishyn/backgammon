class Dice < ActiveRecord::Base
  serialize :dices, ActiveRecord::Coders::Hstore
  attr_accessible :dices
  belongs_to :desk, :class_name => "Desk", :dependent => :destroy, :autosave => true, :foreign_key => :desk_id

  def start
		dices={} # skip 0 for simplisity
		dices.merge!({ "1" => generate_dice_rand.to_s}) #for first User
		dices.merge!({ "2" => generate_dice_rand.to_s}) # for second User
		return dices
	end

	def throw_the_dice
		dices={} # skip 0 for simplisity
		dices.merge!({ "1" => generate_dice_rand}) #for first User
		dices.merge!({ "2" => generate_dice_rand}) # for second User
		if dices["1"] == dices["2"]
			dices["3"]=dices["4"]=dices["1"] # if 2 dices have the same value, return 4 dices
			return dices
		else
			return dices
		end
	end

	protected
		def generate_dice_rand
			1 + rand(1-6) #random number in range 1..6
		end

end
