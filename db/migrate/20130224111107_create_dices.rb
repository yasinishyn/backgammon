class CreateDices < ActiveRecord::Migration
  def change
    create_table :dices do |t|
      t.hstore :dices

      t.timestamps
    end
  end
end
