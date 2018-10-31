class CreateLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :links, id: :string, primary_key: 'short_code' do |t|
      t.string :url, null: false
      t.integer :redirect_count, null: false, default: 0

      t.timestamps
    end
  end
end
