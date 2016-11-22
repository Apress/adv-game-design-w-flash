package mvc
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import com.friendsofed.utils.StatusBox;
	
	public class View extends Sprite
	{
		private var _model:Object;
		private var _controller:Object;
		private var _status:StatusBox;

		public function View(model:Object, controller:Object):void
		{
			_model = model;
			_model.addEventListener(Event.CHANGE, changeHandler);
			_controller = controller;
			_status = new StatusBox();
			_status.fontSize = 40;
			_status.x = 200;
			_status.y = 175;
			_status.text = "Text";
			addChild(_status);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		public function addedToStageHandler(event:Event):void
		{
		  stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		public function keyDownHandler(event:KeyboardEvent):void
		{
		  _controller.processKeyPress(event);
		}
		public function changeHandler(event:Event):void
		{
		  _status.text = _model.direction;
		}
	}
}