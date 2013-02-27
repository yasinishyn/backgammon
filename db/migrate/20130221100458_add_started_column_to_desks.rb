class AddStartedColumnToDesks < ActiveRecord::Migration
  def change
  	add_column :desks, :first_player_id, :integer
  	add_column :desks, :second_player_id, :integer
  	add_column :desks, :started, :boolean, :default => false
  end
end
