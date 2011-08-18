class App.Views.Admins.ChangePassword extends App.Backbone.BaseView

  events:
    'submit form': 'changePassword'

  initialize: ->
    @preloadTemplate 'admins/change-password'

  render: =>
    @renderTemplate 'admins/change-password'
    Backbone.ModelBinding.bind(@, { all: 'name' })
    @

  changePassword: =>

    password = @model.get 'password'
    passwordConfirmation = @model.get 'password_confirmation'

    if !password? || password == ''
      alert "You must enter a new password"
    else if password != passwordConfirmation
      alert "The passwords does not match"
    else
      @model.save {}, success: =>
        @showNotice 'Your password was successfully changed'
        @hideDialog()

    false
