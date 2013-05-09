# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 下午2:34


exports.login_window = (req, res) ->
    res.render 'auth/login_window.jade', {title: 'home!'}


authCallback = (req, res, env, err, user, info, next) ->

    return res.json 500, {message: err.message} if err

    return res.json 401, {message: info.message} unless user

    session = env.session.createSession user.username
    return res.json 600, {message: '你已在其它地方登陆'} unless session?

    req.logIn user, (err) ->
        res.json 500, {message: err.message} if err

        # let everyone know i joined
        env.channel.appendMessage 'join', session.username

        # let me know who online
        env.channel.appendMessage 'users', env.session.usernames(), session.username

        next(session) if next


exports.homeLogin = (req, res, next, env) ->
    env.passport.authenticate('local', (err, user, info) ->
        authCallback req, res, env, err, user, info, ->
            res.json 200, { redirect: '/console' }
    ) req, res, next

exports.consoleLogin = (req, res, next, env) ->
       env.passport.authenticate('local', (err, user, info) ->
           authCallback req, res, env, err, user, info, (session) ->
               res.json 200, {
                   id: session.id,
                   nick: user.username,
                   starttime: session.timestamp.getTime()
               }
        ) req, res, next

