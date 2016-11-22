﻿package player{	import flash.display.*;	import flash.events.Event;	import flash.filters.*;	import flash.events.Event;	import flash.events.KeyboardEvent;	import flash.ui.Keyboard;	public class PlayerView extends Sprite	{		//Object that contains the player model		private var _model:Object;				//Object that contains the player controller		private var _controller:Object;		public function PlayerView(model:Object, controller:Object)		{			_model = model;			_controller = controller;						//Listen for changes on the model.			//The event handler that reacts to changes			//in the model's value is below			_model.addEventListener(Event.CHANGE, changeHandler);						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(event:Event):void		{			//Draw the player			draw();						//Add listeners			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);						//Remove this listener			removeEventListener			  (Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onKeyDown(event:KeyboardEvent):void		{			_controller.processKeyDown(event);		}		private function onKeyUp(event:KeyboardEvent):void		{			_controller.processKeyUp(event);		}		private function draw():void		{			//Draw the outer shape			var outerShape:Shape = new Shape();			outerShape.graphics.beginFill(0x000000);			outerShape.graphics.drawRoundRect			  (			    -(_model.width * 0.5), 			    -(_model.height * 0.5), 			    _model.width, 			    _model.height, 			    10, 			    10			  );			outerShape.graphics.endFill();			addChild(outerShape);						//Add a bevel and drop shadow and bevel filter			var outerFilters:Array = new Array();			outerFilters = outerShape.filters;			outerFilters.push			  (			    new BevelFilter			    (			      5, 135, 0xFFFFFF, 0.50, 0x999999, 0.50, 2, 2			    )			  );			outerFilters.push			  (			    new DropShadowFilter			    (			      5, 135, 0x000000, 0.60, 10, 10			    )			  );			outerShape.filters = outerFilters;						//Draw the inner shape			var innerShape:Shape = new Shape();			innerShape.graphics.beginFill(0xCCCCCC);			innerShape.graphics.drawCircle(0, 0, _model.width * 0.25);			innerShape.graphics.endFill();			addChild(innerShape);						//Add a bevel and drop shadow and bevel filter			var innerFilters:Array = new Array();			innerFilters = innerShape.filters;			innerFilters.push			  (			    new BevelFilter			    (			      3, 315, 0xFFFFFF, 0.50, 0x999999, 			      0.50, 4, 4, 1, 1, "outer"			    )			  );			innerShape.filters = innerFilters;		}				//When the model changes its values,		//it fires a CHANGE event which triggers		//this changeHandler event handler		private function changeHandler(event:Event):void		{			this.x = _model.xPos;			this.y = _model.yPos;		}	}}