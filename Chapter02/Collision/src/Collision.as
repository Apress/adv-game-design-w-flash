﻿package{	import flash.events.Event;  import flash.display.Sprite;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.spaceShip.*;  import com.friendsofed.vector.*;    [SWF(width="550", height="400",   backgroundColor="#FFFFFF", frameRate="60")]	public class Collision extends Sprite	{		//Space ship		private var _shipModel:ShipModel 		  = new ShipModel();		private var _shipController:ShipController 		  = new ShipController(_shipModel);		private var _shipView:ShipView 		  = new ShipView(_shipModel, _shipController);		//Drag handles		private var _handle1:DragHandle = new DragHandle();		private var _handle2:DragHandle = new DragHandle();		//We need 3 vectors:		//A. Vector between the ship and v2's start point		private var _v1:VectorModel = new VectorModel();		//B. Vector for the drag handles		private var _v2:VectorModel 		  = new VectorModel();		private var _v2View:VectorView 		  = new VectorView(_v2, "detailed", 1);		//C. Vector between the first drag handle and the ship		private var _v3:VectorModel = new VectorModel();		//Status box to display the result of the projection		private var _statusBox:StatusBox;				//Variable to track the side of the line the ship is on		private var _lineSide:String = "";				public function Collision():void		{			//Add the drag handles to the stage		  addChild(_handle1);		  _handle1.x = 300;		  _handle1.y = 300;		  		  addChild(_handle2);		  _handle2.x = 100;		  _handle2.y = 100;		  		  //Add the space ship			addChild(_shipView);			_shipModel.setX = 275;			_shipModel.setY = 200;		  		  //Add vector views			addChild(_v2View);						//Add the status box that displays the dot product			_statusBox = new StatusBox();			addChild(_statusBox);						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{			//Update the ship model			_shipModel.update();			StageBoundaries.wrap(_shipModel, stage);       					  //v1: the ship's movement vector			_v1.update			  (			    _shipModel.xPos, 			    _shipModel.yPos, 			    (_shipModel.xPos + _shipModel.vx), 			    (_shipModel.yPos + _shipModel.vy)			  );         			          		  //v2: the drag handle vector      _v2.update(_handle1.x, _handle1.y, _handle2.x, _handle2.y);                       						//v3: the vector between v1 and v2		  _v3.update		    (_shipModel.xPos, _shipModel.yPos, _handle1.x, _handle1.y);		  		  //Find the dot products		  var dp1:Number = VectorMath.dotProduct(_v3, _v2);		  var dp2:Number = VectorMath.dotProduct(_v3, _v2.ln);           		   		  //Check if ship is within the vector's scope		  if(dp1 > -_v2.m && dp1 < 0)		  { 		    //Check if ships has crossed the vector from right to left		    if(dp2 <= 0) 		    {                      //Create the collision vector          var collisionForce_Vx:Number = _v1.dx * Math.abs(dp2);          var collisionForce_Vy:Number = _v1.dy * Math.abs(dp2);                                                  //Move ship out of the collision         _shipModel.setX            = _shipModel.xPos - collisionForce_Vx;                                    _shipModel.setY            = _shipModel.yPos - collisionForce_Vy;                  //Set velocity to zero          _shipModel.vx = 0;          _shipModel.vy = 0; 		    }	    } 		   			//Display the result in a status box			_statusBox.text = "COLLISION:";			_statusBox.text 			  += "\n" + "DP1: " + Math.round(dp1 * 1000) / 1000;			_statusBox.text 			  += "\n" + "V2.M: " + Math.round(_v2.m * 1000) / 1000;			_statusBox.text 			  += "\n" + "DP2: " + Math.round(dp2 * 1000) / 1000;			_statusBox.text 			  += "\n" + "V1.M: " + Math.round(_v1.m * 1000) / 1000;		}	}}