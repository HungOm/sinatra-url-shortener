class CreateUrlHistory < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.integer :user_id
      t.integer :url_id
      t.timestamps
    end
  end
end
