# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  $('.search-form').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail;
    $('.results').html('')
    console.log(data)
    jQuery.each data, (i, val) ->
      $('.results').append("<div class='result-" + i + "'></div>")
      jQuery.each val, (k, v) ->
        $('.results .result-' + i).append(k + ': ' + v + '; ');
)