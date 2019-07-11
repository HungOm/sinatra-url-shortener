class AddColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :urls, :shortenedurl, :string
  end
end
