package
{        
    import flash.display.Sprite;
    import com.friendsofed.utils.StatusBox;

    [SWF(backgroundColor="0xFFFFFF", frameRate="30", 
    width="550", height="400")]

    public class HelloWorld extends Sprite
    {
        private var _status:StatusBox;

        public function HelloWorld():void
        {
            _status = new StatusBox("Hello World!");
            addChild(_status);
        }        
    }
}
