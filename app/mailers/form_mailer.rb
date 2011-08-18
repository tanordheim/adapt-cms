class FormMailer < ActionMailer::Base

  default :from => 'form-mailer@adaptapp.com'

  def send_form(form, params)

    @fields = []
    form.fields.each do |field|
      values = values_for_field(field, params)
      @fields << { :name => field.name, :values => values }
    end

    mail(:to => form.email_address, :subject => "Adapt Form Submission: #{form.name}")

  end

  private

  def values_for_field(field, params)

    key = field.id.to_s
    if params[key] && params[key].respond_to?(:to_a)
      params[key].to_a
    else
      [ params[key] ]
    end

  end

end
