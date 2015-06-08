package {
	import com.bit101.components.ComboBox;
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextDecoration;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	/**
	 * ...
	 * @author lerry
	 */
	public class Control extends HBox {
		public static const FORMAT_CHANGE:String = "fc";
		[Embed(source = "assets/assets.swf", mimeType = "application/octet-stream")]
		private var UIAssets:Class;
		
		private var ui:MovieClip;
		private var color:DisplayObject;
		private var format:TextLayoutFormat;
		private var bold:PushButton;
		private var itlc:PushButton;
		private var under:PushButton;
		private var al:PushButton;
		private var ac:PushButton;
		private var ar:PushButton;
		private var bullet:PushButton;
		private var font:ComboBox;
		private var size:ComboBox;
		private var alignRadio:Array;
		
		private var self:Boolean;
		
		private var tip:Tip = new Tip();
		
		public function Control(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0) {
			super(parent, xpos, ypos);
			spacing = 1;
			
			var loader:Loader = new Loader();
			loader.loadBytes(new UIAssets());
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadUIComplete);
			
			format = new TextLayoutFormat();
			format.fontFamily = "微软雅黑";
			format.fontSize = 12;
			
			self = true;
		}
		
		private function onLoadUIComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, onLoadUIComplete);
			ui = e.target.content as MovieClip;
			init();
		}
		
		private function getUI(str:String):DisplayObject {
			var cl:Class = ui.loaderInfo.applicationDomain.getDefinition(str) as Class;
			return new cl() as DisplayObject;
		}
		
		private function init():void {
			alignRadio = [];
			color = getUI("fl.controls.ColorPicker");
			addChild(color);
			bold = getBtn(getUI("Bold_UI"));
			itlc = getBtn(getUI("Italic_UI"));
			under = getBtn(getUI("Under_UI"));
			al = getBtn(getUI("AlignLeft_UI"));
			ac = getBtn(getUI("AlignCenter_UI"));
			ar = getBtn(getUI("AlignRight_UI"));
			bullet = getBtn(getUI("Bullet_UI"));
			font = new ComboBox(this, 0, 0, "微软雅黑", getFonts());
			font.height = bold.height;
			font.addEventListener(Event.SELECT, onComb);
			
			size = new ComboBox(this, 0, 0, "12", getSize(10, 30));
			size.height = font.height;
			size.addEventListener(Event.SELECT, onComb);
			
			alignRadio.push(al);
			alignRadio.push(ac);
			alignRadio.push(ar);
			color.addEventListener(Event.CHANGE, onColorChange);
			
			
			dispatchEvent(new Event(Event.COMPLETE));
		
		}
		
		private function onComb(e:Event):void {
			if (!self) return;
			if (e.target == font && font.selectedItem != null) {
				format.fontFamily = font.selectedItem.toString();
			}
			if (e.target == size && size.selectedItem != null) {
				format.fontSize = size.selectedItem.toString();
			}
			dispatchEvent(new Event(FORMAT_CHANGE));
		}
		
		private function clearRadio():void {
			for each (var btn:PushButton in alignRadio) {
				btn.selected = false;
			}
		}
		
		private function onColorChange(e:Event):void {
			if (!self) return;
			format.color = (color as Object).selectedColor;
			dispatchEvent(new Event(FORMAT_CHANGE));
		
		}
		
		private function getBtn(icon:DisplayObject):PushButton {
			var btn:PushButton = new PushButton(this, 0, 0, "", onBtn);
			btn.width = 30;
			btn.height = 24;
			btn.addDisplay(icon);
			btn.toggle = true;
			
			return btn;
		}
		
		private function getFonts():Array {
			var farr:Array = Font.enumerateFonts(true);
			var ls:Array = [];
			for each (var f:Font in farr) {
				ls.push(f.fontName);
			}
			return ls;
		}
		
		private function getSize(min:int, max:int):Array {
			var ls:Array = [];
			for (var i:int = min; i <= max; i++) {
				ls.push(i);
			}
			return ls;
		}
		
		private function onBtn(e:MouseEvent):void {
			if (!self) return;
			if (e.target == al || e.target == ac || e.target == ar) {
				clearRadio();
				e.target.selected = true;
				if (al.selected)
					format.textAlign = TextAlign.LEFT;
				if (ac.selected)
					format.textAlign = TextAlign.CENTER;
				if (ar.selected)
					format.textAlign = TextAlign.RIGHT;
			}
			
			if (e.target == bold) {
				//format.
				format.fontWeight = bold.selected?FontWeight.BOLD:FontWeight.NORMAL;
			}
			
			if (e.target == itlc) {
				format.fontStyle = itlc.selected?FontPosture.ITALIC: FontPosture.NORMAL;
			}
			
			if (e.target == under) {
				format.textDecoration = under.selected?TextDecoration.UNDERLINE:TextDecoration.NONE;
			}
			trace(format.textAlign);
			dispatchEvent(new Event(FORMAT_CHANGE));
		
		}
		
		public function getFormat():TextLayoutFormat {
			//format.color = (color as Object).selectedColor;
			//format.fontSize = size.selectedItem;
			return format;
		}
		
		public function setFormat(f:TextLayoutFormat):void {
			self = false;
			(color as Object).selectedColor = f.color;
			bold.selected = f.fontWeight == FontWeight.BOLD;
			itlc.selected = f.fontStyle == FontPosture.ITALIC;
			under.selected = f.textDecoration == TextDecoration.UNDERLINE;
			var len:int = font.items.length;
			for (var i:int = 0; i < len; i++) {
				if (font.items[i] == f.fontFamily) {
					font.selectedIndex = i;
				}
			}
			
			len = size.items.length;
			for (i=0; i < len; i++) {
				if (size.items[i] == f.fontSize) {
					size.selectedIndex = i;
				}
			}
			
			self = true;
		}
	
	}

}