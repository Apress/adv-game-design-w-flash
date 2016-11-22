package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.friendsofed.vector.*;

	public class MixedExplosion extends Bitmap
	{
	  private var _gravity:Number = 0.2;
    private var _animationTimer:Timer = new Timer(16);
    private var _fadeCounter:int = 50;
    private var _gridSize:uint;
    private var _tileSize:uint;
    private var _particleSize:uint;
    private var _sourceBitmapData:BitmapData;
    private var _particles:Array = [];
    private var _numberOfParticles:uint = 100;
     
    //Create a blank BitmapData object as the 
    //canvas for this explosion
    private var _explosionBitmapData:BitmapData 
      = new BitmapData(700, 700, true, 0);
     
    //The array that stores the particle tiles 
    private var _tiles:Array = [];
     
		public function MixedExplosion
		  (
		    bitmapData:BitmapData, 
		    tileSize:int,
		    numberOfParticles:uint,
		    particleSize:uint,
		    particle_Vx:Vector.<Number>,
		    particle_Vy:Vector.<Number>,
		    randomColors:Vector.<uint>,
		    tile_Vx:Vector.<Number>,
		    tile_Vy:Vector.<Number>,
		    gridSize:uint,
		    snapShotSize:uint
		  ):void
		{ 
		  _sourceBitmapData = bitmapData;
		  _tileSize = tileSize;
		  _gridSize = gridSize//uint(_sourceBitmapData.width / _tileSize);
		  _numberOfParticles = numberOfParticles;
		  this._particleSize = particleSize;
		  
		  //Add the blank BitmapData to this Bitmap object
		  this.bitmapData = _explosionBitmapData;
		  
		  //Slice the _sourceBitmapData into small tiles
		  var tileCounter:uint = 0;
		  for(var column:int = 0; column < _gridSize; column++)
      {
        for(var row:int = 0; row < _gridSize; row++)
        {
          //Create a tile object to store the tile's original
          //position and give it initial velocity
          //This become's the tile's "Model"
          var tileModel:Object = new Object();
          
          //Record the tile's position on the snapshop image
          //so that the correct section of the snapshot can be found
          //when the tile is copied onto the explosions bitmap
          tileModel.tileMap_X = column * _tileSize;
          tileModel.tileMap_Y = row * _tileSize;
          
          //Center in the correct place inside this explosion object
          tileModel.x 
            = column * tileSize - (snapShotSize * 0.5);
                        
          tileModel.y 
            = row * tileSize - (snapShotSize * 0.5);
		      
		      //Assign the velocity based on the
		      //precalculated vector in the application class
		      tileModel.vx = tile_Vx[tileCounter]
		      tileModel.vy = tile_Vy[tileCounter]
		  
		      //Push the tile into the tiles array
		      _tiles.push(tileModel);
		      tileCounter++;  
        }
      }
      
      //Create the colored particles
      //Create all the particles
	    //Create all the particles
	    for (var i:uint = 0; i< _numberOfParticles; i++) 
	    {
		    //Create the particle object
		    var particle:Object = new Object();
		  
		    particle.bitmapData 
		      = new BitmapData
		        (
		          _particleSize, _particleSize, false, randomColors[i]
		        );
		      
		    //Give it an intial position 
		    particle.x = 0;
		    particle.y = 0;
		    
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
		  
		  for(var i:int = 0; i < _tiles.length; i++)
      {
        //1. Update the Model.
        //Find the new positions of the particles
        _tiles[i].x += _tiles[i].vx;
			  _tiles[i].vy += _gravity;
			  _tiles[i].y += _tiles[i].vy; 
			    
			   //2. Create the particle View and display it on the stage
			    
			  //Find the tileModel's corresponding tile in the snapshot's
			  //BitmapData and plot it to a new position in this containing 
			  //bitmap Create a Rectangle object that's aligned to the 
			  //correct spot on the snapshot.
        var sourceRectangle:Rectangle = new Rectangle
        (
          _tiles[i].tileMap_X, 
          _tiles[i].tileMap_Y, 
          _tileSize, 
          _tileSize
        );
					
				//Create a Point object that defines the new position of the
				//tile on on the stage bitmap                                        
        var destinationPoint:Point 
          = new Point
          (
            _tiles[i].x + (_explosionBitmapData.width * 0.5), 
            _tiles[i].y + (_explosionBitmapData.height * 0.5)
          );                                       
          
        //Copy the pixels from the original image's BitmapData into 
        //the new tileBitmapData The rectangle and point objects 
        //specify which part to copy
        _explosionBitmapData.copyPixels
          (
            _sourceBitmapData, 
            sourceRectangle, 
            destinationPoint
          );
      }
      
      //Animate the colored particles
      for(var j:int = 0; j < _particles.length; j++)
      {
        //Find the new positions of the particles
        _particles[j].x += _particles[j].vx;
			  //_particles[i].vy += _gravity;
			  _particles[j].y += _particles[j].vy; 
			  
			  //Plot them on the explosion bitmap
			  var source:Rectangle 
			    = new Rectangle(0,0, _particleSize, _particleSize);
			    
			  var destination:Point 
			    = new Point
          (
            _particles[j].x + (_explosionBitmapData.width * 0.5), 
            _particles[j].y + (_explosionBitmapData.height * 0.5)
          );     
          
			  _explosionBitmapData.copyPixels
          (
            _particles[j].bitmapData, 
            source, 
            destination
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
          //Dispatch an event to inform the parent that the
          //explosion is finished so that it can be removed
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