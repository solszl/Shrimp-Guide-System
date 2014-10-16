package com.shrimp.guide
{
	import com.shrimp.framework.log.Logger;
	import com.shrimp.guide.constants.GuideType;
	import com.shrimp.guide.guide.GuideDoAny;
	import com.shrimp.guide.guide.GuideForce;
	import com.shrimp.guide.guide.GuideUnforce;
	import com.shrimp.guide.interfaces.IGuide;
	import com.shrimp.guide.vo.GuideInfoData;

	/**
	 *	引导工厂类
	 * @author Sol
	 *
	 */
	public class GuideFactory
	{
		private static const forceGuide:GuideForce = new GuideForce();
		private static const unforceGuide:GuideUnforce = new GuideUnforce();
		private static const anyGuide:GuideDoAny = new GuideDoAny();

		public function GuideFactory()
		{
			throw new Error("class::GuideFactory cannot create instance");
		}

		/**
		 * 通过工厂用数据返回指定类型的引导方式
		 * @param data
		 * @return
		 * r
		 */
		public static function getGuideType(data:GuideInfoData):IGuide
		{
			if (data == null)
				throw new Error("argument: data is null");

			var iguide:IGuide;
			//通过指定标识，返回特定的引导类型
			iguide = getGuide(data);
			return iguide;
		}

		private static function getGuide(data:GuideInfoData):IGuide
		{
			var guide:IGuide;
			switch (data.guideForce)
			{
				case GuideType.ANYGUIDE:
					guide = anyGuide;
					break;
				case GuideType.FORCE:
					guide = forceGuide;
					break;
				case GuideType.UNFORCE:
					guide = unforceGuide;
					break;
				default:
					Logger.getLogger("Guide").error("unknown guide type:", data.guideType, ",guide moudle:", data.funcId, ",guide step:", data.stepId);
					break;
			}
			return guide;
		}
	}
}
