package classes.display 
{
	import classes.display.BindDisplay;
	import fl.containers.ScrollPane;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Provides a scrollable container for game settings.
	 * @author Kitteh6660
	 */
	public class SettingPane extends ScrollPane
	{	
		private var _stage:Stage;
		
		private var _content:MovieClip;
		private var _contentChildren:int;

		private var _initialized:Boolean = false;
		
		/**
		 * Initiate the SettingPane, setting the stage positioning and reference back to the input manager
		 * so we can generate function callbacks later.
		 * 
		 * @param	xPos			X position on the stage for the top-left corner of the ScrollPane
		 * @param	yPos			Y position on the stage for the top-left corner of the ScrollPane
		 * @param	width			Fixed width of the containing ScrollPane
		 * @param	height			Fixed height of the containing ScrollPane
		 */
		public function SettingPane(xPos:int, yPos:int, width:int, height:int, uiscrollwidth:int)
		{
			this.width = width + uiscrollwidth + 3;
			this.height = height - 3;
			
			this.x = xPos - 1;
			this.y = yPos;
			
			// Cheap hack to remove the stupid styling elements of the stock ScrollPane
			var blank:MovieClip = new MovieClip();
			this.setStyle("upSkin", blank);
			
			_content = new MovieClip();
			_content.name = "controlContent";
			_contentChildren = 0;

			// Hook into some stuff so that we can fix some bugs that ScrollPane has
			this.addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
		}
		
		/**
		 * Cleanly get us a reference to the stage to add/remove other event listeners
		 * @param	e
		 */
		private function AddedToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			
			_stage = this.stage;
			
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, MouseScrollEvent);
		}
		
		private function RemovedFromStage(e:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStage);
			this.addEventListener(Event.ADDED_TO_STAGE, AddedToStage);
			
			_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, MouseScrollEvent);
		}
		
		private function MouseScrollEvent(e:MouseEvent):void
		{
			this.verticalScrollPosition += -( e.delta * 8 );
		}
		
		public function get initialized():Boolean { return _initialized; }
		public function set initialized(bool:Boolean):void { _initialized = bool; }

		public function addHelpLabel():TextField {
			// Add a nice little instructional field at the top of the display.
			var _textFormatLabel:TextFormat = new TextFormat();
			_textFormatLabel.size = 20;
			// Make the help label.
			var helpLabel:TextField = new TextField();
			helpLabel.name = "helpLabel";
			helpLabel.x = 10;
			helpLabel.width = this.width - 40;
			helpLabel.defaultTextFormat = _textFormatLabel;
			helpLabel.multiline = true;
			helpLabel.wordWrap = true;
			helpLabel.autoSize = TextFieldAutoSize.LEFT; // With multiline enabled, this SHOULD force the textfield to resize itself vertically dependent on content.
			this.addChild(helpLabel);
			_contentChildren++;
			return helpLabel;
		}
		
		public function addOrUpdateToggleSettings(label:String, args:Array):BindDisplay {
			var i:int;
			var hl:TextField = this.getChildByName("helpLabel") as TextField;
			if (this.getChildByName(label) != null) {
				var existingSetting:BindDisplay = this.getChildByName(label) as BindDisplay;
				for (i = 0; i < args.length; i++) {
					if (args[i] is String) {
						if (args[i] == "overridesLabel") {
							existingSetting.htmlText = args[i-1][2];
							existingSetting.buttons[i].visible = false;
						}
						continue;
					}
					existingSetting.buttons[i].enabled = !args[i][3];
					existingSetting.buttons[i].alpha = args[i][3] ? 0.5 : 1;
					if (args[i][3]) existingSetting.htmlText = "<b>" + label + ": " + colourifyText(args[i][0]) + "</b>\n<font size=\"12\">" + args[i][2] + "</font>";
				}
				return existingSetting;
			}
			else {
				var newSetting:BindDisplay = new BindDisplay(this.width - 20, 55, args.length);
				newSetting.x = 2;
				newSetting.y = (BindDisplay.BUTTON_Y_DELTA * _contentChildren) + (7 + hl.textHeight);
				newSetting.name = label;
				newSetting.label.y -= 8;
				newSetting.label.multiline = true;
				newSetting.label.wordWrap = true;
				newSetting.htmlText = "<b>" + label + ":</b>\n";
				for (i = 0; i < args.length; i++) {
					if (args[i] is String) {
						if (args[i] == "overridesLabel") {
							newSetting.htmlText = args[i-1][2];
							newSetting.buttons[i].visible = false;
						}
					}
					else {
						newSetting.buttons[i].labelText = args[i][0];
						newSetting.buttons[i].callback = generateCallback(args[i][1]);
						newSetting.buttons[i].enabled = !args[i][3];
						newSetting.buttons[i].alpha = args[i][3] ? 0.5 : 1;
						if (args[i][3]) newSetting.htmlText = "<b>" + label + ": " + colourifyText(args[i][0]) + "</b>\n<font size=\"12\">" + args[i][2] + "</font>";
					}
				}
				_contentChildren++;
				this.addChild(newSetting);
				return newSetting;
			}
		}
		
		private function generateCallback(func:Function):Function {
			return func;
		}
		
		private function colourifyText(text:String):String {
			if (text.toLowerCase() == "on" || text.toLowerCase() == "enabled" || text.toLowerCase() == "easy") {
				text = "<font color=\"#008000\">" + text + "</font>";
			}
			if (text.toLowerCase() == "normal") {
				text = "<font color=\"#808000\">" + text + "</font>";
			}
			else if (text.toLowerCase() == "off" || text.toLowerCase() == "disabled" || text.toLowerCase() == "hard") {
				text = "<font color=\"#800000\">" + text + "</font>";
			}
			else if (text.toLowerCase() == "choose" || text.toLowerCase() == "enable") {
				text = "";
			}
			return text;
		}
	}
}
