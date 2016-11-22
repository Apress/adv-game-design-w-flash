package
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	//Required for creating filters and a gradient fill
	import flash.filters.*;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	//Keyboard Events
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import com.friendsofed.utils.*;

	public class SpaceShip extends Sprite
	{
		//Public properties
		public var xPos:Number = 0;
		public var yPos:Number = 0;
		public var rotationSpeed:Number = 0;
		public var frictionX:Number = 0;
		public var frictionY:Number = 0;
		public var acceleration:Number = 0;
		public var friction:Number = 0;
		public var rotationValue:Number = 0;
		public var direction:Number = 0;
		public var temporaryX:Number = 0;
		public var temporaryY:Number = 0;
		public var previousX:Number = 0;
		public var previousY:Number = 0;
		public var thrusterFired:Boolean = false;
		
		//Private properties
		private var _angle:Number = 0;
		private var _accelerationX:Number = 0;
		private var _accelerationY:Number = 0;
		
		//View variables
	  private var _size:int;
  	private var _shape:Shape;
  	private var _thrusterShape:Shape;
  	private var _color:uint;
  	//The _spaceShip Sprite contains the ship graphics
  	private var _spaceShip:Sprite;

		public function SpaceShip
		  (
		    size:uint = 30, 
		    color:uint = 0x99FF66
		  ):void 
		{
			_size = size;
			_color = color;
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		private function addedToStageHandler(event:Event):void
  	{
  		//Draw the ship
  		draw();

  		//Add listeners
  		addEventListener
  		  (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
  		stage.addEventListener
  		  (KeyboardEvent.KEY_DOWN,keyDownHandler);
  		stage.addEventListener
  		  (KeyboardEvent.KEY_UP,keyUpHandler);
  		removeEventListener
  		  (Event.ADDED_TO_STAGE, addedToStageHandler);
  	}
  	
  	private function removedFromStageHandler(event:Event):void
  	{
  		removeEventListener
  		  (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
  	}
  	
  	private function keyDownHandler(event:KeyboardEvent):void
  	{
  		if (event.keyCode == Keyboard.LEFT)
  		{
  			rotationSpeed = -10;
  		}
  		if (event.keyCode == Keyboard.RIGHT)
  		{
  			rotationSpeed = 10;
  		}
  		if (event.keyCode == Keyboard.UP)
  		{
  			acceleration = 0.2;
  			friction = 1;
  			thrusterFired = true;
  			_thrusterShape.visible = true;
  		}
  	}
  	
  	private function keyUpHandler(event:KeyboardEvent):void
  	{
  		if (event.keyCode == Keyboard.UP)
  		{
  			acceleration = 0;
  			friction = 0.96;
  			thrusterFired = false;
  			_thrusterShape.visible = false;
  		}
  		if(event.keyCode == Keyboard.LEFT 
  		|| event.keyCode == Keyboard.RIGHT)
  		{
  			rotationSpeed = 0;
  		}
  	}
  	
  	private function draw():void
		{
			//Create the gradient fill effect for the thruster
			var matrix:Matrix 
			  = new Matrix();
			  matrix.createGradientBox
			    (
			      _size * 0.5, 
			      _size / 3, 
			      (90 * Math.PI / 180), 
			      0,
			      _size
			    );
			var colors:Array = [0xFF3300, 0xFFFF00];
			var alphas:Array = [100, 0]; 
			var ratios:Array = [0, 255];
			
			//Draw the thruster flame
			_thrusterShape = new Shape();
			_thrusterShape.graphics.lineStyle(1, 0x000000, 0);
			_thrusterShape.graphics.beginGradientFill
			  (GradientType.LINEAR, colors, alphas, ratios, matrix);
			_thrusterShape.graphics.moveTo
			  (
			    _size * 0.25, _size * 0.75
			  ); 
			_thrusterShape.graphics.curveTo
			  (
			    _size * 0.5, 
			    _size, 
			    _size * 0.25 * 3,
			    _size * 0.75
			  );
			_thrusterShape.graphics.lineTo
			  (
			    _size * 0.25, _size * 0.75
			  );
			_thrusterShape.graphics.endFill();
			_thrusterShape.visible = false;
			
			//Add a blur filter to the thruster
			var thrusterFilters:Array = new Array();
			thrusterFilters = _thrusterShape.filters;
			thrusterFilters.push(new BlurFilter(5, 5, 3));
			_thrusterShape.filters = thrusterFilters;
			
			//Draw the ship
			_shape = new Shape();
			//Leave the lineStyle parameters empty for an invisible line
			_shape.graphics.lineStyle();
			//Set the optional starting position (default is 0,0)
			_shape.graphics.moveTo(0, _size); 
			//Start the fill
			_shape.graphics.beginFill(_color);
			//Draw the connecting lines
			_shape.graphics.lineTo
			  (
			    _size * 0.5, 0
			  );
			_shape.graphics.lineTo
			  (
			    _size, _size
			  );
			_shape.graphics.curveTo
			  (  
			    _size * 0.5, _size * 0.5, 
			    0, _size
			  );
			//End the fill
			_shape.graphics.endFill();
			
			//Create a new Sprite to contain the shapes
			_spaceShip = new Sprite();
			_spaceShip.addChild(_thrusterShape);
			_spaceShip.addChild(_shape);
			addChild(_spaceShip);
			//Position ship in center and rotate it to the right
			_spaceShip.x += _size * 0.5;
			_spaceShip.y -= _size * 0.5;
			_spaceShip.rotation = 90;
			
			//Add a bevel and drop shadow filter to the ship
			var shipFilters:Array = new Array();
			shipFilters = _shape.filters;
			shipFilters.push
			  (
			    new BevelFilter
			    (
			      2, 135, 0xFFFFFF, 0.50, 0x000000, 0.50, 2, 2
			    )
			  );
			shipFilters.push
			  (
			    new DropShadowFilter
			    (
			      2, 135, 0x000000, 0.35, 2, 2
			    )
			  );
			_shape.filters = shipFilters;
		}
		
		public function update():void
		{
			//Temporarily store the current x and y positions
			temporaryX = xPos;
			temporaryY = yPos;
			
			//Calculate the rotationValue
			rotationValue += rotationSpeed;
			
			//Calculate the angle and acceleration
			_angle = rotationValue * (Math.PI / 180);
			_accelerationX = Math.cos(_angle) * acceleration;
			_accelerationY = Math.sin(_angle) * acceleration;
			
			frictionX = vx * friction;
			frictionY = vy * friction;
			
			//Alternate friction equation
			//_frictionX = (_xPos - _previousX) * _friction;
			//_frictionY = (_yPos - _previousY) * _friction;
			
			//Speed trap:Stop the object moving 
			//if the up arrow isn't being pressed
			//and its speed falls below 0.1
			
			if(! thrusterFired)
			{
			  if((Math.abs(vx) < 0.1) && (Math.abs(vy) < 0.1))
			  {
				  _accelerationX = 0;
				  _accelerationY = 0;
				  frictionX = 0;
				  frictionY = 0;
			  }
		  }
      
			//Apply acceleration to the position
			xPos += _accelerationX + frictionX;
			yPos += _accelerationY + frictionY;
			
			//The temporary values becomes the
      //previous positions, which are used calculate velocity
			previousX = temporaryX;
			previousY = temporaryY;
		}
		
		//Getters and setters
		//angle
		public function get angle():Number
		{
			_angle = rotationValue * (Math.PI / 180);
			return _angle
		}
		
		//accelerationX
		public function get accelerationX():Number
		{
			_accelerationX = Math.cos(_angle) * acceleration;
			return _accelerationX;
		}
		
		//accelerationY
		public function get accelerationY():Number
		{
			_accelerationY = Math.sin(_angle) * acceleration;
			return _accelerationY;
		}
		
		//vx
		public function get vx():Number
		{
			return xPos - previousX;
		}
		public function set vx(value:Number):void
		{
			previousX = xPos - value;
		}
		
		//vy
		public function get vy():Number
		{
			return yPos - previousY;
		}
		public function set vy(value:Number):void
		{
			previousY = yPos - value;
		}
		
		//setX
		public function set setX(value:Number):void
		{
			previousX = value - vx;
			xPos = value;
		}
		
		//setY
		public function set setY(value:Number):void
		{
			previousY = value - vy;
			yPos = value;
		}
	}
}