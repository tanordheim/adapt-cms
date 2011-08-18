class CreateSitePrivileges < ActiveRecord::Migration
  def change

    create_table :site_privileges do |t|
      t.references :site, :null => false
      t.references :admin, :null => false
      t.timestamps :null => false
    end

    add_index :site_privileges, [:site_id, :admin_id], :unique => true

  end
end
