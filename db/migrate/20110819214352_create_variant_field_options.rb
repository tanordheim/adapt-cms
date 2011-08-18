class CreateVariantFieldOptions < ActiveRecord::Migration
  def change

    create_table :variant_field_options do |t|
      t.references :variant_field, :null => false
      t.integer :position, :null => false
      t.string :value, :null => false
    end

    add_index :variant_field_options, :variant_field_id
    add_index :variant_field_options, :position
    add_index :variant_field_options, [:variant_field_id, :value], :unique => true

  end
end
