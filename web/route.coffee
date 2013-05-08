# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 上午11:43


home = require './controllers/home'
notfound = require './controllers/404'
auth = require './controllers/auth'
console = require './controllers/console'

module.exports = (app, env) ->
    # home
    app.get '/', home

    # auth
    app.post '/homeLogin',
        ((req, res, next) ->
            auth.homeLogin(req, res, next, env)),
    (err, req, res) ->
        res.json 500, err.message

    app.post '/consoleLogin',
        ((req, res, next) ->
            auth.consoleLogin(req, res, next, env)),
    (err, req, res) ->
        res.json 500, err.message

    app.get '/auth/login_window', auth.login_window
    app.post '/auth/join', auth.join

    # console
    app.get '/console/', (req, res)->
        res.redirect '/console'
    app.get '/console/index', (req, res)->
        res.redirect '/console'
    app.get '/console', (req, res) ->
        console.index req, res, env
    app.post '/console/send', console.send
    app.get '/console/recv', console.recv

    # 404
    app.get '*', notfound

