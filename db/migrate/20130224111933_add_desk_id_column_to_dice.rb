class AddDeskIdColumnToDice < ActiveRecord::Migration
  def change
  	add_column :dices, :desk_id, :integer
  	add_index :dices, :desk_id 
  end
end
