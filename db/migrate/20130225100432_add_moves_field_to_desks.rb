class AddMovesFieldToDesks < ActiveRecord::Migration
  def change
    add_column :desks, :moves, :integer
  end
end
