class FormsController < ApplicationController

  expose(:form) { Site.current.forms.find(params[:id]) }

  def post
    FormMailer.send_form(form, params).deliver
    redirect_to form.success_url
  end
  
end
