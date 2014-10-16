package com.shrimp.guide.interfaces
{
	import com.shrimp.guide.vo.GuideInfoData;

	public interface IArrow
	{
		function set data(value:GuideInfoData):void;
		function dispose():void;
	}
}