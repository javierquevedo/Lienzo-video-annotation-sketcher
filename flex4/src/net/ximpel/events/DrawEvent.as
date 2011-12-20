package net.ximpel.events
{
	import flash.events.Event;

	public class DrawEvent extends Event
	{
		public function DrawEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const DRAW_COMPLETE : String = "drawComplete";
		
		
	}
}