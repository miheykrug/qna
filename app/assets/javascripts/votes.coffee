voteListener = ->
  $('.vote .up-down').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail;
    voteContainerClass = '.' + data.klass + '-' + data.id
    $(voteContainerClass + ' .rating').html(data.rating)
    $(voteContainerClass + ' .cancel-link').removeClass('hide-cancel-link')

  $('.vote .cancel-link').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail;
    voteContainerClass = '.' + data.klass + '-' + data.id
    $(voteContainerClass + ' .rating').html(data.rating)
    $(voteContainerClass + ' .cancel-link').addClass('hide-cancel-link')



$(document).ready(voteListener)
$(document).on('turbolinks:load', voteListener)
