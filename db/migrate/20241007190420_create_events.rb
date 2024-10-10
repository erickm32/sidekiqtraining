class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string       :name, null: false, default: ''
      t.references   :category

      t.timestamps
    end
  end
end
