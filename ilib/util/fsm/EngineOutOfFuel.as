package ilib.util.fsm
{	
	public class EngineOutOfFuel implements IState
	{
		private var _car:Car;
		
		public function EngineOutOfFuel($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("you already did this when the fuel ran out earlier...");
		}
		
		public function turnKeyOn ():void
		{
			_car.print ("no fuel - the car will not start, get some fuel before anything. Returning the key to the off position.");
			_car.startEngineNoFuel ();
		}
		
		public function driveForward ():void
		{
			_car.engineTimer = 0;
			_car.print ("click, changing the gear to drive doesn't do anything...the car has no fuel, returning the gear to park...");
		}
		
		public function driveBackward ():void
		{
			_car.engineTimer = 0;
			_car.print ("click, changing the gear to reverse won't do anything either...the car has no fuel, returning the gear to park...");
		}
		
		public function driveReallyFast ():void
		{
			_car.engineTimer = 0;
			_car.print ("click, changed gear to turbo, no change, the car is not running, try to get som fuel, returning the gear to park.");
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.print ("getting out of the car and adding " + _car.refillWithFuel () + " gallon(s) of fuel.\n");
				_car.changeState (_car.getEngineOffState ());
			}
		}
		
		public function update ($tick:Number):void
		{
			if (_car.currentRollSpeed == 0)
			{
				if (! _car.isParked ())
				{
					_car.engineTimer += $tick;
					
					if (_car.engineTimer >= Car.ONE_SECOND)
					{
						_car.switchToPark ();
					}
				}
			}
			
			if (_car.carBlurEffect.alpha > 0) _car.carBlurEffect.alpha += -.005;
			if (_car.carBlurEffect.x < 0) _car.carBlurEffect.x += .01;
			
			if (_car.carBody.rotation > 0) _car.carBody.rotation += -.02;
			else if (_car.carBody.rotation < 0) _car.carBody.rotation += .02;
			
			if (_car.carBody.x < 0) _car.carBody.x += .02;
			else if (_car.carBody.x > 0) _car.carBody.x += -.02;
			
			if (_car.currentRollSpeed > 0.3) _car.currentRollSpeed += -.3;
			else if (_car.currentRollSpeed < -0.3) _car.currentRollSpeed += .3;
			else _car.currentRollSpeed = 0;
			
			_car.carFrontWheel.rotation += _car.currentRollSpeed;
			_car.carRearWheel.rotation += _car.currentRollSpeed;;
			
		}
		
		public function toString ():String 
		{
			return 'out of fuel';
		}
		
	}

}