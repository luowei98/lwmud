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


    sessions: () ->
        return sessions

    createSession: (username) ->

        for _, session of sessions
            return null if session and session.username is username

        session = {
            username: username,
            id: Math.floor(Math.random() * 99999999999).toString(),
            timestamp: new Date()

            poke: -> session.timestamp = new Date()

            destroy: ->
                #todo add msg channel.appendMessage(session.username, 'part')
                delete sessions[session.id]

        }

        sessions[session.id] = session

        return session

    findSession: (username) ->

        for _, session of sessions
            return session if session.username is username

        return null

    usernames: (except) ->
        names = []
        for _, session of sessions
            names.push session.username unless session.username is except
        return names
