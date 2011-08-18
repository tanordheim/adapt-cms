class CreateStylesheets < ActiveRecord::Migration
  def change

    create_table :stylesheets do |t|
      t.references :design, :null => false
      t.string :processor, :null => false, :default => 'plain'
      t.string :filename, :null => false
      t.text :data, :null => false
      t.timestamps :null => false
    end

    add_index :stylesheets, :design_id
    add_index :stylesheets, [:design_id, :filename], :unique => true

  end
end
