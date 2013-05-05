# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-4
# Time: 下午4:20

SESSION_TIMEOUT = 60 * 1000


module.exports = class Session
    sessions = {}

    constructor: ->
        setInterval ->
            now = new Date()
            for id in sessions
                continue if !sessions.hasOwnProperty(id)
                session = session[id]

                session.destroy() if now - session.timestamp > SESSION_TIMEOUT
        , 1000

        console.info 'initialized session'


    createSession: (nick) ->

        for session in sessions
            return null if session and session.nick is nick

        session = {
            nick: nick,
            id: Math.floor(Math.random() * 99999999999).toString(),
            timestamp: new Date()

            poke: -> session.time = new Data()

            destroy: ->
                #todo add msg channel.appendMessage(session.nick, 'part')
                delete sessions[session.id]

        }

        sessions[session.id] = session

        return session

