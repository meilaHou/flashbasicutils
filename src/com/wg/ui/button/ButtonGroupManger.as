package com.wg.ui.button
{
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	/**
	 *按钮组管理类,管理所有的按钮组, 
	 * @author Allen
	 * 
	 */
	public class ButtonGroupManger
	{
		private var currentBtn:LittleButton
		private var buttonGroupXML:XML;
		private var btnArray:Array;
		private var btnArrDic:Dictionary;//存储Array
		private var btnNum:int;
		private static var _instance:ButtonGroupManger;
		public function ButtonGroupManger():void
		{
			if(_instance)
			{
				return;
			}
			init();
		}
		
		public static function get instance():ButtonGroupManger
		{
			if(!_instance) _instance = new ButtonGroupManger();
			return _instance;
		}

		public function init():void
		{
			btnArray = new Array();
			btnArrDic = new Dictionary();
		}
		
		/**
		 *重置按钮组里的所有子按钮为初始状态; 
		 * @param parentMc
		 * 
		 */
		public function resetState(parentMc:Sprite):void
		{
			if(btnArrDic[parentMc])
			{
				for (var i:int = 0; i < btnArrDic[parentMc].length; i++) 
				{
					(btnArrDic[parentMc][i] as LittleButton).gotoStartState();
				}
			}
		}
		/**
		 *改变按钮组的按钮的状态; 
		 * @param btn
		 * @return 
		 * 
		 */
		public function changeState(btn:*,index:int = 0):Boolean
		{
			if(!(btn is LittleButton)&&btnArrDic[btn])
			{
				btn = btnArrDic[btn][index] as LittleButton;
			}
			var isGroupBtn:Boolean = false;
			if(btnArrDic[btn.content.parent])
			{
				for (var i:int = 0; i < btnArrDic[btn.content.parent].length; i++) 
				{
					if(btnArrDic[btn.content.parent][i]==btn)
					{
						(btn.content.parent as MovieClip).clickbtn = btn;
						btn.changeState(LittleButton.ALREADYCLICK);
//						btn.state = LittleButton.ALREADYCLICK;
						isGroupBtn = true;
					}else
					{
						//改变按钮组中的其他按钮状态;
						if((btnArrDic[btn.content.parent][i] as LittleButton).state ==  LittleButton.ALREADYCLICK)
						{
							btnArrDic[btn.content.parent][i].changeState(LittleButton.UNCLICK);
						}
						
					}
				}
			}
			return isGroupBtn;
		}
		/**
		 *获取当前按钮组的按钮; 
		 * @param parentmc
		 * @return 
		 * 
		 */
		public function getCurrentButton(parentmc:MovieClip):LittleButton
		{
			return 	parentmc.clickbtn;
		}
				
		public function dispose():void
		{
			
		}
		public function addBtn(btn:LittleButton):void
		{
			if(!btnArrDic[btn.content.parent])
			{
				btnArrDic[btn.content.parent] = new Array();
			}
			
			btnArrDic[btn.content.parent].push(btn);
		}
		
		public function removeBtn(btn:LittleButton):void
		{
			if(btnArrDic[btn.content.parent])
			{
				for (var i:int = 0; i < btnArrDic[btn.content.parent].length; i++) 
				{
					if(btnArrDic[btn.content.parent][i]==btn)
					{
						(btnArrDic[btn.content.parent] as Array).splice(i,1);
					}
				}
			}else
			{
				trace("没有添加 按钮组");
			}
			
			
		}
	}
}