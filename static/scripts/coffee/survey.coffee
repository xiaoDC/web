$ = require 'jQuery'

$(document).ready (event) ->
  $('body').on 'click', '.answer', (e) ->
    $(@).find('.icon-tick').addClass 'checked'
    setTimeout ->
      $('#iterateEffects').trigger 'click'
    , 1000