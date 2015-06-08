package {
	import fl.text.TLFTextField;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.elements.TextRange;
	import flashx.textLayout.events.SelectionEvent;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class RichText extends Sprite {
		private var tlf:TLFTextField;
		private var flow:TextFlow;
		private var manager:EditManager;
		private var w:Number, h:Number;
		private var drag:DragBar;
		private var bgColor:uint;
		private var control:Control;
		private var line:Shape;
		
		public function RichText() {
			super();
			control = new Control(this);
			control.addEventListener(Event.COMPLETE, onUIComplete);
			control.addEventListener(Control.FORMAT_CHANGE, onSetFormat);
			w = 200;
			h = 300;
			bgColor = 0xffffffff;
			
			tlf = new TLFTextField();
			tlf.width = w;
			tlf.height = h;
			tlf.multiline = true;
			tlf.wordWrap = true;
			tlf.type = TextFieldType.INPUT;
			tlf.alwaysShowSelection = true;
			flow = tlf.textFlow;
			
			addChild(tlf);
			
			drag = new DragBar();
			addChild(drag);
			drag.x = w - drag.width;
			
			drag.addEventListener(Event.CHANGE, onDrag);
			drag.visible = tlf.pixelMaxScrollV > tlf.height;
			
			manager = flow.interactionManager as EditManager;
			tlf.addEventListener(Event.CHANGE, onTextChange);
			tlf.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			tlf.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
			
			line = new Shape();
			addChild(line);
			
			
			
			addEventListener(Event.ADDED_TO_STAGE, added);
		}
		
		private function added(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, added);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSelectionChange);
		}
		
		private function onSelectionChange(e:MouseEvent):void 
		{
			var old:SelectionState = manager.getSelectionState();
			if (old == null) return;
			
			if (old.absoluteStart != old.absoluteEnd) {
				
				var f:TextLayoutFormat = manager.getCommonCharacterFormat(new TextRange(flow,old.anchorPosition,old.activePosition));
				trace(f.color);
				//manager
				control.setFormat(f);
				
			}
		}
		
		private function onSetFormat(e:Event):void {
			setSelectionFormat(control.getFormat());
		}
		
		private function onUIComplete(e:Event):void {
			tlf.y = control.height;
			draw();
			drag.height = height;
			drag.y = control.height;
			drag.x = w - drag.width;
			flow.hostFormat = control.getFormat();
		}
		
		private function onWheel(e:MouseEvent):void {
			drag.value = tlf.pixelScrollV / tlf.pixelMaxScrollV;
		}
		
		private function onTextInput(e:TextEvent):void {
			flow.invalidateAllFormats();
			onTextChange(null);
		}
		
		private function onTextChange(e:Event):void {
			drag.value = tlf.pixelScrollV / tlf.pixelMaxScrollV;
			drag.visible = tlf.pixelMaxScrollV > 0;
		}
		
		private function onDrag(e:Event):void {
			tlf.pixelScrollV = drag.value * tlf.pixelMaxScrollV;
		}
		
		public function draw():void {
			
			graphics.clear();
			graphics.beginFill(bgColor, .2);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
			line.graphics.clear();
			line.graphics.lineStyle(1, 0xcccccc);
			line.graphics.drawRect(0, 0, width, height + control.height);
			line.graphics.moveTo(0, control.height);
			line.graphics.lineTo(width, control.height);
			line.graphics.endFill();
		}
		
		override public function get width():Number {
			return w;
		}
		
		override public function set width(value:Number):void {
			w = value;
			draw();
			drag.x = w - drag.width;
			tlf.width = w;
		
		}
		
		override public function get height():Number {
			return h;
		}
		
		override public function set height(value:Number):void {
			h = value;
			draw();
			drag.height = height;
			drag.y = h / 2 - drag.height / 2;
			tlf.height = h;
		}
		
		/**
		 * 追加文本到尾部
		 * @param	text
		 */
		public function appendText(text:String):void {
			//var span:SpanElement = new SpanElement();
			//span.text = text;
			//
			//var para:ParagraphElement = new ParagraphElement();
			//para.addChild(span);
			//flow.addChild(para);
			//
			//flow.flowComposer.updateAllControllers();
		
		}
		
		public function insertImage(src:Object, imgWidth:Object = "auto", imgHeight:Object = "auto"):void {
			manager.insertInlineGraphic(src, imgWidth, imgHeight, null);
			flow.invalidateAllFormats();
			flow.flowComposer.updateAllControllers();
		}
		
		public function updateAll():void {
			flow.flowComposer.updateAllControllers();
		
		}
		
		public function setSelectionFormat(format:TextLayoutFormat):void {
			//tlf.defaultTextFormat = format;
			var old:SelectionState = manager.getSelectionState();
			if (old == null) return;
			if (old.absoluteStart == old.absoluteEnd) {
				old.pointFormat = format;
				manager.applyLeafFormat(format);
			} else {
				manager.applyLeafFormat(format, old);
				manager.selectRange(old.anchorPosition, old.activePosition);
			}
			manager.setFocus();
		}
		
		public function hasSelection():Boolean {
			return manager.hasSelection();
		}
		
		public function get htmlText():String {
			return "";
			//return TextConverter.export(flow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE).toString();
		}
	
	}

}