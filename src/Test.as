package {
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.undo.UndoManager;
	import flashx.textLayout.formats.TextAlign;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class Test extends Sprite {
		
		public function Test() {
			super();
			//var container:ContainerController = new ContainerController(this, 400, 400);
			//var editor:EditManager = new EditManager(new UndoManager());
			//
			//
			//var flow:TextFlow = new TextFlow();
			//flow.flowComposer.addController(container);
			//flow.interactionManager = editor;
			//
			//
			//var p1:ParagraphElement = new ParagraphElement();
			//var t1:SpanElement = new SpanElement();
			//t1.text = "Hello World";
			//p1.addChild(t1);
			//
			//flow.addChild(p1);
			//
			//flow.flowComposer.updateAllControllers();
			//
			//
			//stage.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void { 
			//editor
			//
			//} );
			
			var rtf:RichText = new RichText();
			addChild(rtf);
			rtf.y = 20;
			
			rtf.width = 400;
			rtf.editable = true;
			//rtf.editable = false;
			//rtf.appendText("Hello World,TextFlow");
			//rtf.appendText("---Hello World\nTextFlow");
			
			var hb:HBox = new HBox(this);
			var btn:PushButton = new PushButton(hb, 0, 0, "right", function(e:MouseEvent):void {
					if (rtf.hasSelection()) {
						var format:TextLayoutFormat = new TextLayoutFormat();
						format.color = 0x00ff00;
						format.fontSize = 20;
						format.textAlign = TextAlign.CENTER;
						rtf.setSelectionFormat(format);
						trace(rtf.htmlText);
					}
					
					//
				});
				
			var b2:PushButton = new PushButton(hb, 0, 0, "insert image",function(e:MouseEvent):void{
				
				rtf.insertImage("sk.jpg");
			})
			var b3:PushButton = new PushButton(hb, 0, 0, "updateAll",function(e:MouseEvent):void{
				
				rtf.updateAll();
			})
		}
	
	}

}