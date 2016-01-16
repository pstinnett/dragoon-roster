class CreateClans < ActiveRecord::Migration
  def change
    create_table :clans do |t|
      t.integer :clan_id

      t.timestamps null: false
    end
  end
end
