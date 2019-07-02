$(document).on('turbolinks:load', function() {
  $('.answers').on('click', '.edit-answer-link', function(e) {
    e.preventDefault()
    $(this).hide();
    var answerId = $(this).data('answerId')
    $('form#edit-answer-' + answerId).removeClass('hidden')
  })

  $('.votes').on('ajax:success', function(e) {
    var vote = e.detail[0]

    $('#' + vote.model + '-' + vote.object_id + ' .votes-count').html(vote.value)
  })
})
