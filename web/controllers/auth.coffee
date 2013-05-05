# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 下午2:34


exports.login_window = (req, res) ->
    res.render 'auth/login_window.jade', {title: 'home!'}

exports.login = (req, res, next, env) ->
       env.passport.authenticate('local', (err, user, info) ->
            return next err if err
            unless user
                req.session.messages = [info.message]
                return res.redirect '/'
            req.logIn user, (err) ->
                return next err if err
                return res.redirect '/console'
        ) req, res, next

exports.ajaxLogin = (req, res, next, env) ->
       env.passport.authenticate('local', (err, user, info) ->
            return res.json 500, {message: err.message} if err
            return res.json 401, {message: info.message} unless user
            req.logIn user, (err) ->
                res.json 500, {message: err.message} if err

                session = env.session.createSession user.username

                #todo channel.addmsg session.nick join

                res.json 200, { id: session.id, nick: session.nick, starttime: (new Date()).getTime() }
        ) req, res, next

exports.join = (req, res) ->
    nick = req.body.nick
    return res.json(400, {error: 'Bad nick.'}) if not nick? or nick.length is 0

    # todo check session if new create it

    console.log 'connection: ' + nick + '@' + res.connection.remoteAddress

    # todo channel add message


    res.json 200, { id: 0, nick: nick, starttime: new Date().getTime()}
    # res.json 200, { id: session.id, nick: nick, starttime: starttime}

