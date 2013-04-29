# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 上午11:43


home = require './controllers/home'
notfound = require './controllers/404'
auth = require './controllers/auth'
console = require './controllers/console'

module.exports = (app) ->
    # home
    app.get '/', home

    # auth
    app.get '/auth/login_window', auth.login_window
    app.post '/auth/join', auth.join

    # console
    app.post '/console/send', console.send
    app.get '/console/recv', console.recv

    # 404
    app.get '*', notfound

