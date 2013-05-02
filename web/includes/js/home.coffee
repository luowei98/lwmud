# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-2
# Time: 下午1:04

#= require 'jquery-1.8.2'
#= require 'kendo/kendo.web.min'


disableLogin = ->
    $("#login-button").addClass('k-state-disabled loading').text '登录中'

enableLogin = ->
    $('#login-button').removeClass('k-state-disabled loading').text '进 入'


$ ->

    validator = $('div#tickets').kendoValidator().data 'kendoValidator'

    status = $(".status");

    $("button").click ->

        disableLogin()
        setTimeout ->
            enableLogin()
        , 10000

        if validator.validate()
            status.text("Hooray! Your tickets has been booked!")
        else
            status.text("Oops! There is invalid data in the form.")

