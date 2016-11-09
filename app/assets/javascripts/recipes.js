var running = false;
var synth = window.speechSynthesis
var utterThis = new SpeechSynthesisUtterance();
utterThis.rate = 0.9;

document.addEventListener("turbolinks:load", function() {
  $('.search-form input[type=checkbox]').click(function() {
      $(this).parents('form').submit();
  });

  var $clone = $('.cooking-step').clone();
  var $cookingStep = $('.cooking-step');

  function showStep(step) {
    $('#cook-container').empty()
    $clone.eq(step).clone().appendTo($('#cook-container'));
  }

  function showNewStep(step) {
    $('#cook-container').empty()
    $clone.eq(step).clone().clone().appendTo($('#cook-container'));
  }

  function showAllSteps() {
    $('#cook-container').empty();
    $('#cook-container').append($cookingStep);
    $("#start, #stop, #pause-resume, #repeat").toggle();
  }

  function play(step, paragraph, delay) {
    if (step > $clone.length - 1) {
      showAllSteps();
      running = false;
    } else {
      var $paragraphs = $('.cooking-step').eq(0).children('div');
      if (paragraph > 0) {
        $paragraphs.eq(paragraph - 1).css({
          'font-weight': 'normal',
          'font-size': '100%'
        });
      }
      var currentParagraph = $paragraphs.eq(paragraph);
      currentParagraph.css({
        'font-weight': 'bold',
        'font-size': '125%'
      });
      utterThis.text = currentParagraph[0].innerHTML;
      synth.speak(utterThis);
      utterThis.onend = function(event) {
        if (running) {
          if (paragraph < $paragraphs.length - 1) {
            setTimeout(function () {
                play(step, paragraph + 1 , delay);
              }, delay
            );
          } else {
            setTimeout(function () {
                showStep(step + 1);
                play(step + 1, 0 , delay);
              }, delay + 0
            );
          }
        }
      };
    }
  }

  document.querySelector('#start').onclick = function() {
    if (!running) {
      running = true;
      synth.cancel();
      utterThis.voice = speechSynthesis.getVoices().filter(function(obj) { return obj.lang === "en-US" })[0];
      $("#start, #stop, #pause-resume, #repeat").toggle();
      showStep(0);
      play(0, 0, 0);
      recognition.start();
    }
  };

  document.querySelector('#stop').onclick = function () {
    if (running) {
      running = false;
      showAllSteps();
      synth.cancel();
      recognition.stop();
    }
  };

  document.querySelector('#pause-resume').onclick = function () {
    if (running && synth.speaking) {
      running = false;
      synth.pause();
      $("#pause-resume").html('Continue');
      console.log(synth);
    } else if (!running) {
      running = true;
      synth.resume();
      $("#pause-resume").html('Pause');
    }
  };

  document.querySelector('#repeat').onclick = function () {
    if (running) {
      var header = $('h3')[0].innerHTML
      var currentStep = /\d+/.exec(header)[0]
      var current = parseInt(currentStep) - 1
      synth.cancel();
      running = false
      showNewStep(current);
      setTimeout(function(){
        running = true;
        play(current, 0, 0);
      }, 300);
    }
  };
  var recognition = new webkitSpeechRecognition();
  recognition.continuous = true;

  recognition.onresult = function(event) {
    var result = '';
    for (var i = event.resultIndex; i < event.results.length; ++i) {
      result += event.results[i][0].transcript;
    }

    if ( result.includes("start") ) {
      if (!running) {
        document.querySelector('#start').click();
      }
    } else if ( result.includes("pause") || result.includes("resume") ) {
      document.querySelector('#pause-resume').click();
    } else if ( result.includes("stop") ) {
      if (running) {
        document.querySelector('#stop').click();
      }
    } else if ( result.includes("repeat") ) {
      document.querySelector('#repeat').click();
    }
    
  }
});