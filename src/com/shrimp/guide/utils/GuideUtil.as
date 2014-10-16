package com.shrimp.guide.utils
{
	import com.shrimp.framework.load.ResourceDomain;
	import com.shrimp.framework.log.Logger;
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.interfaces.IArrow;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;

	public class GuideUtil
	{
		public static function calcArrowPos(rect:Rectangle, arrow:IArrow, guideType:int):void
		{
			if (!rect || !arrow)
			{
				Component(arrow).visible=false;
				return;
			}
			var xpos:Number;
			var co:DisplayObject=arrow as DisplayObject;
			if (guideType == 1)
			{
				xpos=rect.x - (arrow as Component).width;
			}
			else if (guideType == 2)
			{
				xpos=rect.width + rect.x;
			}
			else if (guideType == 3)
			{
				xpos=rect.x - (arrow as Component).width;
			}

			var ypos:Number=(rect.height - (arrow as Component).height) / 2 + rect.y;
			if (ypos + (arrow as Component).height >= StageManager.getStageHeight())
				ypos=StageManager.getStageHeight() - (arrow as Component).height;
			(arrow as Component).move(xpos, ypos);
			StageManager.stage.addChild(arrow as DisplayObject);
			arrow=null;
		}

		public static function calcArrowPosCircle(targetX:int, targetY:int, radius:int, arrow:IArrow):void
		{
			var xpos:Number;
			var ypos:Number;
			var co:DisplayObject=arrow as DisplayObject;
			xpos=targetX - radius - (arrow as Component).width;
			ypos=targetY - (arrow as Component).height / 2;
			if (ypos + (arrow as Component).height >= StageManager.getStageHeight())
				ypos=StageManager.getStageHeight() - (arrow as Component).height;
			(arrow as Component).move(xpos, ypos);
			StageManager.stage.addChild(arrow as DisplayObject);
		}

		private static var mc:MovieClip;

		public static function addBlurEffect(rect:Rectangle):void
		{
			//暂时不加。。。我不知道显示规则是什么……好汗啊……
			return;
			if(rect==null)
				return;
			if(rect.height==0||rect.width==0)
			{
				Logger.getLogger("guidedUtil").warning("特效框矩形存在问题,height:",rect.height,",width:",rect.width);
			}
			if (!mc)
			{
				mc=ResourceDomain.getDomainInstance("guideDomain","guide_rect") as MovieClip;
			}
			mc.x=rect.x;
			mc.y=rect.y;
			mc.width=rect.width;
			mc.height=rect.height;
			if (StageManager.stage.contains(mc))
				StageManager.stage.removeChild(mc);
			StageManager.stage.addChild(mc);
		}
		
		public static function removeBlurEffect():void
		{
			if(!mc)
				return;
			if(!StageManager.stage.contains(mc))
				return;
			StageManager.stage.removeChild(mc);
		}
	}
}
