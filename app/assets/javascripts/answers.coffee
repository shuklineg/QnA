$(document).on 'turbolinks:load', ->
  $('.answers').on 'click', '.edit-answer-link', (e) ->
    e.preventDefault()
    $(this).hide()
    answerId = $(this).data 'answerId'
    $('form#edit-answer-' + answerId).removeClass 'hidden'

  $('.votes').on 'click', (e) ->
    $('#notice').html('')

  $('.votes').on('ajax:success', (e) ->
    vote = e.detail[0]

    $('#' + vote.model + '-' + vote.object_id + ' .votes-count').html vote.value
  ).on('ajax:error', (e) ->
    errors = e.detail[0]

    $.each errors, (_field, array) ->
      $.each array, (_index, value) ->
        $('#notice').append '<p>' + value + '</p>'
  )

  $('.question').each ->
    questionId = $(this).data 'questionId'
    if questionId
      App.cable.subscriptions.create { channel: 'AnswersChannel', id: questionId },
      connected: ->
        @perform 'follow'
      ,
      received: (data) ->
        $('.answers').append JST["templates/answer"]( { answer: data.answer, links: data.links, files: data.files } )
