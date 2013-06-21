package ilib.util.fsm 
{
	public class EngineDriveReallyFast implements IState
	{
		private var _car:Car;
		
		public function EngineDriveReallyFast($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("click... rolling to a stop from turbo...the engine has been turned off.");
			_car.stopEngine ();
			_car.keyOffClick ();
			if (_car.currentRollSpeed != 0) _car.playRoll ();
			_car.changeState (_car.getEngineOffState ());
		}
		
		public function turnKeyOn ():void
		{
			_car.print ("man, we're on turbo, don't crank the ignition!");
			_car.startEngineWhileRunning ();
		}
		
		public function driveForward ():void
		{
			_car.print ("slowing down to regular driving speed...");
			_car.playTurboToDrive ();
			_car.changeState (_car.getEngineDriveForwardState ());
		}
		
		public function driveBackward():void
		{
			_car.print ("click, switching the gears from turbo to reverse...");
			_car.playTurboToReverse ();
			_car.changeState (_car.getEngineDriveBackwardState ());
		}
		
		public function driveReallyFast ():void
		{
			_car.print ("We can't drive any faster than this, no changes...");
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.stopEngine ();
				_car.print ("hitting the breaks!, stopping the car, switching gear to park, turning the key to the off position, getting out of the car and adding " 
				+ Number (_car.refillWithFuel ()).toFixed (2) + " gallon(s) of fuel.");
				_car.changeState (_car.getEngineOffState ());
			}
		}
		
		public function update ($tick:Number):void
		{
			_car.engineTimer += $tick;
			
			//if the speed goes over regular driving speed, show the turbo blur effect
			if (_car.currentRollSpeed > _car.driveRollSpeed) 
			{
				if (_car.carBlurEffect.alpha < .6) _car.carBlurEffect.alpha += .01;
				if (_car.carBlurEffect.x > -30) _car.carBlurEffect.x += -.01;
				
				//rotate the car body clockwise a little
				if (_car.carBody.rotation < 7) _car.carBody.rotation += .05;
				
				//move the car body a little to the left
				if (_car.carBody.x > -5) _car.carBody.x += -.02;
			}			
			
			//slowly increase speed if not maxed
			if (_car.currentRollSpeed < _car.reallyFastRollSpeed) _car.currentRollSpeed += .2;
			else _car.currentRollSpeed = _car.reallyFastRollSpeed;
			
			_car.carFrontWheel.rotation += _car.currentRollSpeed;
			_car.carRearWheel.rotation += _car.currentRollSpeed;
			
			//bobbing motion
			_car.carBody.y = Math.sin (_car.angle += .05) * 2;
			
			if (_car.engineTimer >= Car.ONE_SIXTH_SECONDS)
			{
				_car.engineTimer -= Car.ONE_SIXTH_SECONDS;
				
				_car.consumeFuel (Car.TURBO_FUEL_CONSUMPTION);
			}
		}
		
		public function toString ():String 
		{
			return 'driving really fast';
		}
		
	}

}