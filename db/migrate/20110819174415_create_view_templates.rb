class CreateViewTemplates < ActiveRecord::Migration
  def change

    create_table :view_templates do |t|
      t.references :design, :null => false
      t.string :filename, :null => false
      t.text :markup, :null => false
      t.timestamps :null => false
    end

    add_index :view_templates, :design_id
    add_index :view_templates, [:design_id, :filename], :unique => true

  end
end
