﻿package{          import flash.net.SharedObject;  import flash.text.*;  import flash.display.Sprite;  import flash.events.MouseEvent;  import com.friendsofed.utils.StatusBox;  import com.friendsofed.utils.EasyButton;  [SWF(backgroundColor="0xFFFFFF", frameRate="30",   width="550", height="400")]  public class LocalSharedObjects extends Sprite  {    //Create the shared object    //This creates a "savedData" object that can    //contain any saved values.    private var _sharedObject:SharedObject       = SharedObject.getLocal("savedData");        //Text labels    private var _inputLabel:TextField = new TextField();    private var _outputLabel:TextField = new TextField();        //Input and output textfields    private var _input:TextField = new TextField();    private var _output:TextField = new TextField();        //Buttons    private var _saveButton:EasyButton 		  = new EasyButton("Save", 10, 40, 21);		private var _loadButton:EasyButton 		  = new EasyButton("Load", 10, 40, 21);   		private var _clearButton:EasyButton 		  = new EasyButton("Clear input", 10, 80, 21);		  		//Status box  		private var _status:StatusBox;      		        public function LocalSharedObjects():void    {      _status = new StatusBox("LOCAL SHARED OBJECTS");      addChild(_status);            //Input label      addChild(_inputLabel);      _inputLabel.x = 10;      _inputLabel.y = 50;      _inputLabel.text = "Enter a value:";            //Input text field      addChild(_input);      _input.x = 10;      _input.y = 70;      _input.width = 100;      _input.height = 15;      _input.border = true;      _input.background = true;      _input.type = TextFieldType.INPUT;            //Output label      addChild(_outputLabel);      _outputLabel.x = 10;      _outputLabel.y = _input.y + 30;      _outputLabel.text = "Output:";            //Output text field      addChild(_output);      _output.x = 10;      _output.y = _outputLabel.y + 20;      _output.width = 300;      _output.height = 100;      _output.multiline = true;      _output.wordWrap = true;      _output.border = true;      _output.background = true;            //Add and position the buttons		  addChild(_saveButton);		  _saveButton.y = _input.y;		  _saveButton.x = _input.x + _input.width + 20;		  		  addChild(_loadButton);		  _loadButton.y = _saveButton.y;		  _loadButton.x = _saveButton.x + _saveButton.width + 10;		  		  addChild(_clearButton);		  _clearButton.y = _loadButton.y;		  _clearButton.x = _loadButton.x + _loadButton.width + 10;		  		  //Button listeners		  _clearButton.addEventListener		    (MouseEvent.CLICK, clearHandler);		  _saveButton.addEventListener		    (MouseEvent.CLICK, saveHandler);		  _loadButton.addEventListener		    (MouseEvent.CLICK, loadHandler);    }         private function clearHandler(event:MouseEvent):void		{		  _input.text = "";		} 				private function saveHandler(event:MouseEvent):void		{		  //Save the input text in the shared object		  _sharedObject.data.savedInput = _input.text;		  		  //Write the data to a local file		  _sharedObject.flush();		  		  //Confirm the save in the output box		  _output.appendText("Input text saved" + "\n");		}  				private function loadHandler(event:MouseEvent):void		{		  //Load the shared object		  //This loads a "savedData" object that can      //contain any saved values.		  _sharedObject = SharedObject.getLocal("savedData");      _output.appendText("SharedObject loaded" + "\n\n");      _output.appendText        ("loaded value: " + _sharedObject.data.savedInput + "\n\n");		}         }}