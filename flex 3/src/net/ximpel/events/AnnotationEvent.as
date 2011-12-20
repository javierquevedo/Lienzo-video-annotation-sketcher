package net.ximpel.events
{
	import flash.events.Event;

	public class AnnotationEvent extends Event
	{
		public function AnnotationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		public static const SAVE_COMPLETE : String = "save";
		public static const SAVE_FAULT : String = "AnnotationEventSaveFault";		
		public static const LOAD_COMPLETE : String = "AnnotationEventLoadComplete";
		public static const LOAD_FAULT : String = "AnnotationEventLoadFault";
		public static const TEXT_EDIT_END : String = "AnnotationTextEditEnd";		

	}
}