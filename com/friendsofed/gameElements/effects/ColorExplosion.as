package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.friendsofed.vector.*;

	public class ColorExplosion extends Bitmap
	{
	  private var _fadeCounter:int = 50;
    private var _numberOfParticles:int = 100;
    private var _gravity:Number = 0.1;
    private var _size:Number;
    private var _animationTimer:Timer = new Timer(16);
    
    //The array that stores the particles 
    private var _particles:Array = [];
     
    //Create a blank BitmapData object as the canvas for this bitmap
    private var _explosionBitmapData:BitmapData 
      = new BitmapData(500, 500, true, 0);
     
		public function ColorExplosion
		  (
		    numberOfParticles:uint,
		    particleSize:uint,
		    particle_Vx:Vector.<Number>,
		    particle_Vy:Vector.<Number>,
		    randomColors:Vector.<uint>
		  ):void
		{ 
		  this._numberOfParticles = numberOfParticles;
		  this._size = particleSize;

		  //Add the blank BitmapData to this Bitmap object
		  this.bitmapData = _explosionBitmapData;
		  
		  //Create all the particles
	    for (var i:uint = 0; i< _numberOfParticles; i++) 
	    {
		    //Create the particle object
		    var particle:Object = new Object();
		  
		    //Create the particle's BitmapData based on the
		    //colors from the precalcucalted Vector
		    particle.bitmapData 
		      = new BitmapData(_size, _size, false, randomColors[i]);
		      
		    //Give it an initial position 
		    particle.x = 0;
		    particle.y = 0;
		    
		    //Assign velocity by reading the velocity Vectors
		    particle.vx = particle_Vx[i];
		    particle.vy = particle_Vy[i];
		    
		    //Push the particle into the particles array
		    _particles.push(particle);
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
		  //Clear the bitmap from the previous frame so that it's
		  //blank when you add the new particle positions
		  _explosionBitmapData.fillRect(_explosionBitmapData.rect, 0);
		  
		  for(var i:int = 0; i < _particles.length; i++)
      {
        //Update the Model
        _particles[i].x +=  _particles[i].vx;
			  _particles[i].vy += _gravity;
			  _particles[i].y +=  _particles[i].vy; 
			  
			  //Display the particle in the correct
			  //position on this bitmap
			  var sourceRectangle:Rectangle 
			    = new Rectangle(0,0, _size, _size);
			    
			  var destinationPoint:Point 
			    = new Point
          (
            _particles[i].x + (_explosionBitmapData.width * 0.5), 
            _particles[i].y + (_explosionBitmapData.height * 0.5)
          );     
          
			  _explosionBitmapData.copyPixels
          (
            _particles[i].bitmapData, 
            sourceRectangle, 
            destinationPoint
          );
      }
      
      //Fade the explosion out if the animation has
      //has run for more than 100 frames
      _fadeCounter--;
      if(_fadeCounter < 0)
      {
        this.alpha -= 0.10;
        if(this.alpha <= 0)
        {
          dispatchEvent(new Event("explosionFinished"));
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