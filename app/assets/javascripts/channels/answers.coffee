$(document).on('turbolinks:load', ->
  answersList = $('.answers')

  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      if (gon.current_user.id != data.answer.user_id)
        $(".answers").append(JST["templates/answer"](data));

        $('.vote .up-down').bind 'ajax:success', (e) ->
          [data, status, xhr] = e.detail;
          voteContainerClass = '.' + data.klass + '-' + data.id
          console.log(voteContainerClass)
          $(voteContainerClass + ' .rating').html(data.rating)
          $(voteContainerClass + ' .cancel-link').removeClass('hide-cancel-link')

        $('.vote .cancel-link').bind 'ajax:success', (e) ->
          [data, status, xhr] = e.detail;
          voteContainerClass = '.' + data.klass + '-' + data.id
          $(voteContainerClass + ' .rating').html(data.rating)
          $(voteContainerClass + ' .cancel-link').addClass('hide-cancel-link')
  })
)