package {
	//import fl.controls.UIScrollBar;
	import fl.text.TLFTextField;
	import flash.events.Event;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.IEditManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.StatusChangeEvent;
	
	/**
	 * 使用 STLFTextField 类创建使用文本布局框架 (TLF) 的高级文本显示功能的文本字段。
	 * STLFTextField 对象与 TextField 对象类似，但 STLFTextField 对象可以利用 flashx 包中包含的 TLF 类的属性和方法。TLF 提供了大量格式选项和功能。
	 * @author Jimhy
	 */
	public class STLFTextField extends TLFTextField {
		//最大段落数
		private var _maxParagraph:uint = 0;
		
		public function STLFTextField() {
			super();
		}
		
		private function tlfEventHandle(e:Event):void {
			super.textFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 过滤段落数达到最大值时文本的段落
		 */
		private function filtrationPar():void {
			if (_maxParagraph == 0)
				return;
			if (textFlow.numChildren > _maxParagraph) {
				for (var i:uint = 0; i < textFlow.numChildren - _maxParagraph; i++) {
					textFlow.removeChildAt(0);
				}
			}
		}
		
		/**
		 * 在文本中插入图片
		 * @param        src                图片的路径或者库里面的MC实例
		 * @param        width        图片的宽，默认是图片宽度
		 * @param        height        图片的高，默认是图片的高度
		 */
		public function insertImg(src:Object, width:Object = "auto", height:Object = "auto"):void {
			if (!textFlow.hasEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE))
				super.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, tlfEventHandle);
			IEditManager(super.textFlow.interactionManager).insertInlineGraphic(src, width, height);
			super.textFlow.interactionManager.setFocus();
			super.textFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 将一段XML格式的TLF信息以字符串形式导入
		 * 这个值如:
		 * private const headingMarkup:String = "<flow:TextFlow xmlns:flow='http://ns.adobe.com/textLayout/2008'>" +
		   "<flow:p textAlign='center'>" +
		   "<flow:span fontFamily='Georgia' fontSize='36'>Ethan Brand</flow:span><flow:br/>" +
		   "<flow:span fontSize='8' fontStyle='italic'>by </flow:span>" +
		   "<flow:span fontSize='12' fontStyle='italic'>Nathaniel Hawthorne</flow:span>" +
		   "</flow:p>" +
		   "</flow:TextFlow>";
		 */
		public function importToTLF(value:String):void {
			if (!textFlow.hasEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE))
				super.textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGE, tlfEventHandle);
			if (textFlow.hasEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE))
				super.textFlow.removeEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, tlfEventHandle);
			super.textFlow.addEventListener(CompositionCompleteEvent.COMPOSITION_COMPLETE, tlfEventHandle);
			var tlf:TextFlow = TextConverter.importToFlow(value, TextConverter.TEXT_LAYOUT_FORMAT);
			var elm:FlowElement = tlf.getChildAt(0);
			textFlow.addChild(elm);
			filtrationPar();
			super.textFlow.flowComposer.updateAllControllers();
		}
		
		/**
		 * 设置文本格式
		 */
		public function setTextLayoutformat(fontFamily:String = "宋体", fontSize:uint = 12, color:uint = 0):void {
			textFlow.fontFamily = fontFamily;
			textFlow.fontSize = fontSize;
			textFlow.color = color;
		}
		
		/**
		 * 清除所有子元素
		 */
		public function clearElements():void {
			while (super.textFlow.numChildren) {
				super.textFlow.removeChildAt(0);
			}
		}
		
		/**
		 * 设置最大段落数
		 * 如果设置了最大段落数后，当段落数到达最大段落数时，文本会从最开始加入文本的段落中删除多余的段落。
		 */
		public function set maxParagraph(value:uint):void {
			_maxParagraph = value;
		}
		
	}

}