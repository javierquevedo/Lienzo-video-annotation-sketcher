package net.ximpel.classes
{
	import mx.core.FlexGlobals;

	public class Helper
	{
		import mx.core.Application;
		
		public function Helper(){
		}
		
		public static function getClipsUrl():String{
			var a:Object = FlexGlobals.topLevelApplication;
			return FlexGlobals.topLevelApplication.clipUrl;
		}
		
		public static function getAnnotationsServerUrl():String{
			
			return FlexGlobals.topLevelApplication.annotationsServerUrl;	
		}

		public static function getClipId():String{
			return FlexGlobals.topLevelApplication.clipId;			
		}

	}
}