var CONFIG = { debug: false, nick: '#'   // set in onConnect
  , id: null    // set in onConnect
  , last_message_time: 1, focus: true //event listeners bound in onConnect
  , unread: 0 //updated in the message-processing loop
};

var nicks = [];


/*
 * Wraps up a common pattern used with this plugin whereby you take a String
 * representation of a Date, and want back a date object.
 */
Date.fromString = function (str) {
  return new Date(Date.parse(str));
};


//handles another person joining chat
function userJoin(nick) {
  //if we already know about this user, ignore it
  for (var i = 0; i < nicks.length; i++)
    if (nicks[i] == nick) return;
  //otherwise, add the user to the list
  nicks.push(nick);
  //update the UI
  //todo updateUsersPanel();
}

//handles someone leaving
function userPart(nick, timestamp) {
  //remove the user from the list
  for (var i = 0; i < nicks.length; i++) {
    if (nicks[i] == nick) {
      nicks.splice(i, 1);
      break;
    }
  }
  //update the UI
  //todo updateUsersPanel();
}


//used to keep the most recent messages visible
function scrollDown() {
  $('#middle-pane').scrollTop($('#middle-pane')[0].scrollHeight);
  $('#entry').focus();
}

//inserts an event into the stream for display
//the event may be a msg, join or part type
//from is the user, text is the body and time is the timestamp, defaulting to now
//_class is a css class to apply to the message, usefull for system events
function addMessage(from, text, time, _class) {
  if (text === null)
    return;

  if (time == null) {
    // if the time is null or undefined, use the current time.
    time = new Date();
  } else if ((time instanceof Date) === false) {
    // if it's a timestamp, interpret it
    time = new Date(time);
  }

  //every message you see is actually a table with 3 cols:
  //  the time,
  //  the person who caused the event,
  //  and the content
  var messageElement = $(document.createElement('div'));

  messageElement.addClass('message');
  if (_class)
    messageElement.addClass(_class);

  messageElement.attr('title', util.timeString(time));

  // sanitize
  text = util.toStaticHTML(text);

  /*    // If the current user said this, add a special css class
   var nick_re = new RegExp(CONFIG.nick);
   if (nick_re.exec(text))
   messageElement.addClass('personal');*/

  // replace URLs with links
  text = text.replace(util.urlRE, "<a target='_blank' href='$&'>$&</a>");

  /*    var content = '<h4>天主教堂 - </h4>'
   + '<p>' + text + '</p>'
   + '<p>这里明显的出口是 <span class="exit">north</span> 和 <span class="exit">west</span>。</p>'
   + '<ul>'
   + '<li>教父(Priest)</li>'
   + '</ul>'
   + '<div>></div>'
   ;*/
  var content = '<div>' + text + '</div>';
  messageElement.html(content);

  //the log is the stream that we view
  $('#middle-pane').append(messageElement);

  //always view the most recent message when it is added
  scrollDown();
}


var transmission_errors = 0;

//process updates if we have any, request updates from the server,
// and call again with response. the last part is like recursion except the call
// is being made from the response handler, and not at some point during the
// function's execution.
function longPoll(data) {
  if (transmission_errors > 2) {
    showConnect();
    return;
  }

  if (data && data.rss) {
    rss = data.rss;
    //todo updateRSS();
  }

  //process any updates we may have
  //data will be null on the first call of longPoll
  if (data && data.messages) {
    for (var i = 0; i < data.messages.length; i++) {
      var message = data.messages[i];

      //track oldest message so we only request newer messages from server
      if (message.timestamp > CONFIG.last_message_time)
        CONFIG.last_message_time = message.timestamp;

      //dispatch new messages to their appropriate handlers
      switch (message.type) {
        case 'msg':
          if (!CONFIG.focus) {
            CONFIG.unread++;
          }
          addMessage(message.nick, message.text, message.timestamp);
          break;

        case 'join':
          userJoin(message.nick, message.timestamp);
          break;

        case 'part':
          userPart(message.nick, message.timestamp);
          break;
      }
    }
    //update the document title to include unread message count if blurred
    //todo updateTitle();

  }

  //make another request
  $.ajax({ cache: false, type: 'GET', url: '/recv', dataType: 'json', data: { since: CONFIG.last_message_time, id: CONFIG.id }, error: function () {
    addMessage('', 'long poll error. trying again...', new Date(), 'error');
    transmission_errors += 1;
    //don't flood the servers on error, wait 10 seconds before retrying
    setTimeout(longPoll, 10 * 1000);
  }, success: function (data) {
    transmission_errors = 0;
    //if everything went well, begin another request immediately
    //the server will take a long time to respond
    //how long? well, it will wait until there is another message
    //and then it will return it to us and close the connection.
    //since the connection is closed when we get data, we longPoll again
    longPoll(data);
  }
  });

}

//submit a new message to the server
function send(msg) {
  if (CONFIG.debug === false) {
    // XXX should be POST
    // XXX should add to messages immediately
    jQuery.get('/send', {id: CONFIG.id, text: msg}, function (data) {
    }, 'json');
  }
}

// daemon start time
var starttime;
// daemon memory usage
var rss;


//add a list of present chat members to the stream
function outputUsers() {
  var nick_string = nicks.length > 0 ? nicks.join(', ') : '(none)';
  //addMessage('users:', nick_string, new Date(), 'notice');
  return false;
}

//get a list of the users presently in the room, and add it to the stream
function who() {
  jQuery.get('/who', {}, function (data, status) {
    if (status != 'success') return;
    nicks = data.nicks;
    outputUsers();
  }, 'json');
}

function updateTime() {
  jQuery.get('/time', {}, function (data, status) {
    if (status != 'success') return;
    CONFIG.last_message_time = data.time;
  }, 'json');
}

$(document).ready(function () {


  //submit new messages when the user hits enter if the message isnt blank
  $('#entry').keypress(function (e) {
    if (e.keyCode != 13) return;

    var entry = $('#entry');
    var msg = entry.attr('value').replace('\n', '');

    // output entry message
    addMessage('', msg, null, 'self-entry');

    // clear the entry field.
    entry.attr('value', '');

    if (!util.isBlank(msg)) send(msg);
  });

  // update the daemon uptime every 10 seconds
  setInterval(function () {
    //todo updateUptime();
  }, 10 * 1000);

  if (CONFIG.debug) {
    $('#loading').hide();
    $('#connect').hide();
    scrollDown();
    return;
  }

  //begin listening for updates right away
  //interestingly, we don't need to join a room to get its updates
  //we just don't show the chat stream to the user until we create a session
  //longPoll();

  //todo showConnect();
});

//if we can, notify the server that we're going away.
$(window).unload(function () {
  jQuery.get('/part', {id: CONFIG.id}, function (data) {
  }, 'json');
});
