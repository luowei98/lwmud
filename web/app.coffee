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
app.use express.logger 'dev'
app.use express.bodyParser()
app.use express.methodOverride()
app.use stylus.middleware({
src: path.join(__dirname, 'includes'),
dest: publicDir
compress: true
})
app.use assets(src: 'includes', build: true)
app.use express.static publicDir, {maxAge: 31557600000}
app.use app.router

if app.get('env') is 'production'
  app.use express.errorHandler()

routes app

http.createServer(app).listen app.get('port'), ->
  console.log 'Express server listening on port ' + app.get 'port'
