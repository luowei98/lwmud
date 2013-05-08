HOST = null
PORT = process.env.VMC_APP_PORT || 8000

express = require 'express'
http = require 'http'
path = require 'path'
stylus = require 'stylus'
assets = require 'connect-assets'

passport = require './passport'
routes = require './route'
seed = require './db/seed'
user = require './models/user'

session = new (require('../mud/session'))()
channel = new (require('../mud/channel'))()

app = express()

viewDir = path.join __dirname, 'views'
publicDir = path.join __dirname, 'public'

app.set 'port', Number process.env.PORT || PORT
app.set 'views', viewDir
app.set 'view engine', 'jade'
app.use express.favicon publicDir + '/img/favicon.ico'
app.use express.bodyParser()
app.use express.methodOverride()
app.use express.cookieParser 'lwfyol'
app.use express.session {secret: 'lwfyol', cookie: {maxAge: 60000}}
app.use passport.initialize()
app.use passport.session()

if process.env.NODE_ENV or app.get('env') is 'development'
    app.use express.logger 'dev'
    app.use express.errorHandler dumpExceptions:true, showStack:true
    app.use assets(src: 'web/includes')
    app.use express.static publicDir
else
    app.use express.errorHandler()
    app.use assets(src: 'web/includes', buildDir: 'web/.includes_cache', build: true)
    app.use express.static publicDir, {maxAge: 31557600000}

app.use app.router

routes app, {passport, session, user, channel}

http.createServer(app).listen app.get('port'), ->
    console.log 'Express server listening on port ' + app.get 'port'
