# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-9
# Time: 下午5:23

CONNECTION_TIMEOUT = 5 * 60 * 1000

userdb = require './models/user'

module.exports = class Connections
    users = {}

    constructor: ->
        userdb.createDefault (err, newuser) ->
            if err
                console.log err
            else
                console.info 'create default user: ' + newuser.username

        setInterval ->
            now = new Date()
            for _, user of users
                user.dead() if now - user.timestamp > CONNECTION_TIMEOUT
        , 1000

    add: (comingUser) ->
        for _, user of users
            return null if user and user.username is comingUser.username

        comingUser.connected()
        users[comingUser.id] = comingUser

        return comingUser