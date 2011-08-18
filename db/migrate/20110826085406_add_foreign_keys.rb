class AddForeignKeys < ActiveRecord::Migration
  def change

    # SITE PRIVILEGES
    add_foreign_key :site_privileges, :sites
    add_foreign_key :site_privileges, :admins

    # SITE PRIVILEGE ROLES
    add_foreign_key :site_privilege_roles, :site_privileges

    # SITE HOSTS
    add_foreign_key :site_hosts, :sites

    # DESIGNS
    add_foreign_key :designs, :sites

    # INCLUDE TEMPLATES
    add_foreign_key :include_templates, :designs

    # VIEW TEMPLATES
    add_foreign_key :view_templates, :designs

    # DESIGN RESOURCES
    add_foreign_key :design_resources, :designs

    # STYLESHEETS
    add_foreign_key :stylesheets, :designs

    # JAVASCRIPTS
    add_foreign_key :javascripts, :designs

    # RESOURCES
    add_foreign_key :resources, :sites

    # FORMS
    add_foreign_key :forms, :sites

    # FORM FIELDS
    add_foreign_key :form_fields, :forms

    # FORM FIELD OPTIONS
    add_foreign_key :form_field_options, :form_fields

    # VARIANTS
    add_foreign_key :variants, :sites

    # VARIANT FIELDS
    add_foreign_key :variant_fields, :variants

    # VARIANT FIELD OPTIONS
    add_foreign_key :variant_field_options, :variant_fields

    # VARIANT ATTRIBUTES
    add_foreign_key :variant_attributes, :nodes

    # NODES
    add_foreign_key :nodes, :sites
    add_foreign_key :nodes, :variants
    add_foreign_key :nodes, :admins, :column => 'creator_id'
    add_foreign_key :nodes, :admins, :column => 'updater_id'

  end
end
