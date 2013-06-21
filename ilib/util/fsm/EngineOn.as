package ilib.util.fsm
{	
	public class EngineOn implements IState
	{
		private var _car:Car;
		
		public function EngineOn($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("click... the engine has been turned off from park.");
			
			///visual
			_car.carBody.rotation = 0;
			_car.carBody.x = 0;
			
			_car.stopEngine ();
			_car.keyOffClick ();
			_car.changeState (_car.getEngineOffState ());
		}
		
		public function turnKeyOn ():void
		{
			_car.print ("the engine's already running you didn't have to crank the ignition!");
			_car.startEngineWhileRunning ();
		}
		
		public function driveForward ():void
		{
			_car.print ("click, changing gears to drive ...now were going somewhere...");
			_car.playParkToDrive ();
			_car.changeState (_car.getEngineDriveForwardState ());
		}
		
		public function driveBackward():void
		{
			_car.print ("click, changing gears from park to reverse...");
			_car.playParkToReverse ();
			_car.changeState (_car.getEngineDriveBackwardState ());
		}
		
		public function driveReallyFast ():void
		{	
			_car.print ("click, going on turbo...woohoo!!!");
			_car.playDriveToTurbo ();
			_car.changeState (_car.getEngineDriveReallyFastState ());
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.stopEngine ();
				_car.print ("turning the car off, getting out and adding " + Number (_car.refillWithFuel ()).toFixed (2) + " gallon(s) of fuel.");
				_car.changeState (_car.getEngineOffState ());
			}
		}
		
		public function update ($tick:Number):void
		{			
			_car.engineTimer += $tick;
			
			///visual
			_car.angle += 2;
			
			//vibration effect
			_car.carBody.rotation = Math.cos (_car.angle) * .8; 
			
			if (_car.carBlurEffect.alpha > 0) _car.carBlurEffect.alpha += -.005;
			if (_car.carBlurEffect.x < 0) _car.carBlurEffect.x += .01;
			
			if (_car.currentRollSpeed > .3) _car.currentRollSpeed += -.3;
			else if (_car.currentRollSpeed < -.3) _car.currentRollSpeed += .3;
			else _car.currentRollSpeed = 0;
			
			if (_car.currentRollSpeed == 0) _car.switchToPark ();
			
			_car.carFrontWheel.rotation += _car.currentRollSpeed;
			_car.carRearWheel.rotation += _car.currentRollSpeed;
			
			if (_car.engineTimer >= Car.ONE_SIXTH_SECONDS)
			{					
				_car.engineTimer -= Car.ONE_SIXTH_SECONDS;
				
				_car.consumeFuel (Car.IDLE_FUEL_CONSUMPTION);
			}
		}
		
		public function toString ():String 
		{
			return 'on';
		}
		
	}

}