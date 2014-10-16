package com.shrimp.guide.interfaces
{
	import com.shrimp.guide.vo.GuideInfoData;

	/**
	 * 新手引导接口，该接口实现
	 * @author Sol
	 *
	 */
	public interface IGuide
	{
		function set guideData(data:GuideInfoData):void;
		function start():void;
		function over():void;
		function resize():void;
	}
}
