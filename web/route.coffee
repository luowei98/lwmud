# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 上午11:43


home = require './controllers/home'
notfound = require './controllers/404'
auth = require './controllers/auth'

module.exports = (app) ->
  # home
  app.get '/', home


  # auth
  app.get '/auth/login_window', auth.login_window
  app.post '/auth/join', auth.join

  # 404
  app.get '*', notfound

#return app.router
