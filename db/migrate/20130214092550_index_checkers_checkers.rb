class IndexCheckersCheckers < ActiveRecord::Migration
  def up
  	execute "CREATE INDEX checkers_checkers ON checkers USING GIN(checkers)"
  end

  def down
  	execute "DROP INDEX checkers_checkers"
  end
end
