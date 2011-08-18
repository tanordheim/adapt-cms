class CreateResources < ActiveRecord::Migration
  def change

    create_table :resources do |t|
      t.references :site, :null => false
      t.string :file, :null => false
      t.string :filename, :null =>false
      t.string :content_type, :null => false
      t.integer :file_size, :null => false
      t.integer :creator_id, :null => false
      t.integer :updater_id, :null => false
      t.timestamps :null => false
    end

    add_index :resources, :site_id

  end
end
