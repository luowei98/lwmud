# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-28
# Time: 下午1:23

MESSAGE_BACKLOG = 200

module.exports = class Channel
    messages = []
    callbacks = []

    constructor: ->
        setInterval ->
            now = new Date()
            while callbacks.length > 0 and now - callbacks[0].timestamp > 30 * 1000
                callbacks.shift().callback([])
        , 3000

    appendMessage: (nick, type, text) ->
        m = {
            nick: nick,
            type: type,
            text: text,
            timestamp: new Date().getTime()
        }

        messages.push(m)

        while callbacks.length > 0
            callbacks.shift().callback([m])

        while messages.length > MESSAGE_BACKLOG
            messages.shift()

    query: (since, callback) ->
        matching = []

        for message in messages
            matching.push(message) if message.timestamp > since

        if matching.length isnt 0
            callback(matching)
        else
            callbacks.push(timestamp: new Date(), callback: callback)

