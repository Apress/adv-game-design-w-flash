package com.friendsofed.utils
{
  import flash.display.*;
  import flash.filters.*;
  import flash.text.*;

  public class EasyButton extends SimpleButton 
  {
    //Button properties
    private var _upColor:uint = 0x333333;
    private var _overColor:uint = 0x666666;
    private var _downColor:uint = 0x333333;
    private var _width:uint = 80;
    private var _height:uint = 80;
    private var _text:String;
    
    //Text properties
    [Embed(systemFont="Andale Mono", fontName="embeddedFont", 
		fontWeight="normal", advancedAntiAliasing="true", 
		mimeType="application/x-font")]
    private var EmbeddedFontClass:Class;
		private var _fontSize:uint;
		private var _fontColor:uint;

    public function EasyButton
      (
        textContent:String = "", 
		    fontSize:uint = 12, 
        width:int = 50, 
        height:int = 50,
        fontColor:uint = 0xFFFFFF
      ):void 
    {
      this._text = textContent;
      this._width = width;
      this._height = height;
      this._fontSize = fontSize;
      this._fontColor = fontColor;
     
			//Button properties.
			//These are all built-in properties of the SimpleButton class.
			//They call the displayState method which determines
			//how they look.
      downState = displayState(_downColor);
      overState = displayState(_overColor);
      upState = displayState(_upColor);
      hitTestState = overState;
      useHandCursor = true;
    }
    
    //The displayState method creates a Sprite for each
    //button state. The only difference in this example
    //is the background colors used to diffentiate the states
    private function displayState(backgroundColor:uint):Sprite
    { 
      var sprite:Sprite = new Sprite()
      sprite.graphics.beginFill(backgroundColor);
      sprite.graphics.drawRect(0, 0, _width, _height);
      sprite.graphics.endFill();
      
      var filters:Array = [];
			filters = sprite.filters;
			filters.push
			  (
			    new BevelFilter
			    (
			      2, 135, 0xFFFFFF, 0.50, 
			      0x000000, 0.50, 2, 2
			    )
			  );
			filters.push
			  (
			    new DropShadowFilter
			    (
			      2, 135, 0x000000, 0.35, 2, 2
			    )
			  );
			sprite.filters = filters;
			
			//Create a text format object
			var format:TextFormat = new TextFormat();
			format.size = _fontSize;
			format.color = _fontColor;
			format.font = "embeddedFont"
			
			//Create a TextField object
			var textField:TextField = new TextField();
			textField.embedFonts = true;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = _text;
			textField.setTextFormat(format);
			textField.antiAliasType = flash.text.AntiAliasType.ADVANCED;
			
			//Add the text to the sprite
			sprite.addChild(textField);
			textField.x = 5;
			textField.y = 3;
			
      return sprite;
    }
  }
}