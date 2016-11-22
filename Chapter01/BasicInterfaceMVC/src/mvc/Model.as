package mvc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Model extends EventDispatcher implements IModel
	{
		private var _direction:String;
		
		public function Model()
		{
			_direction = "None";
		}
		public function get direction():String
    {
      return _direction;
    }
    public function set direction(value:String):void
    {
      _direction = value;
      dispatchEvent(new Event(Event.CHANGE));
    }
	}
}