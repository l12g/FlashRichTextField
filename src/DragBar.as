package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class DragBar extends Sprite {
		private var bar:Sprite;
		private var val:Number;
		private var isBar:Boolean;
		private var dy:Number;
		private var by:Number;
		private var w:Number, h:Number;
		
		public function DragBar() {
			super();
			w = 8;
			h = 100;
			
			bar = new Sprite();
			buttonMode = true;
			addChild(bar);
			
			draw();
			
			addEventListener(Event.ADDED_TO_STAGE, added);
			bar.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
					bar.alpha = .8;
				});
			bar.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
					if (!isBar)
						bar.alpha = 1;
				});
			
			addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			val = 0;
		}
		
		private function onUp(e:MouseEvent):void {
			isBar = false;
			bar.alpha = 1;
		}
		
		private function onDown(e:MouseEvent):void {
			dy = mouseY;
			by = bar.y;
			if (e.target == bar) {
				isBar = true;
				bar.alpha = .8;
			} else {
				value = (mouseY - bar.height / 2) / (height - bar.height);
			}
		}
		
		override public function get height():Number {
			return h;
		}
		
		override public function set height(value:Number):void {
			h = value;
			draw();
		}
		
		private function draw():void {
			graphics.clear();
			graphics.beginFill(0xcccccc,.3);
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			drawBar();
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added);
			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
		
		}
		
		private function onMove(e:MouseEvent):void {
			if (isBar) {
				value = (mouseY - dy + by) / (height - bar.height);
			}
		}
		
		private function drawBar():void {
			bar.graphics.clear();
			bar.graphics.beginFill(0xcccccc);
			bar.graphics.drawRect(0, 0, w, 20);
			bar.graphics.endFill();
		}
		
		public function set value(v:Number):void {
			val = v;
			if (val >= 1)
				val = 1;
			if (val <= 0)
				val = 0;
			
			bar.y = (height - bar.height) * val;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get value():Number {
			return val;
		}
		
		public function get drag():Sprite {
			return bar;
		}
	
	}

}