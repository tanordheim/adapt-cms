class CreateNodes < ActiveRecord::Migration
  def change

    create_table :nodes do |t|
      t.references :site, :null => false
      t.string :type
      t.string :ancestry
      t.integer :position, :null => false
      t.string :slug, :null => false
      t.string :uri, :null => false
      t.boolean :published, :null => false, :default => true
      t.date :published_on
      t.boolean :show_in_navigation, :null => false, :default => true
      t.references :variant
      t.string :name, :null => false

      # Link attributes
      t.string :href

      t.integer :creator_id, :null => false
      t.integer :updater_id, :null => false
      t.timestamps :null => false
    end

    add_index :nodes, :site_id
    add_index :nodes, :type
    add_index :nodes, [:site_id, :ancestry]
    add_index :nodes, :position
    add_index :nodes, [:site_id, :uri], :unique => true
    add_index :nodes, :published
    add_index :nodes, :show_in_navigation
    add_index :nodes, :variant_id

  end
end
