$(document).on 'turbolinks:load', ->
  $('.questions, .question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data 'questionId'
    $('form#edit-question-' + questionId).removeClass 'hidden'

  if $('.questions').length
    App.cable.subscriptions.create 'QuestionsChannel',
      connected: ->
        @perform 'follow'
      ,
      received: (data) ->
        $('.questions').append JST["templates/question"]( { question: data.question, links: data.links, files: data.files } )
