package mvc
{
  import flash.events.IEventDispatcher;
  
	public interface IModel extends IEventDispatcher
	{
		function get direction():String
    function set direction(value:String):void
	}
}