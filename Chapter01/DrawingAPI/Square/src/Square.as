package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class Square extends Sprite
	{
		public function Square():void
		{
			var square:Shape = new Shape(); 
      square.graphics.beginFill(0x000000);
      square.graphics.drawRoundRect(-25, -25, 50, 50, 10, 10);
      square.graphics.endFill(); 
      addChild(square);
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}