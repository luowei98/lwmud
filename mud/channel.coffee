# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-28
# Time: 下午1:23

MESSAGE_BACKLOG = 200

module.exports = class Channel
    messages = []
    callbacks = []

    constructor: (@session) ->
        setInterval ->
            now = new Date()
            while callbacks.length > 0 and now - callbacks[0].timestamp > 30 * 1000
                callbacks.shift().callback([])
        , 3000

    appendMessage: (type, text, sendto) ->
        if sendto?
            m = {
                sendto: sendto,
                type: type,
                text: text,
                timestamp: new Date().getTime()
            }
            messages.push(m)
        else
            for usename in @session.usernames()
                m = {
                    sendto: usename,
                    type: type,
                    text: text,
                    timestamp: new Date().getTime()
                }
                messages.push(m)

        while callbacks.length > 0
            callbacks.shift().callback([m])

        while messages.length > MESSAGE_BACKLOG
            messages.shift()


    query: (username, since, callback) ->
        matching = []

        for message in messages
            matching.push(message) if message.timestamp > since and message.sendto is username

        if matching.length isnt 0
            callback(matching)
        else
            callbacks.push(timestamp: new Date(), callback: callback)

