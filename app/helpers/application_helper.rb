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
      if from.match(/middle/)
        t_from = 1 if color == "black"
        t_from = 24 if color == "white"
      end
      t_to = to[0] + to[1]
      t_to = t_to.to_i
      sum_rights = 0
        rights.each do |k, v|
          sum_rights += v.to_i
          rights[k] = v.to_i
        end
      if color == "white"
        if to == "off_game" 
          return move_to_home_field(checkers_hash, to, from, rights) if home_checked(checkers_hash, color)
        elsif t_from - t_to == rights["1"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from - t_to ==  rights["2"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from - t_to == rights["3"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from - t_to == rights["4"]
          return move_helper(checkers_hash, to, from, 1)
        elsif t_from - t_to ==  sum_rights
          return move_helper(checkers_hash, to, from, rights.length)
        else
          return "You can move checker there #{t_from-t_to}"
        end
      #Black move formula Pto - Pfrom == ~rights
      elsif color == "black" 
        if to == "off_game"
          return move_to_home_field(checkers_hash, to, from, rights) if home_checked(checkers_hash, color)
        elsif t_to - t_from == rights["1"]
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
    temp = rand(100) + rand(100) * rand(4) + rand(10)
    if to == "off_game" 
      #generate truly unique key
      to = "#{from}_#{temp}_#{to}"
      checkers_hash.merge!({"#{to}"=>"#{color}"}) if checkers_hash.delete(from)
      @desk.moves -= count
    else
      # if we have 2/3 as to then concatanate srings 2 + / then evaluate it to integer => 2, then evaluate it to string to concatanate with /
      # if we have 12/3 then "12".to_i => 12 to_s "12" + "/" = "12/". Magic :)
      field =  ((to[0] + to[1]).to_i).to_s + '/'
      position = 1
      color_count = 0
      oposite_color = ""
      checkers_hash.each do |current_field, current_color|
        if current_field.match(/^#{field}/)
          position += 1 
          if current_color != color 
            color_count += 1 
            oposite_color = current_color
          end
        end
      end
      if color_count <= 1
        if color_count < 1
          checkers_hash.merge!({"#{field}#{position}"=>"#{color}"}) if checkers_hash.delete(from)
          @desk.moves -= count
        elsif color_count == 1
          position -= 1
          checkers_hash.merge!({"middle_#{temp}"=>"#{oposite_color}"}) if checkers_hash.delete("#{field}#{position}")
          checkers_hash.merge!({"#{field}#{position}"=>"#{color}"}) if checkers_hash.delete(from)
          @desk.moves -= count
        end
      else
        return "You can put your checker only on empty field, or on field where is only one oposite checker!!"
      end
    end 
  end

  def home_checked(checkers_hash, color)
    temp = true
    if color == "black"
      checkers_hash.each do |k, v|
        if (19..24).member?((k[0] + k[1]).to_i)
          temp = false if v != color
        elsif (1..18).member?((k[0] + k[1]).to_i)
          temp = false if v == color
        end
      end
    elsif color == "white"
      checkers_hash.each do |k, v|
        if (1..6).member?((k[0] + k[1]).to_i)
          temp = false if v != color
        elsif (7..24).member?((k[0] + k[1]).to_i)
          temp = false if v == color
        end
      end
    end
    return temp
  end

  def move_to_home_field(checkers_hash, to, from, rights)
    t_from = from[0] + from[1]
    t_from = t_from.to_i
    sum_rights = 0
      rights.each do |k, v|
        sum_rights += v.to_i
        rights[k] = v.to_i
      end
    color = checkers_hash[from] 
    t_to = color == "white" ? 0 : 25
    if color == "white"
      if t_from - t_to <= rights["1"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_from - t_to <=  rights["2"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_from - t_to <= rights["3"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_from - t_to <= rights["4"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_from - t_to <=  sum_rights
        return move_helper(checkers_hash, to, from, rights.length)
      else
        return "You can move checker there #{t_from-t_to}"
      end
    elsif color == "black" 
      if t_to - t_from <= rights["1"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_to - t_from <= rights["2"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_to - t_from <= rights["3"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_to - t_from <= rights["4"]
        return move_helper(checkers_hash, to, from, 1)
      elsif t_to - t_from <= sum_rights
        return move_helper(checkers_hash, to, from, rights.length)
      else
        return "You can move checker there#{t_to} - #{t_from} - #{rights}"
      end
    end
  end

end
