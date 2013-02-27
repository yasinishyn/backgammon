class AddIndexColumnToDice < ActiveRecord::Migration
  def up 	
  		execute "CREATE INDEX dices_dice ON dices USING GIN(dices)"
  	end

  	def down
  		execute "DROP INDEX dices_dice"  
	end
end
