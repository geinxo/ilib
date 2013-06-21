package ilib.util.fsm 
{
	public class EngineDriveBackward implements IState
	{
		private var _car:Car;
		
		public function EngineDriveBackward($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("click... rolling to a stop in reverse...the engine has been turned off.");
			_car.stopEngine ();
			_car.keyOffClick ();
			if (_car.currentRollSpeed != 0) _car.playRoll ();
			_car.changeState (_car.getEngineOffState ());
		}
		
		public function turnKeyOn ():void
		{
			_car.print ("you're driving in reverse, no need to crank the ignition!");
			_car.startEngineWhileRunning ();
		}
		
		public function driveForward ():void
		{
			_car.print ("click, switching from reverse to drive...");
			_car.playReverseToDrive ();
			_car.changeState (_car.getEngineDriveForwardState ());
		}
		
		public function driveBackward ():void
		{
			_car.print ("...already driving in reverse.");
		}
		
		public function driveReallyFast ():void
		{
			_car.print ("click, changing gears from reverse to turbo!!!");
			_car.playReverseToTurbo ();
			_car.changeState (_car.getEngineDriveReallyFastState ());
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.stopEngine ();
				_car.print ("stopping the car from driving in reverse, changing gear to park, turning the key to the off position, getting out of the car and adding " 
				+ Number (_car.refillWithFuel ()).toFixed (2) + " gallon(s) of fuel.");
				_car.changeState (_car.getEngineOffState ());
			}
		}
		
		public function update ($tick:Number):void
		{
			_car.engineTimer += $tick;
			
			///visual
			if (_car.carBlurEffect.alpha > 0) _car.carBlurEffect.alpha += -.01;
			if (_car.carBlurEffect.x < 0) _car.carBlurEffect.x += .01;
			
			if (_car.carBody.rotation > -5) _car.carBody.rotation += -.03;
			if (_car.carBody.x < 3) _car.carBody.x += .02;
			
			if (_car.currentRollSpeed > _car.reverseRollSpeed) _car.currentRollSpeed += -.4;
			else _car.currentRollSpeed = _car.reverseRollSpeed;
			
			_car.carFrontWheel.rotation += _car.currentRollSpeed;
			_car.carRearWheel.rotation += _car.currentRollSpeed;
			
			_car.carBody.y = Math.sin (_car.angle += .1) * 1;
			
			if (_car.engineTimer >= Car.ONE_SIXTH_SECONDS)
			{
				_car.engineTimer -= Car.ONE_SIXTH_SECONDS;
				
				_car.consumeFuel (Car.REVERSE_FUEL_CONSUMPTION);
			}
		}
		
		public function toString ():String 
		{
			return 'driving backward';
		}
		
	}

}