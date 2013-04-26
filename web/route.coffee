# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 上午11:43


home = require './controllers/home'
notfound = require './controllers/404'

module.exports = (app) ->
  # home
  app.get '/', home

  # 404
  app.get '*', notfound

#return app.router
