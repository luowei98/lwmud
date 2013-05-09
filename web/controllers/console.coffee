# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-28
# Time: 下午5:10


exports.index = (req, res, env) ->

    needlogin = false
    if req.isAuthenticated()
        session = env.session.findSession req.user.username
        needlogin = {
            id: session.id,
            nick: session.nick,
            starttime: session.timestamp.getTime()
        } if session?

    res.render 'console/index.jade', {
        title: '风云天下',
        needlogin: needlogin
    }

exports.send = (req, res, env) ->
    id = req.body.id
    text = req.body.text

    # todo session check & session poke

    env.channel.appendMessage id, 'msg', '什么?'
    res.json 200, time: new Date().getTime()


exports.recv = (req, res, env) ->
    since = req.query.since
    if not since?
        res.json 400, error: '参数错误'

    id = req.query.id
    # todo session check & session poke

    since = parseInt since, 10

    env.channel.query req.user.username, since, (messages) ->
        # todo session poke
        res.json 200, messages: messages
