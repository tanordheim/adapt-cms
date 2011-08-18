class CreateSiteHosts < ActiveRecord::Migration
  def change

    create_table :site_hosts do |t|
      t.references :site, :null => false
      t.string :hostname, :null => false
      t.boolean :primary, :null => false, :default => false
    end

    add_index :site_hosts, :site_id
    add_index :site_hosts, [:site_id, :hostname], :unique => true

  end
end
