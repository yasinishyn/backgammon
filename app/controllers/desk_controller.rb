class DeskController < ApplicationController

  include ApplicationHelper

  #user must be signedin to play
  before_filter :authenticate_user!, :except => [:index]
  
  def index
    @desks = Desk.where(second_player_id: nil)
  end

  def join
    @desk = Desk.find(params[:id].to_i)
    @desk.second_player_id = current_user.id
    if @desk.save
      redirect_to :action => "show", :id => @desk.id
    else
      #....
    end
  end
  
  def new
  	checkers = build_start()
    @desk = Desk.new(checkers: checkers)
    @desk.first_player_id = current_user.id
    @desk.dice = Dice.new(:dices => {})
    @desk.save
    redirect_to :action => "show", :id => @desk.id
  end

  def show
    @desk = Desk.find(params[:id].to_i)
    unless @desk
      redirect_to :action => "new"
    end
  end

  def move
    id = params["id"]
    @desk = Desk.find(params[:id].to_i)
    temp = 0
    if @desk.moves != 0 && @desk.turn == current_user.username
      if current_user.id == @desk.first_player_id
        temp = move_checker(@desk.checkers, params[:from], params[:to], @desk.dice.dices, "white")  #add notification about color
      else
        temp = move_checker(@desk.checkers, params[:from], params[:to], @desk.dice.dices, "black") #not.....
      end
      if temp.is_a? Hash
        @desk.checkers = temp
      elsif temp.is_a? String
        flash[:error] = temp
      end
    else
      flash[:notice] = "It is not yout turn or your move is over"
    end
    if @desk.moves <= 0
      if @desk.turn == User.find_by_id(@desk.second_player_id).username
        @desk.turn = User.find_by_id(@desk.first_player_id).username
        flash[:notice] = "#{@desk.turn} throw the dices"
      else
        @desk.turn = User.find_by_id(@desk.second_player_id).username
        flash[:notice] = "#{@desk.turn} throw the dices"
      end
    end
    respond_to do |format|
      if @desk.save
        format.html {redirect_to :action => "show", :id => @desk.id}
        format.js
      else
        #....
      end
    end
  end

  def throw_d
    #resive params from user, and find desk by that id
    id = params["id"]
    @desk = Desk.find(params[:id].to_i)
    #user can throw dice only if second user is present
    if @desk.second_player_id && @desk.first_player_id
      #if game has 2-nd player, change status tu true and call start method
      unless @desk.started 
        @desk.started = true
        @desk.dice.dices = @desk.dice.start
        @dice = @desk.dice
        @dice.save
        #add count of avaliable moves 
        @desk.moves = @desk.dice.dices.length #must be accompanied with notification...
        #Check what user will make first move
        if @desk.dice.dices[1.to_s] > @desk.dice.dices[2.to_s]
          @desk.turn = User.find_by_id(@desk.first_player_id).username
          flash[:notice] = "#{@desk.turn} you can move your checkers. Your are White"
        else
          @desk.turn = User.find_by_id(@desk.second_player_id).username
          flash[:notice] = "#{@desk.turn} you can move your checkers. Your are Black"
        end
      #if it not an initial throw
      else
        #resive id of user whom call the request
        #user_id
        #check whether he has the permission to throw
        if @desk.turn == current_user.username
          @desk.dice.dices = @desk.dice.throw_the_dice if @desk.moves == 0
          @dice = @desk.dice
          @dice.save
          @desk.moves = @desk.dice.dices.length #must be accompanied with notification...
          flash[:notice] = "#{@desk.turn} throws dices"
          #notification.........
        else
          flash[:notice] = "Please wait your turn"
          #notification....
        end
      end
    else
      flash[:notice] = "Please wait second player to connect the game"
      # dont make any changes
      #notification.........
    end
    respond_to do |format|
      if @desk.save
        format.html {redirect_to :action => "show", :id => @desk.id}
        format.js
      else
        #....
      end
    end
  end
  	
end
