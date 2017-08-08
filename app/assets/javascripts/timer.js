// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Date

$( document ).ready(function() {
  // global object
  T = {} ;
  T.timerDiv = document.getElementById('timer');

  // Add a listener to remove a startItem row when clicked on.
  var startItemsTable = document.getElementById("start-items-table");
  if (startItemsTable) {
    var stopBtns = startItemsTable.querySelectorAll(".btn");
    if (stopBtns.length > 0) {
      for (var i = 0; i < stopBtns.length; i++) {
        stopBtns[i].addEventListener("click", function(event) {
          var btn = event.target;
          var cell = btn.parentElement;
          var row = cell.parentElement;
          row.remove();
        });
      }
    }
  }
});

function displayTimer() {
  // initilized all local variables:
  var hours='00', minutes='00',
  miliseconds=0, seconds='00',
  time = '',
  timeNow = new Date().getTime(); // timestamp (miliseconds)

  T.difference = timeNow - T.timerStarted;

  // milliseconds
  if(T.difference > 10) {
    miliseconds = Math.floor((T.difference % 1000) / 10);
    if(miliseconds < 10) {
      miliseconds = '0'+String(miliseconds);
    }
  }
  // seconds
  if(T.difference > 1000) {
    seconds = Math.floor(T.difference / 1000);
    if (seconds > 60) {
      seconds = seconds % 60;
    }
    if(seconds < 10) {
      seconds = '0'+String(seconds);
    }
  }

  // minutes
  if(T.difference > 60000) {
    minutes = Math.floor(T.difference/60000);
    if (minutes > 60) {
      minutes = minutes % 60;
    }
    if(minutes < 10) {
      minutes = '0'+String(minutes);
    }
  }

  // hours
  if(T.difference > 3600000) {
    hours = Math.floor(T.difference/3600000);
    // if (hours > 24) {
    // 	hours = hours % 24;
    // }
    if(hours < 10) {
      hours = '0'+String(hours);
    }
  }

  time  =  hours   + ':'
  time += minutes + ':'
  time += seconds + ':'
  time += miliseconds;

  T.timerDiv.innerHTML = time;
}

function startTimer() {
  // save start time
  T.timerStarted = startTime * 1000;
  console.log('T.timerStarted: '+T.timerStarted)

  if (T.difference > 0) {
    T.timerStarted = T.timerStarted - T.difference
  }
  // update timer periodically
  T.timerInterval = setInterval(function() {
    displayTimer()
  }, 10);
}

function stopTimer() {
  clearInterval(T.timerInterval); // stop updating the timer
}