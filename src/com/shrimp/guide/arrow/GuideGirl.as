package com.shrimp.guide.arrow
{
	import com.shrimp.framework.load.ResourceDomain;
	import com.shrimp.framework.ui.controls.Image;
	import com.shrimp.framework.ui.controls.TextArea;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.interfaces.IArrow;
	import com.shrimp.guide.vo.GuideInfoData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.TextField;

	/**
	 *	引导大妞
	 * @author Sol
	 *
	 */
	public class GuideGirl extends Component implements IArrow
	{
		public function GuideGirl(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			setActualSize(623,238);
		}
		
		private var bg:Bitmap;
		private var girl:Bitmap;
		private var ta:TextField;
		override protected function createChildren():void
		{
			super.createChildren();
			//背景
			bg=new Bitmap(getDisobjBitmap("guide_bg"));
			bg.x = 97;
			bg.y = 114;
			//大妞
			girl=new Bitmap(getDisobjBitmap("guide_npc"));
			//文本框
			ta=new TextField();
			ta.width = 310;
			ta.height = 80;
			ta.selectable=false;
			ta.x = 238;
			ta.y =132;
			addChild(bg);
			addChild(girl);
			addChild(ta);
			
		}

		public function set data(value:GuideInfoData):void
		{
			ta.text = value.guideText;
			bg.bitmapData =getDisobjBitmap("guide_bg");//"Embed('/../t_art/guideAssets/BG.png')";
			girl.bitmapData=getDisobjBitmap("guide_npc");//"Embed('/../t_art/guideAssets/npc.png')";
		}
		
		public function dispose():void
		{
			ta.text="";
			bg.bitmapData.dispose();
			girl.bitmapData.dispose();
		}
		
		private function getDisobjBitmap(key:String):BitmapData
		{
			var c:BitmapData=ResourceDomain.getDomainInstance("guideDomain",key);
			var bmpd:BitmapData=c == null ? null : c;
			return bmpd;
		}
	}
}
