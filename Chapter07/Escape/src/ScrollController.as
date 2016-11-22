package
{
	import flash.events.Event;
  import flash.display.*;
  import flash.geom.Point;
  import flash.geom.Matrix;
  import flash.filters.*;
  import com.friendsofed.utils.*;
  import com.friendsofed.gameElements.lunarLander.*;
  import com.friendsofed.gameElements.primitives.*;
  import com.friendsofed.vector.*;
  
	public class ScrollController
	{	
	  //Initialize the scrolling variables
		private var _rightInnerBoundary:int;
		private var _leftInnerBoundary:int;
		private var _topInnerBoundary:int;
		private var _bottomInnerBoundary:int;
		
		//Variable to hold a reference to the stage
		private var _stage:Object;
		
		//Variable to hold a reference to the game player
		private var _gameModel:Object;
		
		public function ScrollController
		  (stage:Object, gameModel:Object):void
		{ 
		  _stage = stage;
		  _gameModel = gameModel;
		  initializeScroll();
		  
	  }
	  public function initializeScroll():void
	  {
	    //Initialize the scrolling variables
			_rightInnerBoundary 
			  = (_stage.stageWidth * 0.5) + (_stage.stageWidth * 0.25);
		  _leftInnerBoundary 
		    = (_stage.stageWidth * 0.5) - (_stage.stageWidth * 0.25);
		  _topInnerBoundary 
		    = (_stage.stageHeight * 0.5) - (_stage.stageHeight * 0.25);
		  _bottomInnerBoundary 
		    = (_stage.stageHeight * 0.5) + (_stage.stageHeight * 0.25);
	  }
	  public function update():void
	  {
	    var player:AVerletModel = _gameModel.playerModel;
	    var background:Bitmap = _gameModel.caveBitmap;
	    
	    //Capture the current background x and y positions before 
			//they're changed by scrolling
	    var temporaryX:Number = background.x;
	    var temporaryY:Number = background.y;
	    
	    //Position the player's turret
			_gameModel.playersTurretModel.xPos 
			  = _gameModel.playersTurretModel.xPos 
			  - temporaryX 
			  + background.x;
			_gameModel.playersTurretModel.yPos 
			  = _gameModel.playersTurretModel.yPos 
			  - temporaryY 
			  + background.y;
			
			//Position the UFO
			_gameModel.ufoModel.centerX = background.x + 800;
			_gameModel.ufoModel.centerY = background.y + 200;
	    
	    //Stop player at inner boundary edges
			if (player.xPos < _leftInnerBoundary)
			{
				player.setX = _leftInnerBoundary;
				_rightInnerBoundary 
				  = (_stage.stageWidth * 0.5) 
				  + (_stage.stageWidth * 0.25);
				background.x -= player.vx;
			}
			else if (player.xPos + player.width > _rightInnerBoundary)
			{
				player.setX = _rightInnerBoundary - player.width;
				_leftInnerBoundary 
				  = (_stage.stageWidth * 0.5) 
				  - (_stage.stageWidth * 0.25);
				background.x -= player.vx;
			}
			if (player.yPos < _topInnerBoundary)
			{
				player.setY = _topInnerBoundary;
				_bottomInnerBoundary 
				  = (_stage.stageHeight * 0.5) 
				  + (_stage.stageHeight * 0.25);
				background.y -= player.vy;
			}
			else if (player.yPos + player.height > _bottomInnerBoundary)
			{
				player.setY = _bottomInnerBoundary - player.height;
				_topInnerBoundary 
				  = (_stage.stageHeight * 0.5) 
				  - (_stage.stageHeight * 0.25);
				background.y -= player.vy;
			}
			
			//Stop background at _stage edges
			if (background.x + background.width < _stage.stageWidth)
			{
				background.x = _stage.stageWidth - background.width;
				_rightInnerBoundary = _stage.stageWidth;
			}
			else if (background.x > 0)
			{
				background.x = 0;
				_leftInnerBoundary = 0;
			}
			if (background.y > 0)
			{
				background.y = 0;
				_topInnerBoundary = 0;
			}
			else if (background.y + background.height < _stage.stageHeight)
			{
				background.y = _stage.stageHeight - background.height;
				_bottomInnerBoundary = _stage.stageHeight;
			}
			
			//Calculate the scroll velocity
			var scroll_Vx:Number = background.x - temporaryX;
			var scroll_Vy:Number = background.y - temporaryY;
			
			//Position the player's turret
			_gameModel.playersTurretModel.xPos 
			  = _gameModel.playersTurretModel.xPos + scroll_Vx;
			_gameModel.playersTurretModel.yPos 
			  = _gameModel.playersTurretModel.yPos + scroll_Vy;
			
			//Position the UFO
			_gameModel.ufoModel.centerX = background.x + 800;
			_gameModel.ufoModel.centerY = background.y + 200;
			
			//Position the fuel orbs
	    for(var i:int = 0; i < _gameModel.fuelOrbModels.length; i++)
      {
        //Use the background's scroll velocity 
        //to help correctly position the fuel orbs
        _gameModel.fuelOrbModels[i].setX 
          = _gameModel.fuelOrbModels[i].xPos + scroll_Vx;
        _gameModel.fuelOrbModels[i].setY 
          = _gameModel.fuelOrbModels[i].yPos + scroll_Vy;
      }
      
      //Position the cannons and turrets
      for(var j:int = 0; j < _gameModel.cannonModels.length; j++)
      {
        //Use the background's scroll velocity 
        //to help correctly position the cannons
        _gameModel.cannonModels[j].setX 
          = _gameModel.cannonModels[j].xPos + scroll_Vx;
        _gameModel.cannonModels[j].setY 
          = _gameModel.cannonModels[j].yPos + scroll_Vy;
        
        _gameModel.turretModels[j].setX 
          = _gameModel.cannonModels[j].xPos;
        _gameModel.turretModels[j].setY 
          = _gameModel.cannonModels[j].yPos;
      }
      
      //Position the bullets
      for(var k:int = 0; k < _gameModel.bulletModels.length; k++)
      {
        _gameModel.bulletModels[k].setX 
          = _gameModel.bulletModels[k].xPos + scroll_Vx;
        _gameModel.bulletModels[k].setY 
          = _gameModel.bulletModels[k].yPos + scroll_Vy;
      }
      
      //Position the explosions
      for(var l:int = 0; l < _gameModel.explosions.length; l++)
      {
        _gameModel.explosions[l].x 
          = _gameModel.explosions[l].x + scroll_Vx;
        _gameModel.explosions[l].y 
          = _gameModel.explosions[l].y + scroll_Vy;
      }
      
      //Position the UFO's bullets
      for(var m:int = 0; m < _gameModel.ufoBulletModels.length; m++)
      {
        _gameModel.ufoBulletModels[m].setX 
          = _gameModel.ufoBulletModels[m].xPos + scroll_Vx;
        _gameModel.ufoBulletModels[m].setY 
          = _gameModel.ufoBulletModels[m].yPos + scroll_Vy;
      }
	  }
  }
}