App.Helpers.numberToHumanSize = (bytes) ->
  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  return 'N/A' if bytes == 0
  i = parseInt(Math.floor(Math.log(bytes) / Math.log(1024)))
  Math.round(bytes / Math.pow(1024, i), 2) + ' ' + sizes[i]

App.Helpers.formatTimestamp = (timestampString) ->
  timestamp = new Date(timestampString)
  timestamp.strftime('%b %d, %H:%M')

App.Helpers.formatDate = (dateString) ->
  date = new Date(dateString)
  date.strftime('%b %d %Y')
