package net.ximpel.classes
{
	import com.adobe.images.*;
	import com.dynamicflash.util.Base64;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	
	import net.ximpel.components.DrawableCanvas;	
	
	
	public class Snapshot
	{
		
		
		// supported image file types
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
		
		// default parameters
		private static const JPG_QUALITY_DEFAULT:uint = 80;
		private static const PIXEL_BUFFER:uint = 0;
		
		public function Snapshot()
		{
		}
		
		public static function copy(source:DisplayObject, target:DrawableCanvas):void{
			var bitmapData:BitmapData;
			var relative:DisplayObject = source.parent;
			var rect:Rectangle = source.getBounds(relative);
			//trace(rect.width.toString() + " " + rect.height.toString());
			try{
				bitmapData = new BitmapData(rect.width + PIXEL_BUFFER * 2, rect.height + PIXEL_BUFFER * 2, true, 0x00000000);
			// capture the target into bitmapData
			//bitmapData.draw(source, new Matrix(1, 0, 0, 1, -rect.x + PIXEL_BUFFER, -rect.y + PIXEL_BUFFER));
			bitmapData.draw(target, new Matrix(1, 0, 0, 1, 0,0));
			bitmapData.draw(source, new Matrix(1, 0, 0, 1, 0,0));
			
			var bitMap : Bitmap = new Bitmap(bitmapData);
			var image : Image = new Image();
			image.load(bitMap);
			target.removeAllChildren();
			target.addChild(image);
			}
			catch (error:Error){
					trace("<Error> " + error.message);
			}
		}
		
		
		public static function capture(target:DisplayObject, options:Object):String
		{
			var bitmapData:BitmapData;
			var relative:DisplayObject = target.parent;
			// get target bounding rectangle
			var rect:Rectangle = target.getBounds(relative);
			// capture within bounding rectangle; add a 1-pixel buffer around the perimeter to ensure that all anti-aliasing is included
			bitmapData = new BitmapData(rect.width + PIXEL_BUFFER * 2, rect.height + PIXEL_BUFFER * 2, true, 0x00000000);
			// capture the target into bitmapData
			bitmapData.draw(relative, new Matrix(1, 0, 0, 1, -rect.x + PIXEL_BUFFER, -rect.y + PIXEL_BUFFER));
			// encode image to ByteArray
			var byteArray:ByteArray;
			switch (options.format)
			{
				case JPG:
				// encode as JPG
				var jpgEncoder:JPGEncoder = new JPGEncoder(JPG_QUALITY_DEFAULT);
				byteArray = jpgEncoder.encode(bitmapData);
				break;
				case PNG:
				default:
				// encode as PNG
				byteArray = PNGEncoder.encode(bitmapData);
				break;
			}
			// convert binary ByteArray to plain-text, for transmission in POST data
			return Base64.encodeByteArray(byteArray);

			}
	}
}