/*!
 *	Template Functions
 *	Version: 1.0
*/

(function($){

	"use strict";

	/* ---------------------------------------------- /*
	 * Preloader
	/* ---------------------------------------------- */

	$(window).load(function() {
		$('.page-loader').animate({width: 'toggle'});
	});

	$(document).ready(function() {

		$('.style-toggle').on('click', function(e) {
			$('body').toggleClass('dark')
			e.preventDefault();
		});

		var mobileTest;

		/* ---------------------------------------------- /*
		 * Mobile detect
		/* ---------------------------------------------- */

		if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
			mobileTest = true;
		} else {
			mobileTest = false;
		}

		/* ---------------------------------------------- /*
		 * Setting background of modules
		/* ---------------------------------------------- */

		$('[data-background]').each(function() {
			$(this).css('background-image', 'url(' + $(this).attr('data-background') + ')');
		});

		/* ---------------------------------------------- /*
		 * Show/Hide menu
		/* ---------------------------------------------- */

		$('.show-menu-btn').on('click', function() {
			$(this).toggleClass('open');
			$('.overlay-menu').toggleClass('active');
			$('body').toggleClass('menu-opened');
			return false;
		});

		$(window).keydown(function(e) {
			if ($('.overlay-menu').hasClass('active')) {
				if (e.which === 27) {
					$('.show-menu-btn').removeClass('open');
					$('.overlay-menu').removeClass('active');
					$('body').removeClass('menu-opened');
				}
			}
		});

		/* ---------------------------------------------- /*
		 * Portfolio masonry
		/* ---------------------------------------------- */

		var filters   = $('#filters'),
			worksgrid = $('.row-portfolio');

		$('a', filters).on('click', function() {
			var selector = $(this).attr('data-filter');
			$('.current', filters).removeClass('current');
			$(this).addClass('current');
			worksgrid.isotope({
				filter: selector
			});
			return false;
		});

		$(window).on('resize', function() {
			$('.row-portfolio').imagesLoaded(function() {
				$('.row-portfolio').isotope({
					layoutMode: 'masonry',
					itemSelector: '.portfolio-item',
				});
			});
		}).resize();

		/* ---------------------------------------------- /*
		 * Progress bars, counters, pie charts animations
		/* ---------------------------------------------- */

		$('.progress-bar').each(function() {
			$(this).appear(function() {
				var percent = $(this).attr('aria-valuenow');
				$(this).animate({'width' : percent + '%'});
				$(this).parent('.progress').prev('.progress-title').find('.p-coutn').countTo({
					from: 0,
					to: percent,
					speed: 900,
					refreshInterval: 30
				});
			});
		});

		$('.counter-timer').each(function() {
			$(this).appear(function() {
				var number = $(this).attr('data-to');
				$(this).countTo({
					from: 0,
					to: number,
					speed: 1500,
					refreshInterval: 10,
					formatter: function (number, options) {
						number = number.toFixed(options.decimals);
						number = number.replace(/\B(?=(\d{3})+(?!\d))/g, ',');
						return number;
					}
				});
			});
		});

		$('.chart').each(function() {
			$(this).appear(function() {
				$(this).easyPieChart({
					barColor:   "#252525",
					trackColor: "#d9d9d9",
					scaleColor: false,
					lineCap:    'square',
					size:       160,
				});
			});
		});

		/* ---------------------------------------------- /*
		 * Lightbox, Gallery
		/* ---------------------------------------------- */

		$('.lightbox').magnificPopup({
			type: 'image'
		});

		$('[rel=gallery]').magnificPopup({
			type: 'image',
			gallery: {
				enabled: true,
				navigateByImgClick: true,
				preload: [0,1]
			},
			image: {
				titleSrc: 'title',
				tError: 'The image could not be loaded.',
			}
		});

		$('.lightbox-video').magnificPopup({
			type: 'iframe',
		});

		/* ---------------------------------------------- /*
		 * A jQuery plugin for fluid width video embeds
		/* ---------------------------------------------- */

		$('body').fitVids();

		/* ---------------------------------------------- /*
		 * Google Map
		/* ---------------------------------------------- */

		var reg_exp = /\[[^(\]\[)]*\]/g;

		var map_div      = $('#map');
		var is_draggable = Math.max($(window).width(), window.innerWidth) > 736 ? true : false;

		if (map_div.length > 0) {

			var markers_addresses = map_div.data('addresses').match(reg_exp),
				markers_info      = map_div.data('info').match(reg_exp),
				markers_icon      = map_div.data('icon'),
				map_zoom          = map_div.data('zoom');

			var	markers_values = [], map_center;

			markers_addresses.forEach( function(marker_address, index) {
				var marker_value = '{'
				marker_value    += '"latLng":' + marker_address;
				if (index == 0) {
					map_center = JSON.parse(marker_address);
				};
				if (markers_info[index]) {
					var marker_data = markers_info[index].replace(/\[|\]/g, '');
					marker_value   += ', "data":"' + marker_data + '"';
				};
				marker_value += '}';
				markers_values.push(JSON.parse(marker_value));
			});

			var map_options = {
				scrollwheel: false,
				styles: [{"featureType":"water","elementType":"geometry","stylers":[{"color":"#e9e9e9"},{"lightness":17}]},{"featureType":"landscape","elementType":"geometry","stylers":[{"color":"#f5f5f5"},{"lightness":20}]},{"featureType":"road.highway","elementType":"geometry.fill","stylers":[{"color":"#ffffff"},{"lightness":17}]},{"featureType":"road.highway","elementType":"geometry.stroke","stylers":[{"color":"#ffffff"},{"lightness":29},{"weight":0.2}]},{"featureType":"road.arterial","elementType":"geometry","stylers":[{"color":"#ffffff"},{"lightness":18}]},{"featureType":"road.local","elementType":"geometry","stylers":[{"color":"#ffffff"},{"lightness":16}]},{"featureType":"poi","elementType":"geometry","stylers":[{"color":"#f5f5f5"},{"lightness":21}]},{"featureType":"poi.park","elementType":"geometry","stylers":[{"color":"#dedede"},{"lightness":21}]},{"elementType":"labels.text.stroke","stylers":[{"visibility":"on"},{"color":"#ffffff"},{"lightness":16}]},{"elementType":"labels.text.fill","stylers":[{"saturation":36},{"color":"#333333"},{"lightness":40}]},{"elementType":"labels.icon","stylers":[{"visibility":"off"}]},{"featureType":"transit","elementType":"geometry","stylers":[{"color":"#f2f2f2"},{"lightness":19}]},{"featureType":"administrative","elementType":"geometry.fill","stylers":[{"color":"#fefefe"},{"lightness":20}]},{"featureType":"administrative","elementType":"geometry.stroke","stylers":[{"color":"#fefefe"},{"lightness":17},{"weight":1.2}]}]
			};

			map_options.center    = map_center;
			map_options.zoom      = map_zoom;
			map_options.draggable = is_draggable;

			var markers_options  = {};
			markers_options.icon = markers_icon;

			map_div.gmap3({
				map:{
					options:
						map_options
				},
				marker:{
					values: markers_values,
					options: markers_options,
					events:{
						click: function(marker, event, context) {
							if (context.data) {
								var map        = $(this).gmap3("get"),
									infowindow = $(this).gmap3({get:{name:"infowindow"}});
								if (infowindow) {
									infowindow.open(map, marker);
									infowindow.setContent(context.data);
								} else {
									$(this).gmap3({
										infowindow:{
											anchor:marker,
											options:{content: context.data}
										}
									});
								}
							}
						}
					}
				}
			});

		};

		/* ---------------------------------------------- /*
		 * Scroll Animation
		/* ---------------------------------------------- */

		$('.smoothscroll').on('click', function(e) {
			var target  = this.hash;
			var $target = $(target);

			$('html, body').stop().animate({
				'scrollTop': $target.offset().top - header.height()
			}, 600, 'swing');

			e.preventDefault();
		});

		/* ---------------------------------------------- /*
		 * Scroll top
		/* ---------------------------------------------- */

		$('a[href="#top"]').on('click', function() {
			$('html, body').animate({ scrollTop: 0 }, 'slow');
			return false;
		});

		/* ---------------------------------------------- /*
		 * Disable hover on scroll
		/* ---------------------------------------------- */

		var body = document.body,
			timer;
		window.addEventListener('scroll', function() {
			clearTimeout(timer);
			if (!body.classList.contains('disable-hover')) {
				body.classList.add('disable-hover')
			}
			timer = setTimeout(function() {
				body.classList.remove('disable-hover')
			}, 100);
		}, false);

	});

})(jQuery);
