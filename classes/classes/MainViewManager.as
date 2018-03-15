//The code that is responsible for managing MainView.
package classes 
{
	import classes.*
	import classes.GlobalFlags.kFLAGS;
	import classes.GlobalFlags.kGAMECLASS;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import coc.view.MainView;
	import coc.view.CoCButton;
	
	import flash.events.MouseEvent;

	import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flash.utils.Timer;
	
	//import fl.transition.Tween;
	//import fl.transition.easing.*
	
	public class MainViewManager extends BaseContent
	{
		//Interface flags
		public var registeredShiftKey:Boolean = false;
		public var initializedGradients:Boolean = false;
		
		public const textColorArray:Array = [null, null, null, 0xC0C0C0, 0xC0C0C0, null, null, null, null, null];
		public const mainColorArray:Array = [null, null, null, null, 0xC0C0C0, null, null, null, null, null];
		public const barAlphaArray:Array = [0.4, 0.4, 0.5, 1, 1, 1, 1, 1, 1, 0.4];
	
		public const baseHeight:Number = 26;
		public const baseWidth:Number = 170;
		public const gapDiff:Number = 30;
		
		public var statsHidden:Boolean = false;
		public var buttonsTweened:Boolean = false;
		public var barsDecorated:Boolean = false;
		
		//Format		
		private var oldFormatNum:TextFormat = new TextFormat("Lucida Sans Typewriter", 24);
		private var newFormatNum:TextFormat = new TextFormat("Palatino Linotype", 24);
		private var oldFormatLabel:TextFormat = new TextFormat("Lucida Sans Typewriter", 14);
		private var newFormatLabel:TextFormat = new TextFormat("Palatino Linotype", 16);
		
		private var arraySet:Boolean = false;
		public var colorableTexts:Array = [];
		public var fontableNumbers:Array = []; //Will be used for font adjustment.
		public var fontableLabels:Array = [];
		public var bars:Array = [];

		private var universalAlpha:Number = 0.4;
		
		private var previousNums:Array = [0, 0, 0];
		
		public function MainViewManager() 
		{
			
		}
		
		//------------
		// INITIALIZE
		//------------
		//For now
		private function initializeSideBar():void {
			if (barsDecorated) return;
			var i:int;
			barsDecorated = true;
			var barsToDecorate:Array = ["strBar", "touBar", "speBar", "inteBar", "libBar", "sensBar", "corBar", "HPBar", "lustBar", "fatigueBar", "xpBar"];
			var numbersToBeFontable:Array = [mainView.strNum, mainView.touNum, mainView.speNum, mainView.inteNum, mainView.libNum, mainView.senNum, mainView.corNum, mainView.HPNum, mainView.lustNum, mainView.fatigueNum, mainView.levelNum, mainView.xpNum, mainView.gemsNum];
			var labelsToBeFontable:Array = [mainView.strText, mainView.touText, mainView.speText, mainView.inteText, mainView.libText, mainView.senText, mainView.corText, mainView.HPText, mainView.lustText, mainView.fatigueText, mainView.levelText, mainView.xpText, mainView.gemsText];
			for (i = 0; i < barsToDecorate.length; i++) {
				var marker:Sprite = new StatsBarTrim() as Sprite;
				marker.name = barsToDecorate[i] + "Trim";
				marker.x = mainView[barsToDecorate[i]].x - 2;
				marker.y = mainView[barsToDecorate[i]].y + 18;
				mainView.statsView.addChildAt(marker, mainView.statsView.numChildren);
			}
			for (i = 0; i < numbersToBeFontable.length; i++) {
				fontableNumbers.push(numbersToBeFontable[i]);
				fontableLabels.push(labelsToBeFontable[i]);
			}
		}
		
		//------------
		// REFRESH
		//------------
		public function refreshStats():void {

			if (!barsDecorated) {
				initializeSideBar();
			}
			//Set bars
			mainView.strBar.width = (player.str * (baseWidth / 100));
			mainView.touBar.width = (player.tou * (baseWidth / 100));
			mainView.speBar.width = (player.spe * (baseWidth / 100));
			mainView.inteBar.width = (player.inte * (baseWidth / 100));
			mainView.libBar.width = (player.lib * (baseWidth / 100));
			mainView.sensBar.width = (player.sens * (baseWidth / 100));
			mainView.corBar.width = (player.cor * (baseWidth / 100));

			mainView.minLustBar.width = ((player.minLust() / player.maxLust() * 100) * (baseWidth / 100));
			
			//Experience bar.
			if (player.level < kGAMECLASS.levelCap) mainView.xpBar.width = (((player.XP / player.requiredXP()) * 100) * (baseWidth / 100));
			else mainView.xpBar.width = (100 * (baseWidth / 100)); //Display XP bar at 100% if level is capped.
			if (player.XP >= player.requiredXP()) mainView.xpBar.width = baseWidth; //Set to 100% if XP exceeds the requirement.
			
			mainView.strNum.text = String(Math.floor(player.str));
			mainView.touNum.text = String(Math.floor(player.tou));
			mainView.speNum.text = String(Math.floor(player.spe));
			mainView.inteNum.text = String(Math.floor(player.inte));
			mainView.libNum.text = String(Math.floor(player.lib));
			mainView.senNum.text = String(Math.floor(player.sens));
			mainView.corNum.text = String(Math.floor(player.cor));
			
			animateBarChange(mainView.HPBar, mainView.HPNum, previousNums[0], player.HP, player.maxHP());
			animateBarChange(mainView.lustBar, mainView.lustNum, previousNums[1], player.lust, player.maxLust());
			animateBarChange(mainView.fatigueBar, mainView.fatigueNum, previousNums[2], player.fatigue, player.maxFatigue());
			
			//Display experience numbers.
			mainView.levelNum.text = String(player.level);
			if (player.level < kGAMECLASS.levelCap) mainView.xpNum.text = Math.floor(player.XP) + "/" + Math.floor(player.requiredXP());
			else mainView.xpNum.text = "MAX";
			mainView.gemsNum.text = addComma(Math.floor(player.gems)) + "";
			
			mainView.nameText.htmlText = "<b>Name: " + player.short + "</b>";
			
			//Time display
			refreshTimeDisplay();
			refreshTheme();
		}
		
		public function refreshTimeDisplay():void {
			mainView.timeText.htmlText = "<u>Day#: " + model.time.days + "</u>\n";
			if (flags[kFLAGS.USE_12_HOURS] == true) {
				if (model.time.hours % 12 == 0) mainView.timeText.htmlText += "Time: " + (model.time.hours + 12) + ":00" + (model.time.hours < 12 ? "am" : "pm");
				else mainView.timeText.htmlText += "Time: " + (model.time.hours % 12) + ":00" + (model.time.hours < 12 ? "am" : "pm");
			}
			else {
				mainView.timeText.htmlText += "Time: " + model.time.hours + ":00";
			}
		}
		
		//Refresh background
		public function refreshTheme(overrideIdx:int = -2):void {
			var chooser:int = overrideIdx >= -1 ? overrideIdx : flags[kFLAGS.TEXT_BACKGROUND_STYLE];
			switch(chooser) {
				case -1:
					mainView.textBGTan.visible = false;
					mainView.textBGWhite.visible = false;
					break;
				case 0:
					mainView.textBGTan.visible = false;
					mainView.textBGWhite.visible = true;
					mainView.textBGWhite.alpha = 0.4;
					break;
				case 1:
					mainView.textBGTan.visible = false;
					mainView.textBGWhite.visible = true;
					mainView.textBGWhite.alpha = 1;
					break;
				case 2:
					mainView.textBGTan.visible = true;
					mainView.textBGWhite.visible = false;
					break;
				default:
					mainView.textBGTan.visible = false;
					mainView.textBGWhite.visible = true;
					mainView.textBGWhite.alpha = 0.4;
			}
			for (var i:int = 0; i < fontableNumbers.length; i++) {
				var tn:TextField = fontableNumbers[i] as TextField;
				var tl:TextField = fontableLabels[i] as TextField;
				tn.setTextFormat(flags[kFLAGS.USE_OLD_FONT] == true ? oldFormatNum : newFormatNum);
				tl.setTextFormat(flags[kFLAGS.USE_OLD_FONT] == true ? oldFormatLabel : newFormatLabel);
			}
			refreshTimeDisplay();
		}
		
		//Show/hide stats bars.
		public function tweenInStats():void {
			var t:Timer = new Timer(20, 21);
			if (!statsHidden) return;
			statsHidden = false;
			t.addEventListener(TimerEvent.TIMER, function():void { mainView.statsView.x += 10; mainView.statsView.alpha += 0.05; if (mainView.statsView.alpha > 1) mainView.statsView.alpha = 1;} );
			t.start();
		}
		public function tweenOutStats():void {
			var t:Timer = new Timer(20, 21);
			if (statsHidden) return;
			statsHidden = true;
			t.addEventListener(TimerEvent.TIMER, function():void { mainView.statsView.x -= 10; mainView.statsView.alpha -= 0.05; if (mainView.statsView.alpha < 0) mainView.statsView.alpha = 0; } );
			t.start();
		}
		
		//Animate buttons for startup!
		public function startUpButtons():void {
			if (buttonsTweened) return;
			buttonsTweened = true;
			for (var i:int = 0; i < 15; i++) {
				mainView.bottomButtons[i].y += 140;
			}
			var t:Timer = new Timer(1000, 1);
			t.addEventListener(TimerEvent.TIMER, tweenButtonsIn);
			t.start();
		}
		private function tweenButtonsIn(e:TimerEvent = null):void {
			var t:Timer = new Timer(20, 28);
			t.addEventListener(TimerEvent.TIMER, moveButtonsIn);
			t.start();
		}
		private function moveButtonsIn(e:TimerEvent):void {
			for (var i:int = 0; i < 15; i++) {
				mainView.bottomButtons[i].y -= 5;
			}
		}
		
		//Animate bars!
		public function animateBarChange(bar:MovieClip, barNum:TextField, oldValue:Number, newValue:Number, maxValue:Number):void {
			if (kGAMECLASS.flags[kFLAGS.ANIMATE_STATS_BARS] == 0) {
				bar.width = (newValue / maxValue) * baseWidth;
				barNum.text = newValue + "/" + maxValue;
				return;
			}
			var oldValue:Number = oldValue;
			//Now animate the bar.
			var tmr:Timer = new Timer(32, 30);
			tmr.addEventListener(TimerEvent.TIMER, kGAMECLASS.createCallBackFunction2(stepBarChange, bar, barNum, [oldValue, newValue, maxValue, tmr]));
			tmr.start();
		}
		private function stepBarChange(bar:MovieClip, barNum:TextField, args:Array):void {
			var originalValue:Number = args[0]; 
			var targetValue:Number = args[1]; 
			var maxValue:Number = args[2];
			var timer:Timer = args[3];
			var stepIncrement:Number = (targetValue - originalValue) / timer.repeatCount;
			bar.width = (baseWidth * (originalValue + (stepIncrement * timer.currentCount))) / maxValue;
			barNum.text = Math.floor(originalValue + (stepIncrement * timer.currentCount)) + "/" + maxValue;
			if (timer.currentCount >= timer.repeatCount) {
				bar.width = (targetValue / maxValue) * baseWidth;
				barNum.text = Math.floor(targetValue) + "/" + maxValue;
				var idx:int = 0;
				switch(bar.name) {
					case "HPBar":
						idx = 0;
						break;
					case "lustBar":
						idx = 1;
						break;
					case "fatigueBar":
						idx = 2;
						break;
					default:
						idx = 0;
				}
				previousNums[idx] = targetValue;
			}
		}
		
		//Shift key registration. This might be moved to a better place. Maybe.
		public function keyPressed(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SHIFT) {
				getGame().shiftKeyDown = true;
			}
		}
		public function keyReleased(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.SHIFT) {
				getGame().shiftKeyDown = false;
			}
		}
	}
}