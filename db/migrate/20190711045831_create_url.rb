class CreateUrl < ActiveRecord::Migration[5.2]
  def change
    create_table :urls do |t|
      t.string :url_s
      t.integer :user_id, :null=>true
      t.timestamps
    end
  end
end
