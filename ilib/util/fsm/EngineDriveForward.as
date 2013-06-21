package ilib.util.fsm
{	
	public class EngineDriveForward implements IState
	{
		private var _car:Car;
		
		public function EngineDriveForward($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("click... rolling to a stop...the engine has been turned off.");
			_car.stopEngine ();
			_car.keyOffClick ();
			if (_car.currentRollSpeed != 0) _car.playRoll ();
			_car.changeState (_car.getEngineOffState ());
		}
		
		public function turnKeyOn ():void
		{
			_car.print ("you're driving so don't crank the ignition!");
			_car.startEngineWhileRunning ();
		}
		
		public function driveForward ():void
		{
			_car.print ("already driving - no need to change anything...");
		}
		
		public function driveBackward():void
		{
			_car.print ("click, changing the gear from drive to reverse...");
			_car.playDriveToReverse ();
			_car.changeState (_car.getEngineDriveBackwardState ());
		}
		
		public function driveReallyFast ():void
		{
			_car.print ("switching from drive to turbo!!!");
			_car.playDriveToTurbo ();
			_car.changeState (_car.getEngineDriveReallyFastState ());
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.stopEngine ();
				_car.print ("stopping the car, changing gears to park, turning the key to the off position, getting out of the car and adding " 
				+ Number (_car.refillWithFuel ()).toFixed (2) + " gallon(s) of fuel.");
				_car.changeState (_car.getEngineOffState ());
			}
		}
				
		public function update ($tick:Number):void
		{
			_car.engineTimer += $tick;
			
			///visual
			if (_car.carBlurEffect.alpha > 0) _car.carBlurEffect.alpha += -.01; //if coming from turbo, remove blur effect
			if (_car.carBlurEffect.x < 0) _car.carBlurEffect.x += .01;
			
			if (_car.carBody.rotation < 5) _car.carBody.rotation += .01;
			else if (_car.carBody.rotation > 5) _car.carBody.rotation += -.01;
			
			if (_car.carBody.x > -3) _car.carBody.x += -.01;
			else if (_car.carBody.x < -3) _car.carBody.x += .01;
			
			if (_car.currentRollSpeed < _car.driveRollSpeed) _car.currentRollSpeed += .2; //from reverse or park
			else if (_car.currentRollSpeed > _car.driveRollSpeed) _car.currentRollSpeed += -.2; //from turbo
			else _car.currentRollSpeed = _car.driveRollSpeed;
			
			_car.carFrontWheel.rotation += _car.currentRollSpeed;
			_car.carRearWheel.rotation += _car.currentRollSpeed;
			
			_car.carBody.y = Math.sin (_car.angle += .1) * 2;
			
			if (_car.engineTimer >= Car.ONE_SIXTH_SECONDS)
			{
				_car.engineTimer -= Car.ONE_SIXTH_SECONDS;
				
				_car.consumeFuel (Car.DRIVE_FUEL_CONSUMPTION);
			}
		}
		
		public function toString ():String 
		{
			return 'driving forward';
		}
		
	}

}