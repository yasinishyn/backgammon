class AddTurnFieldToDesks < ActiveRecord::Migration
  def change
    add_column :desks, :turn, :string
  end
end
