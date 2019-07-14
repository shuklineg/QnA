$(document).on 'turbolinks:load', ->
  $('.add-comment-link').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    commentable = $(this).data 'commentable'
    $('form#comment-form-' + commentable).removeClass 'hidden'
