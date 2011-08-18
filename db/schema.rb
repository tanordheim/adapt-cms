# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110905085359) do

  create_table "activities", :force => true do |t|
    t.integer  "site_id",                    :null => false
    t.integer  "parent_id"
    t.integer  "author_id",                  :null => false
    t.integer  "source_id",                  :null => false
    t.string   "source_type",                :null => false
    t.string   "source_name",                :null => false
    t.string   "action",                     :null => false
    t.integer  "count",       :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "activities", ["site_id"], :name => "index_activities_on_site_id"
  add_index "activities", ["source_id", "source_type"], :name => "index_activities_on_source_id_and_source_type"

  create_table "admins", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                                                  :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "admins", ["email"], :name => "index_admins_on_email", :unique => true
  add_index "admins", ["reset_password_token"], :name => "index_admins_on_reset_password_token", :unique => true

  create_table "design_resources", :force => true do |t|
    t.integer  "design_id",    :null => false
    t.string   "file",         :null => false
    t.string   "filename",     :null => false
    t.string   "content_type", :null => false
    t.integer  "file_size",    :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "design_resources", ["design_id", "filename"], :name => "index_design_resources_on_design_id_and_filename", :unique => true
  add_index "design_resources", ["design_id"], :name => "index_design_resources_on_design_id"

  create_table "designs", :force => true do |t|
    t.integer  "site_id",                       :null => false
    t.boolean  "default",    :default => false, :null => false
    t.string   "name",                          :null => false
    t.text     "markup",                        :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "designs", ["default"], :name => "index_designs_on_default"
  add_index "designs", ["site_id"], :name => "index_designs_on_site_id"

  create_table "form_field_options", :force => true do |t|
    t.integer "form_field_id", :null => false
    t.integer "position",      :null => false
    t.string  "value",         :null => false
  end

  add_index "form_field_options", ["form_field_id", "value"], :name => "index_form_field_options_on_form_field_id_and_value", :unique => true
  add_index "form_field_options", ["form_field_id"], :name => "index_form_field_options_on_form_field_id"
  add_index "form_field_options", ["position"], :name => "index_form_field_options_on_position"

  create_table "form_fields", :force => true do |t|
    t.integer "form_id",                         :null => false
    t.integer "position",                        :null => false
    t.string  "type"
    t.string  "name",                            :null => false
    t.text    "default_text"
    t.boolean "required",     :default => false, :null => false
  end

  add_index "form_fields", ["form_id"], :name => "index_form_fields_on_form_id"
  add_index "form_fields", ["position"], :name => "index_form_fields_on_position"
  add_index "form_fields", ["type"], :name => "index_form_fields_on_type"

  create_table "forms", :force => true do |t|
    t.integer  "site_id",       :null => false
    t.string   "type"
    t.string   "name",          :null => false
    t.string   "success_url",   :null => false
    t.string   "submit_text",   :null => false
    t.string   "email_address"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "forms", ["site_id"], :name => "index_forms_on_site_id"
  add_index "forms", ["type"], :name => "index_forms_on_type"

  create_table "include_templates", :force => true do |t|
    t.integer  "design_id",  :null => false
    t.string   "filename",   :null => false
    t.text     "markup",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "include_templates", ["design_id", "filename"], :name => "index_include_templates_on_design_id_and_filename", :unique => true
  add_index "include_templates", ["design_id"], :name => "index_include_templates_on_design_id"

  create_table "javascripts", :force => true do |t|
    t.integer  "design_id",                       :null => false
    t.string   "processor",  :default => "plain", :null => false
    t.string   "filename",                        :null => false
    t.text     "data",                            :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "javascripts", ["design_id", "filename"], :name => "index_javascripts_on_design_id_and_filename", :unique => true
  add_index "javascripts", ["design_id"], :name => "index_javascripts_on_design_id"

  create_table "nodes", :force => true do |t|
    t.integer  "site_id",                              :null => false
    t.string   "type"
    t.string   "ancestry"
    t.integer  "position",                             :null => false
    t.string   "slug",                                 :null => false
    t.string   "uri",                                  :null => false
    t.boolean  "published",          :default => true, :null => false
    t.date     "published_on"
    t.boolean  "show_in_navigation", :default => true, :null => false
    t.integer  "variant_id"
    t.string   "name",                                 :null => false
    t.string   "href"
    t.integer  "creator_id",                           :null => false
    t.integer  "updater_id",                           :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "nodes", ["position"], :name => "index_nodes_on_position"
  add_index "nodes", ["published"], :name => "index_nodes_on_published"
  add_index "nodes", ["show_in_navigation"], :name => "index_nodes_on_show_in_navigation"
  add_index "nodes", ["site_id", "ancestry"], :name => "index_nodes_on_site_id_and_ancestry"
  add_index "nodes", ["site_id", "uri"], :name => "index_nodes_on_site_id_and_uri", :unique => true
  add_index "nodes", ["site_id"], :name => "index_nodes_on_site_id"
  add_index "nodes", ["type"], :name => "index_nodes_on_type"
  add_index "nodes", ["variant_id"], :name => "index_nodes_on_variant_id"

  create_table "resources", :force => true do |t|
    t.integer  "site_id",      :null => false
    t.string   "file",         :null => false
    t.string   "filename",     :null => false
    t.string   "content_type", :null => false
    t.integer  "file_size",    :null => false
    t.integer  "creator_id",   :null => false
    t.integer  "updater_id",   :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "resources", ["site_id"], :name => "index_resources_on_site_id"

  create_table "site_hosts", :force => true do |t|
    t.integer "site_id",                     :null => false
    t.string  "hostname",                    :null => false
    t.boolean "primary",  :default => false, :null => false
  end

  add_index "site_hosts", ["site_id", "hostname"], :name => "index_site_hosts_on_site_id_and_hostname", :unique => true
  add_index "site_hosts", ["site_id"], :name => "index_site_hosts_on_site_id"

  create_table "site_privilege_roles", :force => true do |t|
    t.integer "site_privilege_id", :null => false
    t.string  "role",              :null => false
  end

  add_index "site_privilege_roles", ["site_privilege_id", "role"], :name => "index_site_privilege_roles_on_site_privilege_id_and_role", :unique => true

  create_table "site_privileges", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.integer  "admin_id",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "site_privileges", ["site_id", "admin_id"], :name => "index_site_privileges_on_site_id_and_admin_id", :unique => true

  create_table "sites", :force => true do |t|
    t.string   "subdomain",                           :null => false
    t.string   "name",                                :null => false
    t.string   "locale",           :default => "en",  :null => false
    t.boolean  "maintenance_mode", :default => false, :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "sites", ["subdomain"], :name => "index_sites_on_subdomain", :unique => true

  create_table "stylesheets", :force => true do |t|
    t.integer  "design_id",                       :null => false
    t.string   "processor",  :default => "plain", :null => false
    t.string   "filename",                        :null => false
    t.text     "data",                            :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "stylesheets", ["design_id", "filename"], :name => "index_stylesheets_on_design_id_and_filename", :unique => true
  add_index "stylesheets", ["design_id"], :name => "index_stylesheets_on_design_id"

  create_table "variant_attributes", :force => true do |t|
    t.integer "node_id", :null => false
    t.string  "key",     :null => false
    t.text    "value"
  end

  add_index "variant_attributes", ["node_id", "key"], :name => "index_variant_attributes_on_node_id_and_key", :unique => true
  add_index "variant_attributes", ["node_id"], :name => "index_variant_attributes_on_node_id"

  create_table "variant_field_options", :force => true do |t|
    t.integer "variant_field_id", :null => false
    t.integer "position",         :null => false
    t.string  "value",            :null => false
  end

  add_index "variant_field_options", ["position"], :name => "index_variant_field_options_on_position"
  add_index "variant_field_options", ["variant_field_id", "value"], :name => "index_variant_field_options_on_variant_field_id_and_value", :unique => true
  add_index "variant_field_options", ["variant_field_id"], :name => "index_variant_field_options_on_variant_field_id"

  create_table "variant_fields", :force => true do |t|
    t.integer "variant_id",                    :null => false
    t.string  "type"
    t.integer "position",                      :null => false
    t.string  "key",                           :null => false
    t.string  "name",                          :null => false
    t.boolean "required",   :default => false, :null => false
  end

  add_index "variant_fields", ["position"], :name => "index_variant_fields_on_position"
  add_index "variant_fields", ["type"], :name => "index_variant_fields_on_type"
  add_index "variant_fields", ["variant_id", "key"], :name => "index_variant_fields_on_variant_id_and_key", :unique => true
  add_index "variant_fields", ["variant_id"], :name => "index_variant_fields_on_variant_id"

  create_table "variants", :force => true do |t|
    t.integer  "site_id",    :null => false
    t.string   "node_type",  :null => false
    t.integer  "position",   :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "variants", ["node_type"], :name => "index_variants_on_node_type"
  add_index "variants", ["position"], :name => "index_variants_on_position"
  add_index "variants", ["site_id"], :name => "index_variants_on_site_id"

  create_table "view_templates", :force => true do |t|
    t.integer  "design_id",  :null => false
    t.string   "filename",   :null => false
    t.text     "markup",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "view_templates", ["design_id", "filename"], :name => "index_view_templates_on_design_id_and_filename", :unique => true
  add_index "view_templates", ["design_id"], :name => "index_view_templates_on_design_id"

  add_foreign_key "activities", "admins", :name => "activities_author_id_fk", :column => "author_id"
  add_foreign_key "activities", "sites", :name => "activities_site_id_fk"

  add_foreign_key "design_resources", "designs", :name => "design_resources_design_id_fk"

  add_foreign_key "designs", "sites", :name => "designs_site_id_fk"

  add_foreign_key "form_field_options", "form_fields", :name => "form_field_options_form_field_id_fk"

  add_foreign_key "form_fields", "forms", :name => "form_fields_form_id_fk"

  add_foreign_key "forms", "sites", :name => "forms_site_id_fk"

  add_foreign_key "include_templates", "designs", :name => "include_templates_design_id_fk"

  add_foreign_key "javascripts", "designs", :name => "javascripts_design_id_fk"

  add_foreign_key "nodes", "admins", :name => "nodes_creator_id_fk", :column => "creator_id"
  add_foreign_key "nodes", "admins", :name => "nodes_updater_id_fk", :column => "updater_id"
  add_foreign_key "nodes", "sites", :name => "nodes_site_id_fk"
  add_foreign_key "nodes", "variants", :name => "nodes_variant_id_fk"

  add_foreign_key "resources", "sites", :name => "resources_site_id_fk"

  add_foreign_key "site_hosts", "sites", :name => "site_hosts_site_id_fk"

  add_foreign_key "site_privilege_roles", "site_privileges", :name => "site_privilege_roles_site_privilege_id_fk"

  add_foreign_key "site_privileges", "admins", :name => "site_privileges_admin_id_fk"
  add_foreign_key "site_privileges", "sites", :name => "site_privileges_site_id_fk"

  add_foreign_key "stylesheets", "designs", :name => "stylesheets_design_id_fk"

  add_foreign_key "variant_attributes", "nodes", :name => "variant_attributes_node_id_fk"

  add_foreign_key "variant_field_options", "variant_fields", :name => "variant_field_options_variant_field_id_fk"

  add_foreign_key "variant_fields", "variants", :name => "variant_fields_variant_id_fk"

  add_foreign_key "variants", "sites", :name => "variants_site_id_fk"

  add_foreign_key "view_templates", "designs", :name => "view_templates_design_id_fk"

end
