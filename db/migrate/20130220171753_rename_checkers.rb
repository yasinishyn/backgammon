class RenameCheckers < ActiveRecord::Migration
  def change
  	rename_table :checkers, :desks
  end
end
