package classes
{
	import classes.GlobalFlags.*;
	import classes.display.SettingPane;
	import coc.view.MainView;
	import coc.view.StatsView;
	import fl.controls.UIScrollBar;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author ...
	 */
	public class GameSettings extends BaseContent
	{
		private var lastDisplayedPane:SettingPane;
		private var initializedPanes:Boolean = false;
		
		private var panes:Array = [];
		
		private static const PANES_CONFIG:Array = [
			["settingPaneGameplay", "Gameplay Settings", "You can adjust gameplay experience such as game difficulty and NPC standards."], 
			["settingPaneInterface", "Interface Settings", "You can customize aspects of the interface to your liking."]
		];
		
		public function GameSettings() {}

		public function configurePanes():void {
			//Gameplay Settings
			for (var i:int = 0; i < PANES_CONFIG.length; i++) {
				var sb:UIScrollBar = (getGame().stage.getChildByName("mainView") as MovieClip).scrollBar as UIScrollBar;
				var pane:SettingPane = new SettingPane(getGame().mainView.mainText.x, getGame().mainView.mainText.y, getGame().mainView.mainText.width + 16, getGame().mainView.mainText.height, sb.width);
				pane.name = PANES_CONFIG[i][0];
				var hl:TextField = pane.addHelpLabel();
				hl.htmlText = "<b><u>" + PANES_CONFIG[i][1] + "</u></b>\n" + PANES_CONFIG[i][2] + "\n\n";
				setOrUpdateSettings(pane);
				panes.push(pane);
			}
			//All done!
			initializedPanes = true;
		}

		private function setOrUpdateSettings(pane:SettingPane):void {
			if (pane.name == PANES_CONFIG[0][0]) { //Gameplay
				pane.addOrUpdateToggleSettings("Game Difficulty", [
					["Easy", createCallBackFunction2(toggleSetting, kFLAGS.EASY_MODE_ENABLE_FLAG, 1), "Combat is easier and bad-ends can be ignored.", flags[kFLAGS.EASY_MODE_ENABLE_FLAG] == 1],
					["Normal", createCallBackFunction2(toggleSetting, kFLAGS.EASY_MODE_ENABLE_FLAG, 0), "Combat is unaltered and bad-ends can ruin your game.", flags[kFLAGS.EASY_MODE_ENABLE_FLAG] == 0]//,
					//["Hard", createCallBackFunction2(toggleSetting, kFLAGS.EASY_MODE_ENABLE_FLAG, -1), "Combat is challenging and bad-ends can ruin your game.", flags[kFLAGS.EASY_MODE_ENABLE_FLAG] == -1]
				]);
				pane.addOrUpdateToggleSettings("Debug Mode", [
					["ON", createCallBackFunction2(toggleDebug, true), "Items will not be consumed by use, fleeing always succeeds, and bad-ends can be ignored.", debug == true],
					["OFF", createCallBackFunction2(toggleDebug, false), "Items consumption will occur as normal.", debug == false]
				]);
				pane.addOrUpdateToggleSettings("Silly Mode", [
					["ON", createCallBackFunction2(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, true), "Crazy, nonsensical, and possibly hilarious things may occur.", flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == true],
					["OFF", createCallBackFunction2(toggleSetting, kFLAGS.SILLY_MODE_ENABLE_FLAG, false), "You're an incorrigible stick-in-the-mud with no sense of humor.", flags[kFLAGS.SILLY_MODE_ENABLE_FLAG] == false]
				]);
				pane.addOrUpdateToggleSettings("Low Standards", [
					["ON", createCallBackFunction2(toggleSetting, kFLAGS.LOW_STANDARDS_FOR_ALL, true), "NPCs ignore body type preferences. Not gender preferences though; you still need the right hole.", flags[kFLAGS.LOW_STANDARDS_FOR_ALL] == true],
					["OFF", createCallBackFunction2(toggleSetting, kFLAGS.LOW_STANDARDS_FOR_ALL, false), "NPCs have body-type preferences.", flags[kFLAGS.LOW_STANDARDS_FOR_ALL] == false]
				]);
				pane.addOrUpdateToggleSettings("Hyper Happy", [
					["ON", createCallBackFunction2(toggleSetting, kFLAGS.HYPER_HAPPY, true), "Only reducto and humus shrink endowments. Incubus draft doesn't affect breasts, and succubi milk doesn't affect cocks.", flags[kFLAGS.HYPER_HAPPY] == true],
					["OFF", createCallBackFunction2(toggleSetting, kFLAGS.HYPER_HAPPY, false), "Male enhancement potions shrink female endowments, and vice versa.", flags[kFLAGS.HYPER_HAPPY] == false]
				]);
				pane.addOrUpdateToggleSettings("Automatic Leveling", [
					["ON", createCallBackFunction2(toggleSetting, kFLAGS.AUTO_LEVEL, true), "Leveling up is done automatically once you accumulate enough experience.", flags[kFLAGS.AUTO_LEVEL] == true],
					["OFF", createCallBackFunction2(toggleSetting, kFLAGS.AUTO_LEVEL, false), "Leveling up is done manually by pressing 'Level Up' button.", flags[kFLAGS.AUTO_LEVEL] == false]
				]);
			}
			else if (pane.name == PANES_CONFIG[1][0]) { //Interface
				pane.addOrUpdateToggleSettings("Text Background", [
					["Choose", menuTextBackground, "", false]
				]);
				pane.addOrUpdateToggleSettings("Font Size", [
					["Adjust", fontSettingsMenu, "<b>Font Size: " + (flags[kFLAGS.CUSTOM_FONT_SIZE] || 20) + "</b>", false],
					"overridesLabel"
				]);
				pane.addOrUpdateToggleSettings("Sidebar Font", [
					["New", createCallBackFunction2(toggleSetting, kFLAGS.USE_OLD_FONT, false), "Palatino Linotype will be used. This is the current font.", flags[kFLAGS.USE_OLD_FONT] == false],
					["Old", createCallBackFunction2(toggleSetting, kFLAGS.USE_OLD_FONT, true), "Lucida Sans Typewriter will be used. This is the old font.", flags[kFLAGS.USE_OLD_FONT] == true]
				]);
				pane.addOrUpdateToggleSettings("Sprites", [
					["Off", createCallBackFunction2(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 0), "There are only words. Nothing else.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 0],
					["Old", createCallBackFunction2(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 1), "You like to look at pretty pictures. Old, 8-bit sprites will be shown.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 1],
					["New", createCallBackFunction2(toggleSetting, kFLAGS.SHOW_SPRITES_FLAG, 2), "You like to look at pretty pictures. New, 16-bit sprites will be shown.", flags[kFLAGS.SHOW_SPRITES_FLAG] == 2]
				]);
				pane.addOrUpdateToggleSettings("Animate Stats Bars", [
					["ON", createCallBackFunction2(toggleSetting, kFLAGS.ANIMATE_STATS_BARS, true), "The stats bars and numbers will be animated if changed.", flags[kFLAGS.ANIMATE_STATS_BARS] == true],
					["OFF", createCallBackFunction2(toggleSetting, kFLAGS.ANIMATE_STATS_BARS, false), "The stats will not animate. Basically classic.", flags[kFLAGS.ANIMATE_STATS_BARS] == false]
				]);
				pane.addOrUpdateToggleSettings("Time Format", [
					["12-hour", createCallBackFunction2(toggleSetting, kFLAGS.USE_12_HOURS, true), "Time will be shown in 12-hour format. (AM/PM)", flags[kFLAGS.USE_12_HOURS] == true],
					["24-hour", createCallBackFunction2(toggleSetting, kFLAGS.USE_12_HOURS, false), "Time will be shown in 24-hour format.", flags[kFLAGS.USE_12_HOURS] == false]
				]);
			}
		}
		
		public function enterSettings():void {
			kGAMECLASS.saves.savePermObject(false);
			getGame().mainMenu.hideMainMenu();
			hideMenus();
			if (!initializedPanes) configurePanes();
			clearOutput();
			displaySettingPane(lastDisplayedPane != null ? lastDisplayedPane : panes[0]);
			setButtons();
		}
		public function exitSettings():void {
			kGAMECLASS.saves.savePermObject(false);
			hideSettingPane();
			getGame().mainMenu.mainMenu();
		}
		
		private function setButtons():void {
			menu();
			addButton(0, "Gameplay", displaySettingPane, panes[0]);
			addButton(1, "Interface", displaySettingPane, panes[1]);
			addButton(2, "Controls", getGame().displayControls);
			addButton(3, "Debug Info", enterDebugPane);
			addButton(4, "Back", exitSettings);
		}
		
		public function displaySettingPane(pane:SettingPane):void {
			hideSettingPane();
			lastDisplayedPane = pane;
			mainView.mainText.visible = false;
			getGame().stage.addChild(pane);
			setButtons();
		}
		public function hideSettingPane():void {
			mainView.mainText.visible = true;
			if (lastDisplayedPane != null && lastDisplayedPane.parent != null) getGame().stage.removeChild(lastDisplayedPane);
		}
		
		private function enterDebugPane():void {
			hideSettingPane();
			kGAMECLASS.debugPane();
		}

		//------------
		// INTERFACE
		//------------
		public function menuTextBackground():void {
			hideSettingPane();
			clearOutput();
			outputText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae turpis nec ipsum fermentum pellentesque. Nam consectetur euismod diam. Proin vitae neque in massa tempor suscipit eget at mi. In hac habitasse platea dictumst. Morbi laoreet erat et sem hendrerit mattis. Cras in mauris vestibulum nunc fringilla condimentum. Nam sed arcu non ipsum luctus dignissim a eget ante. Curabitur dapibus neque at elit iaculis, ac aliquam libero dapibus. Sed non lorem diam. In pretium vehicula facilisis. In euismod imperdiet felis, vitae ultrices magna cursus at. Vivamus orci urna, fringilla ac elementum eu, accumsan vel nunc. Donec faucibus dictum erat convallis efficitur. Maecenas cursus suscipit magna, id dapibus augue posuere ut.\n\n");
			menu();
			addButton(0, "Normal", chooseTextBackground, 0);
			addButton(1, "White", chooseTextBackground, 1);
			addButton(2, "Tan", chooseTextBackground, 2);
			addButton(3, "Clear", chooseTextBackground, -1);
			addButton(4, "Back", displaySettingPane, lastDisplayedPane);
		}
		private function chooseTextBackground(type:int):void {
			flags[kFLAGS.TEXT_BACKGROUND_STYLE] = type;
			getGame().mainViewManager.refreshBackground();
		}

		//Needed for keys
		public function cycleBackground():void {
			flags[kFLAGS.TEXT_BACKGROUND_STYLE]++;
			if (flags[kFLAGS.TEXT_BACKGROUND_STYLE] > 2) {
				flags[kFLAGS.TEXT_BACKGROUND_STYLE] = -1;
			}
			getGame().mainViewManager.refreshBackground();
		}
		

		public function toggleDebug(selection:Boolean):void { 
			debug = selection;
			setOrUpdateSettings(lastDisplayedPane);
		}
		
		public function toggleSetting(flag:int, selection:int):void { 
			flags[flag] = selection; 
			setOrUpdateSettings(lastDisplayedPane);
		}

		//------------
		// FONT SIZE
		//------------
		public function fontSettingsMenu():void {
			hideSettingPane();
			clearOutput();
			outputText("Font size is currently set at " + (flags[kFLAGS.CUSTOM_FONT_SIZE] > 0 ? flags[kFLAGS.CUSTOM_FONT_SIZE] : 20) +  ".\n\n");
			outputText("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vitae turpis nec ipsum fermentum pellentesque. Nam consectetur euismod diam. Proin vitae neque in massa tempor suscipit eget at mi. In hac habitasse platea dictumst. Morbi laoreet erat et sem hendrerit mattis. Cras in mauris vestibulum nunc fringilla condimentum. Nam sed arcu non ipsum luctus dignissim a eget ante. Curabitur dapibus neque at elit iaculis, ac aliquam libero dapibus. Sed non lorem diam. In pretium vehicula facilisis. In euismod imperdiet felis, vitae ultrices magna cursus at. Vivamus orci urna, fringilla ac elementum eu, accumsan vel nunc. Donec faucibus dictum erat convallis efficitur. Maecenas cursus suscipit magna, id dapibus augue posuere ut.\n\n");
			menu();
			addButton(0, "Smaller Font", adjustFontSize, -1);
			addButton(1, "Larger Font", adjustFontSize, 1);
			addButton(2, "Reset Size", adjustFontSize, 0);
			addButton(4, "Back", displaySettingPane, lastDisplayedPane);
		}
		public function adjustFontSize(change:int):void {
			var fmt:TextFormat = mainView.mainText.getTextFormat();
			if (fmt.size == null) fmt.size = 20;
			fmt.size = (fmt.size as Number) + change;
			if (change == 0) fmt.size = 20;
			if ((fmt.size as Number) < 14) fmt.size = 14;
			if ((fmt.size as Number) > 32) fmt.size = 32;
			mainView.mainText.setTextFormat(fmt);
			flags[kFLAGS.CUSTOM_FONT_SIZE] = fmt.size;
			setOrUpdateSettings(lastDisplayedPane);
			fontSettingsMenu();
		}
	}
}
