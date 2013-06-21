package  ilib.util.fsm
{
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Text;
	import com.bit101.components.Window;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundMixer;
	import flash.media.SoundTransform;

	public class Media extends Sprite 
	{
		///EMBEDDED IMAGES
		[Embed(source = '../../../../bin/media/fullCar.png')] private static var CarImg:Class;
		
		[Embed(source = '../../../../bin/media/carBody.png')] private static var CarBodyImg:Class;
		[Embed(source = '../../../../bin/media/rearWheel.png')] private static var CarRearWheelImg:Class;
		[Embed(source = '../../../../bin/media/frontWheel.png')] private static var CarFrontWheelImg:Class;
		
		///EMBEDDED SOUNDS
		[Embed(source = '../../../../bin/media/keyOffClick.mp3')] private static var KeyOffClickSound:Class;
		[Embed(source = '../../../../bin/media/keyEngineOn.mp3')] private static var KeyEngineOnSound:Class;
		[Embed(source = '../../../../bin/media/engineOff.mp3')] private static var EngineOffSound:Class;
		[Embed(source = '../../../../bin/media/idle.mp3')] private static var IdleSound:Class;
		[Embed(source = '../../../../bin/media/parkToDrive.mp3')] private static var ParkToDriveSound:Class;
		[Embed(source = '../../../../bin/media/driveToPark.mp3')] private static var DriveToParkSound:Class;
		[Embed(source = '../../../../bin/media/peakDrive.mp3')] private static var PeakDriveSound:Class;
		[Embed(source = '../../../../bin/media/driveToTurbo.mp3')] private static var DriveToTurboSound:Class;
		[Embed(source = '../../../../bin/media/turboToDrive.mp3')] private static var TurboToDriveSound:Class;
		[Embed(source = '../../../../bin/media/peakTurbo.mp3')] private static var PeakTurboSound:Class;
		[Embed(source = '../../../../bin/media/keyOnNoFuel.mp3')] private static var KeyOnNoFuelSound:Class;
		[Embed(source = '../../../../bin/media/runningIgnition.mp3')] private static var RunningIgnitionSound:Class;
		[Embed(source = '../../../../bin/media/parkToReverse.mp3')] private static var ParkToReverseSound:Class;
		[Embed(source = '../../../../bin/media/reverseToPark.mp3')] private static var ReverseToParkSound:Class;
		[Embed(source = '../../../../bin/media/peakReverse.mp3')] private static var PeakReverseSound:Class;
		[Embed(source = '../../../../bin/media/rolling.mp3')] private static var RollingSound:Class;
		
		///sound references
		private var _keyOffClick:Sound;
		private var _engineOn:Sound;
		private var _engineOff:Sound;
		private var _idle:Sound;
		private var _parkToDrive:Sound;
		private var _driveToPark:Sound;
		private var _peakDrive:Sound;
		private var _driveToTurbo:Sound;
		private var _turboToDrive:Sound;
		private var _peakTurbo:Sound;
		private var _keyOnNoFuel:Sound;
		private var _runningIgnition:Sound;
		private var _parkToReverse:Sound;
		private var _reverseToPark:Sound;
		private var _peakReverse:Sound;
		private var _roll:Sound;
		
		private var _rollChannel:SoundChannel;
		
		///visual display properties
		private var _carBody:Sprite;
		private var _carRearWheel:Sprite;
		private var _carFrontWheel:Sprite;
		private var _carBlurEffect:Sprite;
		
		///control buttons
		private var _offButton:PushButton;
		private var _onButton:PushButton;
		private var _park:RadioButton;
		private var _driveForwardButton:RadioButton;
		private var _driveTurboButton:RadioButton;
		private var _driveBackwardButton:RadioButton;
		private var _refuelButton:PushButton;
		
		///visual output
		private var _text:Text;
		private var _outPut:Window;
		
		private var _car:Car;
		
		public function Media ($car:Car) 
		{
			_car = $car;
			
			init ();
		}
		
		private function init ():void
		{
			_car.addChild (this);
			
			initializeCar ();
			
			initializeSoundEffects ();
			
			addButtons ();
			
			addOutput ();
		}
		
		private function initializeCar ():void
		{
			var tempBitmap:Bitmap;
			
			_carBlurEffect = new Sprite;
			
			_carBody = new Sprite;
			_carRearWheel = new Sprite;
			_carFrontWheel = new Sprite;
			
			tempBitmap = new CarImg () as Bitmap;
			tempBitmap.smoothing = true;
			_carBlurEffect.addChild (tempBitmap);
			_carBlurEffect.alpha = 0;
			_carBlurEffect.filters = [new BlurFilter (30, 2, 2)];
			_carBlurEffect.y = -2;
			
			tempBitmap.x -= tempBitmap.width * .5 + 15;//20
			tempBitmap.y -= tempBitmap.height * .5 - 8;
			
			tempBitmap = new CarBodyImg () as Bitmap;
			tempBitmap.smoothing = true;
			_carBody.addChild (tempBitmap);
			tempBitmap.x -= tempBitmap.width * .5;
			tempBitmap.y -= tempBitmap.height * .5 + 10;
			
			tempBitmap = new CarRearWheelImg () as Bitmap;
			tempBitmap.smoothing = true;
			_carRearWheel.addChild (tempBitmap);
			tempBitmap.x -= tempBitmap.width * .5;
			tempBitmap.y -= tempBitmap.height * .5;
			
			tempBitmap = new CarFrontWheelImg () as Bitmap;
			tempBitmap.smoothing = true;
			_carFrontWheel.addChild (tempBitmap);
			tempBitmap.x -= tempBitmap.width * .5;
			tempBitmap.y -= tempBitmap.height * .5;
			
			addChild (_carFrontWheel);
			addChild (_carRearWheel);
			addChild (_carBody);
			
			addChild (_carBlurEffect);
			
			_carRearWheel.x = _carBody.x - _carBody.width + 20;
			_carRearWheel.y = _carBody.y + 15;
			
			_carFrontWheel.x = _carBody.x + _carBody.width - 30;
			_carFrontWheel.y = _carBody.y + 25;
		}
		
		private function initializeSoundEffects ():void
		{
			_keyOffClick = new KeyOffClickSound as Sound;
			_engineOn = new KeyEngineOnSound as Sound;
			_engineOff = new EngineOffSound as Sound;
			_idle = new IdleSound as Sound;
			_parkToDrive = new ParkToDriveSound as Sound;
			_driveToPark = new DriveToParkSound as Sound;
			_peakDrive = new PeakDriveSound as Sound;
			_driveToTurbo = new DriveToTurboSound as Sound;
			_turboToDrive = new TurboToDriveSound as Sound;
			_peakTurbo = new PeakTurboSound as Sound;
			_keyOnNoFuel = new KeyOnNoFuelSound as Sound;
			_runningIgnition = new RunningIgnitionSound as Sound;
			_parkToReverse = new ParkToReverseSound as Sound;
			_reverseToPark = new ReverseToParkSound as Sound;
			_peakReverse = new PeakReverseSound as Sound;
			_roll = new RollingSound as Sound;
		}
		
		private function addButtons ():void
		{
			_offButton = new PushButton (this, 50 - 250, 250 - 175, 'off', _car.turnKeyOff);
			_onButton = new PushButton (this, 50 - 250, 270 - 175, 'on', _car.turnKeyOn);
			_refuelButton = new PushButton (this, 350 - 250, 250 - 175, 'refuel', _car.reFuel);
			
			_driveBackwardButton = new RadioButton (this, 250 - 250, 250 - 175, 'reverse', false, _car.driveBackward);	
			_park = new RadioButton (this, 250 - 250, 263 - 175, 'park', true, _car.returnToPark); ///empty, for homework
			_park.mouseEnabled = false; ///ENABLE THIS FOR THE RETURN TO PARK FEATURE
			_driveForwardButton = new RadioButton (this, 250 - 250, 276 - 175, 'drive', false, _car.driveForward);
			_driveTurboButton = new RadioButton (this, 250 - 250, 289 - 175, 'turbo', false, _car.driveReallyFast);
		}
		
		private function addOutput ():void 
		{
			_outPut = new Window (this, 75, -140, 'Output');
			_outPut.title = 'Output';
			_outPut.draggable = true;
			_text = new Text (_outPut, 0, 20);
			_outPut.width = _text.width = 150;
			_outPut.height = 100;
			_text.height = 80;
		}
		
		///SOUND MANIPULATION
		public function startEngine ():void 
		{
			var channel:SoundChannel = _engineOn.play ();
			channel.addEventListener (Event.SOUND_COMPLETE, playIdleEngine);
		}
		
		private function playIdleEngine (e:Event):void 
		{
			_idle.play (778, 500, new SoundTransform (1));
		}
		
		public function startEngineNoFuel ():void 
		{
			var channel:SoundChannel = _keyOnNoFuel.play ();
		}
		
		public function startEngineWhileRunning ():void 
		{
			var channel:SoundChannel = _runningIgnition.play ();
		}
		
		public function keyOffClick ():void { _keyOffClick.play (); }
		
		public function stopEngine ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _engineOff.play ();
		}
		
		public function playParkToDrive (e:Event = null):void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _parkToDrive.play ();
			channel.addEventListener (Event.SOUND_COMPLETE, playPeakDrive);
		}
		
		private function playPeakDrive (e:Event):void 
		{
			_peakDrive.play (65, 500, new SoundTransform (.6));
		}
		
		public function playDriveToTurbo (e:Event = null):void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _driveToTurbo.play ();
			channel.addEventListener (Event.SOUND_COMPLETE, playPeakTurbo);
		}
		
		private function playPeakTurbo (e:Event):void 
		{
			_peakTurbo.play (133, 500, new SoundTransform (1.3));
		}
		
		public function playParkToReverse (e:Event = null):void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _parkToReverse.play (0,0,new SoundTransform (.2));
			channel.addEventListener (Event.SOUND_COMPLETE, playPeakReverse);
		}
		
		private function playPeakReverse(e:Event):void 
		{			
			_peakReverse.play (182, 500, new SoundTransform (.1));
		}
		
		public function playReverseToDrive ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _reverseToPark.play (0, 0, new SoundTransform (.3));
			channel.addEventListener (Event.SOUND_COMPLETE, playParkToDrive);
		}
		
		public function playDriveToReverse ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _driveToPark.play (0, 0, new SoundTransform (.3));
			channel.addEventListener (Event.SOUND_COMPLETE, playParkToReverse);
		}
		
		public function playReverseToTurbo ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _reverseToPark.play (0, 0, new SoundTransform (.3));
			channel.addEventListener (Event.SOUND_COMPLETE, playDriveToTurbo);
		}
		
		public function playTurboToReverse ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _driveToPark.play (0, 0, new SoundTransform (.3));
			channel.addEventListener (Event.SOUND_COMPLETE, playParkToReverse);
		}
		
		public function playTurboToDrive ():void
		{
			SoundMixer.stopAll ();
			var channel:SoundChannel = _turboToDrive.play (0, 0, new SoundTransform (.3));
			channel.addEventListener (Event.SOUND_COMPLETE, playPeakDrive);
		}
		
		public function playRoll ():void
		{
			if (! _rollChannel) _rollChannel = _roll.play (30, 30, new SoundTransform (.1));
		}
		
		public function stopRollSound ():void
		{
			if (_rollChannel) 
			{
				_rollChannel.stop ();
				_rollChannel = null;
			}
		}
		
		///VISUAL OUTPUT MANIPULATION 
		public function setTitle ($title:String):void
		{
			_outPut.title = 'STATE: ' + $title;
		}
		
		public function cleanUp ():void { _text.text = ''; }
		
		public function print ($text:String):void
		{
			_text.text = $text;
		}
		
		public function setColor ($color:uint = 0):void
		{
			_text.textField.textColor = $color;
		}		
		
		public function set parked ($value:Boolean):void
		{
			_park.selected = $value;
		}
		
		public function get parked ():Boolean
		{
			return _park.selected;
		}
		
		///GRAPHIC ANIMATION CONTROL
		public function get carFrontWheel ():Sprite { return _carFrontWheel; }
		
		public function get carRearWheel ():Sprite { return _carRearWheel; }
		
		public function get carBody ():Sprite { return _carBody; }	
		
		public function get carBlurEffect ():Sprite { return _carBlurEffect; }		
		
	}
}