$(document).on 'turbolinks:load', ->
  $('.comments').each ->
    commentsList = this
    commentable = $(commentsList).data 'commentable'
    commentableId = $(commentsList).data 'commentable-id'
    App.cable.subscriptions.create { channel: 'CommentsChannel', id: commentableId, commentable: commentable },
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      if current_user.id != data.comment.user_id
        $(commentsList).append JST["templates/comment"]( { comment: data.comment, user: data.user } )
