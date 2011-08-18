class App.Models.UIState extends App.Backbone.BaseModel

  defaults:
    currentSection: ''
    contentView: ''
    notice: ''

  setSection: (sectionId) ->
    if @get('currentSection') != sectionId
      @set currentSection: sectionId

  setContentView: (contentView) ->
    @set contentView: contentView

  setNotice: (notice) ->

    # We always want to trigger a change event when setting the notice, even
    # though its the same notice. To fix this, just clear the string before
    # setting the actual notice. The listening views will take care of not doing
    # stuff with empty strings.
    #
    # TODO - Room for improvement.
    @set notice: ''
    @set notice: notice
