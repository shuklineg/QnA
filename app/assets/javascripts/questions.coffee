$(document).on 'turbolinks:load', ->
  $('.questions, .question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data 'questionId'
    $('form#edit-question-' + questionId).removeClass 'hidden'
