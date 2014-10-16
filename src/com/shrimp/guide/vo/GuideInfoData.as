package com.shrimp.guide.vo
{
	public class GuideInfoData extends Object
	{
		/** 功能id */
		public var funcId:int;
		/** 步骤id */
		public var stepId:int;
		/** 箭头类型 */
		public var guideType:int;
		/** 区域id */
		public var areaId:String;
		/** 组件id */
		public var componentId:String;
		/** tips */
		public var guideText:String;
		/** 是否结束id */
		public var isComplete:int;
		/** 板子id */
		public var panelId:int;
		/** 动画id */
		public var swfId:int;
		/** 引导强度 */
		public var guideForce:int;
		/**  x坐标 */
		public var targetX:int;
		/**  Y坐标 */
		public var targetY:int;
		/** 目标宽度 */
		public var targetW:int;
		/** 目标高度 */
		public var targetH:int;
		/** 图形状态 */
		public var shapeState:int;
		/** 透明度 */
		public var alpha:int;
		/** 透明度 */
		public var gmDisplay:String;
	}
}