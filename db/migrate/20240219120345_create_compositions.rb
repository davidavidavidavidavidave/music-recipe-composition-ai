class CreateCompositions < ActiveRecord::Migration[7.0]
  def change
    create_table :compositions do |t|
      t.string :name
      t.string :instruments
      t.string :description

      t.timestamps
    end
  end
end
