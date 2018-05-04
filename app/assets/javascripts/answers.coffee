# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

editAnswerListener = ->
  editAnswer = (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.edit-answer-link').click editAnswer

$(document).ready(editAnswerListener) # "вешаем" функцию ready на событие document.ready
$(document).on('turbolinks:load', editAnswerListener)  # "вешаем" функцию ready на событие turbolinks:load
