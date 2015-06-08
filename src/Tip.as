package {
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class Tip extends Sprite {
		private var txt:TextField; //标签
		private var format:TextFormat; //文本格式
		private var con:DisplayObjectContainer;
		private var timer:Timer;
		
		public function Tip() {
			super();
			txt = new TextField();
			format = new TextFormat("微软雅黑", 12, 0x0);
			format.align = "left";
			txt.mouseEnabled = false;
			//txt.wordWrap = true;
			txt.autoSize = "left";
			txt.defaultTextFormat = format;
			addChild(txt);
			txt.background = true;
			txt.multiline = true;
			//txt.wordWrap = true;
			mouseChildren = false;
			mouseEnabled = false;
			filters = [new DropShadowFilter(4, 45, 0, .5)];
		}
		
		public function set container(value:DisplayObjectContainer):void {
			con = value;
		}
		
		public function set tip(value:String):void {
			txt.text = value;
		}
		public function show(x:Number, y:Number):void {
			if (con) {
				con.addChild(this);
				this.x = x;
				this.y = y;
			} else {
				trace("在使用前应先指定container属性");
			}
		}

		
		public function hide():void {
			if (parent) {
				parent.removeChild(this);
			}
		}
	
	}

}