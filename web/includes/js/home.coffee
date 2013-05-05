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

    $('div#tickets').kendoValidator().data 'kendoValidator'

    $("button").click -> disableLogin()


