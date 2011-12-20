package net.ximpel.classes
{
	public class Helper
	{
		import mx.core.Application;
		
		public function Helper(){
		}
		
		public static function getClipsUrl():String{
			return Application.application.clipUrl;
		}
		
		public static function getAnnotationsServerUrl():String{
			
			return Application.application.annotationsServerUrl;	
		}

		public static function getClipId():String{
			return Application.application.clipId;			
		}

	}
}