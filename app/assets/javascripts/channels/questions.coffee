$(document).on 'turbolinks:load', ->
  if $('.questions').length
    App.cable.subscriptions.create 'QuestionsChannel',
      connected: ->
        @perform 'follow'
      ,
      received: (data) ->
        $('.questions').append JST["templates/question"]( { question: data.question, links: data.links, files: data.files } )
