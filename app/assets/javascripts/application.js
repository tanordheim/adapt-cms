// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require libs/jquery-ui
//= require jquery_ujs
//= require libs/handlebars
//= require libs/json2
//= require libs/underscore
//= require libs/backbone
//= require libs/backbone_router_filter
//= require libs/backbone.modelbinding
//= require libs/fileuploader
//= require libs/strftime
//= require libs/ace/ace
//= require libs/ace/mode-css
//= require libs/ace/mode-javascript
//= require libs/ace/mode-html
//= require libs/ace/mode-textile
//= require libs/ace/theme-eclipse
//= require libs/markitup/jquery.markitup
//= require libs/markitup/sets/default/set
//= require adapt
//= require synchronize-status
//= require fileuploader
//= require helpers
//= require view_helpers
//= require error_handler

// BACKBONE VIEWS:
//= require views/base_view
//= require views/app_view
//= require views/dialog_base_view
//= require views/navigator_base_view
//= require views/navigator_actions_base_view
//= require views/content_view
//= require views/ui/app_navigation
//= require views/ui/site_navigation
//= require views/ui/breadcrumb
//= require views/ui/dialog
//= require views/ui/notice
//= require views/ui/primary_content
//= require views/content/form
//= require views/content/edit_page
//= require views/content/new_page
//= require views/content/show_blog
//= require views/content/edit_blog
//= require views/content/new_blog
//= require views/content/edit_blog_post
//= require views/content/new_blog_post
//= require views/content/edit_link
//= require views/content/new_link
//= require views/content/navigator
//= require views/content/navigator_actions
//= require views/content/overview
//= require views/dashboard/navigator
//= require views/dashboard/overview
//= require views/resources/navigator
//= require views/resources/overview
//= require views/resources/resource
//= require views/resources/edit
//= require views/resources/browse_dialog
//= require views/resources/show_dialog
//= require views/designs/navigator
//= require views/designs/navigator_actions
//= require views/designs/overview
//= require views/designs/form
//= require views/designs/new
//= require views/designs/edit
//= require views/designs/view_templates
//= require views/designs/view_template_form
//= require views/designs/new_view_template
//= require views/designs/edit_view_template
//= require views/designs/include_templates
//= require views/designs/include_template_form
//= require views/designs/new_include_template
//= require views/designs/edit_include_template
//= require views/designs/design_resources
//= require views/designs/edit_design_resource
//= require views/designs/javascripts
//= require views/designs/javascript_form
//= require views/designs/new_javascript
//= require views/designs/edit_javascript
//= require views/designs/stylesheets
//= require views/designs/stylesheet_form
//= require views/designs/new_stylesheet
//= require views/designs/edit_stylesheet
//= require views/admins/change_password

// BACKBONE MODELS:
//= require models/base_model
//= require models/ui_breadcrumb
//= require models/ui_state
//= require models/current_site
//= require models/current_admin
//= require models/node
//= require models/page
//= require models/blog
//= require models/blog_post
//= require models/link
//= require models/variant
//= require models/variant_field
//= require models/page_variant
//= require models/blog_variant
//= require models/blog_post_variant
//= require models/link_variant
//= require models/form
//= require models/resource
//= require models/design
//= require models/view_template
//= require models/include_template
//= require models/design_resource
//= require models/javascript
//= require models/stylesheet
//= require models/activity

// BACKBONE COLLECTIONS:
//= require collections/base_collection
//= require collections/ui_breadcrumbs
//= require collections/nodes
//= require collections/blog_posts
//= require collections/variants
//= require collections/variant_fields
//= require collections/page_variants
//= require collections/blog_variants
//= require collections/blog_post_variants
//= require collections/link_variants
//= require collections/forms
//= require collections/resources
//= require collections/designs
//= require collections/view_templates
//= require collections/include_templates
//= require collections/design_resources
//= require collections/javascripts
//= require collections/stylesheets
//= require collections/activities

// BACKBONE ROUTERS:
//= require routers/base_router
//= require routers/content_router
//= require routers/dashboard_router
//= require routers/resources_router
//= require routers/designs_router

$(document).ready(function() {

  // Unless we're in authentication, start the application.
  if ($('body#authentication').length == 0) {
    if (App.browserIsCompatible()) {
      App.initialize();
    } else {
      $('#browser-not-compatible').show()
    }
  }

});
