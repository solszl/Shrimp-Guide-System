package com.shrimp.guide.guide
{
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.controls.core.Style;
	import com.shrimp.guide.GuideServices;
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
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 *	点击任意地方进行下一步
	 * @author Sol
	 *
	 */
	public class GuideDoAny implements IGuide
	{
		public function GuideDoAny()
		{
		}

		private var _data:GuideInfoData;

		public function set guideData(data:GuideInfoData):void
		{
			this._data=data;
		}

		public function start():void
		{
			if (this._data == null)
			{
				throw new ArgumentError("data is null: click any where");
			}

			if (this._data.panelId != 0)
			{
				GuideModel.getInstance().panelId=this._data.panelId;
				TweenNano.delayedCall(.3, startImpl);
			}
			else
			{
				GuideModel.getInstance().panelId=this._data.panelId;
				startImpl();
			}
			
		}

		private var content:DisplayObject;
		private var _loader:Loader;
		private var isLoading:Boolean=false;
		private var preSwfId:int=-1;
		private var isOpen:Boolean=false;
		private var swfPlayOver:Boolean = true;

		private function startImpl():void
		{
			//防止同一个图片加载多次，出现闪烁的现象。
			if (preSwfId == this._data.swfId && isLoading)
			{
				trace("isloading------")
				return;
			}

			if (preSwfId == this._data.swfId && content)
			{
				trace("haveone-----")
				return;
			}

			isOpen=true;

			makeMask();
			StageManager.stage.addEventListener(MouseEvent.CLICK, stageClickHandler, true, 0, true);

			if (!this._data.swfId)
			{
				return;
			}

			var format:String;
			if (this._data.swfId < 100)
			{
				format=".jpg"
			}
			else if (this._data.swfId < 1000)
			{
				format=".png";
			}
			else
			{
				format=".swf"
			}

			if (!_loader)
			{
				_loader=new Loader();
				_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMcLoaded);
			}
			var url:String=GuideResource.getGuideSWF("guide_" + this._data.swfId, format);
			var urlreq:URLRequest=new URLRequest(url);
			_loader.load(urlreq);

			isLoading=true;
			preSwfId=this._data.swfId;
		}

		private function onMcLoaded(event:Event):void
		{
			isLoading=false;
			if (!isOpen)
			{
				return;
			}
			content=_loader.contentLoaderInfo.content;
			content.x=(StageManager.getStageWidth() - content.width) / 2;
			content.y=(StageManager.getStageHeight() - content.height) / 2;
			StageManager.stage.addChild(content);
			if(content is MovieClip){
				swfPlayOver = false;
				var mc:MovieClip = content as MovieClip;
				mc.addFrameScript(mc.totalFrames-2,function():void{swfPlayOver = true});
			}

			if (this._data == null)
				return;

			if (this._data.swfId > 10 && this._data.swfId < 1000)
			{
				createTextarea();
				ta.text=this._data.guideText;
			}
		}

		//点击任意地方进行下一步
		private function stageClickHandler(event:MouseEvent):void
		{
			//要等swf播完
			if(!swfPlayOver){
				return;
			}
			clear();
			isOpen=false;
			GuideServices.getInstance().next();
		}
		//遮罩。用来接收鼠标事件
		private var _mask:Sprite;

		private function makeMask():void
		{
			if (!_mask)
			{
				_mask=new Sprite();
			}
			if (StageManager.stage.contains(_mask))
			{
				StageManager.stage.removeChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.lineStyle(1, 0x000000, .5);
			_mask.graphics.beginFill(0, .5);
			_mask.graphics.drawRect(0, 0, StageManager.getStageWidth(), StageManager.getStageHeight());
			StageManager.stage.addChild(_mask);
			_mask.graphics.lineStyle(2, 0xFF0000);
		}

		public function over():void
		{
			clear();
			this._data=null;
//			PanelManager.getInstance().closeAllPanel();
		}

		private function clear():void
		{
			if (_mask)
				this._mask.graphics.clear();

			if (content && StageManager.stage.contains(content))
			{
				StageManager.stage.removeChild(content);
				content=null;
			}

			if (StageManager.stage.hasEventListener(MouseEvent.CLICK))
			{
				StageManager.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler, true);
			}

			if (ta && StageManager.stage.contains(ta))
			{
				ta.text="";
				StageManager.stage.removeChild(ta);
				ta=null;
			}
		}

		public function setArrVisible(b:Boolean):void
		{

		}

		public function resize():void
		{

		}

		private var ta:TextField
		private var taisCreated:Boolean=false;

		private function createTextarea():void
		{
			if (!ta)
				ta=new TextField();
			ta.x=content.x + 205;
			ta.y=content.y + 8;
			ta.width = 230;
			ta.height = 60;
			var tf:TextFormat = ta.defaultTextFormat;
			tf.size =Style.fontSize + 2;
			tf.bold=true;
			tf.leading=3;
			tf.font="Microsoft YaHei";
			tf.letterSpacing=1;
			ta.defaultTextFormat=tf;
			StageManager.stage.addChild(ta);
		}
	}
}
