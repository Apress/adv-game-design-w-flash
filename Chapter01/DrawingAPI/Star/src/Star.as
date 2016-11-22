package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class Star extends Sprite
	{
		public function Star():void
		{
		  //Create a new Vector object for the drawing coordinates
  		//This must be typed as Number
  		var starCoordinates:Vector.<Number> = new Vector.<Number>();
  			
  		//Push the coordinates into the starCoordinates Vector
  		starCoordinates.push(30,0, 35,15, 50,10, 
  		                     45,25,60,30, 45,35, 
  		                     50,50, 35,45, 30,60, 
  		                     25,45, 10,50, 15,35, 
  		                     0,30, 15,25, 10,10, 
  		                     25,15, 30,0);
  		                     
		  //Create a Vector object for the drawing commands
  		var starCommands:Vector.<int> = new Vector.<int>(); 
  			
  		//Push the drawing commands into the starCommands Vector	
  		//1 = moveTo(), 2 = lineTo(), 3 = curveTo()
  		starCommands.push(1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2);
  			
  			                     
  		//Create the starShape object.
  		var starShape:Shape = new Shape();
  		
  		//Begin the fill
  		starShape.graphics.beginFill(0xFFFF00);
  			
  		//Use the drawPath command to draw the shape using the 
  		//starCommands and starCoordinates Vectors
  		starShape.graphics.drawPath(starCommands, starCoordinates);
  		
  		//End the fill
  		starShape.graphics.endFill();
  			
  		//Position the star in the center of the sprite
  		starShape.x -= starShape.width / 2;
  		starShape.y -= starShape.height / 2;
  		addChild(starShape);
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}