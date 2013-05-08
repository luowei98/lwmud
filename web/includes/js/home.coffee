# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-5-2
# Time: 下午1:04

#= require 'jquery-1.8.2'
#= require 'kendo/kendo.web.min'


disableLogin = () ->
    $("#login-button").addClass('k-state-disabled loading').text '登录中'

enableLogin = () ->
    $("#login-button").removeClass('k-state-disabled loading').text '进 入'

$ ->

    validator = $('#tickets').kendoValidator().data 'kendoValidator'

    $("#login-button").click ->
        return false if not validator.validate()

        disableLogin()
        $.ajax(
            cache: false,
            type: 'POST',
            dataType: 'json',
            url: '/homeLogin',
            data: {
                username: $('#username').val(),
                password: $('#password').val()
            },

            success: (data) ->
                if data.redirect
                    window.location = data.redirect
                else
                    $('li.status').text data.message

            error: (xhr) ->
                enableLogin()
                data = jQuery.parseJSON(xhr.responseText)
                if data and data.message
                    $('li.status').text data.message
                else
                    $('li.status').text '啊呀~ 连接服务器出错了！'
        )
