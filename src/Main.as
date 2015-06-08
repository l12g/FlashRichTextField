package {
	import com.bit101.components.FPSMeter;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import fl.text.TLFTextField;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.net.URLRequest;
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
			//var sp:Shape = new Shape();
			//sp.graphics.beginFill(0x00ffff);
			//sp.graphics.drawCircle(0, 0, 5);
			//sp.graphics.endFill();
			//
			var rt:RT2 = new RT2();
			addChild(rt);
			
			//var loader:Loader = new Loader();
			//loader.load(new URLRequest("TestRTF.swf"));
			//addChild(loader);
		
		}
	
	}

}