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
	  speed: 300,
	  slidesToShow: 3,
	  slidesToScroll: 3,
	  variableWidth: true,
	  responsive: [
	    {
	      breakpoint: 1024,
	      settings: {
	        slidesToShow: 3,
	        slidesToScroll: 3,
	        infinite: true,
	        dots: true
	      }
	    },
	    {
	      breakpoint: 600,
	      settings: {
	        slidesToShow: 3,
	        slidesToScroll: 3
	      }
	    },
	    {
	      breakpoint: 480,
	      settings: {
	        slidesToShow: 1,
	        slidesToScroll: 1
	      }
	    }
	  ]
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
	var sliderimg = 'mozgva/app/assets/images/symbol/ticket.png';
	$("output").html("<span> x1</span>"); 

});

// function outputUpdate(val) {
// 	document.querySelector('#value').value = val;
// }
function outputUpdate(vol) {
  var output = document.querySelector("#volume");
	// output.value ='x'+ vol;
	var sliderimg = 'mozgva/app/assets/images/symbol/ticket.png';
	$("output").html("<span> x"+vol+"</span>"); 
	if (vol==1) {
		output.style.left = 0+'px';
	} else if (vol==2) {
		output.style.left = 20+'px';
	} else if (vol==3) {
		output.style.left = 40+'px';
	} else if (vol==4) {
		output.style.left = 60+'px';
	} else if (vol==5) {
		output.style.left = 80+'px';
	} else if (vol==6) {
		output.style.left = 100+'px';
	} else if (vol==7) {
		output.style.left = 120+'px';
	} else if (vol==8) {
		output.style.left = 140+'px';
	} else if (vol==9) {
		output.style.left = 160+'px';
	}
}

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

