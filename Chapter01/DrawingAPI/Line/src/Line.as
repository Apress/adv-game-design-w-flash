package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class Line extends Sprite
	{
		public function Line():void
		{
			var line:Shape = new Shape();
      line.graphics.lineStyle(1);
      line.graphics.moveTo(-40, -30);
      line.graphics.lineTo(40, 20);
      addChild(line);
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}