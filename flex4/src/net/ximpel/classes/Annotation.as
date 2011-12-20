package net.ximpel.classes
{

	import com.dynamicflash.util.Base64;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;

	
	public class Annotation extends EventDispatcher
	{
		[Bindable]
		public var name : String;
		[Bindable]
		public var author : String;
		[Bindable]
		public var duration : Number;
		[Bindable]
		public var startTime : Number;
		[Bindable]
		public var fadeDuration : Number;
		[Bindable]
		public var alpha : Number;
		[Bindable]
		public var decodedByteArray : ByteArray;
		[Bindable]
		public var visible : Boolean = true;
		[Bindable]
		public var image : Image;
		[Bindable]
		public var id : String;

		
		// Encoding parameters
		private static const PIXEL_BUFFER:uint = 0;
		private static const JPG_QUALITY_DEFAULT:uint = 80;
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
				
		public function Annotation(annotationInfo : Object) 
		{
			this.name = annotationInfo["name"];
			this.author = annotationInfo["author"];
			this.duration = annotationInfo["duration"];
			this.startTime = annotationInfo["starttime"];
			this.alpha = annotationInfo["alpha"];
			this.fadeDuration = annotationInfo["fadeduration"];
			this.id = annotationInfo["id"];
				// Decodes the 
			this.image = new Image();
			this.image.load(Base64.decodeToByteArray(annotationInfo["content"]));
		}		
		
	}
}