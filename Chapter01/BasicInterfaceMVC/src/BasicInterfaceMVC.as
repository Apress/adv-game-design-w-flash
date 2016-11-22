package
{
	import flash.events.Event;
	import flash.display.Sprite;
	import mvc.*;
	
  [SWF(width='550', height='400', backgroundColor='#FFFFFF', frameRate='60')]

	public class BasicInterfaceMVC extends Sprite
	{
		private var _model:Model;
		private var _view:View;
		private var _controller:Controller;
		
		public function BasicInterfaceMVC()
		{
			_model = new Model();
			_controller = new Controller(_model);
			_view = new View(_model, _controller);
			addChild(_view);
		}
	}
}