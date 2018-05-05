# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editAnswerListener = ->
  editAnswer = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answers').on 'click', '.edit-answer-link', editAnswer

bestAnswerTop = ->
  $('.answers').prepend($('.best-answer'))

$(document).ready(editAnswerListener)
$(document).on('turbolinks:load', editAnswerListener)

$(document).ready(bestAnswerTop)
$(document).on('turbolinks:load', bestAnswerTop)

