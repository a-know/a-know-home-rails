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
  $("#gg-img-tag").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '.png">');
  $("#gg-img-tag-option").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '.png?rotate=270&width=568&height=88">');
  $("#gg-img-tag-detail").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '.png?type=detail">');
});

$("#generate-btn").on('click',function(){
  if ($("#mc-github-id").val() == "") {
    return
  }
  $("#gg-img-area").empty();
  $("#gg-img-area").append("<h2 class='description'><small>" + $("#mc-github-id").val() + "'s GitHub Public Contributions Grass-Graph</small></h2>")
  var img_element = document.createElement('img');
  img_element.setAttribute("src", "https://grass-graph.shitemil.works/images/" + $("#mc-github-id").val() + ".png");
  $("#gg-img-area").append(img_element);
});

$("#generate-btn").on('click',function(){
  if ($("#mc-github-id").val() == "") {
    return
  }
  $("#gg-img-area-detail").empty();
  $("#gg-img-area-detail").append("<h2 class='description'><small>type=detail</small></h2>")
  var img_element = document.createElement('img');
  img_element.setAttribute("src", "https://grass-graph.shitemil.works/images/" + $("#mc-github-id").val() + ".png?type=detail");
  $("#gg-img-area-detail").append(img_element);
});