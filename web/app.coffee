HOST = null
PORT = process.env.VMC_APP_PORT || 8000

express = require 'express'
http = require 'http'
path = require 'path'
stylus = require 'stylus'
assets = require 'connect-assets'
# mongoose = require 'mongoose'
routes = require './route'

app = express()

viewDir = path.join __dirname, 'views'
publicDir = path.join __dirname, 'public'

app.set 'port', Number process.env.PORT || PORT
app.set 'views', viewDir
app.set 'view engine', 'jade'
app.use express.favicon publicDir + '/img/favicon.ico'
app.use express.bodyParser()
app.use express.methodOverride()
app.use stylus.middleware(
  src: path.join(__dirname, 'includes'),
  dest: publicDir,
  compress: true
)

if process.env.NODE_ENV or app.get('env') is 'development'
  app.use express.logger 'dev'
  app.use assets(src: 'web/includes')
else
  app.use express.errorHandler()
  app.use assets(src: 'web/includes', buildDir: 'web/.includes_cache', build: true)

app.use express.static publicDir, {maxAge: 31557600000}
app.use app.router

routes app

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'
