package com.friendsofed.utils
{
	import flash.filters.*;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DragHandle extends Sprite
	{
		private var _color:uint;
		private var _radius:uint;
		
		public function DragHandle(radius:uint = 5, color:uint = 0x000000):void
		{
			this._radius = radius;
			this._color = color;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
		{
		  drawHandle();
		  
			//Add drag and drop
			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,  
			                 removedFromStageHandler);
		}
		
		private function removedFromStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, 
			                    removedFromStageHandler);
		}
		
		private function drawHandle():void
		{
		  //Draw a circle
		  var handle:Shape = new Shape()
			handle.graphics.beginFill(_color);
			handle.graphics.drawCircle(0, 0, _radius);
			handle.graphics.endFill();
			
			
			//Add a bevel and drop shadow filter
			var handleFilters:Array = [];
			handleFilters = handle.filters;
			handleFilters.push(new BevelFilter(2, 135, 0xFFFFFF, 0.50, 
			                                    0x000000, 0.50, 2, 2));
			handleFilters.push(new DropShadowFilter(2, 135, 0x000000, 0.35, 
			                                         2, 2));
			handle.filters = handleFilters;
			
			addChild(handle);
		}
		
		private function mouseDownHandler(event:Event):void
		{
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		private function mouseUpHandler(event:Event):void
		{
			this.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
	}
}