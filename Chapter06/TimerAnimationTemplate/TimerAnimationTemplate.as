package 
{
  import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class TimerAnimationTemplate extends Sprite
	{
	  //Instantiate the timer based on the desired rate at which 
    //you want to update the animation.
    //"16" is about 60 fps. 32 is about 30fps. 
    //Divide 1000 (milliseconds) 
    //by the target frame rate by  to find the correct value

	  private var _animationTimer:Timer = new Timer(16);
     
		public function TimerAnimationTemplate():void
		{ 
	    _animationTimer.addEventListener
	      (TimerEvent.TIMER, animationEventHandler);
	    _animationTimer.start();
	  
	    //Removed from stage listener
	    addEventListener
	      (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	  }
		
		private function animationEventHandler(event:TimerEvent):void
		{ 
		  //Add your animation code here.
		  //This behaves the same as an ENTER_FRAME loop
	  }
	  private function removedFromStageHandler(event:Event):void
		{
		  _animationTimer.removeEventListener
		    (TimerEvent.TIMER, animationEventHandler);
			removeEventListener
			  (Event.REMOVED_FROM_STAGE, removedFromStageHandler);
		}
  }
}