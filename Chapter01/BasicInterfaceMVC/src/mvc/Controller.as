package mvc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Controller implements IController
	{
		private var _model:Object;

		public function Controller(model:IModel):void 
		{
			_model = model;
		}
		public function processKeyPress(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
			  case Keyboard.LEFT:
			    _model.direction = "Left";
			    break;
			  case Keyboard.RIGHT:
			    _model.direction = "Right";
			    break;
			  case Keyboard.UP:
  			  _model.direction = "Up";
  			  break;
  			case Keyboard.DOWN:
  			  _model.direction = "Down";
  			  break;
			}
		}
	}
}