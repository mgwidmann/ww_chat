import {Socket} from "phoenix"

class App {

  constructor() {
    this.user = $('#user');
    this.message = $('#message');
    this.messages = $('#messages');
    this.typing = $('#typing');
  }

  init() {
    this.user.val(window.localStorage.user);

    let socket = new Socket("/chat");
    socket.connect();

    socket.onClose( e => {
      this.post_message('Your connection has been closed...', true)
    });

    let chan = socket.chan("rooms:lobby",{user: this.user.val()})

    chan.on('new:message', data => {
      this.post_message(`[${data.user}]: ${data.message}`, data.is_system);
    });

    let typingTimeout = null;
    this.message.off('keypress').on('keypress', event => {
      if(event.keyCode === 13 && this.user.val() != ''){ // enter
        chan.push("new:message", {message: this.message.val()});
        this.message.val('');
      } else if(this.user.val() != '') {
        if(typingTimeout == null) { // Just started typing
          chan.push("user:type", {typing: true});
        }
        clearTimeout(typingTimeout);
        typingTimeout = setTimeout(()=> {
          chan.push("user:type", {typing: false});
          typingTimeout = null;
        }, 500);
      }
    });

    this.user.off('change').on('change', event => {
      chan.push("user:change", {renamed: this.user.val()});
      window.localStorage.user = this.user.val();
    });

    chan.on('user:change', data => {
      if(data.user != ''){
        this.post_message(`User "${data.user}" is now known as "${data.renamed}"`, true);
      }
    });

    let typing = []
    chan.on("user:type", data => {
      if(data.typing){
        typing.push(data.user);
      } else {
        typing.splice(typing.indexOf(data.user), 1);
      }
      // Update the view
      if(typing.length > 0){
        this.typing.text(`${typing.join(', ')} ${typing.length > 1 ? 'are' : 'is'} typing...`);
      } else {
        this.typing.text(''); // Clear out
      }
    });

    chan.join().receive("ok", (chan)=>{
      this.post_message('Connected!', true)
    });

  }

  post_message(message, isSystem) {
    var div = $(`<${isSystem ? 'strong' : 'div'} class="row col-md-12"/>`);
    div.text(message);
    this.messages.append(div);
    this.messages.animate({ scrollTop: this.messages[0].scrollHeight}, 500);
  }

}

$( () => (new App()).init() )

export default App


/*
///////////// Start ////////////////

import {Socket} from "phoenix"

class App {
}

$( () => (new App()).init() )

export default App

///////////////////////////////////

///// Constructor & Helpers ///////

constructor() {
  this.user = $('#user');
  this.message = $('#message');
  this.messages = $('#messages');
  this.typing = $('#typing');
}

init() {
  this.user.val(window.localStorage.user);
}

post_message(message, isSystem) {
  var div = $(`<${isSystem ? 'strong' : 'div'} class="row col-md-12"/>`);
  div.text(message);
  this.messages.append(div);
  this.messages.animate({ scrollTop: this.messages[0].scrollHeight}, 500);
}

///////////////////////////////////

//////////// Socket ///////////////

let socket = new Socket("/ws");
socket.connect();

socket.onClose( e => {
  this.post_message('Your connection has been closed...', true)
});

let chan = socket.chan("rooms:lobby",{user: this.user.val()})

chan.join().receive("ok", (chan)=>{
  this.post_message('Connected!', true)
});

///////////////////////////////////

/////////// After join /////////////

chan.on('new:message', data => {
  this.post_message(`[${data.user}]: ${data.message}`, data.is_system);
});

this.message.off('keypress').on('keypress', event => {
  if(event.keyCode === 13 && this.user.val() != ''){ // enter
    chan.push("new:message", {message: this.message.val()});
    this.message.val('');
  }
});

///////////////////////////////////

////////// After change ///////////

this.user.off('change').on('change', event => {
  chan.push("user:change", {renamed: this.user.val()});
  window.localStorage.user = this.user.val();
});

chan.on('user:change', data => {
  if(data.user != ''){
    this.post_message(`User "${data.user}" is now known as "${data.renamed}"`, true);
  }
});

///////////////////////////////////

////////// After typing ///////////

let typing = []
chan.on("user:type", data => {
  if(data.typing){
    typing.push(data.user);
  } else {
    typing.splice(typing.indexOf(data.user), 1);
  }
  // Update the view
  if(typing.length > 0){
    this.typing.text(`${typing.join(', ')} ${typing.length > 1 ? 'are' : 'is'} typing...`);
  } else {
    this.typing.text(''); // Clear out
  }
});


////// INSERT ABOVE KEYPRESS //////
let typingTimeout = null;

//// INSERT BELOW IF KEYPRESS /////
else if(this.user.val() != '') {
 if(typingTimeout == null) { // Just started typing
   chan.push("user:type", {typing: true});
 }
 clearTimeout(typingTimeout);
 typingTimeout = setTimeout(()=> {
   chan.push("user:type", {typing: false});
   typingTimeout = null;
 }, 500);
}

///////////////////////////////////

*/
