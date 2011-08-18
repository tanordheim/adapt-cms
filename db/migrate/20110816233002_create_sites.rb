# encoding: utf-8

class CreateSites < ActiveRecord::Migration
  def change

    create_table :sites do |t|
      t.string :subdomain, :null => false
      t.string :name, :null => false
      t.string :locale, :null => false, :default => 'en', :length => 2
      t.boolean :maintenance_mode, :null => false, :default => false
      t.timestamps :null => false
    end

    add_index :sites, :subdomain, :unique => true

  end
end
