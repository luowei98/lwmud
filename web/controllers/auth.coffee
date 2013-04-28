# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 下午2:34

url = require('url')
qs = require('querystring')

exports.login_window = (req, res) ->
    res.render 'auth/login_window.jade', {title: 'home!'}

exports.join = (req, res) ->
    nick = req.body.nick
    return res.json(400, {error: 'Bad nick.'}) if not nick? or nick.length is 0

    # todo check session if new create it

    # sys.puts('connection: ' + nick + '@' + res.connection.remoteAddress);

    # todo channel add message


    #res.json 200, { id: session.id, nick: nick, starttime: starttime}
    res.json 200, { id: 0, nick: nick, starttime: new Date().getTime()}

