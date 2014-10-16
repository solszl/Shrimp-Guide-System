package com.shrimp.guide.guide
{
	import com.shrimp.framework.managers.StageManager;
	import com.shrimp.framework.ui.controls.core.Component;
	import com.shrimp.guide.GuideRepository;
	import com.shrimp.guide.GuideServices;
	import com.shrimp.guide.arrow.GuideArrowFactory;
	import com.shrimp.guide.interfaces.IArrow;
	import com.shrimp.guide.interfaces.IGuide;
	import com.shrimp.guide.utils.GuideUtil;
	import com.shrimp.guide.vo.GuideInfoData;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 *	具有条件性的引导
	 * 	该引导行为为：如果不点引导步骤，仍然可以进行游戏。 但是回到指定界面，仍然会指向指定组件。
	 * 
	 * 因为弱引导 目前仅存在于 副本指引，故特殊处理，再场景切换的时候判断是否存在新手引导步骤，且为指引副本区域来进行相应的引导步骤
	 * @author Sol
	 *
	 */
	public class GuideUnforce implements IGuide
	{
		private var _data:GuideInfoData;
		private var _rect:Rectangle;

		public function GuideUnforce()
		{
		}

		public function set guideData(data:GuideInfoData):void
		{
			this._data=data;
		}

		public function start():void
		{
			if (this._data == null)
			{
				throw new ArgumentError("data is null：unforce");
			}

//			if (PanelManager.getInstance().isOpen(this._data.panelId))
//			{
//				TweenNano.delayedCall(.2, startImpl);
//				return;
//			}

			startImpl();
		}

		private var _arrow:IArrow;

		private function startImpl():void
		{
			clear();
			_arrow=GuideArrowFactory.getGuideType(this._data);
			_arrow.data=this._data;
			switch(this._data.shapeState)
			{
				//默认取组件坐标
				case 0:
					_rect=GuideRepository.getInstance().getTargetPosition(_data.componentId);
					GuideUtil.addBlurEffect(_rect);
					break;
				//矩形
				case 1:
					_rect=new Rectangle(_data.targetX,_data.targetY,_data.targetW,_data.targetH);
					GuideUtil.addBlurEffect(_rect);
					break;
				default:
					break;
			}
			setArrVisible(true);
			GuideUtil.calcArrowPos(_rect,_arrow,this._data.guideType);
			StageManager.stage.addEventListener(MouseEvent.CLICK, stageClickHandler, true, 0, true);
		}

		private function stageClickHandler(event:MouseEvent):void
		{
			var comp:Component = event.target as Component;
			if(comp==null)
				return;
			if(comp.guideName==null)
				return;
			if(comp.guideName==this._data.componentId)
			{
				GuideServices.getInstance().next();
			}
			clear();
			return;
		}
		private var _mask:Sprite;
		private function clear():void
		{
			trace("clean  guide");
			if (_rect)
				this._rect=null;
			if (_arrow)
			{
				this._arrow.dispose();
				this._arrow=null;				
			}
			if (_mask)
			{
				_mask.graphics.clear();
				StageManager.stage.removeChild(_mask);
				_mask=null;
			}
			GuideUtil.removeBlurEffect();
			if (StageManager.stage.hasEventListener(MouseEvent.CLICK))
			{
				StageManager.stage.removeEventListener(MouseEvent.CLICK, stageClickHandler,true);
			}
		}

		private function calcArrowPosition():void
		{
			if (!this._rect || !this._arrow)
				throw new Error("component rect or arrow is null");
			var xpos:Number;
			if (this._data.guideType == 1)
			{
				xpos=this._rect.x - (this._arrow as Component).width;
			}
			else if (this._data.guideType == 2)
			{
				xpos=this._rect.width + this._rect.x;
			}
			else if(this._data.guideType==3)
			{
				xpos=this._rect.x - (this._arrow as Component).width;
			}

			var ypos:Number=(this._rect.height - (this._arrow as Component).height) / 2 + this._rect.y;
			(this._arrow as Component).move(xpos, ypos);
		}

		public function over():void
		{
			clear();
			this._data=null;
		}
		
		public function setArrVisible(b:Boolean):void
		{
			if(!_arrow)
				return;
			(_arrow as DisplayObject).visible=b;
		}
		
		public function resize():void
		{
			
		}
	}
}
