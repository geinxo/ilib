package ilib.util.fsm
{
	public interface IState
	{
		function turnKeyOff ():void;
		function turnKeyOn ():void;
		function driveForward ():void;
		function driveBackward ():void; 
		function driveReallyFast ():void;
		function reFuel ():void;		
		function update ($tick:Number):void;
		function toString ():String;
	}
}