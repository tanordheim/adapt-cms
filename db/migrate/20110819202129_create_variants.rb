class CreateVariants < ActiveRecord::Migration
  def change

    create_table :variants do |t|
      t.references :site, :null => false
      t.string :node_type, :null => false
      t.integer :position, :null => false
      t.string :name, :null => false
      t.timestamps :null => false
    end

    add_index :variants, :site_id
    add_index :variants, :node_type
    add_index :variants, :position

  end
end
