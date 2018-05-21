# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  editQuestion = (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit-question-form').show()

  $('.edit-question-link').click editQuestion

  questionsList = $('.questions-list')
  App.cable.subscriptions.create('QuestionsChannel', {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      questionsList.append(data)
  })
)
