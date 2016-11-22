package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class GradientFill extends Sprite
	{
		public function GradientFill():void
		{
		  var matrix:Matrix = new Matrix();
			matrix.createGradientBox(50, 50, 0, 0, 0);
			var colors:Array = [0xCCCCCC, 0x333333];
			var alphas:Array = [255, 255]; 
			var ratios:Array = [0, 255];
			
			var square:Shape = new Shape(); 
			square.graphics.lineStyle(1)
      square.graphics.beginGradientFill
        (GradientType.LINEAR, colors, alphas, ratios, matrix);
      square.graphics.drawRect(0, 0, 50, 50);
      square.graphics.endFill(); 
      addChild(square);
      
      //Center on the stage
      this.x = 275 - square.width / 2;
      this.y = 200 - square.height /2;
    }
	}
}