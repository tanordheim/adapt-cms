class CreateFormFields < ActiveRecord::Migration
  def change

    create_table :form_fields do |t|
      t.references :form, :null => false
      t.integer :position, :null => false
      t.string :type
      t.string :name, :null => false
      t.text :default_text
      t.boolean :required, :null => false, :default => false
    end

    add_index :form_fields, :form_id
    add_index :form_fields, :position
    add_index :form_fields, :type

  end
end
