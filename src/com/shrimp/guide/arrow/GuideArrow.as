package com.shrimp.guide.arrow
{
	import com.shrimp.framework.load.ResourceDomain;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.interfaces.IArrow;
	import com.shrimp.guide.vo.GuideInfoData;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.text.TextField;

	/**
	 *	引导箭头
	 * @author Sol
	 *
	 */
	public class GuideArrow extends Component implements IArrow
	{
		public function GuideArrow(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0)
		{
			super(parent, xpos, ypos);
			this.mouseEnabled=false;
			this.mouseChildren=false;
		}

		private var bg1:MovieClip;

		public function set content(value:String):void
		{
			var disobj:DisplayObject;
			if (value != "")
			{
				bg1.visible=true;
				bg1.txtContent.text=value;//"<P>"++"</P>";
				bg1.play();
			}

		}

		public function dispose():void
		{
			bg1.visible=false;
			//do sth.
		}

		private var mc:MovieClip;
		private var _data:GuideInfoData;
		public function set data(value:GuideInfoData):void
		{
			this._data = value;
			bg1=ResourceDomain.getDomainInstance("guide",'guide00'+this._data.guideType) as MovieClip
			bg1.visible=false;
			addChild(bg1);
			setActualSize(bg1.width, bg1.height);
			content=value.guideText;
		}
	}
}
