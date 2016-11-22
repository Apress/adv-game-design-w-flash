package mvc
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Model extends EventDispatcher
	{
		private var _direction:String;
		private var _mousePosition:String;
		
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
    public function get mousePosition():String
    {
      return _mousePosition;
    }
    public function set mousePosition(value:String):void
    {
      _mousePosition = value;
      dispatchEvent(new Event(Event.CHANGE));
    }
	}
}