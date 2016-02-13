$(document).ready(function() {

	"use strict";


	 //PRELOADER
     $(window).load(function() {
        $("#status").fadeOut();
        $("#preloader").delay(1000).fadeOut("slow");
     });

	 //COUNTDOWN
	 $('#clock').countdown('2016/10/10', function(event) {
	   $(this).html(event.strftime('%D days'));
	 });


	//TEXT ANIMATION
	$('.tlt').textillate({
	  // the default selector to use when detecting multiple texts to animate
	  selector: '.texts',

	  // enable looping
	  loop: true,

	  // sets the minimum display time for each text before it is replaced
	  minDisplayTime: 2000,

	  // sets the initial delay before starting the animation
	  // (note that depending on the in effect you may need to manually apply
	  // visibility: hidden to the element before running this plugin)
	  initialDelay: 0,

	  // set whether or not to automatically start animating
	  autoStart: true,

	  in: {
		// set the effect name
		effect: 'fadeIn',

		// set the delay factor applied to each consecutive character
		delayScale: 1,

		// set the delay between each character
		delay: 50,

		// set to true to animate all the characters at the same time
		sync: true,

		// randomize the character sequence
		// (note that shuffle doesn't make sense with sync = true)
		shuffle: false,

		// reverse the character sequence
		// (note that reverse doesn't make sense with sync = true)
		reverse: false,

		// callback that executes once the animation has finished
		callback: function () {}
	  },

	  // out animation settings.
	  out: {
		effect: 'fadeOut',
		delayScale: 1,
		delay: 50,
		sync: true,
		shuffle: false,
		reverse: false,
		callback: function () {}
	  },

	  // callback that executes once textillate has finished
	  callback: function () {},

	  // set the type of token to animate (available types: 'char' and 'word')
	  type: 'char'
	});

});


	//CONTACT FORM
	$('#contact-form').validate({
    	rules: {
      		name: {
            required: true,
                minlength: 2
            },
          email: {
            required: true,
            email: true
            },

					phone: {
            required: true,
            minlength: 2
            },

          message: {
            required: true,
            minlength: 10
            }
        	},

     messages: {
            name: "<i class='fa fa-exclamation-triangle'></i>Please specify your name.",
            email: {
                required: "<i class='fa fa-exclamation-triangle'></i>We need your email address to contact you.",
                email: "<i class='fa fa-exclamation-triangle'></i>Please enter a valid email address."
            },
						phone:"<i class='fa fa-exclamation-triangle'></i>Please enter a valid email address.",

            message: "<i class='fa fa-exclamation-triangle'></i>Please enter your message."
        },
        submitHandler: function(form) {
            $(form).ajaxSubmit({
                type: "POST",
                data: $(form).serialize(),
                url: "php/contact.php",
                success: function() {
                    $('#contact-form :input').attr('disabled', 'disabled');
                    $('#contact-form').fadeTo("slow", 0.15, function() {
                        $(this).find(':input').attr('disabled', 'disabled');
                        $(this).find('label').css('cursor', 'default');
                        $('.success-cf').fadeIn();
                    });
                    $('#contact-form')[0].reset();
                },
                error: function() {
                    $('#contact-form').fadeTo("slow", 0.15, function() {
                        $('.error-cf').fadeIn();
                    });
                }
            });
        }
    });


//MAIL CHIMP
$('#mc-form').ajaxChimp({
	language: 'cm',
	url: 'http://appengg.us12.list-manage2.com/subscribe/post?u=1262aa2502f3201fcdc20da64&amp;id=547618041b'// type your subcribe post id
  });

$.ajaxChimp.translations.cm = {
	'submit': 'Please Wait few sec.......',
	 0: '<i class="fa fa-envelope"></i> Awesome! We have sent you a confirmation email',
	 1: '<i class="fa fa-exclamation-triangle"></i> Please enter a value',
	 2: '<i class="fa fa-exclamation-triangle"></i> An email address must contain a single @',
	 3: '<i class="fa fa-exclamation-triangle"></i> The domain portion of the email address is invalid (the portion after the @: )',
	 4: '<i class="fa fa-exclamation-triangle"></i> The username portion of the email address is invalid (the portion before the @: )',
	 5: '<i class="fa fa-exclamation-triangle"></i> This email address looks fake or invalid. Please enter a real email address'
};

$("#mc-github-id").on('click blur keydown keyup keypress change',function(){
  var textWrite = $("#mc-github-id").val();
  $("#gg-img-tag").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '">');
  $("#gg-img-tag-option").val('<img src="https://grass-graph.shitemil.works/images/' + textWrite + '?rotate=270&width=568&height=88">');
});