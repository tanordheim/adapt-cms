class CreateForms < ActiveRecord::Migration
  def change

    create_table :forms do |t|
      t.references :site, :null => false
      t.string :type
      t.string :name, :null => false
      t.string :success_url, :null => false
      t.string :submit_text, :null => false

      # EmailForm attributes.
      t.string :email_address

      t.timestamps :null => false
    end

    add_index :forms, :site_id
    add_index :forms, :type

  end
end
