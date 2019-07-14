$(document).on 'turbolinks:load', ->
  questionId = $('.question').data 'questionId'
  if questionId
    App.cable.subscriptions.create { channel: 'AnswersChannel', id: questionId },
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      if current_user.id != data.answer.user_id
        $('.answers').append JST["templates/answer"]( { answer: data.answer, links: data.links, files: data.files } )
