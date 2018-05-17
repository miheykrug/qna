# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
editQuestionListener = ->
  editQuestion = (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show()

  $('.edit-question-link').click editQuestion

$(document).on('turbolinks:load', editQuestionListener)  # "вешаем" функцию ready на событие turbolinks:load