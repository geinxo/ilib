package  ilib.util.fsm
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	[SWF (width = 500, height = 350, frameRate = 60, backgroundColor = 0xFFFFFF)]
	
	public class Main extends Sprite 
	{		
		private var _past:Number;
		private var _present:Number;
		private var _tick:Number;
		private var _car:Car;
		
		public function Main () 
		{			
			init ();
		}		
		
		private function init():void 
		{
			_present = getTimer ();
			_past = _present;
			
			addCar ();
			
			addEventListener (Event.ENTER_FRAME, update);
		}
		
		private function addCar ():void
		{
			_car = new Car;
			_car.x = stage.stageWidth * .5;
			_car.y = stage.stageHeight * .5;
			addChild (_car);
		}
		
		private function update (e:Event):void 
		{
			_present = getTimer ();
			_tick = (_present - _past) * .001; ///converted to 1/1000
			_past = _present;
			
			_car.update (_tick);
		}
		
	}
	
}