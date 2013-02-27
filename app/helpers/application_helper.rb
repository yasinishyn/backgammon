module ApplicationHelper
  
  def broadcast(channel, &block)
    message = {:channel => channel, :data => capture(&block), :ext => {:auth_token => FAYE_TOKEN}}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end

  #initial the new desk for new game
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

  #change pothition of chaker
  def move_checker(checkers_hash, from, to, rights, color)
    # indicates the color of checker that may be moved
    if color == checkers_hash[from]
      # White move formula Pto - Pfrom == ~rights. Where P - position, ~rights - all variants of posible move
      #currently it is a string. t prefixe means temp
      t_from = from[0] + from[1]
      t_from = t_from.to_i
      t_to = to[0] + to[1]
      t_to = t_to.to_i
      sum_rights = 0
        rights.each do |k, v|
          sum_rights += v.to_i
          rights[k] = v.to_i
        end
      if color == "white"
        t_to = 0 if to == "off_game" 
        if t_from-t_to == rights["1"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from-t_to ==  rights["2"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from-t_to == rights["3"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from-t_to == rights["4"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from-t_to ==  sum_rights
          return move_helper(checkers_hash, to, from, rights.length)
        else
          return "You can move checker there #{t_from-t_to}"
        end
      #Black move formula Pto - Pfrom == ~rights
      elsif color == "black" 
        t_to = 25 if to == "off_game"
        if t_to - t_from == rights["1"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_to - t_from == rights["2"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_to - t_from == rights["3"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_to - t_from == rights["4"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_to - t_from == sum_rights
          return move_helper(checkers_hash, to, from, rights.length)
        else
          return "You can move checker there#{t_to} - #{t_from} - #{rights}"
        end
      end
    else
      return "it's not your checker"
    end
  end

  def move_helper (checkers_hash, to, from, count)
    # resive color value by key
    color = checkers_hash[from] 
    if to == "off_game" 
      temp = rand(100) + rand(100) * rand(4) + rand(10)
      #generate truly unique key
      to = "#{from}_#{temp}_#{to}"
    end
    checkers_hash.merge!({"#{to}"=>"#{color}"}) if checkers_hash.delete(from)
    @desk.moves -= count
  end

end
