package {
	import com.bit101.components.FPSMeter;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import fl.text.TLFTextField;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.text.TextFormat;
	import flashx.textLayout.edit.EditManager;
	import flashx.undo.UndoManager;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class Main extends Sprite {
		
		public function Main() {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var sp:Shape = new Shape();
			sp.graphics.beginFill(0x00ffff);
			sp.graphics.drawCircle(0, 0, 5);
			sp.graphics.endFill();
			
			//var textFlow:TextFlow = TextConverter.importToFlow( "How now brown cow.", TextConverter.PLAIN_TEXT_FORMAT );
			//textFlow
			//textFlow.flowComposer.addController( new ContainerController( this ));
			//var editManager:EditManager = new EditManager( new UndoManager() );
			//textFlow.interactionManager = editManager;
			//textFlow.flowComposer.updateAllControllers();
			//
			//editManager.selectRange( 0, 0 );
			//editManager.insertInlineGraphic( new URLRequest("sk.jpg"), 30, 30 );
			
			//addChild(new FPS(w));
			Style.embedFonts = false;
			
			var tlf:TLFTextField = new TLFTextField();
			tlf.y = 30;
			tlf.width = 400;
			tlf.height = 400;
			tlf.graphics.beginFill(0xcccccc, .5);
			tlf.graphics.drawRect(0, 0, tlf.width, tlf.height);
			tlf.graphics.endFill();
			tlf.multiline = true;
			tlf.wordWrap = true;
			
			var editor:EditManager = new EditManager(new UndoManager());
			tlf.textFlow.interactionManager = editor;
			editor.selectRange(0, 0);
			editor.insertInlineGraphic("sk.jpg", 20, 20);
			
			addChild(tlf);
			tlf.textFlow.flowComposer.updateAllControllers();
			
			addEventListener(Event.ENTER_FRAME, function(e:Event):void {
				//tlf.textFlow.flowComposer.updateAllControllers();
				//editor.selectRange( 0, 0 );
				//editor.selectRange( tlf.text.length, tlf.text.length );
				});
			
			tlf.addEventListener(TextEvent.TEXT_INPUT, function(e:TextEvent):void {
				//editor.refreshSelection();
					tlf.textFlow.flowComposer.updateToController();
				});
			
			var hb:HBox = new HBox(this);
			var addImg:PushButton = new PushButton(hb, 0, 0, "添加图片", function(e:MouseEvent):void {
					editor.insertInlineGraphic("sk.jpg", Math.random() * 20 + 20, Math.random() * 20 + 20);
					tlf.textFlow.flowComposer.updateToController();
					//tlf.caretIndex = tlf.text.length;
					editor.setFocus();
				});
			
			var format:TextFormat = new TextFormat();
			var leftAlign:PushButton = new PushButton(hb, 0, 0, "左对齐", function(e:MouseEvent):void {
				format.align = "left";
				tlf.setTextFormat(format,tlf.selectionBeginIndex,tlf.selectionEndIndex);
				});
			var rightAlign:PushButton = new PushButton(hb, 0, 0, "右对齐", function(e:MouseEvent):void {
				});
			var centerAlign:PushButton = new PushButton(hb, 0, 0, "剧中对齐", function(e:MouseEvent):void {
				});
		
		}
	
	}

}