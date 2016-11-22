package com.friendsofed.gameElements.effects
{
  import flash.events.Event;
	import flash.display.*;
	import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.events.TimerEvent;
	import flash.utils.Timer;
	import com.friendsofed.vector.*;

	public class BlitExplosion extends Bitmap
	{
	  private var _speedLimit:int = 5;
    private var _gravity:Number = 0.2;
    private var _animationTimer:Timer = new Timer(16);
    private var _fadeCounter:int = 50;
    private var _gridSize:uint;
    private var _tileSize:uint;
    private var _sourceBitmapData:BitmapData;
     
    //Create a blank BitmapData object as the canvas for this bitmap
    //This is the same as the "stage bitmap" from the 
    //previous examples, except that it's only contained within this      
    //object. It needs to be big enough to
    //contain all the particles during the explosion
    private var _explosionBitmapData:BitmapData 
      = new BitmapData(700, 700, true, 0);
     
    //The array that stores the particle tiles 
    private var _tiles:Array = [];
     
		public function BlitExplosion
		(
		  bitmapData:BitmapData, 
		  tileSize:uint = 10
		):void
		{ 
		  _sourceBitmapData = bitmapData;
		  _tileSize = tileSize;
		  _gridSize = uint(_sourceBitmapData.width / _tileSize);
		  
		  //Add the blank BitmapData to this Bitmap object
		  this.bitmapData = _explosionBitmapData;
		  
		  //Slice the _sourceBitmapData into small tiles
		  for(var column:int = 0; column < _gridSize; column++)
      {
        for(var row:int = 0; row < _gridSize; row++)
        {
          //Create a tile object to store the tile's original
          //position and give it initial velocity
          //This become's the tile's "Model"
          var tileModel:Object = new Object();
          
          //Record the tile's position on the snapshot image
          //so that the correct section of the snapshot can be found
          //when the tile is copied onto the explosions bitmap
          tileModel.tileMap_X = column * _tileSize;
          tileModel.tileMap_Y = row * _tileSize;
          
          //Center in the correct place inside this explosion object
          tileModel.x 
            = column * tileSize - (_sourceBitmapData.width * 0.5);
                        
          tileModel.y 
            = row * tileSize - (_sourceBitmapData.width * 0.5);
		      
		      //Starburst explosion
		      //1. Find the center of the grid
		      var centerOfGrid:uint = _gridSize * 0.5;
		      
		      //2. Find the vx and vy between the center and this particle
		      var vx:int = int(tileModel.x - centerOfGrid);
          var vy:int = int(tileModel.y - centerOfGrid);
		      
		      //3. The distance between the center of 
		      //the grid and the current particle
		      var distance:int = int(Math.sqrt(vx * vx + vy * vy));
		      
		      //4. Find the dx and dy
		      var dx:Number = vx / distance;
		      var dy:Number = vy / distance;
		      
		      //5. Assign a random speed, but a 
		      //definite direction based on the vector
		      tileModel.vx = (Math.random() * _speedLimit) * dx;
		      tileModel.vy = (Math.random() * _speedLimit) * dy;
		  
		      //Push the tile into the tiles array
		      _tiles.push(tileModel);
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