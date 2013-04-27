# ----------------------------------------
# Created with JetBrains WebStorm.
# User: Robert
# Date: 13-4-27
# Time: 上午9:09


@Util = class

  @urlRE = /https?:\/\/([-\w\.]+)+(:\d+)?(\/([^\s]*(\?\S+)?)?)?/g

  # html sanitizer
  toStaticHTML: (inputHtml) ->
    inputHtml = inputHtml.toString()
    inputHtml
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')

  # pads n with zeros on the left
  zeroPad: (digits, n) ->
    n = n.toString()
    while n.length < digits
      n = '0' + n
    n

  # timeString(new Date); returns '19:49:09'
  timeString: (date) ->
    minutes = date.getMinutes().toString()
    hours = date.getHours().toString()
    seconds = date.getSeconds().toString()
    this.zeroPad(2, hours) + ':' + this.zeroPad(2, minutes) + ':' + this.zeroPad(2, seconds)

  # does the argument only contain whitespace?
  isBlank: (text) ->
    blank = /^\s*$/
    text.match(blank) isnt null

  # convert a string representation of a date to a date object
  dateFromString: (str) ->
    new Date Date.parse str


