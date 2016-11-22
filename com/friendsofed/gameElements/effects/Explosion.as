package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.filters.*;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class Explosion extends Sprite
	{
	  private var _speedLimit:int = 5;
    private var _fadeRate:Number = 0.01;
    private var _numberOfParticles:int = 100;
    private var _gravity:Number = 0.1;
    private var _colors:Array = [0xFF6600, 0xFF9900, 0xFFCC00];
    private var _animationTimer:Timer = new Timer(16);
    private var _particles:Array = [];
     
		public function Explosion
		  (
		    numberOfParticles:int = 100, 
		    fadeRate:Number = 0.01
		  ):void
		{ 
		  this._numberOfParticles = numberOfParticles;
		  this._fadeRate = fadeRate;
		  
     //Create all the particles
	   for (var i:uint = 0; i< _numberOfParticles; i++) 
	   {
		  //Draw the particle.
		  //In this example, particles are MovieClip objects
		  //so that properties like vx, vy, and 
		  //fadeRate can be added dynamically
		  //This is just for convenience
		  var particle:MovieClip = new MovieClip();
		  
		  //Create a random color based on the _colors Array
		  //Casting the random number as uint has the same effect
		  //as Math.floor, but it's faster
		  var randomColor:uint = uint(Math.random() * _colors.length);
      particle.graphics.beginFill(_colors[randomColor]);
      
      //Draw the particle
		  particle.graphics.drawRect(-2, -2, 4, 4);
		  particle.graphics.endFill();
		  
		  //Add the particle to this Explosion object
		  addChild(particle);
		
		  //Give the particle a random rotation
		  particle.rotation = Math.floor(Math.random() * 360) - 180;
		  
		  //Give it a random initial alpha
		  particle.alpha = Math.random() + 0.5;
		  
		  //Give it a random velocity
		  particle.vx = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		  particle.vy = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		 
		  //Give the particle a custom rate at which it will fade out
		  particle.fadeRate = Math.random() * _fadeRate + 0.02;
		  
		  //Push the particle into the particles array
		  _particles.push(particle)
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
		  
		  for (var i:uint = 0; i < _particles.length; i++) 
	    {
	      //Set the alpha, update the position, and add gravity
			  _particles[i].alpha -= _particles[i].fadeRate;
			  _particles[i].x += _particles[i].vx;
			  _particles[i].vy += _gravity;
			  _particles[i].y += _particles[i].vy;
			  
			  //Remove the particle if its alpha is less than zero
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
			  (Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
  }
}