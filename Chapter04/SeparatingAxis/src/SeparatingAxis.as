﻿package{	import flash.events.Event;  import flash.display.Sprite;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.primitives.*;  import com.friendsofed.vector.*;  [SWF(width="550", height="400",   backgroundColor="#FFFFFF", frameRate="60")]  	public class SeparatingAxis extends Sprite	{			//Rectangle 1 (player's rectangle)  		private var _r1:RectangleModel   		  = new RectangleModel(60, 45);  		private var _UIController:UIController   		  = new UIController(_r1);  		private var _r1_View:RectangleView   		  = new RectangleView(_r1);  		private var _UIView:UIView   		  = new UIView(_r1, _UIController, stage);  		  		//Rectangle 2  		private var _r2:RectangleModel = new RectangleModel(60, 45);  		private var _r2_View:RectangleView = new RectangleView(_r2);  		  		//Vector between rectangles  		private var _v0:VectorModel = new VectorModel();   		private var _v0_View:VectorView = new VectorView(_v0, "basic");   		  		//Vectors that represent the X and Y Axes   		//that we need to the shapes on to  		private var _xAxis:VectorModel = new VectorModel();  		private var _yAxis:VectorModel = new VectorModel();  		  		//Vectors the represent the projections   		//of the shapes onto the axes  		private var _r1_pW:VectorModel = new VectorModel();  		private var _r1_pH:VectorModel = new VectorModel();  		private var _r2_pW:VectorModel = new VectorModel();  		private var _r2_pH:VectorModel = new VectorModel();  		  		//Views for these projections  		private var _r1_pW_View:VectorView   		  = new VectorView(_r1_pW, "basic");  		private var _r1_pH_View:VectorView   		  = new VectorView(_r1_pH, "basic");  		private var _r2_pW_View:VectorView   		  = new VectorView(_r2_pW, "basic");  		private var _r2_pH_View:VectorView   		  = new VectorView(_r2_pH, "basic");						//A variable to help us test for a collision			private var _collisionSide:String = "No collision";                        		//Status box to display the result of the projection  		private var _statusBox:StatusBox = new StatusBox;  		  		//Status boxes to display the projection graph labels  		private var _statusBox2:StatusBox = new StatusBox;  		private var _statusBox3:StatusBox = new StatusBox;				public function SeparatingAxis():void		{ 		  //Rectangle 1			addChild(_r1_View);			_r1.setX = 300;			_r1.setY = 200;						//Rectangle 2			addChild(_r2_View);			_r2.setX = 200;			_r2.setY = 200;						//Add the vector views			addChild(_v0_View);			addChild(_r1_pW_View);			addChild(_r1_pH_View);			addChild(_r2_pW_View);			addChild(_r2_pH_View);		  		  //Add the status boxes			addChild(_statusBox);			_statusBox.x = 375;						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{ 			//Update _r1 (player's rectangle)			_r1.update();			StageBoundaries.bounce(_r1, stage);       						//Update _r2			_r2.update();			StageBoundaries.bounce(_r2, stage);			      //Vector between rectangles			_v0.update(_r1.xPos, _r1.yPos, _r2.xPos, _r2.yPos);						//X and Y Axes.			//The actual position of these on 			//the stage are completely aribtrary.			//I've set them to these position in 			//the code so that you can see the 			//effect more clearly on the stage. 			//In your own code they just need to have vx 			//and vy values, they don't			//need actual stage positions.						_xAxis.update(0, 300, stage.stageWidth, 300); 			_yAxis.update(100, 0, 100, stage.stageHeight);						//Project _r1's width on the x axis and its height on the y axis			_r1_pW.update			  (			    _r1.xPos - _r1.width * 0.5, 			    _xAxis.a.y, 			    _r1.xPos + _r1.width * 0.5, 			    _xAxis.a.y			  );			  			_r1_pH.update			  (			    _yAxis.a.x, 			    _r1.yPos + _r1.height * 0.5, 			    _yAxis.a.x, _r1.yPos - _r1.height * 0.5			  );						//Project _r2's width on the x axis and its height on the y axis			_r2_pW.update			  (			    _r2.xPos - _r2.width * 0.5, 			    _xAxis.a.y, 			    _r2.xPos + _r2.width * 0.5, 			    _xAxis.a.y			  );			  			_r2_pH.update			  (			    _yAxis.a.x, 			    _r2.yPos + _r2.height * 0.5, 			    _yAxis.a.x, 			    _r2.yPos - _r2.height * 0.5			  );						//We need to track the distance between the projections 			//Two new vectors will help us do this			var xDistance:VectorModel 			  = new VectorModel			  (			    _r1_pW.a.x + _r1_pW.m * 0.5,			    _r1_pW.a.y,			    _r2_pW.a.x + _r2_pW.m * 0.5,			    _r1_pW.a.y			  );			                                            			var yDistance:VectorModel 			  = new VectorModel			  (			    _r1_pH.a.x,			    _r1_pH.a.y - _r1_pH.m * 0.5,			    _r1_pH.a.x,			    _r2_pH.a.y - _r2_pH.m * 0.5			  );			                                            			//Check whether the projections are overlapping.			//If the the distance btween point A of 			//the first projection and point B of the			//second projection are less than the 			//combined widths of the shapes,			//then we know that they are overlapping on the x axis.						if(xDistance.m < _r1_pW.m * 0.5 + _r2_pW.m * 0.5)			{			  //A collision might be ocurring! Check the other 			  //projection on the y axis (v0's vy)			  if(yDistance.m < _r1_pH.m * 0.5 + _r2_pH.m * 0.5)			  {			    //A collision has ocurred! This is good!			    			    //Find out the size of the overlap on both the X and Y axis			    var overlap_X:Number 			      = _r1_pW.m * 0.5 + _r2_pW.m * 0.5 - xDistance.m;			    var overlap_Y:Number 			      = _r1_pH.m * 0.5 + _r2_pH.m * 0.5 - yDistance.m;			    			    //The collision has occurred on the axis with the			    //*smallest* amount of overlap. Let's figure out which			    //axis that is			    			    if(overlap_X >=  overlap_Y)			    {			      			      //The collision is happening on the X axis			      //But on which side? v0's vy can tell us 			      if(_v0.vy > 0)			      {			        _collisionSide = "Top";			        _r1_View.alpha = 0.5;			        //_r1.setY = _r1.yPos - overlap_Y;			      }			      else			      {			        _collisionSide = "Bottom";			        _r1_View.alpha = 0.5;			        //_r1.setY = _r1.yPos + overlap_Y;			      }			      /*			      //Plot the X axis at r1's position			      var xAxis:VectorModel 			        = new VectorModel			        (			          _r1.xPos - _r2.width/2, 			          _r1.yPos, 			          _r1.xPos + _r2.height /2, 			          _r1.yPos			        );			      			      bounceOnPlane(_r1, xAxis, 0.1, 0.98); 			      */                                     			    }			    else			    {			       			      //The collision is happening on the Y axis			      //But on which side? v0's vx can tell us 			      if(_v0.vx > 0)			      {			        _collisionSide = "Left";			        _r1_View.alpha = 0.5;			        //_r1.setX = _r1.xPos - overlap_X;			      }			      else			      {			        _collisionSide = "Right";			        _r1_View.alpha = 0.5;			        //_r1.setX = _r1.xPos + overlap_X;			      }			      /*			      //Plot the y axis at r1's position			      var yAxis:VectorModel 			        = new VectorModel			        (			          _r1.xPos, 			          _r1.yPos - _r2.height /2, 			          _r1.xPos, 			          _r1.yPos + _r2.height /2			        );			       			       bounceOnPlane(_r1, yAxis, 0.1, 0.98); 			       */			    }			  }			  else			  {			    _collisionSide = "No collision";			    _r1_View.alpha = 1;			  }			}			else			{			  _collisionSide = "No collision";			  _r1_View.alpha = 1;			}						//Draw the X and Y Axes			graphics.clear();			graphics.lineStyle(1, 0xCCCCCC);			graphics.moveTo(_xAxis.a.x, _xAxis.a.y);			graphics.lineTo(_xAxis.b.x, _xAxis.b.y);			graphics.moveTo(_yAxis.a.x, _yAxis.a.y);			graphics.lineTo(_yAxis.b.x, _yAxis.b.y);						//Draw the xDistance and yDistance			graphics.lineStyle(1, 0x11D240);			graphics.moveTo(xDistance.a.x, xDistance.a.y + 5);			graphics.lineTo(xDistance.b.x, xDistance.b.y + 5);			graphics.moveTo(yDistance.a.x - 5, yDistance.a.y);			graphics.lineTo(yDistance.b.x - 5, yDistance.b.y);						//Update status box			_statusBox.text = "SEPARATING AXIS:";			_statusBox.text += "\n" + "COLLISION SIDE: " + _collisionSide;			_statusBox.text += "\n" + "V0.VX: " + Math.round(_v0.vx);			_statusBox.text += "\n" + "V0.VY: " + Math.round(_v0.vy);		}				//Use this method to create bounce and 		//friction for the verlet object.		//It takes four arguments: 		//1. The verlet model		//2. The vector that you want to bounce it against		//3. The bounce multiplier, for the amount of "bounciness"		//4. The friction multiplier, for the amount 		//of surface friction between objects				/*		public function bounceOnPlane		  (		    verletModel:AVerletModel, 		    plane:VectorModel, 		    bounce:Number, 		    friction:Number		  ):void		{		  var v1:VectorModel 		    = new VectorModel		    (		      verletModel.xPos, 		      verletModel.yPos,   			  verletModel.xPos + verletModel.vx,   			  verletModel.yPos + verletModel.vy  			);  			  		//Find the projection vectors      var p1:VectorModel = VectorMath.project(v1, plane);      var p2:VectorModel = VectorMath.project(v1, plane.ln);              //Calculate the bounce vector      var bounce_Vx:Number = p2.vx * -1;      var bounce_Vy:Number = p2.vy * -1;              //Calculate the friction vector      var friction_Vx:Number = p1.vx;      var friction_Vy:Number = p1.vy;                  verletModel.vx         = (bounce_Vx * bounce) + (friction_Vx * friction);      verletModel.vy         = (bounce_Vy * bounce) + (friction_Vy * friction);	                                   		}		*/	}}