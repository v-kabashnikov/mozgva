$(document).ready(function(){
	$('.noticCarosel').slick({
		slidesToShow: 1,
	  slidesToScroll: 1,
	  arrows:true
	});

	$('.center').slick({
	  centerMode: true,
	  centerPadding: '60px',
	  slidesToShow: 3,
	  slidesToScroll: 1,
	  responsive: [
	    {
	      breakpoint: 768,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        centerPadding: '40px',
	        slidesToShow: 3
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        arrows: false,
	        centerMode: true,
	        centerPadding: '40px',
	        slidesToShow: 1
	      }
	    }
	  ]
	});

	$('.topPeopleCarousel').slick({
	  speed: 300,
	  slidesToShow: 9,
	  slidesToScroll: 9,
	  variableWidth: true,
	  responsive: [
	    {
	      breakpoint: 1024,
	      settings: {
	        slidesToShow: 9,
	        slidesToScroll: 9,
	        infinite: true,
	        dots: true
	      }
	    },
	    {
	      breakpoint: 600,
	      settings: {
	        slidesToShow: 6,
	        slidesToScroll: 6
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        slidesToShow: 3,
	        slidesToScroll: 3
	      }
	    }
	  ]
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

