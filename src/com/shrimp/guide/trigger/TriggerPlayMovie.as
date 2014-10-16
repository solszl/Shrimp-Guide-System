package com.shrimp.guide.trigger
{
	import com.shrimp.framework.managers.PanelManager;
	import com.shrimp.framework.managers.StageManager;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setTimeout;

	/**
	 *	触发播放swf
	 * @author Sol
	 *
	 */
	public class TriggerPlayMovie
	{
		private static var loader:Loader;
		private static var timeId:uint;
		private static var mc:MovieClip;

		//SWF的id
		public static function play(movieId:String):void
		{
			if(!loader)
				loader=new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onMovieLoaded);
			loader.load(new URLRequest(movieId));
		}

		private static function onMovieLoaded(e:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onMovieLoaded);
			mc=loader.content as MovieClip;
			StageManager.stage.addChild(mc);
			mc.gotoAndPlay(1);

			timeId=setTimeout(playOver, mc.totalFrames / StageManager.stage.frameRate * 1000);
		}

		private static function playOver(event:*=null):void
		{
			clearInterval(timeId);
			dispose();
			PanelManager.getInstance().closeAllPanel();
		}

		private static function dispose():void
		{
			if (mc != null)
			{
				StageManager.stage.removeChild(mc);
				mc=null;
			}

			if (loader != null)
			{
				loader.unloadAndStop();
				loader=null;
			}
		}
	}
}
