﻿package{	import flash.events.Event;  import flash.display.Sprite;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.primitives.*;  import com.friendsofed.vector.*;  [SWF(width="550", height="400",   backgroundColor="#FFFFFF", frameRate="60")]  	public class CircleVsCorner extends Sprite	{			//Circle		private var _circleModel:CircleModel 		  = new CircleModel(30);		private var _circleView:CircleView 		  = new CircleView(_circleModel);		//Drag handles		private var _handle1:DragHandle = new DragHandle();		private var _handle2:DragHandle = new DragHandle();		//We need 6 vectors:		//A. Vector from the center of the circle to its edge which		//points in the direction of the line		private var _v0:VectorModel = new VectorModel();				//B. The circle's motion vector, calculated from the		//end of the spoke		private var _v1:VectorModel = new VectorModel();		//C. Vector for the drag handles		private var _v2:VectorModel 		  = new VectorModel();		private var _v2View:VectorView 		  = new VectorView(_v2, "basic", 1);		//D. Vector between the first drag 		//handle and the end of the spoke		private var _v3:VectorModel = new VectorModel();				//E. Vector between the first drag handle 		//and the center of the circle		private var _v4:VectorModel = new VectorModel();				//F. Vector between the second drag handle and 		//the center of the circle		private var _v5:VectorModel = new VectorModel();		//Status box to display the result of the projection		private var _statusBox:StatusBox;				//Variable to track the side of the line the circle is on		private var _lineSide:String = "";				public function CircleVsCorner():void		{			//Add the drag handles to the stage		  addChild(_handle1);		  _handle1.x = 100;		  _handle1.y = 250;		  		  addChild(_handle2);		  _handle2.x = 400;		  _handle2.y = 300;		  		  //Add the circle view			addChild(_circleView);			_circleModel.setX = 150;			_circleModel.setY = 150;			_circleModel.friction = 1;			_circleModel.gravity_Vy = 0.1;		  		  //Add vector views			addChild(_v2View);						//Add the status box			_statusBox = new StatusBox();			addChild(_statusBox);						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{ 		  //Update the circle model			_circleModel.update();			StageBoundaries.wrap(_circleModel, stage);  						//Create a spoke from the center of the circle to its edge,			//pointing in the direction of the line. Use the the line's 			//right normal if the circle is to its left, and the left			//normal if it's to its right. This give you a point which 			//is always at the closest point of contact between the			//circle and the line.						if(_lineSide == "" || _lineSide == "left")      {     			  _v0.update			    (			      _circleModel.xPos, 			      _circleModel.yPos,             _circleModel.xPos + _v2.rn.dx * _circleModel.radius,             _circleModel.yPos + _v2.rn.dy * _circleModel.radius          );                                                                     			}			else			{			  _v0.update			    (			      _circleModel.xPos, 			      _circleModel.yPos,             _circleModel.xPos + _v2.ln.dx * _circleModel.radius,             _circleModel.yPos + _v2.ln.dy * _circleModel.radius          );			}						//Calculate the velocity from the edge of the circle's spoke			_v1.update			  (			    _v0.b.x, 			    _v0.b.y, 			    (_v0.b.x + _circleModel.vx), 			    (_v0.b.y + _circleModel.vy)			  );						//All other code remains the same as particle vs. line collision        				  //v2: the drag handle vector      _v2.update(_handle1.x, _handle1.y, _handle2.x, _handle2.y);                       						//v3: the vector between v1 and v2.a		  _v3.update		    (_v1.a.x, _v1.a.y, _handle1.x, _handle1.y);   		  		  //v4: the vector between the center of 		  //the circle and the first drag handle		  _v4.update		    (_circleModel.xPos, _circleModel.yPos, _v2.a.x, _v2.a.y);    		  		  //v5: the vector between the 		  //center of the circle and the second drag handle		  _v5.update		    (_circleModel.xPos, _circleModel.yPos, _v2.b.x, _v2.b.y);                          		  		  //The dot product that tells you whether the circle is within		  //the scope of the line's magnitude (its voronoi region)		  var dp1:Number = VectorMath.dotProduct(_v3, _v2);		  		  //The dotproduct that tells you which side of the line		  //the circle is on		  var dp2:Number = VectorMath.dotProduct(_v3, _v2.ln);		  		  //If the circle is within the scope of the line's magnitude		  //then set its line side to left or right      if(dp1 > -_v2.m && dp1 < 0 )      {        if(_lineSide == "")        {          if(dp2 < 0 )          {            _lineSide = "left";          }             else          {            _lineSide = "right";          }        }      }      else      {        //If the circle is not within the         //line's scope (such as rounding        //a corner) clear the _lineSide variable.        _lineSide = "";      }            //Reset the _lineSide variable if the circle has wrapped 	    //around the edges of the stage	    	    if(_circleModel.yPos > stage.stageHeight	    || _circleModel.yPos < 0	    || _circleModel.xPos < 0	    || _circleModel.xPos > stage.stageWidth)  	  {  	    _lineSide = "";  	  }           //Create an environmental boundary based on whether      //the circle has collided from the right or left      if(dp2 > 0 && _lineSide == "left"      || dp2 < 0 && _lineSide == "right")      {          //Create the collision vector        var collisionForce_Vx:Number = _v1.dx * Math.abs(dp2);        var collisionForce_Vy:Number = _v1.dy * Math.abs(dp2);                //Move the particle out of the collision        _circleModel.setX           = _circleModel.xPos           - collisionForce_Vx;	                   _circleModel.setY           = _circleModel.yPos           - collisionForce_Vy          - _circleModel.gravity_Vy;                                                         //Find the projection vectors        var p1:VectorModel = VectorMath.project(_v1, _v2);        var p2:VectorModel = VectorMath.project(_v1, _v2.ln);                //Calculate the bounce vector        var bounce_Vx:Number = p2.vx * -1;        var bounce_Vy:Number = p2.vy * -1;                //Calculate the friction vector        var friction_Vx:Number = p1.vx;        var friction_Vy:Number = p1.vy;                //Apply bounce and friction to the velocity        _circleModel.vx = (bounce_Vx * 0.6) + (friction_Vx * 0.98);        _circleModel.vy = (bounce_Vy * 0.6) + (friction_Vy * 0.98);	    }	    //New code to check for corners	    if(_lineSide == "")	    {     	                                     	      //Check for a collision with the corners	      if(_v4.m < _circleModel.radius 	      || _v5.m < _circleModel.radius)			  {			    //Bounce the circle on the closest corner			    if(_v4.m < _v5.m)			    {			      //The circle is closest to the start of the line			      cornerBounce(_circleModel, _v4);			    }			    else			    {			      //The circle is closest to the end of the line			      cornerBounce(_circleModel, _v5);			    }			  }	    }  	  			//Display the result in a status box						_statusBox.text = "CIRCLE VS CORNER:";			_statusBox.text 			  += "\n" + "DP1: " + Math.round(dp1 * 1000) / 1000;			_statusBox.text 			  += "\n" + "V2.M: " + Math.round(_v2.m * 1000) / 1000;			_statusBox.text 			  += "\n" + "DP2: " + Math.round(dp2 * 1000) / 1000;			_statusBox.text 			  += "\n" + "V1.M: " + Math.round(_v1.m * 1000) / 1000;			_statusBox.text 			  += "\n" + "LINE SIDE: " + _lineSide;					}		public function cornerBounce		  (circleModel:CircleModel, distanceVector:VectorModel):void		{		  //Find the amount of overlap		  var overlap:Number = circleModel.radius - distanceVector.m;		  		  //Move the circle out of the collision			circleModel.setX 			  = circleModel.xPos 			  - (overlap * distanceVector.dx);			  			circleModel.setY 			  = circleModel.yPos 			  - (overlap * distanceVector.dy);						//Calculate the circle's motion vector  		var motion:VectorModel   		  = new VectorModel  		    (  		      circleModel.xPos,   		      circleModel.yPos,   			    circleModel.xPos + circleModel.vx,   			    circleModel.yPos + circleModel.vy  			  );  			                                           //Create the circle's bounce vector                        var bounce:VectorModel         = VectorMath.bounce(motion, distanceVector.ln);                  //Bounce the circle      circleModel.vx = bounce.vx;       circleModel.vy = bounce.vy;		}	}}