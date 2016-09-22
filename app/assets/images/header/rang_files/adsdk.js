/// Yandex Ads SDK ///

// Mobile HomeExpandableBannerAPI
function CHomeExpandableMobileBannerAPI(){
	var origin = null; 
	this.sendCommand = function (command) {
	        if (!this.origin) {
        	    return;
	        }
	        top.postMessage(JSON.stringify({
        	    command: command
        	}), this.origin);
	}
	this.getUrlParam = function (name) {
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
		results = regex.exec(location.search);
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}
	this.init = function(){
		this.origin = this.getUrlParam('origin');
	}
        this.close = function () {
	    this.init();
            this.sendCommand('close');
        }
};

var homeExpandableMobileBannerAPI = new CHomeExpandableMobileBannerAPI(); 
