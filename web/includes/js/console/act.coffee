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
    $('div#middle-pane').scrollTop $('div#middle-pane')[0].scrollHeight
    $('input#entry').focus()

showMessage = (from, text, time, _class) ->
    return if not text?

    time = new Date() if not time?
    time = new Date(time) if not time instanceof Date

    messageElement = $(document.createElement 'div')
    messageElement.addClass('message')
    messageElement.addClass(_class) if not _class?

    text = util.toStaticHTML(text)

    content = '<div>' + text + '</div>'
    messageElement.html(content)

    $('div#middle-pane').append(messageElement)

    scrollDown()


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
    loginWindow = $('div#login-window').data 'kendoWindow'
    loginWindow.close()

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

    validator = $('div#tickets').kendoValidator().data 'kendoValidator'
    return false if not validator.validate()

    nick = $('input#nick').attr 'value'

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

    kendo.ui.progress $('div#loading-cover'), true
    $('div#loading-cover .k-loading-text').text('正在登陆...').css top: 0, left:0
    $.ajax(
        cache: false,
        type: 'POST',
        dataType: 'json',
        url: '/auth/join',
        data: { nick: nick },

        success: (data) ->
            kendo.ui.progress $('div#loading-cover'), false
            onConnect(data)

        error: ->
            kendo.ui.progress $('div#loading-cover'), false
            $('li.status').text '啊呀! 无法连接服务器!'
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
    $('input#entry').keypress (e) ->
        return if e.keyCode isnt 13

        entry = $('#entry');
        msg = entry.attr('value').replace '\n', ''

        # output entry message
        showMessage('', msg, null, 'self-entry');

        entry.attr 'value', ''

        send msg if not util.isBlank(msg)

    ###
    // update the daemon uptime every 10 seconds
    setInterval(function () {
    //todo updateUptime();
    }, 10 * 1000);
    ###

    showConnect()
