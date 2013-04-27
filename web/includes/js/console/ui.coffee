# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-26
# Time: 下午7:36


# document ready
$ ->
  # resize layer
  layer = $('#horizontal')
  resizeLayer = ->
    layer.width $(window).width() - 2
    layer.height $(window).height() - 2

  resizeLayer()

  window.onresize = ->
    resizeLayer()
    kw = $('#login-window').data('kendoWindow')
    kw.center()
    kw.wrapper.css top: ($(window).height() - 300 ) / 3

  # set main layer
  layer.kendoSplitter panes: [
    { collapsible: true, size: '200px' },
    { collapsible: false },
    { collapsible: true, size: '200px' }
  ]

  # set center layer
  $('#vertical').kendoSplitter orientation: 'vertical', panes: [
    { collapsible: false },
    { collapsible: false, resizable: false, size: '48px' }
  ]

  # set both side panelbar
  $('#left-panelbar').kendoPanelBar expandMode: 'single'
  $('#right-panelbar').kendoPanelBar expandMode: 'single'

  # set login window
  $('#login-window').kendoWindow(
    title: false,
    height: '300px',
    modal: true,
    resizable: false,
    width: '600px',
    content: 'auth/login_window'

    activate: ->
      $('#nick').focus()
    open: ->
      this.wrapper.css top: ($(window).height() - 300 ) / 3
    refresh: ->
      # set accept the terms and condition of service by default
      $('#accept-checkbox')[0].checked = true
      $('#login-button').click login
  )




  