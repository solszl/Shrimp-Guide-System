package com.shrimp.guide.arrow
{
	import com.shrimp.guide.arrow.GuideArrow;
	import com.shrimp.guide.interfaces.IArrow;
	import com.shrimp.guide.vo.GuideInfoData;
	import com.shrimp.guide.constants.GuideArrowType;

	/**
	 *	箭头工厂类
	 * @author Sol
	 *
	 */
	public class GuideArrowFactory
	{
		private static const guideArrow:GuideArrow=new GuideArrow();
		private static const guideGirl:GuideGirl=new GuideGirl();

		public function GuideArrowFactory()
		{
			throw new Error("class::GuideArrowFactory cannot create instance");
		}

		public static function getGuideType(data:GuideInfoData):IArrow
		{
			if (data == null)
				throw new Error("argument: data is null");

			//通过指定标识，返回特定的引导类型
			var iguide:IArrow=getArrow(data);
			return iguide;
		}

		private static function getArrow(data:GuideInfoData):IArrow
		{
			var arrow:IArrow;
			switch (data.guideType)
			{
				case GuideArrowType.ARROWLEFT:
				case GuideArrowType.ARROWRIGHT:
					arrow=guideArrow;
					break;
				case GuideArrowType.ARROWGIRL:
					arrow=guideGirl;
					break;
			}
			return arrow;
		}
	}
}
