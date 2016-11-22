﻿package{	import flash.events.Event;  import flash.display.*;  import flash.geom.Point;  import flash.geom.Rectangle;  import flash.geom.Matrix;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.lunarLander.*;  import com.friendsofed.gameElements.turret.*;  import com.friendsofed.gameElements.primitives.*;  import com.friendsofed.gameElements.effects.*;  import com.friendsofed.vector.*;  [SWF(width="550", height="400",   backgroundColor="#FFFFFF", frameRate="60")]  	public class BitmapParticleExplosion extends Sprite	{			//Create the lander and add its UI controller  		private var _lander:LanderModel   		  = new LanderModel(30,30);  		private var _landerUIController:LanderUIController   		  = new LanderUIController(_lander);  		private var _lander_View:LanderView   		  = new LanderView(_lander);  		private var _landerUIView:LanderUIView   		  = new LanderUIView(_lander, _landerUIController, stage);  		  		//Create the lander's turret and add its UI controller  		private var _turret:TurretModel   		  = new TurretModel(15, 3, 0x000000, -15, -160);  		private var _turretUIController:TurretUIController   		  = new TurretUIController(_turret);  		private var _turret_View:TurretView   		  = new TurretView(_turret);  		private var _turretUIView:TurretUIView   		  = new TurretUIView(_turret, _turretUIController, stage);  		  		//Array to store the bullet model and views  		private var _bulletModels:Array = [];  		private var _bulletViews:Array = [];  		  		//Status box  		private var _statusBox:StatusBox = new StatusBox;						//Variables required to display the cave bitmap			private var _caveBitmap:Bitmap;			private var _caveImage:DisplayObject;			private var _caveBitmapData:BitmapData;						//Array to store the explosions			private var _explosions:Array = [];						//The starting x position for the snapshots			private var _snapshot_X:int = 10;						//Embed the image of the cave      [Embed(source="../assets/images/caveTwo.png")]      private var CaveImage:Class;				public function BitmapParticleExplosion():void		{ 		  //Add the lander to the stage			addChild(_lander_View);			_lander.setX = 75;			_lander.setY = 50;						//Add gravity			_lander.gravity_Vy = 0.1;						//Add the turret to the stage			addChild(_turret_View);						//Set the turret to the lander's position			_turret.setX = _lander.xPos;			_turret.setY = _lander.yPos - 13;						//Create a new instance of the CaveImage class			_caveImage = new CaveImage();						//Create a BitmapData object to store the image			_caveBitmapData 			  = new BitmapData			    (			      _caveImage.width, _caveImage.height, true, 0			    );			_caveBitmapData.draw(_caveImage);						//Create and add the cave bitmap image			_caveBitmap = new Bitmap(_caveBitmapData);			addChild(_caveBitmap);			_caveBitmap.x = 0;			_caveBitmap.y = 0;						//Add the status box			addChild(_statusBox);						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{ 						//Update the lander and position the turret			_lander.update();			_turret.setX = _lander.xPos + _lander.width / 2;			_turret.setY = _lander.yPos + 2;			StageBoundaries.wrapBitmap(_lander, stage); 						bitmapCollision(_lander, _lander_View, _caveBitmap);						//Fire bullets			if(_turret.fireBullet == true)			{			  //Create the bulllet model and push it 			  //into the _bulletModels array        var bulletModel:CircleModel = new CircleModel(2);        _bulletModels.push(bulletModel);                    //Position the bullet model at the end of the turret         //and give it an initial velocity        bulletModel.setX           = _turret.xPos - _turret.width * Math.cos(_turret.angle);        bulletModel.setY           = _turret.yPos - _turret.width * Math.sin(_turret.angle);        bulletModel.vx = Math.cos(_turret.angle) * -7;        bulletModel.vy = Math.sin(_turret.angle) * -7;        bulletModel.friction = 1;                  //Add the bullet views and push it into the _bulletViews array         var bulletView:CircleView = new CircleView(bulletModel);        addChild(bulletView);        _bulletViews.push(bulletView);                  //Reset the turret so that it can fire again  			  _turret.fireBullet = false;			}						//Update the bullet models			for(var i:int = 0; i < _bulletModels.length; i++)      {        //Update them        _bulletModels[i].update();                //Check for a collision between the cave bitmap and the			  //bullets x and y position			  if(_caveBitmapData.hitTest			      (			        new Point(_caveBitmap.x, _caveBitmap.y), 			        255, 			        new Point(_bulletModels[i].xPos, 			        _bulletModels[i].yPos)			      )			    )                                    			  { 			    //Add the circle			    var radius:int = 40;			    var circle:Shape = makeCircle(radius);			    			    //Take a snapshot of the area being hit			    			    //Create a blank BitmapData object to store the snapshot			    //It should be the same size as the circle			    var snapshotBitmapData:BitmapData 			      = new BitmapData(80, 80, true, 0);			    			    //Create a rectangle object that's also 			    //the same size as the circle. 			    //This is the viewfinder that finds the 			    //right spot on the bitmap to copy.					var rectangle:Rectangle 					  = new Rectangle					  (					    _bulletModels[i].xPos - 40, 					    _bulletModels[i].yPos - 40, 					    80, 80					  );										//A point object, which is needed to define the 					//upper left corner of the bitmap					//Leave this at 0,0 unless you need to offset it.          var point:Point = new Point(0, 0);                    //Copy the pixels from the _caveBitmapData into           //the new snapshotBitmapData          //The rectangle and point objects specify which part to copy          snapshotBitmapData.copyPixels            (_caveBitmapData, rectangle, point);      			    //Add the explosion					var explosion:BitmapExplosion 					  = new BitmapExplosion(snapshotBitmapData, 4);					explosion.x = _bulletModels[i].xPos;					explosion.y = _bulletModels[i].yPos;										addChild(explosion);					_explosions.push(explosion);					explosion.addEventListener			      ("explosionFinished", removeExplosion);			      			    //Create a Matrix object. It's used to 			    //position the circle shape			    //in the right place in the cave bitmap			    var matrix:Matrix = new Matrix();			    matrix.translate			      (_bulletModels[i].xPos, _bulletModels[i].yPos)			      			    //Redraw the cave bitmap using the 			    //circle shape and the matrix			    _caveBitmapData.draw(circle, matrix, null, BlendMode.ERASE);					  			    //Remove the bullet			    _bulletModels.splice(i, 1);					removeChild(_bulletViews[i]);					_bulletViews.splice(i, 1);					i--;										//Break the for loop					break;		    }      }      		  //Remove the bullets if they cross the stage boundaries			for(var j:int = 0; j < _bulletModels.length; j++)      {        //Update the bullet Model        _bulletModels[j].update();                //Remove the bullet if it crosses the stage boundary				if(_bulletModels[j].yPos < 0				|| _bulletModels[j].yPos > stage.stageHeight				|| _bulletModels[j].xPos < 0				|| _bulletModels[j].xPos > stage.stageWidth)				{					_bulletModels.splice(j, 1);					removeChild(_bulletViews[j]);					_bulletViews.splice(j, 1);					j--;				}      }            //Update status box			_statusBox.text = "PARTICLE EXPLOSION:"; 			_statusBox.text 			  += "\n" + "BULLETS ON STAGE: " + _bulletModels.length;  		}			  //Remove the explosion if the "explosionFinished"    //event is triggered by the explosion instance    public function removeExplosion(event:Event):void    {      removeChild(BitmapExplosion(event.target));      _explosions.splice(_explosions.indexOf(event.target), 1);    }        //Collision between the Lander and the cave		private function bitmapCollision		  (		    model:AVerletModel, 		    view:AVerletView, 		    collisionBitmap:Bitmap		  ):void		{		  var bitmapData:BitmapData = new BitmapData		    (		      model.width, model.height, true, 0		    );		  bitmapData.draw(view); 						var objectBitmap:Object = createBitmap(model, view);						var loopCounter:int = 0;		  while (loopCounter++ != 10) 		  {			  if(objectBitmap.bitmapData.hitTest			      (			        new Point(model.xPos, model.yPos), 			        255, 			        collisionBitmap,			        new Point(collisionBitmap.x, collisionBitmap.y),			        255			       )			    )			  {    			    //Switch off gravity			 	  model.gravity_Vy = 0;			 	 			    //Create "collision boxes" on all four 			    //sides of the object to			    //find out which side the collision is occuring on			    			    //Check for a collision on the bottom			    if(objectBitmap.bitmapData.hitTest			        (			          new Point(model.xPos, model.yPos + 10), 			          255, 			          collisionBitmap,			          new Point(collisionBitmap.x, collisionBitmap.y),			          255			        )			      )			    {			      //Move the object out of the collision			      model.setY = model.yPos - 1;			      model.vy = 0;			    }			    			    //Check for a collision on the top			    else if(objectBitmap.bitmapData.hitTest			        (			          new Point(model.xPos, model.yPos - 10), 			          255, 			          collisionBitmap,			          new Point(collisionBitmap.x, collisionBitmap.y),			          255			        )			      )			    {			      //Move the object out of the collision			      model.setY = model.yPos + 1;			      model.vy = 0;			    } 			    			    //Check for a collision on the right			    if(objectBitmap.bitmapData.hitTest			        (			          new Point(model.xPos + 10, model.yPos), 			          255, 			          collisionBitmap,			          new Point(collisionBitmap.x, collisionBitmap.y),			          255			        )			      )			    {			      //Move the object out of the collision			      model.setX = model.xPos - 1;			      model.vx = 0;			    }			    			    //Check for a collision on the left 			    else if(objectBitmap.bitmapData.hitTest			        (			          new Point(model.xPos - 10, model.yPos), 			          255, 			          collisionBitmap,			          new Point(collisionBitmap.x, collisionBitmap.y),			          255			        )			      )			    {			      //Collision on left			      model.setX = model.xPos + 1;			      model.vx = 0;			    }			  }   			  else 			  {			    break;			  }		  }		  		  //Switch gravity back on if there is no ground below the object		  if(!objectBitmap.bitmapData.hitTest		      (		        new Point(model.xPos, model.yPos + 3), 			      255, 			      collisionBitmap,			      new Point(collisionBitmap.x, collisionBitmap.y),			      255			    )			  )			{			  model.gravity_Vy = 0.1;		  }	  }	  	  private function makeCircle(radius:int = 30):Shape		{		  //Create the shape		  var shape:Shape = new Shape();		  shape.graphics.lineStyle(0);			shape.graphics.beginFill(0xFFFFFF);			shape.graphics.drawCircle(0, 0, radius);			shape.graphics.endFill();						return shape	  }	  		private function createBitmap		  (		     model:AVerletModel, 		     view:AVerletView, 		     alphaTransparency:Boolean = true		  ):Object		{		  //BitmapData(width, height, transparent?, fillColor(0 is alpha))			var bitmapData:BitmapData = new BitmapData			  (			    model.width, model.height, alphaTransparency, 0			  );			  			bitmapData.draw(view);			var bitmap:Bitmap = new Bitmap(bitmapData);						//Create the object to return to the caller			var bitmapObject:Object = new Object;			bitmapObject.bitmapData = bitmapData;			bitmapObject.bitmap = bitmap;						return bitmapObject;		}	}}