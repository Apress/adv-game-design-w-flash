package mvc
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.friendsofed.utils.StatusBox;
	
	public class View extends Sprite
	{
		private var _model:Object;
		private var _controller:Object;
		private var _status:StatusBox;
		private var _stage:Object;

		public function View(model:Object, controller:Object):void
		{
			_model = model;
			_model.addEventListener(Event.CHANGE, changeHandler);
			_controller = controller;
			_status = new StatusBox();
			_status.fontSize = 40;
			_status.x = 100;
			_status.y = 175;
			_status.text = "Move Mouse"
			addChild(_status);
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		public function addedToStageHandler(event:Event):void
		{
		  _stage = stage;
		  stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
		}
		public function mouseMoveHandler(event:MouseEvent):void
		{
		  _controller.processMouseMove(event, _stage);
		}
		public function changeHandler(event:Event):void
		{
		  _status.text = _model.mousePosition;
		}
	}
}