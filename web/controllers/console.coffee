# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-28
# Time: 下午5:10


Channel = require('../../mud/channel')
channel = new Channel()

exports.send = (req, res) ->
    id = req.body.id
    text = req.body.text

    # todo session check & session poke

    channel.appendMessage id, 'msg', '什么?'
    res.json 200, time: new Date().getTime()


exports.recv = (req, res) ->
    since = req.query.since
    if not since?
        res.json 400, error: '参数错误'

    id = req.query.id
    # todo session check & session poke

    since = parseInt since, 10

    channel.query since, (messages) ->
        # todo session poke
        res.json 200, messages: messages
