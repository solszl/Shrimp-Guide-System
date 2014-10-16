package com.shrimp.guide.utils
{
	public class GuideResource
	{
		
		private static var base_path:String;
		public static function init(basePath:String="/"):void
		{
			base_path = basePath;
		}
								
		public static function getGuideImage(id:int):String
		{
			return "";
		}
		
		public static function getGuideSWF(id:String,format:String=".swf"):String
		{
			return "";
		}
	}
}