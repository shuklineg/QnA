$(document).on 'turbolinks:load', ->
  $('.questions-wrapper').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).parents('.question-view-port').hide()
    questionId = $(this).data 'questionId'
    $('form#edit-question-' + questionId).removeClass 'hidden'
