class CreateVariantAttributes < ActiveRecord::Migration
  def change

    create_table :variant_attributes do |t|
      t.references :node, :null => false
      t.string :key, :null => false
      t.text :value
    end

    add_index :variant_attributes, :node_id
    add_index :variant_attributes, [:node_id, :key], :unique => true

  end
end
