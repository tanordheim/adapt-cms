class CreateSitePrivilegeRoles < ActiveRecord::Migration
  def change

    create_table :site_privilege_roles do |t|
      t.references :site_privilege, :null => false
      t.string :role, :null => false
    end

    add_index :site_privilege_roles, [:site_privilege_id, :role], :unique => true

  end
end
