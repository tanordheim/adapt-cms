Adapt::Application.routes.draw do

  root :to => 'nodes#show'

  devise_for :admins
  get '/admin' => 'admin#show'
  get '/admin/*path' => 'admin#show'

  # Ping controller for the LB health check.
  get '/api/ping' => 'api/ping#show'

  # API version 1.
  scope '/api/v1' do

    # Site API. Manages information about the currently loaded site.
    scope '/site' do
      get '/' => 'api/version1/site#show'
      put '/' => 'api/version1/site#update'
    end

    # Admin API. Manages information about the currently authenticated
    # administrator.
    scope '/admin' do
      get '/' => 'api/version1/admin#show'
      put '/' => 'api/version1/admin#update'
    end

    # Activity API. Retrieves activity information for the current site.
    scope '/activities' do
      get '/' => 'api/version1/activities#index'
    end

    # Hosts API. Manages the hosts for the currently loaded site.
    scope '/hosts' do
      get '/' => 'api/version1/hosts#index'
      post '/' => 'api/version1/hosts#create'
      get '/:id' => 'api/version1/hosts#show'
      put '/:id' => 'api/version1/hosts#update'
      delete '/:id' => 'api/version1/hosts#destroy'
    end

    # Nodes API. Manages the nodes for the currently loaded site.
    scope '/nodes' do
      get '/' => 'api/version1/nodes#index'
      post '/:id/position/:position' => 'api/version1/nodes#position'
      delete '/:id' => 'api/version1/nodes#destroy'
    end
    scope '/pages' do
      post '/' => 'api/version1/pages#create'
      get '/:id' => 'api/version1/pages#show'
      put '/:id' => 'api/version1/pages#update'
    end
    scope '/links' do
      post '/' => 'api/version1/links#create'
      get '/:id' => 'api/version1/links#show'
      put '/:id' => 'api/version1/links#update'
    end
    scope '/blogs' do
      post '/' => 'api/version1/blogs#create'

      scope '/:parent_id/posts' do
        get '/' => 'api/version1/blog_posts#index'
        post '/' => 'api/version1/blog_posts#create'
        get '/:id' => 'api/version1/blog_posts#show'
        put '/:id' => 'api/version1/blog_posts#update'
      end
      
      get '/:id' => 'api/version1/blogs#show'
      put '/:id' => 'api/version1/blogs#update'
    end
    
    # Resources API. Manages the resources for the currently loaded site.
    scope '/resources' do
      get '/' => 'api/version1/resources#index'
      post '/' => 'api/version1/resources#create'
      get '/:id' => 'api/version1/resources#show'
      post '/:id' => 'api/version1/resources#update' # TODO - this shouldn't really be here as we use PUT for updates, but the file uploader in use doesn't support PUT out of the box, only POST
      put '/:id' => 'api/version1/resources#update'
      delete '/:id' => 'api/version1/resources#destroy'
    end
    
    # Forms API. Manages the forms for the currently loaded site.
    scope '/forms' do
      get '/' => 'api/version1/forms#index'
      delete '/:id' => 'api/version1/forms#destroy'

      # Form fields API. Manages the fields for any form for the currently
      # loaded site.
      scope '/:form_id/fields' do
        get '/' => 'api/version1/form_fields#index'
        delete '/:id' => 'api/version1/form_fields#destroy'
      end
      scope '/:form_id/text_fields' do
        get '/' => 'api/version1/form_fields/text_fields#index'
        post '/' => 'api/version1/form_fields/text_fields#create'
        get '/:id' => 'api/version1/form_fields/text_fields#show'
        put '/:id' => 'api/version1/form_fields/text_fields#update'
      end
      scope '/:form_id/string_fields' do
        get '/' => 'api/version1/form_fields/string_fields#index'
        post '/' => 'api/version1/form_fields/string_fields#create'
        get '/:id' => 'api/version1/form_fields/string_fields#show'
        put '/:id' => 'api/version1/form_fields/string_fields#update'
      end
      scope '/:form_id/check_box_fields' do
        get '/' => 'api/version1/form_fields/check_box_fields#index'
        post '/' => 'api/version1/form_fields/check_box_fields#create'
        get '/:id' => 'api/version1/form_fields/check_box_fields#show'
        put '/:id' => 'api/version1/form_fields/check_box_fields#update'
      end
      scope '/:form_id/select_fields' do
        get '/' => 'api/version1/form_fields/select_fields#index'
        post '/' => 'api/version1/form_fields/select_fields#create'
        get '/:id' => 'api/version1/form_fields/select_fields#show'
        put '/:id' => 'api/version1/form_fields/select_fields#update'
      end
    end
    scope '/email_forms' do
      get '/' => 'api/version1/email_forms#index'
      post '/' => 'api/version1/email_forms#create'
      get '/:id' => 'api/version1/email_forms#show'
      put '/:id' => 'api/version1/email_forms#update'
    end

    # Designs API. Manages the designs for the currently loaded site.
    scope '/designs' do
      get '/' => 'api/version1/designs#index'
      post '/' => 'api/version1/designs#create'
      get '/:id' => 'api/version1/designs#show'
      put '/:id' => 'api/version1/designs#update'
      delete '/:id' => 'api/version1/designs#destroy'

      # Include templates API. Manages the include templates for any design for
      # the currently loaded site.
      scope '/:design_id/include_templates' do
        get '/' => 'api/version1/include_templates#index'
        post '/' => 'api/version1/include_templates#create'
        get '/:id' => 'api/version1/include_templates#show'
        put '/:id' => 'api/version1/include_templates#update'
        delete '/:id' => 'api/version1/include_templates#destroy'
      end

      # View templates API. Manages the view templates for any design for
      # the currently loaded site.
      scope '/:design_id/view_templates' do
        get '/' => 'api/version1/view_templates#index'
        post '/' => 'api/version1/view_templates#create'
        get '/:id' => 'api/version1/view_templates#show'
        put '/:id' => 'api/version1/view_templates#update'
        delete '/:id' => 'api/version1/view_templates#destroy'
      end

      # Design resources API. Manages the assets for any design for the
      # currently loaded site.
      scope '/:design_id/resources' do
        get '/' => 'api/version1/design_resources#index'
        post '/' => 'api/version1/design_resources#create'
        get '/:id' => 'api/version1/design_resources#show'
        put '/:id' => 'api/version1/design_resources#update'
        post '/:id' => 'api/version1/design_resources#update' # TODO - this shouldn't really be here as we use PUT for updates, but the file uploader in use doesn't support PUT out of the box, only POST
        delete '/:id' => 'api/version1/design_resources#destroy'
      end

      # Stylesheet API. Manages the stylesheets for any design for the currently
      # loaded site.
      scope '/:design_id/stylesheets' do
        get '/' => 'api/version1/stylesheets#index'
        post '/' => 'api/version1/stylesheets#create'
        get '/:id' => 'api/version1/stylesheets#show'
        put '/:id' => 'api/version1/stylesheets#update'
        delete '/:id' => 'api/version1/stylesheets#destroy'
      end

      # Javascript API. Manages the javascript for any design for the currently
      # loaded site.
      scope '/:design_id/javascripts' do
        get '/' => 'api/version1/javascripts#index'
        post '/' => 'api/version1/javascripts#create'
        get '/:id' => 'api/version1/javascripts#show'
        put '/:id' => 'api/version1/javascripts#update'
        delete '/:id' => 'api/version1/javascripts#destroy'
      end
    end
    
    # Variants API. Manages the node variants for the currently loaded site.
    scope '/variants' do
      delete '/:id' => 'api/version1/variants#destroy'

      # Variant fields API. Manages the fields for any variant for the currently
      # loaded site.
      scope '/:variant_id/fields' do
        get '/' => 'api/version1/variant_fields#index'
        delete '/:id' => 'api/version1/variant_fields#destroy'
      end
      scope '/:variant_id/check_box_fields' do
        get '/' => 'api/version1/variant_fields/check_box_fields#index'
        post '/' => 'api/version1/variant_fields/check_box_fields#create'
        get '/:id' => 'api/version1/variant_fields/check_box_fields#show'
        put '/:id' => 'api/version1/variant_fields/check_box_fields#update'
      end
      scope '/:variant_id/form_reference_fields' do
        get '/' => 'api/version1/variant_fields/form_reference_fields#index'
        post '/' => 'api/version1/variant_fields/form_reference_fields#create'
        get '/:id' => 'api/version1/variant_fields/form_reference_fields#show'
        put '/:id' => 'api/version1/variant_fields/form_reference_fields#update'
      end
      scope '/:variant_id/radio_fields' do
        get '/' => 'api/version1/variant_fields/radio_fields#index'
        post '/' => 'api/version1/variant_fields/radio_fields#create'
        get '/:id' => 'api/version1/variant_fields/radio_fields#show'
        put '/:id' => 'api/version1/variant_fields/radio_fields#update'
      end
      scope '/:variant_id/resource_reference_fields' do
        get '/' => 'api/version1/variant_fields/resource_reference_fields#index'
        post '/' => 'api/version1/variant_fields/resource_reference_fields#create'
        get '/:id' => 'api/version1/variant_fields/resource_reference_fields#show'
        put '/:id' => 'api/version1/variant_fields/resource_reference_fields#update'
      end
      scope '/:variant_id/select_fields' do
        get '/' => 'api/version1/variant_fields/select_fields#index'
        post '/' => 'api/version1/variant_fields/select_fields#create'
        get '/:id' => 'api/version1/variant_fields/select_fields#show'
        put '/:id' => 'api/version1/variant_fields/select_fields#update'
      end
      scope '/:variant_id/string_fields' do
        get '/' => 'api/version1/variant_fields/string_fields#index'
        post '/' => 'api/version1/variant_fields/string_fields#create'
        get '/:id' => 'api/version1/variant_fields/string_fields#show'
        put '/:id' => 'api/version1/variant_fields/string_fields#update'
      end
      scope '/:variant_id/text_fields' do
        get '/' => 'api/version1/variant_fields/text_fields#index'
        post '/' => 'api/version1/variant_fields/text_fields#create'
        get '/:id' => 'api/version1/variant_fields/text_fields#show'
        put '/:id' => 'api/version1/variant_fields/text_fields#update'
      end
    end

    scope '/blog_variants' do
      get '/' => 'api/version1/blog_variants#index'
      post '/' => 'api/version1/blog_variants#create'
      get '/:id' => 'api/version1/blog_variants#show'
      put '/:id' => 'api/version1/blog_variants#update'
    end
    scope '/blog_post_variants' do
      get '/' => 'api/version1/blog_post_variants#index'
      post '/' => 'api/version1/blog_post_variants#create'
      get '/:id' => 'api/version1/blog_post_variants#show'
      put '/:id' => 'api/version1/blog_post_variants#update'
    end
    scope '/link_variants' do
      get '/' => 'api/version1/link_variants#index'
      post '/' => 'api/version1/link_variants#create'
      get '/:id' => 'api/version1/link_variants#show'
      put '/:id' => 'api/version1/link_variants#update'
    end
    scope '/page_variants' do
      get '/' => 'api/version1/page_variants#index'
      post '/' => 'api/version1/page_variants#create'
      get '/:id' => 'api/version1/page_variants#show'
      put '/:id' => 'api/version1/page_variants#update'
    end
    
  end

  # Sitemap
  get '/sitemap(.:format)' => 'sitemap#index'

  # Design stylesheets and javascripts
  get '/d/:design_id-:cache_buster/s/*filename' => 'stylesheets#show'
  get '/d/:design_id-:cache_buster/j/*filename' => 'javascripts#show'
  # get '/design/:design_id/stylesheets/*filename' => 'stylesheets#show'
  # get '/design/:design_id/javascripts/*filename' => 'javascripts#show'

  # Form submissions
  post '/forms/:id' => 'forms#post'

  # Catch all route for viewing node content.
  get '*path' => 'nodes#show'

end
