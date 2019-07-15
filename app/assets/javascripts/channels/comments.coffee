$(document).on 'turbolinks:load', ->
  questionId = $('.question').data 'questionId'
  if questionId
    App.cable.subscriptions.create { channel: 'CommentsChannel', questionId: questionId },
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      if current_user.id != data.comment.user_id
        commentableType = data.comment.commentable_type.toLowerCase() 
        commentableId = data.comment.commentable_id
        commentsList = $('#' + commentableType + '-' + commentableId + '  .comments')
        $(commentsList).append JST["templates/comment"]( { comment: data.comment, user: data.user } )
