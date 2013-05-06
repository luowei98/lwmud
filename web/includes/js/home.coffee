# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-2
# Time: 下午1:04

#= require 'jquery-1.8.2'
#= require 'kendo/kendo.web.min'


$ ->

    validator = $('#tickets').kendoValidator().data 'kendoValidator'

    $("#login-button").click ->
        return false if not validator.validate()
        $("#login-button").addClass('k-state-disabled loading').text '登录中'


