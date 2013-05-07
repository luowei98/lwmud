# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-6
# Time: 下午8:10


mongoose = require '../db/schema'

Schema = mongoose.Schema

# user schema
userSchema = new Schema
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

# password verification
userSchema.methods.comparePassword = (candidatePassword, cb) ->
    cb null, candidatePassword is @password

module.exports = User = mongoose.model("User", userSchema)

