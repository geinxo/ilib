package  ilib.util.fsm
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Car extends Sprite 
	{		
		///CAR STATES
		//engine off state
		//engine on state
		//drive state
		//no gas state
		
		public static const ONE_SIXTH_SECONDS:Number = 1 / 6; //6 times per second
		
		public static const IDLE_FUEL_CONSUMPTION:Number = .0055;
		public static const DRIVE_FUEL_CONSUMPTION:Number = .011;
		public static const REVERSE_FUEL_CONSUMPTION:Number = .0066;
		public static const TURBO_FUEL_CONSUMPTION:Number = .016;
		
		private var _engineOffState:IState;
		private var _engineOnState:IState;
		private var _engineDriveForwardState:IState;
		private var _engineDriveBackwardState:IState;
		private var _engineDriveReallyFastState:IState;
		private var _engineOutOfFuelState:IState;
		
		private var _fuelCapacity:Number = 3;
		private var _fuelSupply:Number = _fuelCapacity; //starting on a full tank (in gallons)
		
		private var _engineTimer:Number = 0;
		
		private var _currentState:IState;
		
		public static const ONE_SECOND:int = 1; //used to reposition the gear to park when off/out of fuel after 1 second
		
		private static const TEN_SECONDS:int = 10; //triggers clean up for visual output
		private var _cleanUpTimer:Number = 0; //visual output clean up timer

		private var _angle:Number = 0; //for the car body animation when engine is on and parked

		private var _reallyFastRollSpeed:Number = 63; //roll speed when on turbo
		private var _driveRollSpeed:Number = 35; //roll speed when on drive
		private var _reverseRollSpeed:Number = -15; //roll speed when on reverse
		private var _currentRollSpeed:Number = 0; //changes based on target roll speed see last 3 properties above, used for wheel rotation animation

		private var _carBlurEffect:Sprite; //turbo speed blur effect

		private var _media:Media; //reference to the Media class for visual/output/sound manipulation
		
		public function Car () 
		{
			init ();
		}
		
		private function init ():void
		{
			initializeStates ();
			
			_media = new Media (this);
		}
		
		private function initializeStates ():void
		{
			_engineOffState = new EngineOff (this);
			_engineOnState = new EngineOn (this);
			_engineDriveForwardState = new EngineDriveForward (this);
			_engineOutOfFuelState = new EngineOutOfFuel (this);
			_engineDriveBackwardState = new EngineDriveBackward (this);
			_engineDriveReallyFastState = new EngineDriveReallyFast (this);
			
			_currentState = _engineOffState;
		}
		
		public function update ($tick:Number):void 
		{
			_currentState.update ($tick);
			
			_media.setTitle (_currentState.toString ());
			
			if (_currentState == _engineOutOfFuelState || _currentState == _engineOffState) 
			{
				if (_currentRollSpeed == 0) //or add this test for the update method of the 2 states 
				{
					_media.stopRollSound ();
				}
			}
			
			//clean up the output panel after 10 seconds
			if ((_cleanUpTimer += $tick) >= TEN_SECONDS) 
			{
				_cleanUpTimer -= TEN_SECONDS;
				_media.cleanUp ();
			}
		}
		
		///car functions
		public function returnToPark (e:Event = null):void
		{
			//homework
		}
		
		public function turnKeyOn (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.turnKeyOn ();
		}
		
		public function turnKeyOff (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.turnKeyOff ();
		}
		
		public function driveForward (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.driveForward ();
		}
		
		public function driveBackward (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.driveBackward ();
		}
		
		public function driveReallyFast (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.driveReallyFast ();
		}
		
		public function reFuel (e:Event = null):void
		{
			_cleanUpTimer = 0;
			_currentState.reFuel ();
		}
		
		public function consumeFuel ($consumption:Number):void
		{
			if ((_fuelSupply -= $consumption) <= 0)
			{
				_fuelSupply = 0;
				_cleanUpTimer = 0;
				
				stopEngine ();
				
				if (currentRollSpeed != 0) 
				{
					playRoll ();
					print ("the engine has stopped, no more fuel to run...rolling to a stop.");
				}
				else print ("the engine has stopped, no more fuel to run...");
				
				_media.setColor (0xFF0000);
				
				changeState (_engineOutOfFuelState);
			}
		}
		
		public function refillWithFuel ():Number
		{
			if (_currentRollSpeed != 0) playRoll ();
			
			var neededSupply:Number = _fuelCapacity - _fuelSupply;
			_fuelSupply += neededSupply;
			_media.setColor ();
			return neededSupply;
		}
		
		public function hasFullTank ():Boolean
		{
			var fullTank:Boolean = _fuelCapacity == _fuelSupply ? true : false;
			if (fullTank) print ("no need to refuel right now, the tank is full...");
			return fullTank;
		}
		
		public function getEngineOffState ():IState { return _engineOffState; } //explicit, you know you're calling a method
		
		public function getEngineOnState ():IState { return _engineOnState; }
		
		public function getEngineOutOfFuelState ():IState { return _engineOutOfFuelState; }
		
		public function getEngineDriveForwardState ():IState { return _engineDriveForwardState; }
		
		public function getEngineDriveBackwardState ():IState { return _engineDriveBackwardState; }
		
		public function getEngineDriveReallyFastState ():IState { return _engineDriveReallyFastState; }
		
		public function changeState ($state:IState):void 
		{
			_currentState = $state; 
		}
		
		public function get engineTimer ():Number { return _engineTimer; } //implicit, as if you're accessing a public variable
		
		public function set engineTimer ($value:Number):void { _engineTimer = $value; }		
		
		public function print ($text:String):void
		{
			//trace ($text);
			_media.print ($text);
		}
		
		override public function toString ():String 
		{
			return 'The car is currently ' + _currentState + ' with a fuel amount of ' + _fuelSupply +  ' gallon(s).';
		}
		
		///Sound control
		public function startEngine ():void 
		{
			_media.startEngine ();
		}
		
		public function startEngineNoFuel ():void 
		{
			_media.startEngineNoFuel ();
		}
		
		public function startEngineWhileRunning ():void 
		{
			_media.startEngineWhileRunning ();
		}
		
		public function keyOffClick ():void { _media.keyOffClick (); }
		
		public function stopEngine ():void
		{
			_media.stopEngine ();
		}
		
		public function playParkToDrive (e:Event = null):void
		{
			_media.playParkToDrive (e);
		}
		
		public function playDriveToTurbo (e:Event = null):void
		{
			_media.playDriveToTurbo (e);
		}
		
		public function playParkToReverse (e:Event = null):void
		{
			_media.playParkToReverse (e);
		}
		
		public function playReverseToDrive ():void
		{
			_media.playReverseToDrive ();
		}
		
		public function playDriveToReverse ():void
		{
			_media.playDriveToReverse ();
		}
		
		public function playReverseToTurbo ():void 
		{
			_media.playReverseToTurbo ();
		}
		
		public function playTurboToReverse ():void
		{
			_media.playTurboToReverse ();
		}
		
		public function playTurboToDrive ():void
		{
			_media.playTurboToDrive ();
		}
		
		public function playRoll ():void
		{
			_media.playRoll ();
		}
		
		//auto return to park controls when out of fuel / off state
		public function switchToPark ():void
		{
			_media.parked = true;
		}
		
		public function isParked ():Boolean
		{
			return _media.parked;
		}
		
		///Animation control
		public function get currentRollSpeed ():Number { return _currentRollSpeed; }
		
		public function set currentRollSpeed ($value:Number):void
		{
			_currentRollSpeed = $value;
		}
		
		public function get carFrontWheel ():Sprite { return _media.carFrontWheel; }
		
		public function get carRearWheel ():Sprite { return _media.carRearWheel; }
		
		public function get carBody ():Sprite { return _media.carBody; }
		
		public function get carBlurEffect ():Sprite { return _media.carBlurEffect; }
		
		public function get angle ():Number { return _angle; }
		
		public function set angle (value:Number):void { _angle = value; }
		
		public function get reallyFastRollSpeed ():Number { return _reallyFastRollSpeed; }
		
		public function get reverseRollSpeed ():Number { return _reverseRollSpeed; }
		
		public function get driveRollSpeed ():Number { return _driveRollSpeed; }
	}
}