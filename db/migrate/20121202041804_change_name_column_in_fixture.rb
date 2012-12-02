class ChangeNameColumnInFixture < ActiveRecord::Migration
  def up
  	change_table :fixtures do |t|
  		t.rename :fist_team, :first_team
	end
  end

  def down
  end
end
