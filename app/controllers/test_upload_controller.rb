class TestUploadController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def create
    render :text => '{success: true}'
  end

end
