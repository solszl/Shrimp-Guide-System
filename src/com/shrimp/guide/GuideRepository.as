package com.shrimp.guide
{
	import com.shrimp.framework.log.Logger;
	import com.shrimp.framework.ui.controls.core.Component;

	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 *	引导仓库，仓库里存放被点击控件的guideName和所处坐标
	 * @author Sol
	 *
	 */
	public class GuideRepository
	{
		private static var _instance:GuideRepository;
		private static var _guideTargets:Dictionary;

		public static function getInstance():GuideRepository
		{
			if (!_instance)
			{
				_instance = new GuideRepository();
			}
			return _instance;
		}

		public function GuideRepository()
		{
			if (_instance)
			{
				throw new Error("GuideRepository instance has already been constructed!");
			}
			_instance = this;
			_guideTargets = new Dictionary();
		}

		/**
		 *	注册按钮名称
		 * @param guideName 引导按钮名称
		 * @param target	目标组件
		 *
		 */
		public function registPosition(guideName:String, target:DisplayObject):void
		{
			if (guideName == "")
			{
				throw new Error("can't regist guide component, guide name is null or empty! guideName:" + guideName);
			}
			if (target == null)
			{
				throw new Error("can't regist guide compoent, target component is null,guideName:" + guideName);
			}
			var rect:Rectangle = getCompoentBounds(target);
			_guideTargets[guideName] = rect;
			Logger.getLogger('注册引导组件(按名称)').info(guideName, rect.x, rect.y, rect.width, rect.height);
		}

		public function registRect(guideName:String, rect:Rectangle):void
		{
			if (guideName == "")
			{
				throw new Error("can't regist guide component, guide name is null or empty!");
			}
			if (rect == null)
			{
				throw new Error("can't regist guide compoent, rect is null");
			}
			_guideTargets[guideName] = rect;
			Logger.getLogger('注册引导组件(按形状)').info(guideName, rect.x, rect.y, rect.width, rect.height);
		}

		public function registComponent(guideName:String, comp:Component):void
		{
			if ("" == guideName)
			{
				throw new Error("can't regist guide component, guide name is null or empty!");
			}
			if (null == comp)
			{
				throw new Error("can't regist guide compoent, component is null");
			}
			_guideTargets[guideName] = comp;
			Logger.getLogger('注册引导组件').info(guideName, comp);
		}

		/**
		 *	通过引导名称卸载引导位置
		 * @param guideName
		 *
		 */
		public function unregistPosition(guideName:String):void
		{
			_guideTargets[guideName] = null;
			delete _guideTargets[guideName];
		}

		/**
		 *	通过引导名称返回引导位置
		 * @param guideName	引导组件名称
		 * @return 返回组件位置
		 *
		 */
		public function getTargetPosition(guideName:String):Rectangle
		{
			trace(_guideTargets[guideName]);
			if (!_guideTargets[guideName])
				Logger.getLogger("GuideRepository").error("Error::	while get component from repository!!!", guideName);
			var rect:Rectangle = _guideTargets[guideName] as Rectangle;
			return rect;
		}

		public function getRegComponent(guideName:String):Component
		{
			if (!_guideTargets[guideName])
				Logger.getLogger("GuideRepository").error("Error::	while get component from repository!!!", guideName);
			var comp:Component = _guideTargets[guideName] as Component;
			return comp;
		}

		/**
		 *	获取带有笔触的大小，组件的 矩形框。
		 * @param target 	组件
		 * @return 矩形框
		 * 此方法返回的x,y,width,height可能不是整数。可能是这样的,使用的时候。只好取整一下。 避免过多的精度计算。 导致性能降低
		 * bound.getBounds(bound);
		 *	trace(bound); // (x=-10, y=-24.1, w=134.10000000000002, h=134.1)
		 * bound.getRect(bound);
		 *	trace(rect);     // (x=0, y=0, w=100, h=100)
		 *
		 */
		private function getCompoentBounds(target:DisplayObject):Rectangle
		{
			var rect:Rectangle = target.getBounds(target);
			if (rect.width == 0 || rect.height == 0)
			{
				Logger.getLogger("GuideRepository").warning("while regist guide component, with or height maybe go wrong. width:", rect.width, ",height:", rect.height);
			}
			var p:Point = target.localToGlobal(new Point());
			rect.x = p.x;
			rect.y = p.y;
			return rect;
		}
	}
}
