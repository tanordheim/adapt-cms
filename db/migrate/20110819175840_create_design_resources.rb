class CreateDesignResources < ActiveRecord::Migration
  def change

    create_table :design_resources do |t|
      t.references :design, :null => false
      t.string :file, :null => false
      t.string :filename, :null =>false
      t.string :content_type, :null => false
      t.integer :file_size, :null => false
      t.timestamps :null => false
    end

    add_index :design_resources, :design_id
    add_index :design_resources, [:design_id, :filename], :unique => true

  end
end
