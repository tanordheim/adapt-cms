class Api::Version1::AdminController < Api::Version1::ApiController #:nodoc

  # Overridden update action. This updates the current administrator and signs
  # them in again in case they changed their password to avoid the administrator
  # becoming logged out after a password change. It follows the same behaviour
  # as the super-method otherwise.
  def update

    record_author(:updater)

    if resource.update_attributes(filtered_params(resource))
      sign_in(current_admin, :bypass => true)
      respond_with(resource) do |format|
        format.json { render :json => resource_as_json }
      end
    else
      respond_with(resource.errors, :status => 422) do |format|
        format.json { render :json => resource.errors.to_json(error_collection_serialization_options), :status => 422 }
      end
    end

  end

  private

  # Returns the serialization options to use for admin objects. This filters out
  # the created_at, updated_at, current_sign_in_at, current_sign_in_ip,
  # encrypted_password, last_sign_in_at, last_sign_in_ip, remember_created_at,
  # reset_password_sent_at, reset_password_token and sign_in_count columns.
  #
  # @returns [ Hash ] Hash of serialization options.
  def object_serialization_options
    {:except => [
      :created_at, :updated_at, :current_sign_in_at, :current_sign_in_ip,
      :encrypted_password, :last_sign_in_at, :last_sign_in_ip,
      :remember_created_at, :reset_password_sent_at, :reset_password_token,
      :sign_in_count
    ]}
  end
  
  # Load the resource for this request. In the Admin controller, this returns
  # the currently authenticated administrator.
  #
  # @return [ Admin ] The currently authenticated administrator.
  def load_resource
    current_admin
  end
  
end
