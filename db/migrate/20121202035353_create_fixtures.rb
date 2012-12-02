class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.string :fist_team
      t.string :second_team
      t.string :location
      t.string :date

      t.timestamps
    end
  end
end
