class App.Views.UI.SiteNavigation extends App.Backbone.BaseView

  el: '#site-nav'

  events:
    'click #change-password a': 'showChangePasswordDialog'

  showChangePasswordDialog: =>
    dialogView = new App.Views.Admins.ChangePassword model: @model
    @showDialog 'Change password', dialogView
