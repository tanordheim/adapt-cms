class CreateDesigns < ActiveRecord::Migration
  def change

    create_table :designs do |t|
      t.references :site, :null => false
      t.boolean :default, :null => false, :default => false
      t.string :name, :null => false
      t.text :markup, :null => false
      t.timestamps :null => false
    end

    add_index :designs, :site_id
    add_index :designs, :default

  end
end
