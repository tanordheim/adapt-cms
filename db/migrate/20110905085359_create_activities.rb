class CreateActivities < ActiveRecord::Migration
  def change

    create_table :activities do |t|
      t.references :site, :null => false
      t.integer :parent_id
      t.integer :author_id, :null => false
      t.references :source, :null => false, :polymorphic => true
      t.string :source_name, :null => false
      t.string :action, :null => false
      t.integer :count, :null => false, :default => 1
      t.timestamps :null => false
    end

    add_index :activities, :site_id
    add_index :activities, [:source_id, :source_type]

    add_foreign_key :activities, :sites
    add_foreign_key :activities, :admins, :column => 'author_id'

  end
end
