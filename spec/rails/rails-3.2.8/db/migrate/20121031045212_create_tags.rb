class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags, :id => false, :primary_key => :id do |t|
			t.string :id

      t.string :name

      t.timestamps
    end
  end
end
