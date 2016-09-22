var Storm={};

/* rAF */
var raf_lastTime = 0;
var raf_vendors = ['ms', 'moz', 'webkit', 'o'];
for(var x = 0; x < raf_vendors.length && !window.requestAnimationFrame; ++x) {
	window.requestAnimationFrame = window[raf_vendors[x]+'RequestAnimationFrame'];
	window.cancelAnimationFrame = window[raf_vendors[x]+'CancelAnimationFrame'] || window[raf_vendors[x]+'CancelRequestAnimationFrame'];
} 
if (!window.requestAnimationFrame){
	window.requestAnimationFrame = function(callback, element) {
		var currTime = new Date().getTime();
		var timeToCall = Math.max(0, 16 - (currTime - raf_lastTime));
		var id = window.setTimeout(function() { callback(currTime + timeToCall); }, timeToCall);
		raf_lastTime = currTime + timeToCall;
		return id;
	};
}	
if (!window.cancelAnimationFrame){
	window.cancelAnimationFrame = function(id) {
		clearTimeout(id);
	};
}
	
/* init */
Storm.init=function(_obj){
	if(_obj.debug==true){	Storm.debug=true;	}else{	Storm.debug=false; }
	
	var divStorm = document.createElement("div");
	divStorm.style.display = "none";
	divStorm.style.position = "absolute";
	divStorm.style.top = "0px";
	divStorm.style.left = "0px";
	divStorm.innerHTML='<canvas id="stageTemp" width="'+_obj.width+'" height="'+_obj.height+'" style="display:none; position:absolute; top:0px; left:0px;"></canvas>';	
	document.body.appendChild(divStorm);
	
	Storm.stage = document.getElementById(_obj.elementId);
	Storm.ctx = Storm.stage.getContext && Storm.stage.getContext('2d');

	Storm.stageTemp = document.getElementById("stageTemp");
	Storm.ctxTemp = Storm.stageTemp.getContext && Storm.stageTemp.getContext('2d');
	
	Storm.activeUser=false;
	Storm.tmEF=false;
	
	Storm.toRAD = Math.PI/180; 
	Storm.aRand=[0.48,0.86,0.53,0.98,0.83,0.4,0.76,0,0.28,0.33,0.56,0.5,0.88,0.6,0.7,0.58,0.68,0.66,0.26,0.1,0.36,0.38,0.43,0.78,0.46,0.8,0.9,0.73,0.2,0.93,0.96,0.3,0.63,1,0.13,0.16,0.18,0.23];
	Storm.idRandom=0;
	
	Storm.stageWidth=_obj.width;
	Storm.stageHeight=_obj.height;
	
	if(_obj.retina==true){ Storm.retina=2; }else{ Storm.retina=1; }
	
	Storm.obj={};
	Storm.bitmaps = {};	
	Storm.completeLoadImages=_obj.complete;

	//- load images
	Storm.numLoadImages = 0;	
	Storm.numTotalImages = _obj.graphics.length;	
	
	if(Storm.numTotalImages==0){
		Storm.numTotalImages();
	}else{
		for(Storm.i=0; Storm.i<Storm.numTotalImages; Storm.i++){
			Storm.n1=_obj.graphics[Storm.i].lastIndexOf("/");
			Storm.n2=_obj.graphics[Storm.i].lastIndexOf(".");
			if(Storm.n1==-1){ Storm.n1=-1; }
			if(Storm.n2==-1){ Storm.n2=_obj.graphics[Storm.i].length; }		
			Storm.str=_obj.graphics[Storm.i].substring(Storm.n1+1, Storm.n2);
			
			Storm.bitmaps[Storm.str] = new Image();
			Storm.bitmaps[Storm.str].onload = function(){
				if(++Storm.numLoadImages >= Storm.numTotalImages){
					Storm.completeLoadImages();
				}
			};
			Storm.bitmaps[Storm.str].src = _obj.graphics[Storm.i];
		}
	}
	
	//- events
	Storm.stage.addEventListener('click', function(event) {
		Storm.mouseX = (event.pageX - Storm.stage.offsetLeft)*Storm.retina;
		Storm.mouseY = (event.pageY - Storm.stage.offsetTop)*Storm.retina;

		for(Storm.tObj in Storm.obj){
			if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){	
				if(Storm.obj[Storm.tObj].bitmap!="" && Storm.obj[Storm.tObj].onClick!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY)){						
					Storm.obj[Storm.tObj].onClick();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.obj[Storm.tObj].onClick!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].width*0.5*Storm.obj[Storm.tObj]._scaleX) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width*0.5*Storm.obj[Storm.tObj]._scaleX) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].height*0.5*Storm.obj[Storm.tObj]._scaleY) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height*0.5*Storm.obj[Storm.tObj]._scaleY)){											
					Storm.obj[Storm.tObj].onClick();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}
			}
		}					
	});
	Storm.stage.addEventListener('mousedown', function(event) {
		Storm.mouseX = (event.pageX - Storm.stage.offsetLeft)*Storm.retina;
		Storm.mouseY = (event.pageY - Storm.stage.offsetTop)*Storm.retina;

		for(Storm.tObj in Storm.obj){
			if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){	
				if(Storm.obj[Storm.tObj].bitmap!="" && Storm.obj[Storm.tObj].onDown!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY)){						
					Storm.obj[Storm.tObj].onDown();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.obj[Storm.tObj].onDown!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].width*0.5) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width*0.5) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].height*0.5) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height*0.5)){						
					Storm.obj[Storm.tObj].onDown();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}
			}
		}					
	});
	Storm.stage.addEventListener('mouseup', function(event) {
		Storm.mouseX = (event.pageX - Storm.stage.offsetLeft)*Storm.retina;
		Storm.mouseY = (event.pageY - Storm.stage.offsetTop)*Storm.retina;

		for(Storm.tObj in Storm.obj){
			if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){	
				if(Storm.obj[Storm.tObj].bitmap!="" && Storm.obj[Storm.tObj].onUp!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2*Storm.obj[Storm.tObj].scaleX) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2*Storm.obj[Storm.tObj].scaleY)){						
					Storm.obj[Storm.tObj].onUp();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.obj[Storm.tObj].onUp!=undefined && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].width*0.5) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width*0.5) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].height*0.5) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height*0.5)){						
					Storm.obj[Storm.tObj].onUp();
					if(Storm.obj[Storm.tObj].breakEvent==true){
						break; 
					}
				}
			}
		}					
	});
	Storm.stage.addEventListener('mouseout', function(event) {
		for(Storm.tObj in Storm.obj){
			if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){
				if(Storm.obj[Storm.tObj].onOut!=undefined){	
					Storm.obj[Storm.tObj].onOut();
				}
			}
		}					
	});
	Storm.stage.addEventListener('mousemove', function(event) {
		Storm.mouseX = (event.pageX - Storm.stage.offsetLeft)*Storm.retina;
		Storm.mouseY = (event.pageY - Storm.stage.offsetTop)*Storm.retina;

		for(Storm.tObj in Storm.obj){
			if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){
				if(Storm.obj[Storm.tObj].onOver!=undefined && Storm.obj[Storm.tObj].onOut!=undefined){	
					if(Storm.obj[Storm.tObj].bitmap!="" && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2)){
						Storm.obj[Storm.tObj].onOver();
					}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].width*0.5*Storm.obj[Storm.tObj]._scaleX) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width*0.5*Storm.obj[Storm.tObj]._scaleX) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].height*0.5*Storm.obj[Storm.tObj]._scaleY) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height*0.5*Storm.obj[Storm.tObj]._scaleY)){
						Storm.obj[Storm.tObj].onOver();	
					}else if(Storm.obj[Storm.tObj].graphics=="circle" && Storm.mouseX>Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].radius*Storm.obj[Storm.tObj].mouseZoneKoef && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].radius*Storm.obj[Storm.tObj].mouseZoneKoef) && Storm.mouseY>Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].radius*Storm.obj[Storm.tObj].mouseZoneKoef && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].radius*Storm.obj[Storm.tObj].mouseZoneKoef)){
						Storm.obj[Storm.tObj].onOver();		
					}else if(Storm.obj[Storm.tObj].stateMouse=="over"){
						Storm.obj[Storm.tObj].onOut();
					}
				}
			}
		}	

		if(Storm.debug==true && Storm.debugTarget!=null){
			Storm.debugTarget.x=Storm.mouseX+Storm.debugX;
			Storm.debugTarget.y=Storm.mouseY+Storm.debugY;
		}
	});
	
	if(Storm.debug==true){
		Storm.debugTarget=null;
		Storm.stage.addEventListener('mousedown', function(event) {
			for(Storm.tObj in Storm.obj){
				if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){
					if(Storm.obj[Storm.tObj].bitmap!="" && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2)){
						Storm.debugTarget=Storm.obj[Storm.tObj];
						Storm.debugX=Storm.obj[Storm.tObj].x-event.pageX - Storm.stage.offsetLeft;
						Storm.debugY=Storm.obj[Storm.tObj].y-event.pageY - Storm.stage.offsetTop;					
					}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.mouseX>Storm.obj[Storm.tObj]._x && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width) && Storm.mouseY>Storm.obj[Storm.tObj]._y && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height)){
						Storm.debugTarget=Storm.obj[Storm.tObj];
						Storm.debugX=Storm.obj[Storm.tObj].x-event.pageX - Storm.stage.offsetLeft;
						Storm.debugY=Storm.obj[Storm.tObj].y-event.pageY - Storm.stage.offsetTop;
					}
				}
			}					
		});
		Storm.stage.addEventListener('mouseup', function(event) {
			if(Storm.debugTarget!=null){
				//trace("x: "+Storm.debugTarget.x+"; y: "+Storm.debugTarget.y);
				Storm.debugTarget=null;		
			}	
		});
		Storm.stage.addEventListener('dblclick', function(event) {
			for(Storm.tObj in Storm.obj){
				if(Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1){
					if(Storm.obj[Storm.tObj].bitmap!="" && Storm.mouseX>(Storm.obj[Storm.tObj]._x-Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].bitmap.width/2) && Storm.mouseY>(Storm.obj[Storm.tObj]._y-Storm.obj[Storm.tObj].bitmap.height/2) && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].bitmap.height/2)){
						Storm.obj[Storm.tObj].visible=false;
						break;	
					}else if(Storm.obj[Storm.tObj].graphics!="" && Storm.mouseX>Storm.obj[Storm.tObj]._x && Storm.mouseX<(Storm.obj[Storm.tObj]._x+Storm.obj[Storm.tObj].width) && Storm.mouseY>Storm.obj[Storm.tObj]._y && Storm.mouseY<(Storm.obj[Storm.tObj]._y+Storm.obj[Storm.tObj].height)){
						Storm.obj[Storm.tObj].visible=false;
						break;
					}
				}
			}	
		});
	}
	
	//- enter frame
	Storm.EF = window.requestAnimationFrame(Storm.Update);
}

/* enterframe */
Storm.Update=function(){
	Storm.DriveDisplayList();
	if(Storm.enterFrame){
		Storm.enterFrame();
	}
	Storm.EF = window.requestAnimationFrame(Storm.Update); 
}

/* utilits */
Storm.Random=function(_n){
	_n*=Storm.aRand[Storm.idRandom];
	Storm.idRandom++;
	if(Storm.idRandom==Storm.aRand.length){ Storm.idRandom=0; }
	return Math.ceil(_n);				
}
function trace(_t){	
	console.log(_t);
}

/* create display objects */
Storm.addChild=function(_obj){
	var _this=this;
	if(_this!=Storm.stage && _this.displayObject!=true){ _this=Storm.stage; }
	_obj.parent=_this;
}
Storm.mask=function(_mask){
	var _this=this;
	_mask.is_mask=true;
	_this.to_mask=_mask;

	for(Storm.tObj in Storm.obj){
		if(Storm.obj[Storm.tObj].parent==_this){
			Storm.obj[Storm.tObj].to_mask=_mask;
		}
	}
} 
Storm.SaveDisplayList=function(){
	for(Storm.tObj in Storm.obj){
		Storm.obj[Storm.tObj].x=Math.ceil(Storm.obj[Storm.tObj].x);
		Storm.obj[Storm.tObj].y=Math.ceil(Storm.obj[Storm.tObj].y);		
		if(Storm.obj[Storm.tObj].reboot!=false){
			Storm.obj[Storm.tObj].m_scaleX=Storm.obj[Storm.tObj].scaleX;
			Storm.obj[Storm.tObj].m_scaleY=Storm.obj[Storm.tObj].scaleY;
			Storm.obj[Storm.tObj].m_alpha=Storm.obj[Storm.tObj].alpha;
			Storm.obj[Storm.tObj].m_visible=Storm.obj[Storm.tObj].visible;
			Storm.obj[Storm.tObj].m_x=Storm.obj[Storm.tObj].x;
			Storm.obj[Storm.tObj].m_y=Storm.obj[Storm.tObj].y;
			Storm.obj[Storm.tObj].m_rotation=Storm.obj[Storm.tObj].rotation;
			Storm.obj[Storm.tObj].m_lineHeight=Storm.obj[Storm.tObj].lineHeight;
			Storm.obj[Storm.tObj].m_ty=Storm.obj[Storm.tObj].ty;
		}
	}		
}
Storm.RebootDisplayList=function(){
	for(Storm.tObj in Storm.obj){
		if(Storm.obj[Storm.tObj].reboot!=false){
			Storm.obj[Storm.tObj].scaleX=Storm.obj[Storm.tObj].m_scaleX;
			Storm.obj[Storm.tObj].scaleY=Storm.obj[Storm.tObj].m_scaleY;
			Storm.obj[Storm.tObj].alpha=Storm.obj[Storm.tObj].m_alpha
			Storm.obj[Storm.tObj].visible=Storm.obj[Storm.tObj].m_visible;
			Storm.obj[Storm.tObj].x=Storm.obj[Storm.tObj].m_x;
			Storm.obj[Storm.tObj].y=Storm.obj[Storm.tObj].m_y;
			Storm.obj[Storm.tObj].rotation=Storm.obj[Storm.tObj].m_rotation;
			Storm.obj[Storm.tObj].lineHeight=Storm.obj[Storm.tObj].m_lineHeight;
			Storm.obj[Storm.tObj].ty=Storm.obj[Storm.tObj].m_ty;
			
			try{ TweenLite.killTweensOf(Storm.obj[Storm.tObj]); }catch(e){}
			try{ TweenMax.killTweensOf(Storm.obj[Storm.tObj]); }catch(e){}
		}
	}		
}

Storm.CreateDisplayList=function(){
	Storm.stage.x=Storm.stage.y=Storm.stage.z=Storm.stage.rotation=0;
	Storm.stage.alpha=Storm.stage.visible=Storm.stage.scaleX=Storm.stage.scaleY=1;
	Storm.stage.parent=Storm.stage;
	Storm.stage.addChild=Storm.addChild;

	for(Storm.tObj in Storm.obj){
		if(Storm.obj[Storm.tObj].displayObject==undefined){ Storm.obj[Storm.tObj].displayObject=true; }
		
		if(Storm.obj[Storm.tObj].x==undefined){ Storm.obj[Storm.tObj].x=0; }
		if(Storm.obj[Storm.tObj].y==undefined){ Storm.obj[Storm.tObj].y=0; }
		if(Storm.obj[Storm.tObj].z==undefined){ Storm.obj[Storm.tObj].z=0; }			
		if(Storm.obj[Storm.tObj].scaleX==undefined){ Storm.obj[Storm.tObj].scaleX=1; }
		if(Storm.obj[Storm.tObj].scaleY==undefined){ Storm.obj[Storm.tObj].scaleY=1; }
		if(Storm.obj[Storm.tObj].rotation==undefined){ Storm.obj[Storm.tObj].rotation=0; }
		if(Storm.obj[Storm.tObj].alpha==undefined){ Storm.obj[Storm.tObj].alpha=1; }
		if(Storm.obj[Storm.tObj].visible==undefined){ Storm.obj[Storm.tObj].visible=true; }		
		if(Storm.obj[Storm.tObj].width==undefined){ Storm.obj[Storm.tObj].width=0; }		
		if(Storm.obj[Storm.tObj].height==undefined){ Storm.obj[Storm.tObj].height=0; }		
		
		if(Storm.obj[Storm.tObj].bitmap==undefined){ Storm.obj[Storm.tObj].bitmap=""; }else{
			if(Storm.obj[Storm.tObj].width==0){ Storm.obj[Storm.tObj].width=Storm.obj[Storm.tObj].bitmap.width; }		
			if(Storm.obj[Storm.tObj].height==0){ Storm.obj[Storm.tObj].height=Storm.obj[Storm.tObj].bitmap.height; }		
		}		
		if(Storm.obj[Storm.tObj].text==undefined){ Storm.obj[Storm.tObj].text=""; }else{
			Storm.obj[Storm.tObj].textLines=Storm.obj[Storm.tObj].text.split('\n');
			for(Storm.i=0; Storm.i< Storm.obj[Storm.tObj].textLines.length; Storm.i++){
				Storm.obj[Storm.tObj]["line_"+Storm.i]={text:Storm.obj[Storm.tObj].textLines[Storm.i],x:0,y:0,alpha:1,rotation:0,scaleX:1,scaleY:1}
			}
		}
		if(Storm.obj[Storm.tObj].graphics==undefined){ Storm.obj[Storm.tObj].graphics=""; }
		if(Storm.obj[Storm.tObj].pattern==undefined){ Storm.obj[Storm.tObj].pattern=""; }
		if(Storm.obj[Storm.tObj].gradient==undefined){ Storm.obj[Storm.tObj].gradient=""; }
		if(Storm.obj[Storm.tObj].video==undefined){ Storm.obj[Storm.tObj].video=""; }
		
		if(Storm.obj[Storm.tObj].is_play==undefined){ Storm.obj[Storm.tObj].is_play=false; }
		
		if(Storm.obj[Storm.tObj].lineHeight==undefined){ Storm.obj[Storm.tObj].lineHeight=20; }
		if(Storm.obj[Storm.tObj].ty==undefined){ Storm.obj[Storm.tObj].ty=0; }
		
		if(Storm.obj[Storm.tObj].fill==undefined){ Storm.obj[Storm.tObj].fill=""; }		
		if(Storm.obj[Storm.tObj].stroke==undefined){ Storm.obj[Storm.tObj].stroke=""; }		
		if(Storm.obj[Storm.tObj].lineWidth==undefined){ Storm.obj[Storm.tObj].lineWidth=1; }		
		
		if(Storm.obj[Storm.tObj].mouseZoneKoef==undefined){ Storm.obj[Storm.tObj].mouseZoneKoef=1; }
		
		if(Storm.obj[Storm.tObj].shadowColor==undefined){ Storm.obj[Storm.tObj].shadowColor=""; }		

		if(Storm.obj[Storm.tObj].parent==undefined){ Storm.obj[Storm.tObj].parent=Storm.stage; Storm.stage.addChild(Storm.obj[Storm.tObj]); }
		if(Storm.obj[Storm.tObj].addChild==undefined){ Storm.obj[Storm.tObj].addChild=Storm.addChild; }
		
		if(Storm.obj[Storm.tObj].repeatX==undefined){ Storm.obj[Storm.tObj].repeatX=1; }
		if(Storm.obj[Storm.tObj].repeatY==undefined){ Storm.obj[Storm.tObj].repeatY=1; }
		
		if(Storm.obj[Storm.tObj].reboot==undefined){ Storm.obj[Storm.tObj].reboot=true; }
		if(Storm.obj[Storm.tObj].is_stop==undefined){ Storm.obj[Storm.tObj].is_stop=true; }
		
		if(Storm.obj[Storm.tObj].mask==undefined){Storm.obj[Storm.tObj].mask=Storm.mask; }
		if(Storm.obj[Storm.tObj].to_mask==undefined){ Storm.obj[Storm.tObj].to_mask=""; }
		if(Storm.obj[Storm.tObj].is_mask==undefined){ Storm.obj[Storm.tObj].is_mask=""; }
	}	
}

Storm.DriveDisplayList=function(){
	Storm.ctx.clearRect(0, 0, Storm.stage.width, Storm.stage.height);
	Storm.ctxTemp.clearRect(0, 0, Storm.stage.width, Storm.stage.height);
	
	Storm.tObjTotal=0; 
	Storm.tObjDrawing=0; 
	for(Storm.tObj in Storm.obj){
		Storm.tObjTotal++;	
		if((Storm.obj[Storm.tObj].bitmap!="" || Storm.obj[Storm.tObj].text!="" || Storm.obj[Storm.tObj].graphics!="" || Storm.obj[Storm.tObj].video!="" || Storm.obj[Storm.tObj].pattern!="" || Storm.obj[Storm.tObj].gradient!="") && (Storm.obj[Storm.tObj].visible==true || Storm.obj[Storm.tObj].visible==1) && (Storm.obj[Storm.tObj].parent.visible==true || Storm.obj[Storm.tObj].parent.visible==1) && Storm.obj[Storm.tObj].alpha>0 && Storm.obj[Storm.tObj].parent.alpha>0  && Storm.obj[Storm.tObj].is_mask==""){						
			if(Storm.obj[Storm.tObj].to_mask!=""){
				Storm.ctxTemp.save();	
				Storm.ctxTemp.clearRect(0, 0, Storm.stage.width-1, Storm.stage.height-1);
				
				Storm.DrawingObject(Storm.obj[Storm.tObj]);	
				Storm.ctxTemp.restore();
				
				Storm.ctxTemp.save(); 		
				Storm.ctxTemp.globalCompositeOperation = "destination-in";
				Storm.DrawingObject(Storm.obj[Storm.tObj].to_mask);	

				Storm.ctxTemp.restore();
				Storm.ctx.drawImage(Storm.stageTemp, 0, 0);
			}else{
				Storm.ctxTemp.clearRect(0, 0, Storm.stage.width-1, Storm.stage.height-1);
				
				Storm.ctxTemp.save();				
				Storm.DrawingObject(Storm.obj[Storm.tObj]);			
				Storm.ctxTemp.restore();
				Storm.ctx.drawImage(Storm.stageTemp, 0, 0);
			}
		}	
	}
}
Storm.DrawingObject=function(_obj){
	//- 
	_obj._x=_obj.x;
	_obj._y=_obj.y;	
	
	_obj._scaleX=_obj.scaleX;
	_obj._scaleY=_obj.scaleY;
	_obj._alpha=_obj.alpha;
	_obj._rotation=_obj.rotation;

	//- 
	Storm.pObj=_obj.parent;
	do{
		if(Storm.pObj.visible==false || Storm.pObj.visible==0 || Storm.pObj.alpha==0){
			_obj._alpha=0;
			break;
		}
		
		_obj.x0=_obj._x//*Storm.pObj.scaleX;
		_obj.y0=_obj._y//*Storm.pObj.scaleY;
		_obj._x = _obj.x0 * Math.cos(Storm.pObj.rotation*Storm.toRAD ) - _obj.y0 * Math.sin(Storm.pObj.rotation*Storm.toRAD );
		_obj._y = _obj.x0 * Math.sin(Storm.pObj.rotation*Storm.toRAD ) + _obj.y0 * Math.cos(Storm.pObj.rotation*Storm.toRAD );						
		_obj._x=_obj._x*Storm.pObj.scaleX;
		_obj._y=_obj._y*Storm.pObj.scaleY;
		
		_obj._x+=Storm.pObj.x;
		_obj._y+=Storm.pObj.y;				
		
		_obj._scaleX*=Storm.pObj.scaleX;
		_obj._scaleY*=Storm.pObj.scaleY;
		_obj._alpha*=Storm.pObj.alpha;
		_obj._rotation+=Storm.pObj.rotation;

		Storm.pObj=Storm.pObj.parent;
	}while(Storm.pObj!=Storm.stage);

	if(_obj._alpha==0){
		
	}else{
		Storm.tObjDrawing++;
		
		//- 	
		Storm.ctxTemp.translate(_obj._x, _obj._y);
		Storm.ctxTemp.rotate(_obj._rotation * Storm.toRAD );
		Storm.ctxTemp.globalAlpha = _obj._alpha;
		Storm.ctxTemp.scale(_obj._scaleX, _obj._scaleY);

		//- 
		if(_obj.text!=""){		
			// Text			
			for(Storm.i=0; Storm.i< _obj.textLines.length; Storm.i++){
				Storm.j=(-( _obj.textLines.length-1)*_obj.lineHeight*0.5+Storm.i*_obj.lineHeight);
				Storm.ctxTemp.translate(0, Storm.j+_obj.ty*(Storm.i+1)*0.3);
				Storm.ctxTemp.translate(_obj["line_"+Storm.i].x, _obj["line_"+Storm.i].y);
				Storm.ctxTemp.globalAlpha =_obj["line_"+Storm.i].alpha;
				Storm.ctxTemp.rotate(_obj["line_"+Storm.i].rotation * Storm.toRAD );
				Storm.ctxTemp.scale(_obj["line_"+Storm.i].scaleX, _obj["line_"+Storm.i].scaleY);

				Storm.ctxTemp.font = _obj.font;
				Storm.ctxTemp.fillStyle = _obj.color;							
				Storm.ctxTemp.textAlign = _obj.align;	
				Storm.ctxTemp.textBaseline = "middle";

				if(_obj.shadowColor!=""){
					Storm.ctxTemp.shadowColor = _obj.shadowColor;
					Storm.ctxTemp.shadowBlur = 0; 
					Storm.ctxTemp.shadowOffsetX = _obj.shadowOffsetX;
					Storm.ctxTemp.shadowOffsetY = _obj.shadowOffsetY;
				}
				if(_obj.stroke!=""){
					Storm.ctxTemp.lineWidth=_obj.lineWidth;
					Storm.ctxTemp.strokeStyle=_obj.stroke;
					Storm.ctxTemp.strokeText( _obj.textLines[Storm.i], 0, 0);
				}				
				Storm.ctxTemp.fillText(_obj.textLines[Storm.i], 0, 0);
				
				Storm.ctxTemp.scale(1/_obj["line_"+Storm.i].scaleX, 1/_obj["line_"+Storm.i].scaleY);
				Storm.ctxTemp.rotate(-_obj["line_"+Storm.i].rotation * Storm.toRAD );				
				Storm.ctxTemp.globalAlpha = _obj._alpha;
				Storm.ctxTemp.translate(-_obj["line_"+Storm.i].x, -_obj["line_"+Storm.i].y);
				Storm.ctxTemp.translate(0, -Storm.j);
			}
		}else if(_obj.video!="" && _obj.is_play==true){
			// Video
			Storm.ctxTemp.drawImage(_obj.video, 0, 0, _obj.width, _obj.height);
		}else if(_obj.graphics=="rect"){
			// Rectangle
			if(_obj.fill!=""){
				Storm.ctxTemp.fillStyle=_obj.fill;
				Storm.ctxTemp.fillRect(-_obj.width*0.5, -_obj.height*0.5, _obj.width, _obj.height); 
			}
			if(_obj.stroke!=""){
				Storm.ctxTemp.beginPath();
				Storm.ctxTemp.lineWidth=_obj.lineWidth;
				Storm.ctxTemp.strokeStyle=_obj.stroke;
				Storm.ctxTemp.rect(0, 0, _obj.width, _obj.height); 
				Storm.ctxTemp.stroke();
			}
		}else if(_obj.graphics=="circle"){
			// Circle
			Storm.ctxTemp.beginPath();
			Storm.ctxTemp.arc(0, 0, _obj.radius, 0, 2 * Math.PI, false);
			 
			if(_obj.shadowColor!=""){
				Storm.ctxTemp.shadowColor = _obj.shadowColor;
				Storm.ctxTemp.shadowBlur = _obj.shadowBlur;
				Storm.ctxTemp.shadowOffsetX = -1;
				Storm.ctxTemp.shadowOffsetY = -1;
			}		
			if(_obj.fill!=""){
				Storm.ctxTemp.fillStyle=_obj.fill;
				Storm.ctxTemp.fill(); 
			}
			if(_obj.stroke!=""){
				Storm.ctxTemp.lineWidth=_obj.lineWidth;
				Storm.ctxTemp.strokeStyle=_obj.stroke;
				Storm.ctxTemp.stroke();
			}		
		}else if(_obj.pattern!=""){
			// Pattern
			Storm.ctxTemp.fillStyle=Storm.ctxTemp.createPattern(_obj.pattern, 'repeat');
			Storm.ctxTemp.fillRect(0, 0, _obj.width, _obj.height);	
		}else if(_obj.gradient!=""){
			// Gradient
			var tpgr = Storm.ctxTemp.createLinearGradient(0, 0, 0, _obj.height);
			tpgr.addColorStop(0, "rgba("+_obj.gradient+", 1)");		
			tpgr.addColorStop(1, "rgba("+_obj.gradient+", 0)");	
			Storm.ctxTemp.fillStyle=tpgr;
			Storm.ctxTemp.fillRect(0, 0, _obj.width, _obj.height);	
		}else if(_obj.bitmap!=""){
			// Bitmap
			if(_obj.shadowColor!=""){
				Storm.ctxTemp.shadowColor = _obj.shadowColor;
				Storm.ctxTemp.shadowBlur = _obj.shadowBlur;
				Storm.ctxTemp.shadowOffsetX = _obj.shadowOffsetX;
				Storm.ctxTemp.shadowOffsetY = _obj.shadowOffsetY;
			}	
			
			for(Storm.i=0; Storm.i<_obj.repeatX; Storm.i++){
				for(Storm.j=0; Storm.j<_obj.repeatY; Storm.j++){
					Storm.ctxTemp.drawImage(_obj.bitmap, -Math.ceil(_obj.bitmap.width/2+_obj.bitmap.width*Storm.i), -Math.ceil(_obj.bitmap.height/2+_obj.bitmap.height*Storm.j));
				}
			}
		}
	}
}