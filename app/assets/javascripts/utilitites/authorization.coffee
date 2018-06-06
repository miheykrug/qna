$(document).on('turbolinks:load', ->
  $(document).bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail;
    switch (xhr.status)
      when 403
        $('p.alert').html('You are not authorized to access this page.')
      when 401
        $('p.alert').html('You need to sign in or sign up before continuing.')
)
