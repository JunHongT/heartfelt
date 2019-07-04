class AddExpressionToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :expression, :string
  end
end
