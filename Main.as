package 
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Romain Quessada
	 */
	 
	[SWF(width = "320", height = "240", frameRate = "60", backgroundColor = "#000000")]
	public class Main extends Sprite 
	{
		private var mStarling:Starling;
		
		public function Main():void 
		{
			/*stage.scaleMode = StageScaleMode.NO_SCALE;*/
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.DEACTIVATE, deactivate);
			
			/*Autorise le multi-touch*/
			Starling.multitouchEnabled = true;
						
			/*Création de l'instance de jeu*/
			mStarling = new Starling(Game, stage);
			mStarling.simulateMultitouch = true;
            mStarling.start();
			
			// touch or gesture?
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// entry point
			
			// new to AIR? please read *carefully* the readme.txt files!
		}
		
		private function deactivate(e:Event):void 
		{
			// make sure the app behaves well (or exits) when in background
			//NativeApplication.nativeApplication.exit();
		}
		
	}
	
}