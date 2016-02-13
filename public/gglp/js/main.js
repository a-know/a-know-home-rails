$(document).ready(function() {

	"use strict";

  //PRELOADER
  $(window).load(function() {
    $("#status").fadeOut();
    $("#preloader").delay(1000).fadeOut("slow");
  });

	//TEXT ANIMATION
	$('.tlt').textillate({
	  // set the type of token to animate (available types: 'char' and 'word')
	  type: 'word'
	});

});

$("#mc-github-id").on('blur keydown keyup keypress change',function(){
  var textWrite = $("#mc-github-id").val();
  $("#gg-img-tag").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '">');
  $("#gg-img-tag-option").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '?rotate=270&width=568&height=88">');
});

$("#generate-btn").on('click',function(){
  if ($("#mc-github-id").val() == "") {
    return
  }
  $("#gg-img-area").empty();
  var img_element = document.createElement('img');
  img_element.setAttribute("src", "https://grass-graph.shitemil.works/images/" + $("#mc-github-id").val());
  $("#gg-img-area").append(img_element);
  $("#gg-img-area").append("<h2 class='description'><small>" + $("#mc-github-id").val() + "'s GitHub Public Contributions Grass-Graph</small></h2>")
});