class AddContentToCompositions < ActiveRecord::Migration[7.0]
  def change
    add_column :compositions, :content, :text
  end
end
