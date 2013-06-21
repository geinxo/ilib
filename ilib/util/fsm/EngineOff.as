package ilib.util.fsm 
{
	public class EngineOff implements IState
	{
		private var _car:Car;
		
		public function EngineOff($car:Car) 
		{
			_car = $car;
		}
		
		/* INTERFACE com.activeTuts.fsm.IState */
		
		public function turnKeyOff ():void
		{
			_car.print ("The car's already off, you can't turn the key counter-clockwise any further...");
		}
		
		public function turnKeyOn ():void
		{			
			_car.print ("Turning the car on...the engine is now running!");
			_car.startEngine ();
			_car.changeState (_car.getEngineOnState ());
			
		}
		
		public function driveForward ():void
		{
			_car.engineTimer = 0;
			_car.print ("click, changing the gear to drive doesn't do anything...the car is not running, returning the gear to park...");
		}
		
		public function driveBackward ():void
		{
			_car.engineTimer = 0;
			_car.print ("click, changing the gear to reverse does nothing, the car is not running, returning the gear to park...");
		}
		
		public function driveReallyFast ():void
		{	
			_car.engineTimer = 0;
			_car.print ("click, changing the gear to turbo, nothing happens, the engine's off, returning the gear to park...");
		}
		
		public function reFuel ():void
		{
			if (_car.hasFullTank () == false) 
			{
				_car.print ("getting out of the car and adding " + Number (_car.refillWithFuel ()).toFixed (2) + " gallon(s) of fuel.");
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
			_car.carRearWheel.rotation += _car.currentRollSpeed;
		}
		
		public function toString ():String 
		{
			return 'off';
		}
		
	}

}