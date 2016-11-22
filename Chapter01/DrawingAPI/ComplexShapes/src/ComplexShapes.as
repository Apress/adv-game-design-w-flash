package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.filters.*;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class ComplexShapes extends Sprite
	{
		public function ComplexShapes():void
		{
			//Create the gradient box and arrays
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(25, 17, (90*Math.PI / 180), 0, -13);
			var colors:Array = [0xFF3300, 0xFFFF00];
			var alphas:Array = [100, 0]; 
			var ratios:Array = [0, 255];
			
			//Draw the thruster flame
			var flame:Shape = new Shape();
			flame.graphics.lineStyle(1, 0x000000, 0);
			flame.graphics.beginGradientFill(GradientType.LINEAR, 
			                        colors, alphas, ratios, matrix);
			flame.graphics.moveTo(13, -13); 
			flame.graphics.curveTo(25, 25, 
			                        (13 * 3), -13);
			flame.graphics.lineTo(13, -13);
			flame.graphics.endFill();
			addChild(flame);
			
			 //draw the ship
  		var ship:Shape = new Shape();
  		ship.graphics.lineStyle();
  		ship.graphics.moveTo(0, 0); 
  		ship.graphics.beginFill(0x666666);
  		ship.graphics.lineTo(25, -50);
  		ship.graphics.lineTo(50, 0);
  		ship.graphics.curveTo(25, -25, 0, 0);
  		ship.graphics.endFill();
  		addChild(ship);
  		
  		//Create a new sprite to contain the shapes
			var spaceShip:Sprite = new Sprite();
			spaceShip.addChild(flame);
			spaceShip.addChild(ship);
			addChild(spaceShip);
			
			//Add a bevel and drop shadow filter to the space ship
			var shipFilters:Array = new Array();
			shipFilters = spaceShip.filters;
			shipFilters.push(new BevelFilter(2, 135, 0xFFFFFF, 0.50, 
			                     0x000000, 0.50, 2, 2));
			shipFilters.push(new DropShadowFilter(2, 135, 0x000000, 
			                     0.35, 2, 2));
			spaceShip.filters = shipFilters;
			
			//Position ship in center and rotate it to the right
			spaceShip.x = this.x - spaceShip.height/2;
			spaceShip.y = this.y - spaceShip.width/2;
			spaceShip.rotation = 90;
			
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}