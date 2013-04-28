# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 下午4:44


# login-button click event
@login = ->

  validator = $('#tickets').kendoValidator().data 'kendoValidator'
  return false if not validator.validate()

  nick = $('#nick').attr 'value'

  # todo showLoad(), lock the UI while waiting for a response

  # todo easy validations
  ###
  //don't bother the backend if we fail easy validations
  if (nick.length > 50) {
  alert('Nick too long. 50 character max.');
  showConnect();
  return false;
  }

  //more validations
  if (/[^\w_\-^!]/.exec(nick)) {
  alert("Bad character in nick. Can only have letters, numbers, and '_', '-', '^', '!'");
  showConnect();
  return false;
  }
  ###

  $.ajax(
    cache: false,
    type: 'POST',
    dataType: 'json',
    url: '/auth/join',
    data: { nick: nick },

    error: ->
      alert 'error connection to server'

    success: ->
      # todo check session.error
      # todo set CONFIG, update uptime
      loginWindow = $('#login-window').data 'kendoWindow'
      loginWindow.close()

      # todo window blur & focus event

      # todo update both sidebar

      # todo update client time

      # todo longPoll!
  )


$ ->

  # send message in entry box
  $('#entry').keypress (e) ->
    return if e.keyCode isnt 13

    entry = $('#entry');
    msg = entry.attr('value').replace '\n', ''

    # todo output entry message
    # addMessage('', msg, null, 'self-entry');

    entry.attr 'value', ''

    send msg if not new Util().isBlank(msg)

  ###
  // update the daemon uptime every 10 seconds
  setInterval(function () {
    //todo updateUptime();
  }, 10 * 1000);
  ###

  showConnect()
