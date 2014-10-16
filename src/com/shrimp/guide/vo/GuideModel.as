package com.shrimp.guide.vo
{
	public class GuideModel
	{
		private static var _instance:GuideModel;
		
		public static function getInstance():GuideModel
		{
			if(!_instance)
			{
				_instance = new GuideModel();
			}
			
			return _instance;
		}
		
		public function GuideModel()
		{
			if(_instance)
			{
				throw new Error("guide model is singleton");
			}
			
			_instance = this;
		}
		
		public var panelId:int;
	}
}