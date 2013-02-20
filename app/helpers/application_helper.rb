module ApplicationHelper

  def build_start
  	checkers = Hash.new
	  (1..24).each do |x|
      next if [2,3,4,5,7,9,10,11,14,15,16,18,20,21,22,23].include?(x)
  		if x == 1 
        (1..2).each do |y|
  			   color = "black"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 6
  			(1..5).each do |y|
           color = "white"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 8
        (1..3).each do |y|
           color = "white"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 12
        (1..5).each do |y|
           color = "black"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 13
        (1..5).each do |y|
           color = "white"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 17
        (1..3).each do |y|
           color = "black"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 19
        (1..5).each do |y|
           color = "black"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
  		elsif x == 24
        (1..2).each do |y|
           color = "white"
           checkers.merge!({"#{x}/#{y}"=>"#{color}"})
        end
      end
  	end
  	checkers
  end
end
