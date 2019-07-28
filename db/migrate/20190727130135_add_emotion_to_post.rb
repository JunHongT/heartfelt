class AddEmotionToPost < ActiveRecord::Migration[5.2]
  def change
    add_column :posts, :emotion, :string
  end
end
