# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 上午11:13

exports = module.exports = (req, res, next) ->
  res.render '404.jade', { title: 'No Found' }