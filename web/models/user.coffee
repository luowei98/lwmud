# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-6
# Time: 下午8:10


mongoose = require '../db/schema'

# user schema
userSchema = new mongoose.Schema
    username:
        type: String
        required: true
        unique: true

    email:
        type: String
        required: true
        unique: true

    password:
        type: String
        required: true

    admin:
        type: Boolean
        required: true

    lastActtime:
        type: Date
        'default': Date.now

    needClose:
        type: Boolean
        'default': false

    connectionToken:
        type: String


userSchema.methods.comparePassword = (candidatePassword, cb) ->
    cb null, candidatePassword is @password

userSchema.methods.connected = ->
    @lastActtime = new Date()
    @needClose = false
    @connectionToken = Math.floor(Math.random() * 99999999999).toString()

userSchema.methods.poke = ->
    @lastActtime = new Date()

userSchema.methods.dead = ->
    @needClose = true


module.exports.model = userModel = mongoose.model("User", userSchema)

module.exports.createDefault = (next) ->
    userModel.findOne { username: 'rob' }, (err, user) ->
        next err if err
        unless user?
            userModel.create {
                username: 'rob',
                email: 'rob@example.com',
                password: 'admin',
                admin: true
            }, next
        else
            next 'default user already exists'

