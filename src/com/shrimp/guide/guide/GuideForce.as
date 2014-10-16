package com.shrimp.guide.guide
{
	import com.shrimp.framework.log.Logger;
	import com.shrimp.framework.managers.PanelManager;
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.GuideRepository;
	import com.shrimp.guide.GuideServices;
	import com.shrimp.guide.arrow.GuideArrowFactory;
	import com.shrimp.guide.interfaces.IArrow;
	import com.shrimp.guide.interfaces.IGuide;
	import com.shrimp.guide.utils.GuideResource;
	import com.shrimp.guide.vo.GuideInfoData;
	import com.shrimp.guide.vo.GuideModel;
	import com.thirdparts.greensock.TweenNano;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	public class GuideForce implements IGuide
	{
		//timer控件轮询次数
		private static const REPEAT_COUNT:int= 10;
		private var _data:GuideInfoData;
		private var _mask:Sprite;
		private var _rect:Rectangle;
		private var _p:Point;
		private var _arrow:IArrow;
		private var _comp:Component;

		private var _loader:Loader;
		
		private var _skipTimer:Timer;

		public function GuideForce()
		{
			_skipTimer = new Timer(7000,1);
			_skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,onSkipTimer);
		}

		public function set guideData(data:GuideInfoData):void
		{
			this._data=data;
		}

		public function start():void
		{
			if (this._data == null)
			{
				throw new ArgumentError("data is null force");
//				return;
			}
			
			if (this._data.panelId != 0 && this._data.panelId != GuideModel.getInstance().panelId)
			{
				GuideModel.getInstance().panelId=this._data.panelId;
				TweenNano.delayedCall(.3, startImpl);
				return;
			}else{
				GuideModel.getInstance().panelId=this._data.panelId;
			}

			if (this._data.swfId != 0)
			{
				var url:String=GuideResource.getGuideSWF("guide_" + this._data.swfId);
				_loader=new Loader();
				var urlreq:URLRequest=new URLRequest(url);
				_loader.load(urlreq);
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMcLoaded);

			}
			startImpl();
		}

		private function startImpl():void
		{
			if(!this._data){
				clear();
				return;
			}

			clear();
			maskShape();
			_arrow=GuideArrowFactory.getGuideType(this._data);
			_arrow.data=this._data;
			drawHole()
			resize();
			StageManager.stage.addEventListener(MouseEvent.CLICK, stageClickHandler, true, 0, true);
			
			//设置 跳过流程
			_skipTimer.start();
		}



		public function over():void
		{
			clear();
			this._data=null;
		}

		/**	设置遮罩层*/
		private function maskShape():void
		{
			if (!_mask)
			{
				_mask=new Sprite();
			}
			if (StageManager.stage.contains(_mask))
			{
				StageManager.stage.removeChild(_mask);
			}
			if(this._data==null)
			{
				return;
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,this._data.alpha/100);
			_mask.graphics.drawRect(0, 0, StageManager.getStageWidth(), StageManager.getStageHeight());
			StageManager.stage.addChild(_mask);
		}
		private var hasCircle:Boolean=false;

		private function stageClickHandler(event:MouseEvent):void
		{
			trace("you had click stage");
			
			if (hasCircle)
			{
				var p1:Point=new Point(this._data.targetX, this._data.targetY);
				var p2:Point=new Point(event.stageX, event.stageY);
				if (Point.distance(p1, p2) <= this._data.targetW)
				{
					clear();
					TweenNano.delayedCall(.3, GuideServices.getInstance().next);
				}
				return;
			}
			//按钮矩形如果为空
			if (this._rect == null)
				return;
			//点击区域不在矩形内
			if (!this._rect.contains(event.stageX, event.stageY))
				return;
			//点击目标不是基于component的
			if (!(event.target is Component))
				return;
			//只有，点击点在组件区域内才执行
			if ((event.target as Component).guideName == this._data.componentId)
			{
				if (this._data.componentId.indexOf("closebtn") > 0)
				{
					trace("GuideForce---closeAllPanel()");
					PanelManager.getInstance().closeAllPanel();
				}
				clear();					
				GuideServices.getInstance().next();

//				_comp=null;
			}
//			event.stopImmediatePropagation();
		}

		private function clear():void
		{
			trace("clean  guide");
			hasCircle=false;
			if (_mask)
			{
				this._mask.graphics.clear();
			}
			if (_rect)
				this._rect=null;
			if (_arrow)
			{
				if(StageManager.stage.contains(_arrow as DisplayObject))
				{
					StageManager.stage.removeChild(_arrow as DisplayObject);
				}
				this._arrow.dispose();
				this._arrow=null;
			}
			if (_mc2)
			{
				if(StageManager.stage.contains(_mc2))
				{
					_mc2.stop();
					StageManager.stage.removeChild(_mc2);
					_mc2=null;
				}
			}

			if (StageManager.stage.hasEventListener(MouseEvent.CLICK))
			{
				StageManager.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler, true);
			}
			
			if(_comp)
			{
				TweenNano.killTweensOf(_comp.parent,true);
				_comp=null;
			}
			
			_skipTimer.reset();
		}

		public function setArrVisible(b:Boolean):void
		{
			if (!_arrow)
				return;
			(_arrow as DisplayObject).visible=b;
		}

		public function resize():void
		{
			redraw();
		}

		private function redraw():void
		{
			if (!_mask)
				return;

			if (null == _comp)
				return;
			_comp.invalidateDisplayList();
			_comp.invalidateProperties();
			var p:Point=_comp.localToGlobal(new Point());
			_mask.graphics.clear();
//			_mask.graphics.lineStyle(1, 0x000000, .5);
			_mask.graphics.beginFill(0, this._data.alpha/100);
			_mask.graphics.drawRect(0, 0, StageManager.getStageWidth(), StageManager.getStageHeight());
			_rect=new Rectangle(p.x, p.y, _comp.width, _comp.height);
			_mask.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);
			if(_arrow)
			{
				adjustArrow(p);
			}
			if(_mc2)
			{
				adjustMc(p);
			}
		}

		private var _timer:Timer;
		private var _createComp:Boolean=false;

		private function onTimer(event:TimerEvent):void
		{
			if(_data==null)
				return;
			
			_comp=GuideRepository.getInstance().getRegComponent(_data.componentId);
			if (_comp && _comp.stage && _comp.visible)
			{
				_createComp=true;
				_timer.reset();
				resize();
				drawHole();
			}
			if (_timer.currentCount >= REPEAT_COUNT)
			{
				Logger.getLogger("guide").fatal("get component timeout! repeat Count:", _timer.repeatCount)
				_timer.reset();
				clear();
			}
		}

		private function drawHole():void
		{
			_comp=GuideRepository.getInstance().getRegComponent(_data.componentId);
			if (!_comp||!_comp.stage)
			{
				if (!_timer)
					_timer=new Timer(300, REPEAT_COUNT);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
			}
			else
			{
				_createComp=true;
			}
			if (!_createComp)
				return;
			_createComp=false;
			GuideServices.getInstance().onStageResize();
			_comp.invalidateDisplayList();
			_comp.invalidateProperties();
			_comp.validateNow();
			var p:Point=_comp.localToGlobal(new Point(_comp.x,_comp.y));
			if(_arrow)
			{
				StageManager.stage.addChild(_arrow as DisplayObject);
				adjustArrow(p);
			}
			if(_mc2)
			{
				adjustMc(p);
			}
			_rect=new Rectangle(p.x, p.y, _comp.width, _comp.height);
			if (_rect == null)
			{
				this._mask.graphics.clear();
				return;
			}

			if (_rect)
			{
				_mask.graphics.drawRect(_rect.x, _rect.y, _rect.width, _rect.height);

				//_comp.filters = [];
				//TweenMax.to(_comp,0.6,{glowFilter:{color:ColorUtil.RGB_YELLOWY,alpha:1,blurX:20, blurY:20,inner:true,strength:2},yoyo:true,repeat:-1});
			}
			if (hasCircle)
			{
				_mask.graphics.drawCircle(_data.targetX, _data.targetY, _data.targetW);
			}
			resize();
		}

		private var _mc2:MovieClip;
		//战斗中的引导
		private function onMcLoaded(event:Event):void
		{
			_mc2=new (_loader.contentLoaderInfo.applicationDomain.getDefinition(this._data.swfId.toString()) as Class)
			_loader.unloadAndStop();
			if (_comp)
			{
				var p:Point=_comp.localToGlobal(new Point());
				_mc2.x=p.x;
				_mc2.y=p.y;
				StageManager.stage.addChild(_mc2);
//				_comp.addType("arrow", _data.guideType.toString());
//				ColorUtil.removeAllFilter(_comp);
//				_comp.addGuide(_mc2);
			}
		}
		
		private function adjustArrow(p:Point):void
		{
			if(this._data.guideType%2==1)
			{
				(_arrow as DisplayObject).y = p.y+_comp.height*.5;
				var tempX:Number = (this._data.guideType==3||this._data.guideType==7)?_comp.width:0;
				(_arrow as DisplayObject).x = p.x+tempX;
			}
			else
			{
				var tempY:Number = this._data.guideType==4?_comp.height:0;
				(_arrow as DisplayObject).y = p.y+tempY;
				(_arrow as DisplayObject).x = p.x+_comp.width*.5;
			}
			
		}
		
		private function adjustMc(p:Point):void
		{
			_mc2.x = p.x;
			_mc2.y = p.y;
		}
		
		private function onSkipTimer(event:TimerEvent):void
		{
			_skipTimer.stop();
		}
		
		private function skipGuide(event:MouseEvent=null):void
		{
			GuideServices.getInstance().dispose();
			_skipTimer.reset();
		}
	}
}
