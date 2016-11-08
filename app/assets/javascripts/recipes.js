document.addEventListener("turbolinks:load", function() {
  var running = false;
  var synth = window.speechSynthesis
  var utterThis = new SpeechSynthesisUtterance();
  utterThis.rate = 0.8;

  var $clone = $('.cooking-step').clone();
  var $cookingStep = $('.cooking-step');

  function showStep(step) {
    $('#cook-container').empty()
    $clone.eq(step).clone().appendTo($('#cook-container'));
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

  document.querySelector('#start').onclick = function () {
    if (!running) {
      running = true;
      synth.cancel();
      utterThis.voice = speechSynthesis.getVoices()[1];
      $("#start, #stop, #pause-resume, #repeat").toggle();
      showStep(0);
      play(0, 0, 0);
    }
  };

  document.querySelector('#stop').onclick = function () {
    if (running) {
      running = false;
      showAllSteps();
      synth.cancel();
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
      running = false
      showStep(current);
      synth.cancel();
      play(current, 0, 0);
      running = true
    }
  };
});
