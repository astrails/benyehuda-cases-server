(function($) {
	$.fn.lookup_updater = function(action, options){
		return this.each(function() {
			var obj = $(this);
			var last_value = obj.val();
			
			var defaults = {
				timeout:	2000,
			};
			if (typeof(action) == 'object') {
				options = action;
				action = "init";
			}

			var options = $.extend(defaults, options);

			var update_function = function() {
				if (last_value == obj.val()) {
					return;
				}
				opts = jQuery.data(obj.get(0), "options");
				
				last_value = obj.val();
				var data = opts.data || {};
				data.query = last_value;
				jQuery.ajax({data: data, url: opts.url, type:'get', dataType:'script', beforeSend: opts.beforeSend, complete: opts.complete});
			};

			function clear_interval() {
				var interval = jQuery.data(obj.get(0), "completer_lookup");
				if (interval) {
					clearInterval(interval);
					jQuery.data(obj.get(0), "completer_lookup", null);
				}				
			}

			function reset_interval() {
				clear_interval();
				var interval = setInterval(update_function, options.timeout);
				jQuery.data(obj.get(0), "completer_lookup", interval);				
			}

			if ("stop" ==  action) {
				clear_interval();
				return;
			}
			
			if ("start" == action) {
				reset_interval();
				return;
			}

			if ("init" == action) {
				jQuery.data(obj.get(0), "options", options);
				obj.keyup(function(e){
					if (13 == e.which) {
						update_function();
						reset_interval();
					}
				});
			}
		});
	}
})(jQuery);
