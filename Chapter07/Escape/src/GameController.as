﻿package{  import flash.events.Event;  import flash.display.*;  import flash.geom.Point;  import flash.geom.Matrix;  import flash.filters.*;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.lunarLander.*;  import com.friendsofed.gameElements.turret.*;  import com.friendsofed.gameElements.ufo.*;  import com.friendsofed.gameElements.primitives.*;  import com.friendsofed.vector.*;	public class GameController 	{	  private var _gameModel:GameModel;		private var _stage:Object;				//Delcare the lander MVC  	private var _landerModel:LanderModel;  	private var _landerUIController:LanderUIController;  	private var _landerView:LanderView;  	private var _landerUIView:LanderUIView;				//Declare the Bitmap objects that will hold the image of the cave		private var _caveImage:DisplayObject;		private var _caveBitmap:Bitmap;				//Create the fuel orb objects		private var _orbModel_0:CircleModel 		  = new CircleModel(15, 0x66FF33);		private var _orbView_0:CircleBlockView 		  = new CircleBlockView(_orbModel_0);		private var _orbModel_1:CircleModel 		  = new CircleModel(15, 0x66FF33);		private var _orbView_1:CircleBlockView 		  = new CircleBlockView(_orbModel_1);				//Declare the lander's turret and add its UI controller  	private var _turretModel:TurretModel;  	private var _turretUIController:TurretUIController;  	private var _turretView:TurretView;  	private var _turretUIView:TurretUIView;  	  	//Delclare the UFO   	private var _ufoModel:UfoModel;  	private var _ufoView:UfoView;  	private var _ufoAIController:UfoAIController;  	private var _ufoAIView:UfoAIView;				//Declare the enemy turret objects		private var _turretAIModel_0:TurretAIModel;		private var _turretAIController_0:TurretAIController;		private var _turretAIView_0:TurretAIView;    private var _turretView_0:TurretView;        private var _turretAIModel_1:TurretAIModel;		private var _turretAIController_1:TurretAIController;		private var _turretAIView_1:TurretAIView;    private var _turretView_1:TurretView;        private var _turretAIModel_2:TurretAIModel;		private var _turretAIController_2:TurretAIController;		private var _turretAIView_2:TurretAIView;    private var _turretView_2:TurretView;  	  	//Create the enemy cannon objects  	private var _cannonModel_0:RectangleModel   	  = new RectangleModel(30, 30, 0x000000);		private var _cannonView_0:RectangleBlockView 		  = new RectangleBlockView(_cannonModel_0);		private var _cannonModel_1:RectangleModel 		  = new RectangleModel(30, 30, 0x000000);		private var _cannonView_1:RectangleBlockView 		  = new RectangleBlockView(_cannonModel_1);		private var _cannonModel_2:RectangleModel 		  = new RectangleModel(30, 30, 0x000000);		private var _cannonView_2:RectangleBlockView 		  = new RectangleBlockView(_cannonModel_2);				//Declare scroll and collision controllers		private var _scroll:ScrollController;		private var _collision:CollisionController;		private var _sound:SoundController;					//The image of the cave    [Embed(source="../assets/images/lunarCave.png")]    private var CaveImage:Class;		public function GameController(model:GameModel, stage:Object):void 		{			_gameModel = model;			_stage = stage;						createLevel();			}		public function createLevel():void		{ 		  //Create the collision and scroll controllers		  //The CollisionController needs to access the SoundController		  _scroll = new ScrollController(_stage, _gameModel);		  _sound = new SoundController(_gameModel);		  _collision 		    = new CollisionController(_gameModel, _sound, _stage);		  		  //Build the lander MVC		  _landerModel = new LanderModel(30,30);  	  _landerUIController = new LanderUIController(_landerModel);  	  _landerView = new LanderView(_landerModel);  	  _landerUIView   	    = new LanderUIView(_landerModel, _landerUIController, _stage);  	    	  //Add the lander to the GameModel  	  _gameModel.playerModel = _landerModel;  	  		  //Add the lander to the game model's screen sprite		  _gameModel.playerView = _landerView;			_gameModel.screen.addChild(_landerView);			_landerModel.setX = 275;			_landerModel.setY = 300;			_landerModel.gravity_Vy = 0.1;						//Give the lander some fuel			_landerModel.fuel = 100;									//Power-up the lander's shields			_landerModel.shield = 100;						  //Add the cave			_caveImage = new CaveImage();			 var caveBitmapData:BitmapData 			   = new BitmapData			   (			     _caveImage.width, _caveImage.height, true, 0			   );			 			//Assign the cave's bitmap data to the game model			//so that it's accessable to other objects			_gameModel.caveBitmapData = caveBitmapData;						//Use the cave image to draw the cave bitmap data			_gameModel.caveBitmapData.draw(_caveImage);						//Create the cave bitmap			_caveBitmap = new Bitmap(_gameModel.caveBitmapData);						//Assign the cave bitmap to the game model 			//so that it's available to the map			_gameModel.caveBitmap = _caveBitmap;						//Add the cave bitmap to the game model's screen sprite			_gameModel.screen.addChild(_caveBitmap);						//Position the background so that the game starts			//at the bottom center			_caveBitmap.x = -500;			_caveBitmap.y = -1600;						//Add the fuel orbs			_gameModel.screen.addChild(_orbView_0);			_gameModel.fuelOrbModels.push(_orbModel_0);		  _gameModel.fuelOrbViews.push(_orbView_0);			_orbModel_0.setX = 1300 + _caveBitmap.x;			_orbModel_0.setY = 900 + _caveBitmap.y;					_gameModel.screen.addChild(_orbView_1);		  _gameModel.fuelOrbModels.push(_orbModel_1);		  _gameModel.fuelOrbViews.push(_orbView_1);			_orbModel_1.setX = 230 + _caveBitmap.x;			_orbModel_1.setY = 210 + _caveBitmap.y;						//Add the enemy cannons			_gameModel.screen.addChild(_cannonView_0);			_gameModel.cannonModels.push(_cannonModel_0);		  _gameModel.cannonViews.push(_cannonView_0);			_cannonModel_0.setX = 1250 + _caveBitmap.x;			_cannonModel_0.setY = 930 + _caveBitmap.y;						_gameModel.screen.addChild(_cannonView_1);		  _gameModel.cannonModels.push(_cannonModel_1);		  _gameModel.cannonViews.push(_cannonView_1);			_cannonModel_1.setX = 700 + _caveBitmap.x;			_cannonModel_1.setY = 500 + _caveBitmap.y;						_gameModel.screen.addChild(_cannonView_2);		  _gameModel.cannonModels.push(_cannonModel_2);		  _gameModel.cannonViews.push(_cannonView_2);			_cannonModel_2.setX = 200 + _caveBitmap.x;			_cannonModel_2.setY = 1250 + _caveBitmap.y;						//Dynamically build the turret MVCs and 			//add them to the GameModel's arrays			//They're all the same so building them 			//dynamically like this saves a bit of			//space. But, is it readable? I'll let 			//you decide. For a huge number of objects			//doing this would be necessary, but for a small 			//game like this you wouldn't need to.			//The last argument in the TurretModel 			//constructor assigns the player			//as the turret's enemy						//TurretAIModel(width, height, color, leftConstraint,       			//rightConstraint, enemy, attackRange, fireFrequency,     			//randomFire?);						for(var i:int = 0; i < 3; i++)      {        //Create the turrets        //1. Create the Model        this["_turretAIModel_" + i]           = new TurretAIModel          (            50, 10, 0x000000, 0, 0, _landerModel, 300, 2000, true          );                //2. Create the Controller  			  this["_turretAIController_" + i] 			    = new TurretAIController			    (			      this["_turretAIModel_" + i], 			      _gameModel, 			      _stage			    );			  			  //3. Create the View  			  this["_turretAIView_" + i] 			    = new TurretAIView			    (			      this["_turretAIModel_" + i], 			      _gameModel, this["_turretAIController_" + i], 			      _stage			    );			      		  this["_turretView_" + i]    		    = new TurretView(this["_turretAIModel_" + i]);  		      		  //Add them to the GameModel's screen sprite  		  //and give them exactly the same x and y   		  //positions as the cannons.  		  _gameModel.screen.addChild  		    (this["_turretView_" + i]);			  this["_turretAIModel_" + i].setX 			    = this["_cannonModel_" + i].xPos;			  this["_turretAIModel_" + i].setY 			    = this["_cannonModel_" + i].yPos;			  			  //Push them into the GameModel's arrays			  _gameModel.turretModels.push(this["_turretAIModel_" + i]);		    _gameModel.turretViews.push(this["_turretView_" + i]);		    		    //Add a CHANGE event listener to the turret Model so that		    //the GameController can detect changes to its		    //fireBullet property. fireBullet tells it when it		    //can add bullets to the stage.		    this["_turretAIModel_" + i].addEventListener			  (Event.CHANGE, enemyTurretChangeHandler);      }            //Create the player's turret      //It's not added to the stage until the player picks it up      _turretModel = new TurretModel(15, 3, 0x000000, -15, -160);  	  _turretUIController = new TurretUIController(_turretModel);  	  _turretView = new TurretView(_turretModel);  	  _turretUIView   	    = new TurretUIView(_turretModel, _turretUIController, _stage);  	    	  //Add the player's turret			_gameModel.screen.addChild(_turretView);			_gameModel.playersTurretModel = _turretModel;		  _gameModel.playersTurretView = _turretView;			_turretModel.setX = 150 + _caveBitmap.x;			_turretModel.setY = 850 + _caveBitmap.y;			//Make the turret inactive at the start of the game			_turretModel.turretIsActive = false;						//Add a CHANGE event listener to the player's turret so that		  //the GameController can detect changes to its		  //fireBullet property. fireBullet tells it when it		  //can add bullets to the stage.    		_turretModel.addEventListener			  (Event.CHANGE, playerTurretChangeHandler);						//Create the UFO and add its UI controller  		_ufoModel = new UfoModel(80,60);  		_ufoAIController = new UfoAIController(_ufoModel, _gameModel);  		_ufoView = new UfoView(_ufoModel);  		_ufoAIView   		  = new UfoAIView(_ufoModel, _gameModel, _ufoAIController);  		    		//Add a CHANGE event listener to the UFO Model so that		  //the GameController can detect changes to its		  //fireBullet property. fireBullet tells it when it		  //can add bullets to the stage.    		_ufoModel.addEventListener			  (Event.CHANGE, ufoChangeHandler);  			    		  		//Add the UFO  		_gameModel.screen.addChild(_ufoView);  		_gameModel.ufoModel = _ufoModel;		  _gameModel.ufoView = _ufoView;			_ufoModel.setX = 800 + _caveBitmap.x;			_ufoModel.setY = 100 + _caveBitmap.y;						//Set the center point for the UFO's elliptical flight path			_ufoModel.centerX = _caveBitmap.x + 800;			_ufoModel.centerY = _caveBitmap.y + 200;						//Set the range of the UFO's elliptical flight path			_ufoModel.rangeX = 500;			_ufoModel.rangeY = 50;		  		  //Start the ENTER_FRAME loop that runs the game		  _stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);	  }		private function enterFrameHandler(event:Event):void		{  		  //Run the game if it's visible on the stage		  if(_gameModel.screen.visible)		  {  		    //Update the game model		    _gameModel.update();		  		    //Update the lander			  _landerModel.update();			  StageBoundaries.stopBitmap(_landerModel, _stage); 			  _sound.thruster();						  //Make the UFO fly			  _ufoModel.fly();						  //Reduce the fuel if the lander is going up			  if(_landerModel.vy < 0)			  {			    _landerModel.fuel -= 0.05;			  }						  //Rotate the player's turret if it hasn't been picked up yet			  if(!_turretModel.turretIsActive)			  {			    _turretModel.angle += 5;			    //Check for a collision between the lander and the turret			    //If a collision occurs the GameModel's 			    //playersTurretIsActive property			    //is set to true. This allows fixes the 			    //turret to the player's position			    //and allows the player to fire bullets			    _collision.playerVsTurret();			  }			  else			  {			    _turretModel.setX 			      = _landerModel.xPos + _landerModel.width / 2;			    _turretModel.setY 			      = _landerModel.yPos + 2;			  }						  //Check for collisions with the fuel orbs			  _collision.playerVsFuelOrbs();						  //Check for collisions between the player and the cannons			  _collision.playerVsCannons();						  //Check for a collision between the player and the UFO			  _collision.playerVsUfo();              //Bullets        //The turrets and player share the         //same bullet pool, which simplifies         //bullet management. But, it also means         //that the player can be hit        //by its own bullets. A nice touch of realism!        var bulletModel:CircleModel;        var bulletView:CircleBlockView;              //Update the bullets        for(var i:int = 0; i < _gameModel.bulletModels.length; i++)        {          _gameModel.bulletModels[i].update;        }                //Check bullets for collision with other objects        _collision.checkBullets();              //The UFO's bullets behave differently         //when they hit the cave walls,        //so they don't share the same arrays as         //the turret and lander bullets        //Update the UFO bullet models and check         //whether any bullets are hitting anything        for(var l:int = 0; l < _gameModel.ufoBulletModels.length; l++)        {          _gameModel.ufoBulletModels[l].update;        }        _collision.checkUfoBullets();        			  //Scroll the background			  _scroll.update();					  //Collision between the lander and the cave bitmap			  _collision.landerVsCave			    (_landerModel, _landerView, _caveBitmap);			  	      //Remove any bullets that may 	      //have crossed the stage boundaries 	      _collision.removeBullets();	    }    }    private function playerTurretChangeHandler(event:Event):void		{		  if(_turretModel.fireBullet			&& _turretModel.turretIsActive		  && _turretModel.visible)		  {		    //Create the bulllet model and 		    //push it into the _bulletModels array        var bulletModel:CircleModel = new CircleModel(2);        _gameModel.bulletModels.push(bulletModel);                  //Position the bullet model at the end of the turret         //and give it an initial velocity        bulletModel.setX           = _turretModel.xPos           - _turretModel.width * Math.cos(_turretModel.angle);        bulletModel.setY           = _turretModel.yPos           - _turretModel.width * Math.sin(_turretModel.angle);        bulletModel.vx = Math.cos(_turretModel.angle) * -7;        bulletModel.vy = Math.sin(_turretModel.angle) * -7;        bulletModel.friction = 1;                //Add the bullet view and push         //it into the game model's bulletViews array         var bulletView:CircleBlockView           = new CircleBlockView(bulletModel);        _gameModel.screen.addChild(bulletView);        _gameModel.bulletViews.push(bulletView);              //Play the sound        _sound.playersTurret();               //Reset the turret so that it can fire again  		    _turretModel.fireBullet = false;			}	  }    private function ufoChangeHandler(event:Event):void		{		       if(_ufoModel.fireBullet      && _ufoModel.visible)  	  {  	    //Create the bulllet model and push   	    //it into the _bulletModels array        var bulletModel:CircleModel = new CircleModel(2);        _gameModel.ufoBulletModels.push(bulletModel);              //Position the bullet model in the middle of the UFO         //and give it an initial velocity        bulletModel.setX = _ufoModel.xPos + _ufoModel.width / 2;        bulletModel.setY = _ufoModel.yPos + _ufoModel.height / 2;        bulletModel.vx = Math.cos(_ufoModel.angle) * -7;        bulletModel.vy = Math.sin(_ufoModel.angle) * -7;        bulletModel.friction = 1;            //Add the bullet view and push it into         //the game model's bulletViews array         var bulletView:CircleBlockView           = new CircleBlockView(bulletModel);        _gameModel.screen.addChild(bulletView);        _gameModel.ufoBulletViews.push(bulletView);             //Play the sound        _sound.ufoShoot();          //Reset the UFO so that it can fire again    	    _ufoModel.fireBullet = false;  			        }	  }        private function enemyTurretChangeHandler(event:Event):void		{		  for(var i:int = 0; i < _gameModel.turretModels.length; i++)      {        if(event.target == _gameModel.turretModels[i])        {          var turret:TurretAIModel = _gameModel.turretModels[i];                  if(turret.fireBullet          && turret.visible)			    { 			      //Create the bullet model and push 			      //it into the game model's bulletModels array            var bulletModel:CircleModel = new CircleModel(2);            _gameModel.bulletModels.push(bulletModel);                        //Position the bullet model at the end of the turret             //and give it an initial velocity            bulletModel.setX               = turret.xPos - turret.width * Math.cos(turret.angle);            bulletModel.setY               = turret.yPos - turret.width * Math.sin(turret.angle);            bulletModel.vx = Math.cos(turret.angle) * -5;            bulletModel.vy = Math.sin(turret.angle) * -5;            bulletModel.friction = 1;                      //Add the bullet view and push it             //into the game model's bulletViews array             var bulletView:CircleBlockView               = new CircleBlockView(bulletModel);            _gameModel.screen.addChild(bulletView);            _gameModel.bulletViews.push(bulletView);                      //Play the sound            _sound.enemyTurret();                    //Reset the turret so that it can fire again  			      turret.fireBullet = false;			    }        }      }	  }	  internal function resetGame():void		{		  //Reset the GameModel's gameOver variable		  _gameModel.gameOver = false;		  		  //Redraw the cave bitmap to patch up 		  //any holes from the previous game		  _gameModel.caveBitmapData.draw(_caveImage);		  		  //Reset the scrolling values		  _scroll.initializeScroll();		  		  //Reset the lander		  _landerModel.visible = true;		  _landerModel.setX = 275;			_landerModel.setY = 300;			_landerModel.fuel = 100;				_landerModel.shield = 100;			_landerModel.vx = 0;				_landerModel.vy = 0;							//Reposition the cave bitmap			_caveBitmap.x = -500;			_caveBitmap.y = -1600;						//Reposition the player's turret			_turretModel.visible = true;			_turretModel.setX = 150 + _caveBitmap.x;			_turretModel.setY = 850 + _caveBitmap.y;			_turretModel.turretIsActive = false;			_turretModel.fireBullet = false;						//Reposition the UFO			_ufoModel.visible = true;			_ufoModel.setX = 800 + _caveBitmap.x;			_ufoModel.setY = 100 + _caveBitmap.y;			_ufoModel.centerX = _ufoModel.xPos;			_ufoModel.centerY = _ufoModel.yPos + 100;			_ufoModel.shield = 100;						//Reposition the cannons, turrets and fuel orbs			_cannonModel_0.setX = 1250 + _caveBitmap.x;			_cannonModel_0.setY = 930 + _caveBitmap.y;			_cannonModel_1.setX = 700 + _caveBitmap.x;			_cannonModel_1.setY = 500 + _caveBitmap.y;						_cannonModel_2.setX = 200 + _caveBitmap.x;			_cannonModel_2.setY = 1250 + _caveBitmap.y;						_turretAIModel_0.setX = _cannonModel_0.xPos;			_turretAIModel_0.setY = _cannonModel_0.yPos;			_turretAIModel_0.fireBullet = false;						_turretAIModel_1.setX = _cannonModel_1.xPos;			_turretAIModel_1.setY = _cannonModel_1.yPos;			_turretAIModel_1.fireBullet = false;						_turretAIModel_2.setX = _cannonModel_2.xPos;			_turretAIModel_2.setY = _cannonModel_2.yPos;			_turretAIModel_2.fireBullet = false;						_orbModel_0.setX = 1300 + _caveBitmap.x;			_orbModel_0.setY = 900 + _caveBitmap.y;					_orbModel_1.setX = 230 + _caveBitmap.x;			_orbModel_1.setY = 210 + _caveBitmap.y;						//Make the turrets and cannons visible again			for(var i:int = 0; i < _gameModel.cannonModels.length; i++)      {        if(!_gameModel.cannonModels[i].visible)        {          _gameModel.cannonModels[i].visible = true;        }        if(!_gameModel.turretModels[i].visible)        {          _gameModel.turretModels[i].visible = true;        }      }            //Make the fuel orbs visible again			for(var j:int = 0; j < _gameModel.fuelOrbModels.length; j++)      {        if(!_gameModel.fuelOrbModels[j].visible)        {          _gameModel.fuelOrbModels[j].visible = true;        }      }            //Remove any bullets that from the previous       //game that may still be flying around the stage      for(var k:int = 0; k < _gameModel.bulletModels.length; k++)      {        _gameModel.bulletModels.splice(k, 1);				_gameModel.screen.removeChild(_gameModel.bulletViews[k]);				_gameModel.bulletViews.splice(k, 1);				k--;      }      for(var l:int = 0; l < _gameModel.ufoBulletModels.length; l++)      {        _gameModel.ufoBulletModels.splice(l, 1);			  _gameModel.screen.removeChild(_gameModel.ufoBulletViews[l]);				_gameModel.ufoBulletViews.splice(l, 1);				l--;      }	  }	}}