﻿package{	import flash.events.Event;  import flash.display.Sprite;  import com.friendsofed.utils.*;  import com.friendsofed.gameElements.primitives.*;  import com.friendsofed.vector.*;  [SWF(width="550", height="400", backgroundColor="#FFFFFF", frameRate="60")]  	public class PolygonEnvironment extends Sprite	{  	    //Arrays to store references to the shapes	    private var _triangles:Array = [];	    private var _rectangles:Array = [];	  			//Circle  		private var _c1:CircleModel = new CircleModel(20, 0xC27D96);  		private var _UIController:UIController = new UIController(_c1);  		private var _c1_View:CircleBlockView = new CircleBlockView(_c1);  		private var _UIView:UIView   		  = new UIView(_c1, _UIController, stage);  		  		//Triangles  		private var _t1:TriangleModel   		  = new TriangleModel(150, 50, "right", 0xBDCEA8);  		private var _t1_View:TriangleBlockView   		  = new TriangleBlockView(_t1);  		private var _t2:TriangleModel   		  = new TriangleModel(100, 150, "left", 0x769690);  		private var _t2_View:TriangleBlockView   		  = new TriangleBlockView(_t2);  		private var _t3:TriangleModel   		  = new TriangleModel(50, 50, "right", 0x6C8388);  		private var _t3_View:TriangleBlockView   		  = new TriangleBlockView(_t3);    		private var _t4:TriangleModel   		  = new TriangleModel(50, 50, "left", 0x061737F);  		private var _t4_View:TriangleBlockView   		  = new TriangleBlockView(_t4);    		private var _t5:TriangleModel   		  = new TriangleModel(50, 50, "right", 0xBDCEA8);  		private var _t5_View:TriangleBlockView   		  = new TriangleBlockView(_t5);  		private var _t6:TriangleModel   		  = new TriangleModel(200, 70, "left", 0x90AE9A);  		private var _t6_View:TriangleBlockView   		  = new TriangleBlockView(_t6);  		private var _t7:TriangleModel   		  = new TriangleModel(250, 120, "right", 0x769690);  		private var _t7_View:TriangleBlockView   		  = new TriangleBlockView(_t7);          		  		//Rectangles  		private var _r1:RectangleModel   		  = new RectangleModel(150, 150, 0x90AE9A);  		private var _r1_View:RectangleBlockView   		  = new RectangleBlockView(_r1);  		private var _r2:RectangleModel   		  = new RectangleModel(100, 20, 0x6C8388);  		private var _r2_View:RectangleBlockView   		  = new RectangleBlockView(_r2);   		private var _r3:RectangleModel   		  = new RectangleModel(30, 30, 0x061737F);  		private var _r3_View:RectangleBlockView   		  = new RectangleBlockView(_r3);   		private var _r4:RectangleModel   		  = new RectangleModel(30, 30, 0xBDCEA8);  		private var _r4_View:RectangleBlockView   		  = new RectangleBlockView(_r4);                      		//Status box to display the result of the projection  		private var _statusBox:StatusBox = new StatusBox;				public function PolygonEnvironment():void		{ 		  //Circle			addChild(_c1_View);			_c1.setX = 80;			_c1.setY = 50;			_c1.gravity_Vy = 0.1;						//Triangles			addChild(_t1_View);			_t1.setX = 150;			_t1.setY = 100;			_triangles.push(_t1);						addChild(_t2_View);			_t2.setX = 400;			_t2.setY = 150;			_triangles.push(_t2);  						addChild(_t3_View);			_t3.setX = _t2.xPos + _t2.width * 0.5 + _t3.width * 0.5;			_t3.setY = 100;			_triangles.push(_t3);						addChild(_t4_View);			_t4.setX = stage.stageWidth - _t4.width * 0.5;			_t4.setY = 175;			_triangles.push(_t4);						addChild(_t5_View);			_t5.setX = _t2.xPos + _t2.width * 0.5 + _t5.width * 0.5;			_t5.setY = 250;			_triangles.push(_t5);						addChild(_t6_View);			_t6.setX = stage.stageWidth - _t6.width * 0.5;			_t6.setY = stage.stageHeight - _t6.height * 0.5;			_triangles.push(_t6);						addChild(_t7_View);			_t7.setX = _t7.width * 0.5;			_t7.setY = stage.stageHeight - _t7.height * 0.5;			_triangles.push(_t7);						//Rectangles			addChild(_r1_View);			_r1.setX = _t1.xPos + _t1.width * 0.5;			_r1.setY = _t1.yPos + _r1.height * 0.5 + _t1.height * 0.5;			_rectangles.push(_r1);						addChild(_r2_View);			_r2.setX = _r1.xPos + _r1.width * 0.5 + _r2.width * 0.5;			_r2.setY = _r1.yPos + _r1.height * 0.5 + _r2.height * 0.5;			_rectangles.push(_r2);						addChild(_r3_View);			_r3.setX = 75;			_r3.setY = _r1.yPos;			_rectangles.push(_r3);						addChild(_r4_View);			_r4.setX = _r3.xPos + _r4.width;			_r4.setY = _r3.yPos + _r4.height;			_rectangles.push(_r4);		  		  //Add the status box			addChild(_statusBox);						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{ 			//Update c1 			_c1.update();			StageBoundaries.bounce(_c1, stage);       						for(var i:int = 0; i < _triangles.length; i++)      {        circleVsTriangle(_c1, _triangles[i]);      }            for(var j:int = 0; j < _rectangles.length; j++)      {        circleVsRectangle(_c1, _rectangles[j]);      }		  			//Update the status box			_statusBox.text = "POLYGON ENVIRONMENT";		}		public function circleVsRectangle		  (c1:CircleModel, r1:RectangleModel):void		{			//Vector between objects			var v0:VectorModel 			  = new VectorModel(c1.xPos, c1.yPos, r1.xPos, r1.yPos); 						//Find the voronoi region			var region:String = "";						//Is the circle above the rectangle's top edge?			if(c1.yPos < r1.yPos - r1.height * 0.5)			{			  //If it is, we need to check whether it's in the 			  //top left, top center or top right			  if(c1.xPos < r1.xPos - r1.width * 0.5)			  {			    region = "topLeft";			  }			  else if (c1.xPos > r1.xPos + r1.width * 0.5)			  {			    region = "topRight";			  }			  else			  {			    region = "topMiddle";			  }			}			//The circle isn't above the top edge, so it might be 			//below the bottom edge			else if (c1.yPos > r1.yPos + r1.height * 0.5)			{			  //If it is, we need to check whether it's in the 			  //bottom left, bottom center or bottom right			  if(c1.xPos < r1.xPos - r1.width * 0.5)			  {			    region = "bottomLeft";			  }			  else if (c1.xPos > r1.xPos + r1.width * 0.5)			  {			    region = "bottomRight";			  }			  else			  {			    region = "bottomMiddle";			  }			}			//The circle isn't above the top edge or below the bottom			//edge it must be on the left or right side			else			{			  if(c1.xPos < r1.xPos - r1.width * 0.5)			  {			    region = "leftMiddle";			  }			  else			  {			    region = "rightMiddle";			  }			}					//If the circle is the topMiddle, bottomMiddle, 			//leftMiddle or rightMiddle			//perform the standard check for overlaps as you would			//with a rectangle						if(region == "topMiddle"			|| region == "bottomMiddle"			|| region == "leftMiddle"			|| region == "rightMiddle")			{			//Check whether the projection on the x 			//axis (in this case the v0's vx) 			//is less than the combined half widths			if(Math.abs(v0.vx) < c1.width * 0.5 + r1.width * 0.5)			{			  //A collision might be ocurring! Check the other 			  //projection on the y axis (v0's vy)			  			  if(Math.abs(v0.vy) < c1.height * 0.5 + r1.height * 0.5)			  {			    //A collision has ocurred! This is good!			    			    //Find out the size of the overlap on both the X and Y axis			    var overlap_X:Number 			      = c1.width * 0.5 + r1.width * 0.5 - Math.abs(v0.vx);			    var overlap_Y:Number 			      = c1.height * 0.5 + r1.height * 0.5 - Math.abs(v0.vy);			    			    //The collision has occurred on the axis with the			    //*smallest* amount of overlap. Let's figure out which			    //axis that is			    			    if(overlap_X >=  overlap_Y)			    {			      //The collision is happening on the X axis			      //But on which side? v0's vy can tell us 			      if(v0.vy > 0)			      {			        //Collision on top			        c1.setY = c1.yPos - overlap_Y;			      }			      else			      {			        //Collision on bottom			        c1.setY = c1.yPos + overlap_Y;			      }			      			      //Plot the X axis at r1's position			      var xAxis:VectorModel 			        = new VectorModel			        (			          c1.xPos - r1.width * 0.5, 			          c1.yPos, 			          c1.xPos + r1.height * 0.5, 			          c1.yPos			        );			        			      VectorMath.bounceOnPlane(c1, xAxis, 1, 0.98);                       			    }			    else			    {			       			      //The collision is happening on the Y axis			      //But on which side? v0's vx can tell us 			      if(v0.vx > 0)			      {			        //Collision on left			        c1.setX = c1.xPos - overlap_X;			      }			      else			      {			        //Collision on right			        c1.setX = c1.xPos + overlap_X;			      }			      			      //Plot the y axis at r1's position			      var yAxis:VectorModel 			        = new VectorModel			        (			          c1.xPos, 			          c1.yPos - r1.height * 0.5, 			          c1.xPos, 			          c1.yPos + r1.height * 0.5			        );			      VectorMath.bounceOnPlane(c1, yAxis, 1, 0.98);			    }			  }			  else			  {			    //No collision			  }			}			else			{			  //No collision			}		}				  //The circle isn't in danger of intersecting 		  //with any of the rectangle's planes,		  //so it has to be closer to one of the four corners		  //The checkCornerCollision method does 		  //the work of the collison detection		  //It takes four arguments:		  //1. The CircleModel object		  //2. The x position of the corner		  //3. The y position of the corner		  //4. The bounce multiplier which 		  //determines the amount of "bouncines"				  if(region == "topLeft")		  {			  checkCornerCollision			    (			      c1, 			      r1.xPos - r1.width * 0.5, 			      r1.yPos - r1.height * 0.5, 			      1			    ); 		  }		  else if(region == "topRight")		  {		    checkCornerCollision		      (		        c1, 		        r1.xPos + r1.width * 0.5, 		        r1.yPos - r1.height * 0.5, 		        1		      ); 		  }		  else if(region == "bottomLeft")		  {		    checkCornerCollision		      (		        c1, 		        r1.xPos - r1.width * 0.5, 		        r1.yPos + r1.height * 0.5, 		        1		      ); 		  }		  else if(region == "bottomRight")		  {		    checkCornerCollision		      (		        c1, 		        r1.xPos + r1.width * 0.5, 		        r1.yPos + r1.height * 0.5, 		        1		      ); 		  }			}		private function circleVsTriangle		  (c1:CircleModel, t1:TriangleModel):void		{		  //Vector between rectangles			var v0A:VectorModel 			  = new VectorModel(c1.xPos, c1.yPos, t1.xPos, t1.yPos);						//Vector between the center of the 			//circle and the hypotenuse's start point			//We need this to calculate whether the circle is within the 			//hypotenuse's voronoi region			var v0B:VectorModel 			  = new VectorModel			  (			    c1.xPos, 			    c1.yPos, 			    t1.hypotenuse.a.x, 			    t1.hypotenuse.a.y			  );						//Dot product that will help tell 			//us whether the circle is within			//the triangle's voronoi region			var dp1:Number = VectorMath.dotProduct(v0B, t1.hypotenuse);						//Find the voronoi region			var region:String = "";						//Find the voronoi regions if the 			//triangle's inclination is right			if(t1.inclination == "right")			{			  //Which region is the circle in?			  //First check the hypotenuse			  //Which region is the circle in?			  //First check the hypotenuse			  if(dp1 < 0 			  && dp1 > -t1.hypotenuse.m			  && c1.xPos > t1.xPos - t1.width * 0.5			  && c1.yPos < t1.yPos + t1.height * 0.5)			  {			    region = "hypotenuse";			  }			  //If it's not in the hypotenuse region,			  //check the other possibilities			  else			  {			    //Check the top corner			    if(c1.yPos < t1.yPos - t1.height * 0.5)			    {			      region = "topCorner";			    }			    //The circle isn't above the top edge, so it might be 			    //below the bottom edge			    else if (c1.yPos > t1.yPos + t1.height * 0.5)			    {			      //If it is, we need to check whether it's in the 			      //bottom left, bottom center or bottom right			      if(c1.xPos < t1.xPos - t1.width * 0.5)			      {			        region = "bottomLeftCorner";			      }			      else if(c1.xPos > t1.xPos + t1.width * 0.5)			      {			        region = "bottomRightCorner";			      }			      else			      {			        region = "bottomMiddle";			      }		      }		      //The circle isn't above the top edge or below the bottom			    //edge it must be on the left or right side			    else			    {			      if(c1.xPos < t1.xPos - t1.width * 0.5)			      {			        region = "leftMiddle";			      }			      //If all the previous tests fail, then 			      //the circle must be within the wedge of space between the			      //bottom right corner and the the hypotenuse's region			      else			      {			        region = "bottomRightCorner";			      }		      }			  }		  }			if(t1.inclination == "left")			{			  //Which region is the circle in?			  //First check the hypotenuse			  //Which region is the circle in?			  //First check the hypotenuse			  if(dp1 < 0 			  && dp1 > -t1.hypotenuse.m			  && c1.xPos < t1.xPos + t1.width * 0.5			  && c1.yPos < t1.yPos + t1.height * 0.5)			  {			    region = "hypotenuse";			  }			  //If it's not in the hypotenuse region,			  //check the other possibilities			  else			  {			    //Check the top corner			    if(c1.yPos < t1.yPos - t1.height * 0.5)			    {			      region = "topCorner";			    }			    //The circle isn't above the top edge, so it might be 			    //below the bottom edge			    else if (c1.yPos > t1.yPos + t1.height * 0.5)			    {			      //If it is, we need to check whether it's in the 			      //bottom left, bottom center or bottom right			      if(c1.xPos < t1.xPos - t1.width * 0.5)			      {			        region = "bottomLeftCorner";			      }			      else if(c1.xPos > t1.xPos + t1.width * 0.5)			      {			        region = "bottomRightCorner";			      }			      else			      {			        region = "bottomMiddle";			      }		      }		      //The circle isn't above the top edge or below the bottom			    //edge it must be on the left or right side			    else			    {			      if(c1.xPos > t1.xPos + t1.width * 0.5)			      {			        region = "rightMiddle";			      }			      //If all the previous tests fail, then 			      //the circle must be within the wedge of space between the			      //bottom right corner and the the hypotenuse's region			      else			      {			        region = "bottomLeftCorner";			      }		      }			  }		  }			  		if(region == "bottomMiddle"  		|| region == "leftMiddle"  		|| region == "rightMiddle"  		|| region == "hypotenuse")  		{   		  		  //Project v0A onto the hypotenuse's normal  		  //Get the projection's vx and vy  		  var v0_P:VectorModel   		    = VectorMath.project(v0A, t1.hypotenuse.ln)  		  var v0A_P:VectorModel   		    = new VectorModel  		    (  		      t1.hypotenuse.ln.a.x,   		      t1.hypotenuse.ln.a.y,   		      t1.hypotenuse.ln.a.x - v0_P.vx,  		      t1.hypotenuse.ln.a.y - v0_P.vy  		    );  		  		  //A vector that represents the projected radius  		  //on the hypotenuse's normal  		    		  var v1_P:VectorModel   		    = new VectorModel  		    (  		      t1.hypotenuse.ln.a.x + v0A_P.vx,  		      t1.hypotenuse.ln.a.y + v0A_P.vy,   		      t1.hypotenuse.ln.a.x + v0A_P.vx   		        - t1.hypotenuse.ln.dx * c1.radius,  		      t1.hypotenuse.ln.a.y + v0A_P.vy   		        - t1.hypotenuse.ln.dy * c1.radius  		    );    		  		  //The distance between hypotenuse and the projected rectangle  	    var hDistance:VectorModel   	      = new VectorModel  	      (  	        t1.hypotenuse.ln.a.x,   	        t1.hypotenuse.ln.a.y,  	        t1.hypotenuse.ln.a.x - v0A_P.vx - v1_P.vx,  	        t1.hypotenuse.ln.a.y - v0A_P.vy - v1_P.vy  	      );  	    	    //The dot product that helps us figure   	    //out if the projection of the  	    //rectangle is overlaping the hypotenuse                                              	    var dp2:Number   	      = VectorMath.dotProduct(hDistance, t1.hypotenuse.ln);    	                                           			  //Check whether the projections are overlapping.			  if(Math.abs(v0A.vx) < c1.radius + t1.width * 0.5)			  {			    //A collision might be ocurring! Check the other 			    //projection on the y axis (v0's vy)			  			    if(Math.abs(v0A.vy) < c1.radius + t1.height * 0.5)			    {			      //Check the projection on the hypotenuse's normal			    			      if(dp2 > 0)			      {			        //A collision has ocurred			    			        //Find out the size of the overlap 			        //on both the X and Y axis			        var overlap_X:Number 			          = c1.radius + t1.width * 0.5 - Math.abs(v0A.vx);			        var overlap_Y:Number 			          = c1.radius + t1.height * 0.5 - Math.abs(v0A.vy);			        var overlap_H:Number = dp2;			    			        //The collision has occurred on the axis with the			        //*smallest* amount of overlap. Let's figure out which			        //axis that is			    			        if(overlap_X <  overlap_Y			        && overlap_X <  overlap_H)			        {			          //The collision is happening on the Y axis			          //But on which side? v0's vx can tell us 			          if(v0A.vx > 0)			          {			            //Collision on left			            c1.setX = c1.xPos - overlap_X;			          }			          else			          {			            //Collision on right			            c1.setX = c1.xPos + overlap_X;			          }			          //Plot the y axis at r1's position			          //and bounce the rectangle			          var yAxis:VectorModel 			            = new VectorModel			            (			              c1.xPos, 			              c1.yPos, 			              c1.xPos, 			              c1.yPos + c1.height			            );			                                                			          VectorMath.bounceOnPlane(c1, yAxis, 0.6, 0.98);                        			          }			          else if(overlap_Y < overlap_X			               && overlap_Y < overlap_H)			          {			          //The collision is happening on the X axis			          //But on which side? v0's vy can tell us 			        			          if(v0A.vy > 0)			          {			            //Collision on top			            c1.setY = c1.yPos - overlap_Y;			          }			          else			          {			            //Collision on bottom			            c1.setY = c1.yPos + overlap_Y;			          }			      			          //Plot the X axis at r1's position			          //and bounce the rectangle			          var xAxis:VectorModel 			          = new VectorModel			          (			            c1.xPos, 			            c1.yPos, 			            c1.xPos + c1.width, 			            c1.yPos			          );			                                                			          VectorMath.bounceOnPlane(c1, xAxis, 0.6, 0.98); 			        }			        else if(overlap_H < overlap_Y && overlap_H < overlap_X)			         {			          //The collision is happening on the hypotenuse			          //Use the hDistance's vx and vy to correctly			          //reposition the rectangle			          c1.setY = c1.yPos + hDistance.vy;			          c1.setX = c1.xPos + hDistance.vx;			        			          //Bounce			          var friction:Number;			          c1.vy > 0 ? friction = 1.05 : friction = 0.98;			          VectorMath.bounceOnPlane			            (c1, t1.hypotenuse, 0.6, friction);		          }	          }			      else			      {			        //No collision			      }			    }			    else			    {			      //No collision			    }		    }		    else			  {			    //No collision			  }		  }						if(region == "topCorner")		  {		    if(t1.inclination == "right")		    {			    checkCornerCollision			      (			        c1, 			        t1.xPos - t1.width * 0.5, 			        t1.yPos - t1.height * 0.5, 			        1			      );			  }			  else			  {			    checkCornerCollision			      (			        c1, 			        t1.xPos + t1.width * 0.5, 			        t1.yPos - t1.height * 0.5, 			        1			      );			  } 		  }		  else if(region == "bottomLeftCorner")		  {		    checkCornerCollision		      (		        c1,		        t1.xPos - t1.width * 0.5, 		        t1.yPos + t1.height * 0.5, 		        1		      ); 		  }		  else if(region == "bottomRightCorner")		  {		    checkCornerCollision		      (		        c1, 		        t1.xPos + t1.width * 0.5, 		        t1.yPos + t1.height * 0.5, 		        1		      ); 		  }	  }		public function checkCornerCollision		  (		    circle:CircleModel, 		    corner_X:Number, 		    corner_Y:Number, 		    bounceAmount:Number		  ):void		{		  //Vector between circle and particle			var v0:VectorModel 			  = new VectorModel			  (			    circle.xPos, 			    circle.yPos, 			    corner_X, 			    corner_Y			  );   						if(v0.m < circle.radius)			{			  			  //Find the amount of overlap 				var overlap:Number = circle.radius - v0.m;                      			  circle.setX = circle.xPos - (overlap * v0.dx);				circle.setY = circle.yPos - (overlap * v0.dy);                //circle's motion vector  			var v1:VectorModel   			  = new VectorModel  			  (  			    circle.xPos,   			    circle.yPos,   			    circle.xPos + circle.vx,   			    circle.yPos + circle.vy  			  );  			                                             //Create the circle's bounce vector                          var bounce:VectorModel = VectorMath.bounce(v1, v0.ln);                //Bounce the circle        circle.vx = bounce.vx * bounceAmount;         circle.vy = bounce.vy * bounceAmount;			}		}	}}