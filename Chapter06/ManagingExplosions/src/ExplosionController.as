package
{
	import flash.events.Event;
  import flash.display.*;
  import com.friendsofed.gameElements.effects.*;
  
	public class ExplosionController extends Sprite
	{
	  //Create Lookup Tables to precalculate the
	  //values for the explosions.

	  //Determine the number of particles
	  //and their size, maximum speed and colors
	  private var _numberOfParticles:uint = 100;
	  private var _particleSize:uint = 2;
	  private var _particleSpeedLimit:int = 20;
    private var _snapShotSize:uint = 80;
    private var _tileSize:uint = 4;
	  private var _tileSpeedLimit:int = 5;
	  private var _gridSize:uint;
	    
	  //Create Vectors to the particle velocities
	  private var _particle_Vx:Vector.<Number> = new Vector.<Number>;
	  private var _particle_Vy:Vector.<Number> = new Vector.<Number>;
	    
	  //Create a Vector to store the colors
	  private var _colors:Vector.<uint> = new Vector.<uint>;
	  private var _randomColors:Vector.<uint> = new Vector.<uint>;
	    
    private var _tile_Vx:Vector.<Number> = new Vector.<Number>;
	  private var _tile_Vy:Vector.<Number> = new Vector.<Number>;
	  
	  //Array to store the explosions
		private var _explosions:Array = [];
	  
	  public function ExplosionController(snapShotSize:uint = 80):void
	  {
	    this._snapShotSize = snapShotSize;
	    this._gridSize = _snapShotSize / _tileSize;
	    
      //Initialize values for the colored particles.	 
  	  //Create random velocities for all the particles
  	  //and store them in the Vector
  	  _colors.push(0xFF6600, 0xFF9900, 0xFFCC00);
  		for (var i:uint = 0; i< _numberOfParticles; i++) 
  	  {
  		  //Give it a random velocity
  		  _particle_Vx[i]
  		    = (Math.random() * _particleSpeedLimit) 
  		    - _particleSpeedLimit * 0.5;
  		  _particle_Vy[i]
  		    = (Math.random() * _particleSpeedLimit) 
  		    - _particleSpeedLimit * 0.5;
		      
  		  //Populate the _colors Vector with random colors  
  		   var randomColor:uint = uint(Math.random() * _colors.length);
  		   _randomColors.push(_colors[randomColor]);
  	  }
	    
      //Initialize values for the bitmap tiles.
	    //Pre-calculate the vectors for the starburst explosion effect
  	  var tileCounter:uint = 0;
  	  for(var column:int = 0; column < _gridSize; column++)
      {
        for(var row:int = 0; row < _gridSize; row++)
        {
          //Find the tile's x and y position
          var x:uint
            = column * _tileSize - (_snapShotSize * 0.5);      
          var y:uint
            = row * _tileSize - (_snapShotSize * 0.5);
            
          //1. Find the center of the grid
  		    var centerOfGrid:uint = _gridSize * 0.5;
		      
  		    //2. Find the vx and vy between the center and this particle
  		    var vx:int = int(x - centerOfGrid);
          var vy:int = int(y - centerOfGrid);
          
          //3. The distance btween the center of 
  		    //the grid and the current tile
  		    var distance:int = int(Math.sqrt(vx * vx + vy * vy));
		      
  		    //4. Find the dx and dy
  		    var dx:Number = vx / distance;
  		    var dy:Number = vy / distance;
		      
  		    //5. Find a random speed, but a 
  		    //definite direction based on the vector  
          _tile_Vx[tileCounter]
  		      = (Math.random() * _tileSpeedLimit) * dx;
  		    _tile_Vy[tileCounter]
  		      = (Math.random() * _tileSpeedLimit) * dy;
		      
  		    tileCounter++;  
        }
      }
      trace("object created");
    }
    
    public function createExplosion
      (
        xPos:Number, 
        yPos:Number,
        snapshotBitmapData:BitmapData
      ):void
    {
      var explosion:MixedExplosion
				= new MixedExplosion
			  (
			    snapshotBitmapData,
			    _tileSize,
			    _numberOfParticles, 
			    _particleSize, 
			    _particle_Vx, 
			    _particle_Vy,
			    _randomColors,
			    _tile_Vx,
			    _tile_Vy,
			    _gridSize,
			    _snapShotSize
			  );
			 
			//Position the explosion so that it matches the
			//x and y position of the bullet on the stage 
			explosion.x = xPos - explosion.width * 0.5;
			explosion.y = yPos - explosion.height * 0.5;
			
			//Add an event listener to the explosion so that
			//it can be removed when its alpha reaches zero
			explosion.addEventListener
			  ("explosionFinished", removeExplosion);
			
			//Add the explosion to the display list 
			addChild(explosion);
			
			//Push the explosion into the _explosions array
			_explosions.push(explosion);
    }
    
    //Remove the explosion if the "explosionFinished"
    //event is triggered by the explosion instance.
    //This will happen when it's alpha reaches zero.
    public function removeExplosion(event:Event):void
    {
      removeChild(MixedExplosion(event.target));
      _explosions.splice(_explosions.indexOf(event.target), 1);
    }
	}
} 