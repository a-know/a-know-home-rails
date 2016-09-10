(function($){

		"use strict";

		/**
		 * -------------------
		 * Switcher CSS & HTML
		 * -------------------
		 */

		var switcher_code =
		'<link id="style-switcher" href="" rel="stylesheet" type="text/css">\
		<div class="custom-panel">\
			<div class="panel-header">\
				<span>Style Switcher</span>\
			</div>\
			<div class="panel-options">\
				<ul class="accent color-picker clearfix">\
				</ul>\
				<p>These color skins are included inside the template, and also you can easily create your own one!</p>\
			</div>\
			<div class="panel-toggle">\
				<i class="fa fa-cog"></i>\
			</div>\
		</div>';

		/**
		 * ----------------
		 * Switcher options
		 * ----------------
		 */

		var accent_styles_path = 'assets/css/template-';
		var accent_colors_list = [
			{ colorCode: '#3498db', fileName: 'blue.css' },
			{ colorCode: '#27ae60', fileName: 'green.css' },
			{ colorCode: '#e74c3c', fileName: 'alizarin.css' },
			{ colorCode: '#95a5a6', fileName: 'concrete.css' },
			{ colorCode: '#2ecc71', fileName: 'emerald.css' },

			// { colorCode: '#3498db', fileName: 'blue.css' },
			// { colorCode: '#27ae60', fileName: 'green.css' },
			// { colorCode: '#e74c3c', fileName: 'alizarin.css' },
			// { colorCode: '#95a5a6', fileName: 'concrete.css' },
			// { colorCode: '#2ecc71', fileName: 'emerald.css' }
		];

		/**
		 * -------------------------
		 * Insert switcher into body
		 * -------------------------
		 */

		$(document).ready(function() {

			$('.wrapper').after(switcher_code);

			/**
			 * -----------------------------
			 * Insert elements into switcher
			 * -----------------------------
			 */

			accent_colors_list.forEach(function(color_data) {
				var picker_style = 'style="background-color: ' + color_data.colorCode + '; border: 2px solid ' + color_data.colorCode + ';"';
				$('ul.accent.color-picker').append('<li><a ' + picker_style + ' data-file-name="' + color_data.fileName + '" href="#"></a></li>');
			});

			/**
			 * ---------------------
			 * Set switcher position
			 * ---------------------
			 */

			var custom_panel_width  = $('.custom-panel').innerWidth();
			var panel_header_height = $('.panel-header').outerHeight();
			var negative_indent     = -1 * custom_panel_width;
			$('.custom-panel').css({ 'left' : negative_indent + 'px' });
			$('.panel-toggle').css({ 'left' : custom_panel_width + 'px', 'top' :  panel_header_height + 'px' });

			/**
			 * -------------------
			 * Change accent color
			 * -------------------
			 */

			$('ul.accent.color-picker a').click(function(event) {
				event.preventDefault();
				$('ul.accent.color-picker a').removeClass('selected-color');
				$(this).addClass('selected-color');
				var file_name = $(this).data('file-name');
				$('#style-switcher').attr('href', accent_styles_path + file_name);
			});

			/**
			 * ------------
			 * Panel toggle
			 * ------------
			 */

			$('.panel-toggle').on('click', function() {
				var panel = $('.custom-panel');
				if (parseInt(panel.css('left')) == negative_indent) {
					panel.animate({left: '0px'}, 250);
				} else if ( parseInt(panel.css('left')) == 0) {
					panel.animate({left: negative_indent}, 250);
				}
			});

		});

	})(jQuery);