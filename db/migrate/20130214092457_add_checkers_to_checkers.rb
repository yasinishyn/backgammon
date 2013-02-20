class AddCheckersToCheckers < ActiveRecord::Migration
  def change
    add_column :checkers, :checkers, :hstore
  end
end
