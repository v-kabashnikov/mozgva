(function() {
	window.ya = window.ya || {};
	window.ya.mediaCode = window.ya.mediaCode || {	
        	templates: {}
	};

	var templates = ya.mediaCode.templates;

	ya.mediaCode.templates["div.tpl.html"] = function(obj) {
        	var p = [];
		with(obj) p.push('<div id="html5_container" style="width: ', width, "; height: ", height, ';"></div>');
		return p.join("");
	}

	ya.mediaCode.templates["image.tpl.html"] = function(obj) {
		var p = [];				
		with(obj) p.push(""), gif_tizer || p.push('<a href="', click_url, '" target="_blank">'), p.push('<img src="', img_src, '" width="', width, '" height="', height, '" border=0 alt="', alt, '">'), gif_tizer || p.push("</a>"), p.push("");
		return p.join("")
	}

	ya.mediaCode.templates["iframe.tpl.html"] = function(obj) {
        	var p = [];		
		var tag_sandbox = "";
		var sandbox = "allow-same-origin allow-popups allow-scripts";

		var isSafari = /^((?!chrome|android).)*safari/i.test(navigator.userAgent);

		if (isSafari){
//			sandbox += " allow-same-origin allow-top-navigation "; //need for window.open work on click 
			tag_sandbox = ""; //but not work well
		}else{
			tag_sandbox = " sandbox=\"" + sandbox + "\" ";
		}


		with(obj) p.push('<iframe src="', iframe_src, '" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" width="', width, '" height="', height, '"' , tag_sandbox , '></iframe>');
		return p.join("");
	}

	AwHtml5.prototype.isCanvasSupported = function(url) {
		var elem = document.createElement('canvas');
		return !!(elem.getContext && elem.getContext('2d'));
	}

	function AwHtml5(params) {
        	this._params = params;
		this._params.iframe_src += (params.iframe_src.split('?') [1] ? '' : '?');
		if ( this._params.iframe_src.toLowerCase().indexOf('awaps') > 0
			|| this._params.awaps_native
		){
			this._params.iframe_src += "&html5ad=1";					
		}

		this._params.iframe_src+= "&" + params.getargs;		

		if ( params.width == 0) this._params.width = "100%";
		if ( params.height == 0) this._params.height = "100%";

	}
	
	var reportedURLs = {};
	AwHtml5.prototype.reportURL = function(url) {
        	if (!url || reportedURLs[url]) return;
	        reportedURLs[url] = true;
        	var img = new Image();
	        img.src = url;
	}

	AwHtml5.prototype.mp4Enable = function() {
		var v = document.createElement('video');		
        	return (v.canPlayType && v.canPlayType('video/mp4').replace(/no/, ''));
	};

	AwHtml5.prototype.html5Enable = function() {
		if(this._params.getargs &&  this._params.getargs.indexOf("video1=") >=0){ // HTML5 have video
			if (!this.mp4Enable()) {
			this.reportURL(this._params.stats.noVideo);
			return false;
			}

		}
        	return this._params.html5_enable && this._params.iframe_src && this.isCanvasSupported();
	};

	AwHtml5.prototype.report = function() {
		this.reportURL(this._params.pixel_stat1);
		this.reportURL(this._params.pixel_stat2);
	};

	AwHtml5.prototype.showStub = function() {
		this.reportURL(this._params.stats.imageStat);

//		var inner_html_stub = '<center><img src="' + this._params.img_src + '" border=0 alt=\"' + this._params.alt + '\" ></center>';
	        var inner_html_stub  = '<img style="background:#fff url(' + this._params.img_src  + ') no-repeat 50% 50%;" src="https://awaps.yandex.ru/2/35823/0.gif?cache=1" " width="' + this._params.width + '"  height="' + this._params.height + '" border=0 alt=\"' + this._params.alt + '\" >';
		if (!this._params.gif_tizer){
				inner_html_stub  = '<a href="' + this._params.click_url  + '" target=_blank >' + inner_html_stub  + '</a>'; 
		}
        	document.getElementById('html5_container').innerHTML = inner_html_stub;
	};

	AwHtml5.prototype.showHtml5 = function() {
        	document.getElementById('html5_container').innerHTML = templates['iframe.tpl.html'](this._params);
	};

	AwHtml5.prototype.render = function () {
        	var params = this._params;
		document.write(templates['div.tpl.html'](params));

		if (this.html5Enable()) {
			this.showHtml5();
        	}else {
			this.showStub();
		}
		this.report();
    };

    window.ya.mediaCode.AwHtml5 = AwHtml5;
}());
