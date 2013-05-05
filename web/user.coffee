# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-4
# Time: 下午7:30

module.exports = class User
    users = [
        { id: 1, username: 'bob', password: 'secret', email: 'bob@example.com' },
        { id: 2, username: 'joe', password: 'birthday', email: 'joe@example.com' }
    ]

    constructor: ->
        console.info 'initialized user'


    @findById: (id, fn) ->
        idx = id - 1
        if users[idx]?
            fn(null, users[idx])
        else
            fn(new Error('User ' + id + ' does not exist'))

    @findByUsername: (username, fn) ->
        for user in users
            if user.username is username
                return fn(null, user)
        return fn(null, null)