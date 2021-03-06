# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 下午4:44


util = new Util()

CONFIG = {
    nick: '#',
    id: null,
    last_message_time: 1,
    focus: true,
    unread: 0
}

scrollDown = ->
    $('#middle-pane').scrollTop $('#middle-pane')[0].scrollHeight
    $('#entry').focus()

showMessage = (from, text, time, _class) ->
    return if not text?

    time = new Date() if not time?
    time = new Date(time) if not time instanceof Date

    messageElement = $(document.createElement 'div')
    messageElement.addClass('message')
    messageElement.addClass(_class) if _class?

    text = util.toStaticHTML(text)

    content = '<div>' + text + '</div>'
    messageElement.html(content)

    $('#middle-pane').append(messageElement)

    scrollDown()

refleshUser = (users) ->
    users = [users] unless util.typeIsArray users

    $('#online-text').text('当前用户 (' + users.length + ')')
    for username in users
        continue if not username?
        panelBar = $('#online-users').kendoPanelBar().data('kendoPanelBar')
        panelBar.append '<li>' + username + '</li>'
    panelBar._updateClasses()

transmission_errors = 0
longPoll = (data) ->
    if transmission_errors > 2
        showConnect()
        transmission_errors = 0
        return

    #if (data? and data.time)

    if data? and data.messages

        for message in data.messages
            CONFIG.last_message_time = message.timestamp
            showMessage message.nick, message.text, message.timestamp

            switch message.type
                when 'msg'
                    CONFIG.unread++ if not CONFIG.focus
                when 'join'
                    # todo sth
                    alert 'a'
                when 'part'
                    alert 'b'
                when 'status'
                    # todo update both sidebar
                    alert 'c'
                when 'users'
                    if message? and message.text?
                        refleshUser(message.text)
                else
                    alert 'd'

        # todo updateTitle

    $.ajax(
        cache: false,
        type: 'GET',
        url: '/console/recv',
        dataType: 'json'
        data: { since: CONFIG.last_message_time, id: CONFIG.id },

        error: ->
            showMessage '', '无法连接服务器', new Date(), 'error'
            transmission_errors++
            # don't flood the servers on error, wait 10 seconds before retrying
            setTimeout longPoll, 10 * 1000

        success: (data) ->
            transmission_errors = 0
            # todo update time
            longPoll(data)
    )

#handle the server's response to our nickname and join request
onConnect = (session) ->
    # todo session check

    CONFIG.nick = session.nick
    CONFIG.id   = session.id
    CONFIG.last_message_time = session.starttime

    # close login window
    loginWindow = $('#login-window').data 'kendoWindow'
    loginWindow.close()

    $('#entry').focus()

    $(window).bind 'blur', ->
        CONFIG.focus = false
        # todo updateTitle();

    $(window).bind 'focus', ->
        CONFIG.focus = true
        CONFIG.unread = 0
        # todo updateTitle();

    longPoll()

# login-button click event
@login = ->
    $('li.status').text ''

    validator = $('#tickets').kendoValidator().data 'kendoValidator'
    return false if not validator.validate()

    username = $('#nick').val()
    password = $('#pwd').val()

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

    kendo.ui.progress $('#loading-cover'), true
    $('div#loading-cover .k-loading-text').text('正在登陆...').css top: 0, left:0
    $.ajax(
        cache: false,
        type: 'POST',
        dataType: 'json',
        url: '/consoleLogin',
        data: { username: username, password: password },

        success: (data) ->
            kendo.ui.progress $('#loading-cover'), false
            onConnect(data)

        error: (xhr) ->
            kendo.ui.progress $('#loading-cover'), false
            data = jQuery.parseJSON(xhr.responseText)
            if data and data.message
                $('li.status').text data.message
            else
                $('li.status').text '啊呀~ 连接服务器出错了！'
    )

send = (msg) ->
    # XXX should add to messages immediately
    $.post(
        "/console/send",
        {id: CONFIG.id, text: msg},
        (data) ->
            CONFIG.last_message_time = data
        "json"
    )

$ ->

    # send message in entry box
    $('#entry').keypress (e) ->
        return if e.keyCode isnt 13

        entry = $('#entry');
        msg = entry.attr('value').replace '\n', ''

        # output entry message
        showMessage('', msg, null, 'self-text-color');

        entry.attr 'value', ''

        send msg if not util.isBlank(msg)

    ###
    // update the daemon uptime every 10 seconds
    setInterval(function () {
    //todo updateUptime();
    }, 10 * 1000);
    ###

    if window.needlogin is false
        showConnect()
    else
        onConnect(window.needlogin)

