# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-3
# Time: 下午3:42

module.exports = passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require './user'


passport.serializeUser (user, done) ->
    done null, user.id

passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
        done err, user

passport.use new LocalStrategy { usernameField: 'username', passwordField: 'password' }, (username, password, done) ->
    process.nextTick ->
        User.findByUsername username, (err, user) ->
            return done err if err
            if not user or user.password isnt password
                return done null, false, { message: '用户名或密码错误！'}
            return done null, user
