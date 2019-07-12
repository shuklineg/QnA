class User
  constructor: (@id) ->
  author_of: (resource) ->
    resource && @id && @id == resource.user_id



window.current_user = new User(gon.user_id)
