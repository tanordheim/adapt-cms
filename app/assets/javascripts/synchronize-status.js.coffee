$(document).ready ->

  synchronizeStatus = $('#synchronize-status')

  $('body').ajaxStart ->
    synchronizeStatus.addClass 'visible'

  $('body').ajaxStop ->
    synchronizeStatus.removeClass 'visible'
