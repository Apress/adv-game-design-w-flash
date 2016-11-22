package
{
	import flash.events.Event;
  import flash.display.*;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.geom.Matrix;
  import flash.filters.*;
  import com.friendsofed.utils.*;
  import com.friendsofed.gameElements.lunarLander.*;
  import com.friendsofed.gameElements.primitives.*;
  import com.friendsofed.vector.*;
  import com.friendsofed.gameElements.effects.*;
  
	public class CollisionController
	{	
	  private var _gameModel:Object;
	  private var _sound:Object;
	  private var _stage:Object;
	  
	  //Create a Lookup Table to precalculate the
    //velocities of the particles for the big explosions.
    //Determine the number of particles
    //and their size, maximum speed and colors
    private var _numberOfParticles:uint = 150;
    private var _particleSize:uint = 4;
    private var _speedLimit:int = 10;
    
    //Create Vectors to the particle velocities
    private var _particle_Vx:Vector.<Number> = new Vector.<Number>;
    private var _particle_Vy:Vector.<Number> = new Vector.<Number>;
    
    //Create a Vector to store the colors
    private var _colors:Vector.<uint> = new Vector.<uint>;
    private var _randomColors:Vector.<uint> = new Vector.<uint>;
	  
		public function CollisionController
		  (
		    gameModel:Object, 
		    soundController:Object, 
		    stage:Object
		  ):void
		{ 
		  this._gameModel = gameModel;
		  this._sound = soundController;
		  this._stage = stage;
		  
		  //Initialize explosion data
		  //Add colors to the _colors Vector
	    _colors.push(0xFF6600, 0xFF9900, 0xFFCC00);
	    
	    //Create random velocities and colors for all the particles
	    //and store them in the Vectors
		  for (var i:uint = 0; i< _numberOfParticles; i++) 
	    {
		    //Give it a random velocity
		    _particle_Vx[i]
		      = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		    _particle_Vy[i]
		      = (Math.random() * _speedLimit) - _speedLimit * 0.5;
		      
		    //Populate the _colors Vector with random colors  
		     var randomColor:uint = uint(Math.random() * _colors.length);
		     _randomColors.push(_colors[randomColor]);
	    }
	  }
	  public function landerVsCave
	    (
	      model:AVerletModel, 
	      view:AVerletView, 
	      objectB_Bitmap:Bitmap
	    ):void
	  {
	    //Create the bitmap
	    var modelBitmapData:BitmapData 
	      = new BitmapData(model.width, model.height, true, 0);
	   	modelBitmapData.draw(view); 
			var objectA_Bitmap:Object = createBitmap(model, view, true);
			
			var loopCounter:int = 0;
		  while (loopCounter++ != 10) 
		  {
			  if(objectA_Bitmap.bitmapData.hitTest
			      (
			        new Point(model.xPos, model.yPos), 
			        255, 
			        objectB_Bitmap,
			        new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			        255
			      )
			    )
			  {    
			    //Switch off gravity
			 	  model.gravity_Vy = 0;
			 	  
			 	  //Move objectA out of the collision 
			 	  //in the opposite direction
			 	  //of objectA's motion vector
			 	  
			    //Create "collision boxes" on all four sides of objectA to
			    //find out which side the collision is occuring on
			    
			    //Check for a collision on the bottom
			    if(objectA_Bitmap.bitmapData.hitTest
			        (
			          new Point(model.xPos, model.yPos + 10), 
			          255, 
			          objectB_Bitmap,
			          new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			          255  
			        )
			      )
			    {
			      //Move objectA out of the collision
			      model.setY = model.yPos - 1;
			      model.vy = 0;
			    }
			    
			    //Check for a collision on the top
			    else if
			      (objectA_Bitmap.bitmapData.hitTest
			        (
			          new Point(model.xPos, model.yPos - 10), 
			          255, 
			          objectB_Bitmap,
			          new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			          255
			        )
			      )
			    {
			      //Move objectA out of the collision
			      model.setY = model.yPos + 1;
			      model.vy = 0;
			    } 
			    
			    //Check for a collision on the right
			    if(objectA_Bitmap.bitmapData.hitTest
			        (
			          new Point(model.xPos + 10, model.yPos), 
			          255, 
			          objectB_Bitmap,
			          new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			          255
			        )
			      )
			    {
			      //Move objectA out of the collision
			      model.setX = model.xPos - 1;
			      model.vx = 0;
			    }
			    
			    //Check for a collision on the left 
			    else if
			      (objectA_Bitmap.bitmapData.hitTest
			        (
			          new Point(model.xPos - 10, model.yPos), 
			          255, 
			          objectB_Bitmap,
			          new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			          255
			        )
			      )
			    {
			      //Collision on left
			      model.setX = model.xPos + 1;
			      model.vx = 0;
			    }                      
			  } 
			  else 
			  {
			    break;
			  }
		  }
		  //Switch gravity back on if there is no ground below objectA
		  //Adding "+1" to objectA's y position in the collision
		  //test is the key to making this work
		  if(!objectA_Bitmap.bitmapData.hitTest
		      (
		        new Point(model.xPos, model.yPos + 3), 
			      255, 
			      objectB_Bitmap,
			      new Point(objectB_Bitmap.x, objectB_Bitmap.y),
			      255
			    )
			  )
			{
			  model.gravity_Vy = 0.1;
		  }
	  }
	  
    public function checkUfoBullets():void
    {
      //This is a long method which loops 
      //through all the UFO's bullets
      //and checks them for things they might be colliding with
      
      for(var i:int = 0; i < _gameModel.ufoBulletModels.length; i++)
      {
        //Decalre variables used in the method
        var bulletModel:CircleModel = _gameModel.ufoBulletModels[i];
        var bulletView:CircleBlockView = _gameModel.ufoBulletViews[i];
        var explosion:Explosion;
        var bigExplosion:ColorExplosion;
    
    //1. UFO BULLET VS. PLAYER
        
        if(_gameModel.playerModel.visible)
	      {
	        if(_gameModel.playerView.hitTestPoint
	            (
	              bulletView.x, bulletView.y, true
	            )
	          )                             
			    {
			      //Add the explosion
			      //Explosion(numberOfParticles, fadeRate)
				    explosion = new Explosion(10, 0.03);
				    explosion.x = bulletModel.xPos;
				    explosion.y = bulletModel.yPos;
				    _gameModel.screen.addChild(explosion);
				    _gameModel.explosions.push(explosion);
				  
				    //Play the sound
				    _sound.smallExplosion();
				
				    //Decrease the lander's sheild strength
				    _gameModel.playerModel.shield -= 10;
				
				    //If this the lander's shield is at zero, 
				    //add a really big explosion
				    //remove the lander's view from the stage
				    if(_gameModel.playerModel.shield <= 0
				    && _gameModel.playerModel.visible)
				    {
				      bigExplosion 
				        = new ColorExplosion
  					    (
  					      _numberOfParticles, 
  					      _particleSize, 
  					      _particle_Vx, 
  					      _particle_Vy,
  					      _randomColors
  					    );
				      bigExplosion.x 
			          = _gameModel.playerModel.xPos 
    			      + (_gameModel.playerModel.width * 0.5)
    			      - bigExplosion.width * 0.5;
    			    bigExplosion.y
    			      = _gameModel.playerModel.yPos
    			      + (_gameModel.playerModel.height * 0.5)
    			      - bigExplosion.height * 0.5; 
				      _gameModel.screen.addChild(bigExplosion);
				      _gameModel.explosions.push(bigExplosion);
				      explosion.addEventListener
				        ("explosionFinished", removeExplosion);
				    
				      //Play the sound
				      _sound.bigExplosion();
				    
				      //Make the lander and its turret invisible
				      _gameModel.playerModel.visible = false;
				      _gameModel.playersTurretModel.visible = false;
				    }
				    
				    //Remove the bullet
			      _gameModel.ufoBulletModels.splice(i, 1);
				    _gameModel.screen.removeChild
				      (_gameModel.ufoBulletViews[i]);
				    _gameModel.ufoBulletViews.splice(i, 1);
				    i--;
				  
				    //Quit the loop
				    break;
			    }
			  }
			  
		//2. UFO BULLET VS. CAVE WALL	  
		  
		    //The cave bitmap
		    var cave:Bitmap = _gameModel.caveBitmap;
		    
		    //Create the bullet bitmap
	      var bullet:Object = createBitmap
	        (bulletModel, bulletView, true);
			
			  if(bullet.bitmapData.hitTest
			      (
			        new Point(bulletModel.xPos, bulletModel.yPos), 
			        255, 
			        cave,
			        new Point(cave.x, cave.y),
			        255
			      )
			    )
			  {
			    //Cut out a section of the cave
			    /*
			    var radius:int = 40;
			    var circle:Shape = makeCircle(radius);
			    */
			    var brokenRock:Shape = makeBrokenRock();
			    
			    //Take a snapshot of the area being hit
			    //Create a blank BitmapData object to store the snapshot
			    //It should be the same size as the circle
			    var snapshotBitmapData:BitmapData 
			      = new BitmapData(80, 80, true, 0);
			      
			    //Create a rectangle object that's also 
			    //the same size as the circle. 
			    //This is the viewfinder that finds 
			    //the right spot on the bitmap to copy.
			    //!!IMPORTANT: Compensate for the scrolling
			    //background including the absolute value of
			    //cave background bitmap.
					var rectangle:Rectangle 
					  = new Rectangle
					  (
  					  bulletModel.xPos + Math.abs(cave.x) - 40, 
  					  bulletModel.yPos + Math.abs(cave.y) - 40, 
  					  80, 80
  				  ); 
				  
				  //A point object, which is needed to define 
					//the upper left corner of the bitmap
					//Leave this at 0,0 unless you need to offset it.
          var point:Point = new Point(0, 0);
          
          //Copy the pixels from the _caveBitmapData 
          //into the new snapshotBitmapData
          //The rectangle and point objects specify which part to copy
          snapshotBitmapData.copyPixels
            (
              _gameModel.caveBitmapData, 
              rectangle, 
              point
            ); 
			    
			    //Add the explosion
					var blitExplosion:BlitExplosion 
					  = new BlitExplosion(snapshotBitmapData, 4);
					  
					blitExplosion.x = 
					  bulletModel.xPos - blitExplosion.width * 0.5;
					blitExplosion.y = 
					  bulletModel.yPos - blitExplosion.height * 0.5;
					  
				  _gameModel.screen.addChild(blitExplosion);
				  _gameModel.explosions.push(blitExplosion);
				  blitExplosion.addEventListener
				    ("explosionFinished", removeExplosion);
			      
			    //Create a Matrix object. It's used to 
			    //position the circle shape
			    //in the right place in the cave bitmap
			    //IMPORTANT! Remember to compensate for 
			    //the displacement of the 
			    //bitmap in the scolling environment
			    var matrix:Matrix = new Matrix();
			    matrix.translate
			      (
			        bulletModel.xPos + Math.abs(cave.x), 
			        bulletModel.yPos + Math.abs(cave.y)
			      );
			  
			    //Redraw the cave bitmap using the circle 
			    //shape and the matrix
			    /*
			    _gameModel.caveBitmapData.draw
			      (circle, matrix, null, BlendMode.ERASE);
			      */
				  _gameModel.caveBitmapData.draw
			      (brokenRock, matrix, null, BlendMode.ERASE);
			      
				  //Play the sound
				  _sound.bigExplosion();
				  
			    //Remove the bullet
			    _gameModel.ufoBulletModels.splice(i, 1);
				  _gameModel.screen.removeChild
				    (_gameModel.ufoBulletViews[i]);
				  _gameModel.ufoBulletViews.splice(i, 1);
				  i--;
				  
				  //Quit the loop
				  break;
			  } 
      }
    }
    
    public function checkBullets():void
    {
      //This is a long method which loops through all the bullets
      //and checks them for things they might be colliding with
      
      for(var i:int = 0; i < _gameModel.bulletModels.length; i++)
      {
        //Decalre variables used in the method
        var bulletModel:CircleModel = _gameModel.bulletModels[i];
        var bulletView:CircleBlockView = _gameModel.bulletViews[i];
        var explosion:Explosion;
        var bigExplosion:ColorExplosion;
    
    //1.BULLET VS. CANNON
    
        for(var j:int = 0; j < _gameModel.cannonModels.length; j++)
        {
          if(_gameModel.cannonModels[j].visible)
          {
			      if(bulletView.hitTestObject(_gameModel.cannonViews[j]))                             
			      {
			        if(_gameModel.cannonModels[j].visible)
				      {
			          //Create a big explosion
  			        bigExplosion = new ColorExplosion
  					      (
      					    _numberOfParticles, 
      					    _particleSize, 
      					    _particle_Vx, 
      					    _particle_Vy,
      					    _randomColors
      					  );
  			        bigExplosion.x = 
  					      _gameModel.cannonModels[j].xPos 
  					      - bigExplosion.width * 0.5;
  					    bigExplosion.y = 
  					      _gameModel.cannonModels[j].yPos 
  					      - bigExplosion.height * 0.5;
  			        _gameModel.screen.addChild(bigExplosion);
  			        _gameModel.explosions.push(bigExplosion);
  			        bigExplosion.addEventListener
  			          ("explosionFinished", removeExplosion);
			      
  			        //Play the sound
  				      _sound.bigExplosion();
			      
  			        //Make the cannon and turret invisible
  			        _gameModel.cannonModels[j].visible = false;
  			        _gameModel.turretModels[j].visible = false;
			      
  			        //Remove the bullet
  			        _gameModel.bulletModels.splice(i, 1);
  				      _gameModel.screen.removeChild
  				        (_gameModel.bulletViews[i]);
  				      _gameModel.bulletViews.splice(i, 1);
  				      i--;
				  
  				      //Quit the loop
  				      break;
			        }
			      }
			    }
		    }
        
    //2. BULLET VS. PLAYER
    
        if(_gameModel.playerModel.visible)
	      {
			    if(_gameModel.playerView.hitTestPoint
			        (
			          bulletView.x, bulletView.y, true
			        )
			      )                             
			    {
			      //Add the explosion
			      //Explosion(numberOfParticles, fadeRate)
				    explosion = new Explosion(10, 0.03);
				    explosion.x = bulletModel.xPos;
				    explosion.y = bulletModel.yPos;
				    _gameModel.screen.addChild(explosion);
				    _gameModel.explosions.push(explosion);
				    explosion.addEventListener
				        ("explosionFinished", removeExplosion);
				  
				    //Play the sound
				    _sound.smallExplosion();
				
				    //Decrease the lander's sheild strength
				    _gameModel.playerModel.shield -= 10;
				
				    //If this the lander's shield is at zero, 
				    //add a really big explosion
				    //remove the lander's view from the stage
				    if(_gameModel.playerModel.shield <= 0)
				    {
				      bigExplosion 
				        = new ColorExplosion
  					    (
  					      _numberOfParticles, 
  					      _particleSize, 
  					      _particle_Vx, 
  					      _particle_Vy,
  					      _randomColors
  					    );
				      bigExplosion.x = 
					      bulletModel.xPos - bigExplosion.width * 0.5;
					    bigExplosion.y = 
					      bulletModel.yPos - bigExplosion.height * 0.5;
				      _gameModel.screen.addChild(bigExplosion);
				      _gameModel.explosions.push(bigExplosion);
				      bigExplosion.addEventListener
				        ("explosionFinished", removeExplosion);
				    
				      //Play the sound
				      _sound.bigExplosion();
				    
				      //Make the lander and its turret invisible
				      _gameModel.playerModel.visible = false;
				      _gameModel.playersTurretModel.visible = false;
				    }
				    
				    //Remove the bullet
  			    _gameModel.bulletModels.splice(i, 1);
			      _gameModel.screen.removeChild
			        (_gameModel.bulletViews[i]);
			      _gameModel.bulletViews.splice(i, 1);
			      i--;
				  
				    //Quit the loop
				    break;
			    }
			  }  
			     
    //3. BULLET VS. UFO
    
        if(_gameModel.playerModel.visible)
	      {
	        if(_gameModel.ufoView.hitTestPoint
	            (
	              bulletView.x, bulletView.y, true
	            )
	          )                             
			    {
			      //Add the explosion
			      //Explosion(numberOfParticles, fadeRate)
				    explosion = new Explosion(10, 0.03);
				    explosion.x = bulletModel.xPos;
				    explosion.y = bulletModel.yPos;
				    _gameModel.screen.addChild(explosion);
				    _gameModel.explosions.push(explosion);
				    explosion.addEventListener
				      ("explosionFinished", removeExplosion);
				  
				    //Play the sound
				    _sound.smallExplosion();
				
				    //Decrease the ufo's sheild strength
				    _gameModel.ufoModel.shield -= 10;
				
				    //If this the UFO's shield is at zero, 
				    //add a really big explosion
				    //remove the UFO's view from the stage
				    if(_gameModel.ufoModel.shield <= 0)
				    {
				      if(_gameModel.ufoModel.visible)
				      {
				        bigExplosion
  				        = new ColorExplosion
      			      (
      					    _numberOfParticles, 
      					    _particleSize, 
      					    _particle_Vx, 
      					    _particle_Vy,
      					    _randomColors
      					  );
      		      bigExplosion.x 
      			      = _gameModel.ufoModel.xPos 
      			      + (_gameModel.ufoModel.width * 0.5)
      			      - bigExplosion.width * 0.5;
      			    bigExplosion.y
      			      = _gameModel.ufoModel.yPos
      			      + (_gameModel.ufoModel.height * 0.5)
      			      - bigExplosion.height * 0.5; 
  				      _gameModel.screen.addChild(bigExplosion);
  				      _gameModel.explosions.push(bigExplosion);
  				      bigExplosion.addEventListener
  				        ("explosionFinished", removeExplosion);
				    
  				      //Play the sound
  				      _sound.bigExplosion();
				    
  				      //Make the ufo and its turret invisible
  				      _gameModel.ufoModel.visible = false;
			        }
				    }
				    
				    //Remove the bullet
  			    _gameModel.bulletModels.splice(i, 1);
			      _gameModel.screen.removeChild
			        (_gameModel.bulletViews[i]);
			      _gameModel.bulletViews.splice(i, 1);
			      i--;
				  
				    //Quit the loop
				    break;
			    }
			  } 
			  
    //4. BULLET VS. CAVE WALL
        
        //The cave bitmap
        var cave:Bitmap = _gameModel.caveBitmap; 
        
        //Create the bullet bitmap
	      var bullet:Object 
	        = createBitmap(bulletModel, bulletView, true);
        if(bullet.bitmapData.hitTest
            (
              new Point(bulletModel.xPos, bulletModel.yPos), 
			        255, 
			        cave,
			        new Point(cave.x, cave.y),
			        255
			      )
			    )
			  {
			    //Add the explosion
			    //Explosion(numberOfParticles, fadeRate)
				  explosion = new Explosion(10, 0.03);
				  explosion.x = bulletModel.xPos;
				  explosion.y = bulletModel.yPos;
				  _gameModel.screen.addChild(explosion);
				  _gameModel.explosions.push(explosion);
				  explosion.addEventListener
				    ("explosionFinished", removeExplosion);
				
				  //Play the sound
				  _sound.smallExplosion();
				
			    //Remove the bullet
			    _gameModel.bulletModels.splice(i, 1);
				  _gameModel.screen.removeChild(_gameModel.bulletViews[i]);
				  _gameModel.bulletViews.splice(i, 1);
				  i--;
				  
				  //Quit the loop
				  break;
			  } 
      }
    }
    
    
    public function playerVsTurret():void
    {
      if(_gameModel.playerView.hitTestObject
          (
            _gameModel.playersTurretView
          )
        )
      {
        //Allow the player to use the turret
        _gameModel.playersTurretModel.turretIsActive = true;
        
        //Give the turret its original rotation value
        _gameModel.playersTurretModel.angle = 0;
        
        //Play sound
        _sound.itemPickup();
      }
    }
    public function playerVsFuelOrbs():void
    {
      for(var i:int = 0; i < _gameModel.fuelOrbModels.length; i++)
      {
        //If the lander hits the fuel orb and its visible
        //then top up the lander's fuel supply and make
        //the fuel orb invisible.
        if(_gameModel.playerView.hitTestObject
            (_gameModel.fuelOrbViews[i])
        && _gameModel.fuelOrbModels[i].visible == true
        && _gameModel.playerModel.visible == true)
        {
					_gameModel.fuelOrbModels[i].visible = false;
					_gameModel.playerModel.fuel = 100;
					_sound.itemPickup();
        }
      }
    }
    public function playerVsCannons():void
    {
      for(var i:int = 0; i < _gameModel.cannonModels.length; i++)
      {
        //If the lander hits the cannon and the 
        //cannon is visible, then destroy the lander
        if(_gameModel.playerView.hitTestObject
            (_gameModel.cannonViews[i])
        && _gameModel.cannonModels[i].visible == true
        && _gameModel.playerModel.visible == true)
        {
					_gameModel.playerModel.shield = 0;
					
					//When the GameModel detects that the player's shield is 
					//zero, it set its gameOver variable to false
					//and dispatches an event. The GameView listens for that
					//event and ends the game
					
				  var bigExplosion:ColorExplosion 
				    = new ColorExplosion
			      (
					    _numberOfParticles, 
					    _particleSize, 
					    _particle_Vx, 
					    _particle_Vy,
					    _randomColors
					  );
		      bigExplosion.x 
			      = _gameModel.playerModel.xPos 
			      + (_gameModel.playerModel.width * 0.5)
			      - bigExplosion.width * 0.5;
			    bigExplosion.y
			      = _gameModel.playerModel.yPos
			      + (_gameModel.playerModel.height * 0.5)
			      - bigExplosion.height * 0.5; 
		      _gameModel.screen.addChild(bigExplosion);
		      _gameModel.explosions.push(bigExplosion);
		      bigExplosion.addEventListener
		        ("explosionFinished", removeExplosion);
				  //Play the sound
				  _sound.bigExplosion();
				  
				  _gameModel.playerModel.visible = false;
				  _gameModel.playersTurretModel.visible = false;
        }
      }
    }
    
    public function playerVsUfo():void
    {
      //If the lander hits the ufo and the ufo is visible, 
      //then destroy the lander
      if(_gameModel.playerView.hitTestObject(_gameModel.ufoView)
      && _gameModel.ufoModel.visible == true
      && _gameModel.playerModel.visible == true)
      {
				_gameModel.playerModel.shield = 0;
					
				//When the GameModel detects that the player's shield is 
				//zero, it set its gameOver variable to false
				//and dispatches an event. The GameView listens for that
				//event and ends the game
					
				//Create a big explosion
				var bigExplosion:Explosion = new Explosion(200, 0.005);
			  bigExplosion.x 
			    = _gameModel.playerModel.xPos 
			    + _gameModel.playerModel.width * 0.5;
			  bigExplosion.y 
			    = _gameModel.playerModel.yPos 
			    + _gameModel.playerModel.height * 0.5;
			  _gameModel.screen.addChild(bigExplosion);
			  _gameModel.explosions.push(bigExplosion);
			  bigExplosion.addEventListener
			    ("explosionFinished", removeExplosion);
			  
			  //Play the sound
				_sound.bigExplosion();
				
				//Make the player and the turret invisible
			  _gameModel.playerModel.visible = false;
			  _gameModel.playersTurretModel.visible = false;
      }
    }
    
    //Remove bullets that have crossed the stage boundaries
    public function removeBullets():void
    {
      var background:Bitmap = _gameModel.caveBitmap
      
      //Turret bullets
			for(var i:int = 0; i < _gameModel.bulletModels.length; i++)
      {
        _gameModel.bulletModels[i].update();
        
        //Remove them if they cross the stage boundaries
        //Top
				if 
				  (
				    _gameModel.bulletModels[i].yPos < background.y
				  )
				{
					_gameModel.bulletModels.splice(i, 1);
					_gameModel.screen.removeChild(_gameModel.bulletViews[i]);
					_gameModel.bulletViews.splice(i, 1);
					i--;
				}
				//Bottom
				else if 
				  (
				    _gameModel.bulletModels[i].yPos 
				    > background.y + background.height
				  )
		  	{
				  _gameModel.bulletModels.splice(i, 1);
					_gameModel.screen.removeChild(_gameModel.bulletViews[i]);
					_gameModel.bulletViews.splice(i, 1);
					i--;
				}
				//Left
				else if 
				  (
				    _gameModel.bulletModels[i].xPos < background.x
				  )
				{
					_gameModel.bulletModels.splice(i, 1);
					_gameModel.screen.removeChild(_gameModel.bulletViews[i]);
					_gameModel.bulletViews.splice(i, 1);
					i--;
				}
				//Right
				else if 
				  (
				    _gameModel.bulletModels[i].xPos 
				    > background.x + background.width
				  )
				{
					_gameModel.bulletModels.splice(i, 1);
					_gameModel.screen.removeChild(_gameModel.bulletViews[i]);
					_gameModel.bulletViews.splice(i, 1);
					i--;
				}
      }
      
      //UFO bullets
			for(var j:int = 0; j < _gameModel.ufoBulletModels.length; j++)
      {
        _gameModel.ufoBulletModels[j].update();
        
        //Remove them if they cross the stage boundaries
        //Top
				if 
				  (
				    _gameModel.ufoBulletModels[j].yPos < background.y
				  )
				{
					_gameModel.ufoBulletModels.splice(j, 1);
					_gameModel.screen.removeChild(_gameModel.ufoBulletViews[j]);
					_gameModel.ufoBulletViews.splice(j, 1);
					j--;
				}
				//Bottom
				else if 
				  (
				    _gameModel.ufoBulletModels[j].yPos  
				    > background.y + background.height
				  )
		  	{
				  _gameModel.ufoBulletModels.splice(j, 1);
					_gameModel.screen.removeChild(_gameModel.ufoBulletViews[j]);
					_gameModel.ufoBulletViews.splice(j, 1);
					j--;
				}
				//Left
				else if 
				  (
				    _gameModel.ufoBulletModels[j].xPos < background.x
				  )
				{
					_gameModel.ufoBulletModels.splice(j, 1);
					_gameModel.screen.removeChild(_gameModel.ufoBulletViews[j]);
					_gameModel.ufoBulletViews.splice(j, 1);
					j--;
				}
				//Right
				else if 
				  (
				    _gameModel.ufoBulletModels[j].xPos 
				    > background.x + background.width
				  )
				{
					_gameModel.ufoBulletModels.splice(j, 1);
					_gameModel.screen.removeChild(_gameModel.ufoBulletViews[j]);
					_gameModel.ufoBulletViews.splice(j, 1);
					j--;
				}
      }
    }
	  private function createBitmap
	    (
	      model:AVerletModel, 
	      view:AVerletView, 
	      alphaTransparency:Boolean
	    ):Object
		{
		  //BitmapData(width, height, transparent?, fillColor(0 is alpha))
			var bitmapData:BitmapData 
			  = new BitmapData
			  (
			    model.width, model.height, alphaTransparency, 0
			  );
			bitmapData.draw(view);
			var bitmap:Bitmap = new Bitmap(bitmapData);
			
			//Create the star object to return to the caller
			var bitmapObject:Object = new Object;
			bitmapObject.bitmapData = bitmapData;
			bitmapObject.bitmap = bitmap;
			
			return bitmapObject;
		}
		
		private function makeCircle(radius:int = 30):Shape
		{
		  //Create the shape
		  var shape:Shape = new Shape();
		  shape.graphics.lineStyle(0);
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawCircle(0, 0, radius);
			shape.graphics.endFill();
			
			return shape
	  }
	  
	  private function makeBrokenRock(scaleFactor:int = 8):Shape
		{
		  //Create a new Vector object for the drawing coordinates
			var coordinates:Vector.<Number> = new Vector.<Number>();
			
			//Create the broken rock shape
			//in a 1:1 grid
			coordinates.push
			  (
			    0,0, 4,2, 7,0, 10,2,
			    8,6, 10,10, 6,9, 4,10,
			    3,9, 0,10, 2,7, 0,5,
			    1,3, 0,0
			  );
		
			//Scale to the correct size, and center the shape
			for(var i:int = 0; i < coordinates.length; i++)
      {
        //Scale the shape to the scaleFactor value
        coordinates[i] *= scaleFactor;
        
        //Center the shape at 0,0
        coordinates[i] -= (scaleFactor * 10) * 0.5;
      }
      
			//Create a Vector object for the drawing commands
			var commands:Vector.<int> = new Vector.<int>(); 
			
			//1 = moveTo(), 2 = lineTo(), 3 = curveTo()
			commands.push(1,2,2,2,2,2,2,2,2,2,2,2,2,2);
			
		  //Create the shape
		  var shape:Shape = new Shape();
		  shape.graphics.lineStyle(0);
			shape.graphics.beginFill(0xFFFFFF);
			shape.graphics.drawPath(commands, coordinates);
			shape.graphics.endFill();
			
			return shape
	  }
	  
	  //Remove the explosion if the "explosionFinished"
    //event is triggered by the explosion instance.
    //The explosion object could be of three different types,
    //so you need to use the "is" keyword to find out what
    //type of explosion is calling this handler. This is important
    //because you have to cast is as the right type if you
    //want to remove it from the stage with removeChild.
    public function removeExplosion(event:Event):void
    {
      if(event.target is Explosion)
      {
        _gameModel.screen.removeChild(Explosion(event.target));
      }
      else if(event.target is ColorExplosion)
      {
        _gameModel.screen.removeChild(ColorExplosion(event.target));
      }
      else if(event.target is BlitExplosion)
      {
        _gameModel.screen.removeChild(BlitExplosion(event.target));
      }
      _gameModel.explosions.splice
        (_gameModel.explosions.indexOf(event.target), 1);
    }
    /*
    public function removeBExplosion(event:Event):void
    {
      _gameModel.screen.removeChild(ColorExlposion(event.target));
      _gameModel.explosions.splice
        (_gameModel.explosions.indexOf(event.target), 1);
    }
    */
  }
}