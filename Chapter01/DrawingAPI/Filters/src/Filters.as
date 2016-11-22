package
{
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.filters.*;
	
	[SWF(width='550', height='400', 
	backgroundColor='#FFFFFF', frameRate='30')]

	public class Filters extends Sprite
	{
		public function Filters():void
		{
			var square:Shape = new Shape(); 
      square.graphics.beginFill(0x000000);
      square.graphics.drawRoundRect(-25, -25, 50, 50, 10, 10);
      square.graphics.endFill(); 
      addChild(square);
      
      var squareFilters:Array = square.filters;
      squareFilters.push
        (
          new BevelFilter
          (
            5, 135, 0xFFFFFF, 0.50, 0x999999, 0.50, 2, 2
          )
        );
      squareFilters.push
        (
          new DropShadowFilter
          (
            5, 135, 0x000000, 0.60, 10, 10
          )
        );
      square.filters = squareFilters;
      
      //Center on the stage
      this.x = 275;
      this.y = 200;
    }
	}
}