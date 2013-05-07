# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-7
# Time: 下午4:49

User = require '../models/user'

# seed default user
User.findOne { username: 'rob' }, (err, user) ->
    return console.warn('can not create default user') if err
    unless user?
        user = new User {
            username: 'rob',
            email: 'rob@example.com',
            password: 'admin',
            admin: true
        }
        user.save (err) ->
            if err
                console.log err
            else
                console.log 'created default admin user: ' + user.username