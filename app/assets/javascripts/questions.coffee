$(document).on 'turbolinks:load', ->
  $('.questions, .question').on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    questionId = $(this).data 'questionId' 
    $('form#edit-question-' + questionId).removeClass 'hidden'

App.cable.subscriptions.create 'QuestionsChannel',
  connected: ->
    @perform 'follow'
  ,
  received: (data) ->
    question = JSON.parse(data)
    $('.questions').append JST["templates/question"]( { question: question } )
