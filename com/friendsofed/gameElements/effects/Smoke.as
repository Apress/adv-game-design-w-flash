package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Smoke extends Sprite
	{
     private var _circle:Sprite = new Sprite();
     private var _animationTimer:Timer = new Timer(96);
     
		public function Smoke():void
		{ 
		  //Create the smoke using a Perlin Noise effect
		  
		  //1. Create a random "seed" number to start the pattern
		  var seed:Number = Math.floor(Math.random() * 100);
		  
		  //2. Determine what colors channels you want to use. 
      var channels:uint 
        = BitmapDataChannel.BLUE|BitmapDataChannel.ALPHA;
      
      //3. Create a blank BitmapData to contain the noise
      var smoke:BitmapData = new BitmapData(5, 5, true, 0);
      
      //4. Use the perlinNoise method to create the noise
      //based on the random seed number and color channels
      smoke.perlinNoise
        (200, 200, 6, seed, true, false, channels, true, null);
			
      //5. Create a circle and fill it with the perlinNoise pattern
      _circle.graphics.beginBitmapFill(smoke);
      _circle.graphics.drawCircle(0, 0, 5);
      _circle.graphics.endFill();
      addChild(_circle);
     
	    _animationTimer.addEventListener
	      (TimerEvent.TIMER, animationEventHandler);
	    _animationTimer.start();
	  
	    //Removed from stage listener
	    addEventListener
	      (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	  }
		
		private function animationEventHandler(event:TimerEvent):void
		{ 
		  _circle.rotation += 3;
		  _circle.scaleX += 0.24;
		  _circle.scaleY += 0.24;
		  _circle.alpha -= 0.08;
			  
			//Flag the smoke as "finished" so that the parent can remove it
			if(_circle.alpha <= 0)
			{
				dispatchEvent(new Event("smokeFinished"));
			}
	  }
	  
	  private function removedFromStageHandler(event:Event):void
		{
		  _animationTimer.removeEventListener
		    (TimerEvent.TIMER, animationEventHandler);
			removeEventListener
			  (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
  }
}