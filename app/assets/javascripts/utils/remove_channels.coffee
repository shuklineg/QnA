$(document).on 'turbolinks:before-visit', ->
  for channel in App.channels
    App.cable.subscriptions.remove channel
  App.channels = []
