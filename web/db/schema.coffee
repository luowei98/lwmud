# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-6
# Time: 下午7:42


mongoose = require 'mongoose'

module.exports = mongoose

# Database connect
if process.env.VCAP_SERVICES
    env = JSON.parse(process.env.VCAP_SERVICES)
    mongo = env["mongodb-1.8"][0]["credentials"]
else
    mongo =
        hostname: "localhost"
        port: 27017
        username: ""
        password: ""
        name: ""
        db: "test"

generate_mongo_url = (obj) ->
    obj.hostname = (obj.hostname or "localhost")
    obj.port = (obj.port or 27017)
    obj.db = (obj.db or "test")
    if obj.username and obj.password
        "mongodb://" + obj.username + ":" + obj.password + "@" + obj.hostname + ":" + obj.port + "/" + obj.db
    else
        "mongodb://" + obj.hostname + ":" + obj.port + "/" + obj.db

mongourl = generate_mongo_url(mongo)
mongoOptions = db:
    safe: true

mongoose.connect mongourl, mongoOptions, (err, res) ->
    if err
        console.log 'ERROR connecting to: ' + mongourl + '. ' + err
    else
        console.info 'Successfully connected to: ' + mongourl

