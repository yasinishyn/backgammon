class DeskController < ApplicationController

  include ApplicationHelper
  
  
  def new
  	checkers = build_start()
    @checkers = Checkers.new(checkers: checkers)
    @checkers.save
    redirect_to :action => "show", :id => @checkers.id
  end
  def show
    @checkers = Checkers.find(params[:id].to_i)
    unless @checkers
      redirect_to :action => "new"
    end
  end
  def move
    id = params["id"]
    @checkers = Checkers.find(params[:id].to_i)
    @checkers.checkers = move_checker(@checkers.checkers, params[:from], params[:to])
    respond_to do |format|
      if @checkers.save
        format.html {redirect_to :action => "show", :id => @checkers.id}
        format.js
      else
        #....
      end
    end
  end
  protected
  	def move_checker(checkers_hash, from, to)
      if to == "off_game"
        to = "#{from}_#{to}" 
      end
      color = checkers_hash[from]
      checkers_hash.merge!({"#{to}"=>"#{color}"}) if checkers_hash.delete(from)
  		return checkers_hash
  	end
end
