class CreateVariantFields < ActiveRecord::Migration
  def change

    create_table :variant_fields do |t|
      t.references :variant, :null => false
      t.string :type
      t.integer :position, :null => false
      t.string :key, :null => false
      t.string :name, :null => false
      t.boolean :required, :null => false, :default => false
    end

    add_index :variant_fields, :variant_id
    add_index :variant_fields, :type
    add_index :variant_fields, :position
    add_index :variant_fields, [:variant_id, :key], :unique => true

  end
end
