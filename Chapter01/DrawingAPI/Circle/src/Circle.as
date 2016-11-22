package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	[SWF(width='550', height='400', backgroundColor='#FFFFFF', frameRate='30')]

	public class Circle extends Sprite
	{
		public function Circle():void
		{
			var circle:Shape = new Shape();
      circle.graphics.beginFill(0x000000);
      circle.graphics.drawCircle(0, 0, 25);
      addChild(circle);
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}