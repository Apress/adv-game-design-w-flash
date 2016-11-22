package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.filters.*;
	import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.friendsofed.vector.*;

	public class BitmapExplosion extends Sprite
	{
	   private var _speedLimit:int = 5;
     private var _fadeRate:Number = 0.01;
     private var _numberOfParticles:int = 100;
     private var _gravity:Number = 0.2;
     private var _colors:Array = [0xFF6600, 0xFF9900, 0xFFCC00];
     private var _animationTimer:Timer = new Timer(16);
     private var _particles:Array = [];
     
		public function BitmapExplosion
		  (
		    bitmapData:BitmapData, 
		    tileSize:int = 10,
		    numberOfParticles:int = 100, 
		    fadeRate:Number = 0.01
		  ):void
		{ 
		  var gridSize:uint = uint(bitmapData.width / tileSize);
		  
		  //Slice the bitmap into small squares called "tiles"
		  for(var column:int = 0; column < gridSize; column++)
      {
        for(var row:int = 0; row < gridSize; row++)
        {
          //Create a tile
			    var tileBitmapData:BitmapData 
			      = new BitmapData(tileSize, tileSize, true, 0);
			    
			    //Create a rectangle object that's also the 
			    //same size as the tile. 
			    //This is the viewfinder that finds the 
			    //right spot on the bitmap to copy.
					var sourceRectangle:Rectangle 
					  = new Rectangle
					  (
					    column * tileSize, 
					    row * tileSize, 
					    tileSize, 
					    tileSize
					  );
					
					//A point object, which is needed to define the 
					//upper left corner of the bitmap
					//Leave this at 0,0 unless you need to offset it.
          var point:Point = new Point(0, 0);
          
          //Copy the pixels from the original image's 
          //BitmapData into the new tileBitmapData
          //The rectangle and point objects specify which part to copy
          tileBitmapData.copyPixels
            (bitmapData, sourceRectangle, point);
          
          //Create a new Bitmap based on the tileBitmapData
          //and add it to the stage
          var tile:Bitmap = new Bitmap(tileBitmapData);
          
          //Create a particle MovieClip
          var particle:MovieClip = new MovieClip();
          addChild(particle);
          
          //Wrap the tile Bitmap in the particle MovieClip
          //This allows it to be easily faded and rotated
		      particle.addChild(tile);
          
          //Position in the correct place on the stage
          particle.x = column * tileSize - (bitmapData.width * 0.5);
          particle.y = row * tileSize - (bitmapData.width * 0.5);
          
          //Give the particle a random rotation
		      particle.rotation = Math.floor(Math.random() * 360) - 180;
		  
		      //Give it a random velocity
		      particle.vx 
		        = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		      particle.vy 
		        = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		 
		      //Give the particle a custom rate at which it will fade out
		      particle.fadeRate = Math.random() * _fadeRate + 0.02;
		  
		      //Push the particle into the particles array
		      _particles.push(particle);
        }
      }
		
		_animationTimer.addEventListener
		  (TimerEvent.TIMER, animationEventHandler);
	  _animationTimer.start();
	  
	  //Removed from stage listener
	  addEventListener
	    (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	  }
		
		private function animationEventHandler(event:TimerEvent):void
		{  
		  //Make the particles move and gradually fade them out
		  for (var i:uint = 0; i < _particles.length; i++) 
	    {
	      //Set the alpha, update the position, and add gravity
			  _particles[i].alpha -= _particles[i].fadeRate;
			  _particles[i].x += _particles[i].vx;
			  _particles[i].vy += _gravity;
			  _particles[i].y += _particles[i].vy;
			  
			  //Remove the particle if it's alpha is less than zero
			  if(_particles[i].alpha <= 0)
			  {
				  removeChild(_particles[i]);
					_particles.splice(i, 1);
					i--;
					//If there are no more particles left,
          //dispatch an event to inform the parent that the
          //explosion is finished so that it can be removed
          if(_particles.length == 0)
          {
            dispatchEvent(new Event("explosionFinished"));
          }
			  }
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