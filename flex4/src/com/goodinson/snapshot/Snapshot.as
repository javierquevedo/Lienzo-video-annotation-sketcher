package com.goodinson.snapshot
{
	import com.adobe.images.*;
	import com.dynamicflash.util.Base64;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.utils.ByteArray;
	
	import mx.controls.Image;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import net.ximpel.events.AnnotationEvent;
	
	public class Snapshot extends EventDispatcher
	{
		[Bindable]
		public var content : String;
		[Bindable]
		public var decodedBitmapData:BitmapData
		[Bindable]
		public var bitmapData : BitmapData;
		[Bindable]
		public var author : String;
		[Bindable]
		public var startTime : Number;
		[Bindable]
		public var duration : Number;
		[Bindable]
		public var name : Number;
		[Bindable]
		public var image : Image;
		
		// supported image file types
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
		
		// supported server-side actions
		public static const DISPLAY:String = "display";
		public static const PROMPT:String = "prompt";
		public static const LOAD:String = "load";
		
		// default parameters
		private static const JPG_QUALITY_DEFAULT:uint = 80;
		private static const PIXEL_BUFFER:uint = 0;
		private static const DEFAULT_FILE_NAME:String = 'snapshot';
		
		private var _target : DisplayObject;
		
		public function retrieve(target:DisplayObject, options:Object):void{
			_target = target;
			var downloadDataService : HTTPService = new HTTPService();
			downloadDataService.url = "http://localhost:3000/clips/"+options.clipId+"/annotations/"+options.annotationId +".xml";
			//downloadDataService.contentType="application/xml";
			downloadDataService.method="GET";
			downloadDataService.addEventListener(ResultEvent.RESULT,onDownloadDataResult);
			downloadDataService.addEventListener(ResultEvent.RESULT,onDownloadDataFault);
			downloadDataService.send();
			
		}
		
		
		
		public function capture(target:DisplayObject, options:Object):void
		{
			var relative:DisplayObject = target.parent;
			// get target bounding rectangle
			var rect:Rectangle = target.getBounds(relative);
			// capture within bounding rectangle; add a 1-pixel buffer around the perimeter to ensure that all anti-aliasing is included
			bitmapData = new BitmapData(rect.width + PIXEL_BUFFER * 2, rect.height + PIXEL_BUFFER * 2);
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
			var byteArrayAsString:String = Base64.encodeByteArray(byteArray);
			
			var uploadDataService : HTTPService = new HTTPService();
			uploadDataService.url = "http://localhost:3000/clips/1/annotations.xml"
			uploadDataService.contentType="application/xml";
			uploadDataService.resultFormat="e4x";
			uploadDataService.method="POST";
												
			var request:XML = <annotation></annotation>;
			if (options.author)
				request.appendChild(<author>{options.author}</author>);
			
			if (options.duration)
				request.appendChild(<duration>{parseInt(options.duration)}</duration>);
			
			if (options.startTime)
				request.appendChild(<starttime>{parseInt(options.startTime)}</starttime>);

			request.appendChild(<content>{byteArrayAsString}</content>);
			uploadDataService.request = request;

			uploadDataService.addEventListener(ResultEvent.RESULT, onUploadDataResult);
			uploadDataService.addEventListener(FaultEvent.FAULT, onUploadDataFault);
			uploadDataService.send();
		}
		private function onUploadDataResult(event:ResultEvent):void{
			trace("result");
			dispatchEvent(new AnnotationEvent(AnnotationEvent.SAVE_COMPLETE));
		}	
		
		private function onUploadDataFault(event:FaultEvent):void{
			trace("fault");
			dispatchEvent(new AnnotationEvent(AnnotationEvent.SAVE_FAULT));
		}	
		
		private function onDownloadDataResult(event:ResultEvent):void{
			var annotation : Object = event.result.annotation;
			duration = annotation["duration"];
			startTime = annotation["starttime"];
			content = annotation["content"];
			var relative:DisplayObject = _target.parent;
			var decodedByteArray : ByteArray = Base64.decodeToByteArray(content);
			var loader : Loader = new Loader();
			image = new Image();
			image.load(decodedByteArray);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onDecodedComplete)
			loader.loadBytes(decodedByteArray);		
		}
		private function onDecodedComplete(event:Event):void{
			decodedBitmapData = Bitmap(event.target.content).bitmapData
			dispatchEvent(new AnnotationEvent(AnnotationEvent.LOAD_COMPLETE));

		}
		
		private function onDownloadDataFault(event:ResultEvent):void{
			var object : Object = event.currentTarget;
			var results : Object = event.result;
			
			trace("results");
		}
		
	
	}		
}