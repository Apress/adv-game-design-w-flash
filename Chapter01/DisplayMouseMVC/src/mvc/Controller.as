package mvc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;

	public class Controller 
	{
		private var _model:Object;

		public function Controller(model:Object):void 
		{
			_model = model;
		}
		public function processMouseMove
			  (event:MouseEvent, stage:Object):void
		{
		  _model.mousePosition 
		    = "X: " + stage.mouseX + " Y: " + stage.mouseY;
	  }
	}
}