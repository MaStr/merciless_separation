// Source: https://css-tricks.com/snippets/jquery/load-jquery-only-if-not-present/

// Only do anything if jQuery isn't defined
if (typeof jQuery == 'undefined') {

	if (typeof $ == 'function') {
		// warning, global var
		thisPageUsingOtherJSLibrary = true;
	}
	
	function getScript(url, success) {
	
		var script     = document.createElement('script');
		     script.src = url;
		
		var head = document.getElementsByTagName('head')[0],
		done = false;
		
		// Attach handlers for all browsers
		script.onload = script.onreadystatechange = function() {
		
			if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {
			
			done = true;
				
				// callback function provided as param
				success();
				
				script.onload = script.onreadystatechange = null;
				head.removeChild(script);
				
			};
		
		};
		
		head.appendChild(script);
	
	};
	
	getScript('http://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js', function() {
	
		if (typeof jQuery=='undefined') {
		
			// Super failsafe - still somehow failed...
		
		} else {
		
			// jQuery loaded! Make sure to use .noConflict just in case
			fancyCode();
			
			if (thisPageUsingOtherJSLibrary) {

				// Run your jQuery Code

                jQuery(function($) {
                    var scrollInt = setInterval(function(){
                        $(window).scrollTop($(window).scrollTop() + 1);
                    }, 50);

                    $("body").click(function(){
                        clearInterval(scrollInt);
                    });

                });


			} else {

				// Use .noConflict(), then run your jQuery Code

                jQuery(function($) {
                    var scrollInt = setInterval(function(){
                        $(window).scrollTop($(window).scrollTop() + 1);
                    }, 50);

                    $("body").click(function(){
                        clearInterval(scrollInt);
                    });

                });
			}
		
		}
	
	});
	
} else {

                jQuery(function($) {
                    var scrollInt = setInterval(function(){
                        $(window).scrollTop($(window).scrollTop() + 1);
                    }, 50);

                    $("body").click(function(){
                        clearInterval(scrollInt);
                    });

                });
}
