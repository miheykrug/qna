# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  addComment = (e) ->
    e.preventDefault();
    $(this).hide();
    klass = $(this).data('klass')
    id = $(this).data('id')
    $('form#comment' + '-' + klass + '-' + id).show()

  $(document).on 'click', '.add-comment-link', addComment

  $('.add-comment-form').bind 'ajax:success', (e) ->
    [data, status, xhr] = e.detail;
    resourseContainerId = '#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id
    $(resourseContainerId + ' .comments').append('<div><p><b>' + data.user_email + '</b></p><p>' + data.comment.body + '</p></div>')
    $('form:first-child', this).hide()
    $('form:first-child #comment_body', this).val('')
    $('.add-comment-link').show()
  .bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail;
    $.each data, (index, value) ->
      $('.new-comment-errors').append(value)
)
