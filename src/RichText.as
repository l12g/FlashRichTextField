package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.ConversionType;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionState;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.undo.UndoManager;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class RichText extends Sprite {
		private var rc:Sprite;
		
		private var flowContainer:ContainerController;
		private var flow:TextFlow;
		private var bgColor:uint;
		private var isEdit:Boolean;
		private var manager:EditManager;
		private var w:Number, h:Number;
		
		public function RichText() {
			super();
			w = 200;
			h = 300;
			bgColor = 0xff0000;
			rc = new Sprite();
			addChild(rc);
			
			
			flowContainer = new ContainerController(rc, w, h);
			flowContainer.backgroundColor = 0xcccccc;
			flow = new TextFlow();
			flow.flowComposer.addController(flowContainer);
	
			flow.flowComposer.updateAllControllers();
			
			draw();
			
			rc.x = 1;
			rc.y = 3;
			
			addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
				
				//var old:SelectionState = manager.getSelectionState();
				//trace(old);
				//manager.selectRange(old.anchorPosition, old.activePosition);
			} );
		}
		

		public function draw():void {
			graphics.clear();
			graphics.beginFill(bgColor,.2);
			graphics.drawRect(0, 0, w+1, h+5);
			graphics.endFill();
		}
		
		override public function get width():Number {
			return w;
		}
		
		override public function set width(value:Number):void {
			w = value;
			flowContainer.setCompositionSize(w, h);
			draw();
		}
		
		override public function get height():Number {
			return h;
		}
		
		override public function set height(value:Number):void {
			h = value;
			flowContainer.setCompositionSize(w, h);
			draw();
		}
		
		/**
		 * 追加文本到尾部
		 * @param	text
		 */
		public function appendText(text:String):void {
			var span:SpanElement = new SpanElement();
			span.text = text;
			
			var para:ParagraphElement = new ParagraphElement();
			para.addChild(span);
			flow.addChild(para);
			
			flow.flowComposer.updateAllControllers();
		
		}
		
		
		public function insertImage(src:Object,imgWidth:Object="auto",imgHeight:Object="auto"):void {
			if (manager == null)
				return;
				
			manager.insertInlineGraphic(src, imgWidth, imgHeight);
			flow.flowComposer.updateAllControllers();
		}
		
		public function updateAll():void {
			flow.flowComposer.updateAllControllers();
			flow.invalidateAllFormats();
		}
		
		
		/**
		 * 是否可编辑
		 */
		public function set editable(v:Boolean):void {
			isEdit = v;
			if (isEdit) {
				manager ||= new EditManager(new UndoManager());
				flow.interactionManager = manager;
				manager.selectRange(0, 0);
				var old:SelectionState = manager.getSelectionState();
				manager.applyLeafFormat(null, old);
			} else {
				flow.interactionManager = null;
			}
		}
		
		public function get editable():Boolean {
			return isEdit;
		}
		
		public function setSelectionFormat(format:TextLayoutFormat):void {
			if (manager == null)
				return;
			if (!manager.hasSelection())
				return;
				
			var old:SelectionState = manager.getSelectionState();
			manager.applyLeafFormat(format, old);
			manager.setFocus();
			manager.selectRange(old.anchorPosition, old.activePosition);
			
			trace(flow.hostFormat);
		}
		
		public function hasSelection():Boolean {
			return manager.hasSelection();
		}
		
		public function get htmlText():String {
			return TextConverter.export(flow, TextConverter.TEXT_LAYOUT_FORMAT, ConversionType.XML_TYPE).toString();
		}
	
	}

}