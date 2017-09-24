class CreateFrameworks < ActiveRecord::Migration[5.0]
  def change
    create_table :frameworks id: false, primary_key :framework do |t|
      t.string :framework, null: false
      t.string :language
      t.integer :community_size
      t.string :license
      t.integer :time
      t.integer :rps
      t.string :hosting
      t.string :databases
      t.string :patterns

      t.timestamps
    end
  end
end
