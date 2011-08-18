class CreateFormFieldOptions < ActiveRecord::Migration
  def change

    create_table :form_field_options do |t|
      t.references :form_field, :null => false
      t.integer :position, :null => false
      t.string :value, :null => false
    end

    add_index :form_field_options, :form_field_id
    add_index :form_field_options, :position
    add_index :form_field_options, [:form_field_id, :value], :unique => true

  end
end
