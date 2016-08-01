$(document).ready(function(){
	$('.headTabNav input[type=radio]').click(function() {
	  if (this.checked) {
	  	$('div.tabs').removeClass("visible");
	  	$('.body div.'+this.id).addClass("visible");
	  	
	  	$('.title').removeClass("current");
	  	$('.title.'+this.id).addClass("current");
	  } 
	  $('.center .slick-track').each(function (e) {
        $('.center.slick-slider').each(function() {
          $(this).slick("getSlick").refresh();
        });
      });
	});
	$("#mySliderTabs").slick({
		arrows:false,
	  	dots:false,
	  	slidesToShow: 3,
	  	slidesToScroll: 3
	});
	
	$(":radio[name='selectAns']").click(function(){
	  $(":radio[name='selectAns']").attr('disabled','disabled');
	});
	$('.noticCarosel').slick({
		
	  arrows:true
	});

	$('.teamsCarousel').slick({
	  slidesToShow: 1,
	  slidesToScroll: 1
	});
	$('.partnerCarousel').slick({
	  slidesToShow: 3,
	  slidesToScroll: 3
	});
	$('.gamesCarousel').slick({
	  rows: 2,
	  arrows:false,
	  dots:true,
	  variableWidth:true,
	  slidesToShow: 2,
	  slidesToScroll: 2,
	  variableWidth: true
	});

});


function DropDown(el) {
	this.dd = el;
	this.placeholder = this.dd.children('span');
	this.opts = this.dd.find('ul.dropdown > li');
	this.val = '';
	this.index = -1;
	this.initEvents();
}
DropDown.prototype = {
	initEvents : function() {
		var obj = this;
		obj.dd.on('click', function(event){
			$('.wrapper-dropdown').not(this).removeClass('active');
			$(this).toggleClass('active');
			return false;
		});
		obj.opts.on('click',function(){
			var opt = $(this);
			obj.val = opt.text();
			obj.index = opt.index();
			obj.placeholder.text(obj.val);
			obj.placeholder.data('current-value', opt.find('a').data('value'));
			// obj.dd.trigger( "dropdown:change" );
		});
	},
	getValue : function() {
		return this.val;
	},
	getIndex : function() {
		return this.index;
	}
}
$(function() {
	var dd = new DropDown($('#dd'));
	dd = new DropDown($('#dd2'));
	dd = new DropDown( $('#update_city'));
	$(document).click(function() {
		$('.wrapper-dropdown').removeClass('active');
	});
});









