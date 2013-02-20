class CreateCheckers < ActiveRecord::Migration
  def change
    create_table :checkers do |t|
      t.timestamps
    end
  end
end
