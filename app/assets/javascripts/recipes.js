document.addEventListener("turbolinks:load", function() {
  // direction has many steps
  var cookSteps = $('.cooking-step')
  var numSteps = cookSteps.length
  var indexStep = 0

  // each step has a few smaller steps
  var subStep = cookSteps.eq(indexStep).children('div')
  var dirLength = subStep.length
  var indexSub = 0

  var synth = window.speechSynthesis;
  var utterThis = new SpeechSynthesisUtterance();
  var timeBetDir = 10;
  var timeBetStep = 50;

  function playThis(index) {
    var currentDir = subStep.eq(index);
    if (index > 0) {
      subStep.eq(index-1).css({"font-weight": "normal", "font-size": "100%"})
    }
    currentDir.css({"font-weight": "bold", "font-size": "125%"})
    utterThis.text = currentDir[0].innerHTML;
    synth.speak(utterThis);
    console.log(subStep[index].innerHTML);
  }

  function playNext() {
    indexSub++;
    if (indexSub < dirLength) {
      playThis(indexSub);
    } else {
      indexStep++;
      if (indexStep < numSteps) {
        setTimeout(function(){
          $('#cook-container').empty();
          $('#cook-container').append(cookSteps[indexStep]);
          
          indexSub = 0;
          subStep = cookSteps.eq(indexStep).children('div');
          dirLength = subStep.length;
          playThis(indexSub);
        }, timeBetStep);
      }
    }
  }

  document.querySelector('#start').onclick = function () {
    var voice = speechSynthesis.getVoices()[1];
    utterThis.voice = voice;
    utterThis.rate = 2;

	  $('#cook-container').empty();
	  $('#cook-container').append(cookSteps[indexStep])
		playThis(indexSub);
		utterThis.addEventListener("end", function(){
  		setTimeout(playNext, timeBetDir)
  	});
	  	
  };

});