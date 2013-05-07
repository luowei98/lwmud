# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-3
# Time: 下午3:42


module.exports = passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
User = require './models/user'


passport.serializeUser (user, done) ->
    done null, user.id

passport.deserializeUser (id, done) ->
    User.findById id, (err, user) ->
        done err, user

passport.use new LocalStrategy { usernameField: 'username', passwordField: 'password' }, (username, password, done) ->
    process.nextTick ->
        User.findOne { username: username }, (err, user) ->
            return done err if err
            if not user
                return done null, false, { message: '用户名或密码错误！'}
            user.comparePassword password, (err, isMatch) ->
                return done err if err
                if isMatch
                    return done null, user
                else
                    return done null, false, { message: '用户名或密码错误！' }
