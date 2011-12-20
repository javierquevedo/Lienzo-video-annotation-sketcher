package net.ximpel.events
{
	import flash.events.Event;

	public class PlayerEvent extends Event
	{
		public function PlayerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const PLAY : String = "play";
		public static const PAUSE : String = "pause";
		public static const STOP : String = "stop";
		
		
	}
}