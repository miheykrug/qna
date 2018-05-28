$(document).on('turbolinks:load', ->
  questionId = $('.question').data('questionId')

  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,

    received: (data) ->
      if (gon.current_user == null) || (gon.current_user.id != data.comment_user_id)
        resourseContainerId = '#' + data.klass.toLowerCase() + '-' + data.id
        $(resourseContainerId + ' .comments').append(data.partial)
  })
)