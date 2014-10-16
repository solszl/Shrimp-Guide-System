package com.shrimp.guide
{
	import com.shrimp.framework.core.ApplicationBase;
	import com.shrimp.framework.log.Logger;
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.constants.GuideCMD;
	import com.shrimp.guide.interfaces.IGuide;
	import com.shrimp.guide.utils.GuideResource;
	import com.shrimp.guide.vo.GuideInfoData;
	import com.thirdparts.greensock.TweenNano;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 *	新手引导服务类
	 * 	该类执行步骤
	 *  1：安装数据
	 * 	2：按步骤执行（按照vo 去判断相应逻辑）
	 * @author Sol
	 *
	 */
	public class GuideServices extends Component
	{
		/**	新手引导执行完毕的时候 调取的回调*/
		public var allFinishCallBK:Function;
		private static var _instance:GuideServices;

		private var _guides:Array = null;
		private var _currentGuide:IGuide;
		private var _currentIndex:int;

		/**
		 *
		 * @return
		 */
		public static function getInstance():GuideServices
		{
			if (!_instance)
			{
				_instance = new GuideServices();
			}
			return _instance;
		}

		/**
		 *
		 * @throws Error
		 */
		public function GuideServices()
		{
			if (_instance)
			{
				throw new Error("GuideServices instance has already been constructed!");
			}

			_instance = this;
			//初始化必要数据
			initNecessaryData();
		}

		private function initNecessaryData():void
		{
			StageManager.stage.addEventListener(Event.RESIZE, onStageResize);
		}

		public function initStage():void
		{
			GuideResource.init();
		}

		/**
		 *
		 * @return
		 */
		public function listResponderinterests():Array
		{
			var arr:Array = [];
			arr.push(GuideCMD.CC_GUIDE_NEXT);
			arr.push(GuideCMD.CC_GUIDE_RENDEROVER);
			arr.push(GuideCMD.CC_GUIDE_LOADCOMPLETE);
			return arr;
		}


		/**
		 *
		 * @param action
		 * @param arg
		 */
		public function handleResponder(action:String, ... arg):void
		{
			switch (action)
			{
				case GuideCMD.CC_GUIDE_NEXT:
					trace("next");
					break;
				case GuideCMD.CC_GUIDE_RENDEROVER:
					trace("guide :: render over");
					startGuide();
					break;
				case GuideCMD.CC_GUIDE_LOADCOMPLETE:
					trace("guide :: assets load complete");
					startGuide();
					break;
			}
		}

		/**	设置引导*/
		public function setupGuideData(data:Array):void
		{
			this.dispose();
			this._guides = data;
			_currentIndex = 0;
		}

		/**	获得引导总步数*/
		public function getGuideCount():int
		{
			if (this._guides == null)
				return 0;
			return this._guides.length;
		}

		/**
		 *
		 */
		public function next():void
		{
			gotoStep(_currentIndex++);
		}

		/**	从当前引导继续*/
		public function startGuide():void
		{
			gotoStep(_currentIndex);
			_currentIndex++;
		}

		public function preGuide():void
		{
			gotoStep(--_currentIndex);
			_currentIndex++;
		}

		/**	跳转到指定步骤*/
		public function gotoAppointStep(index:int):void
		{
			_currentIndex = index;
			gotoStep(_currentIndex);
			_currentIndex++;
		}

		private function gotoStep(stepIndex:int):void
		{
			if (stepIndex >= getGuideCount() || stepIndex == -1)
			{
				dispose();
				if (allFinishCallBK != null)
				{
					allFinishCallBK();
					allFinishCallBK = null;
				}
				return;
			}

			var data:GuideInfoData = this._guides[stepIndex];
			if (data == null)
			{
				Logger.getLogger('GuideServices').error("guide data is null");
				return;
			}

			this._currentGuide = getGuide(data);
			this._currentGuide.start();
		}

		private function getGuide(data:GuideInfoData):IGuide
		{
			var iG:IGuide = GuideFactory.getGuideType(data);
			iG.guideData = data;
			return iG;
		}

		public function removeCurrentGuide():void
		{
			if (this._currentGuide != null)
			{
				this._currentGuide.over();
			}
		}

		private function cleanData():void
		{
			_currentIndex = 0;
			removeCurrentGuide();
			this._guides = null;
		}

		public function dispose():void
		{
			cleanData();
		}

		public function onStageResize(event:Event = null):void
		{
			super.updateDisplayList();
			width = StageManager.getStageWidth();
			height = StageManager.getStageHeight();
			if (!this._currentGuide)
				return;

			//由于新手引导stage.resize事件添加比 舞台baseview的晚， 所以当舞台发生改变，堆栈原理，先触发新手引导的stageresize.
			//但是此时原组件还没有进行stageresize事件调度，所以取到了 原来的值。、
			//这里延迟执行，目的是为了让 baseview的resize事件先触发。从而讲component的属性进行更新。
			//再进行新手引导的舞台改变事件 进行新手引导的重绘工作 
			//fix by Sol 2013-09-29
			TweenNano.delayedCall(.2, this._currentGuide.resize);
		}

		/**
		 *	返回当前引导步骤数据
		 * @return
		 *
		 */
		public function getCurrentGuideData():GuideInfoData
		{
			if (this._guides)
				return this._guides[_currentIndex];

			return null
		}
	}
}
