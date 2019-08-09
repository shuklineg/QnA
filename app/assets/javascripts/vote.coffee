$(document).on 'turbolinks:load', ->
  $('.votes').on 'click', (e) ->
    $('#flash_messages').html('')

  $('.votes').on('ajax:success', (e) ->
    vote = e.detail[0]

    $('#' + vote.model + '-' + vote.object_id + ' .votes-count').html vote.value
  ).on('ajax:error', (e) ->
    errors = e.detail[0]

    $.each errors, (_field, array) ->
      $.each array, (_index, value) ->
        $('#flash_messages').append('<div class="flash-alert">' + value + '</div>')
  )