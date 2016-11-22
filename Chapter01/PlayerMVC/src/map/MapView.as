﻿package map{	import flash.display.*;	import flash.events.Event;		public class MapView extends Sprite	{		//Object that contains the player model		private var _model:Object;		private var _scaleFactor:Number;		private var _mapBoundary:Shape;		private var _positionMarker:Sprite;		public function MapView(model:Object)		{			_model = model;			_model.addEventListener(Event.CHANGE, changeHandler);						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(event:Event):void		{			_scaleFactor = 0.15;						//Draw the map			draw();						//Remove this listener			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function draw():void		{			//Draw the map boundary			_mapBoundary = new Shape();			_mapBoundary.graphics.lineStyle(1);			_mapBoundary.graphics.moveTo(0, 0); 			_mapBoundary.graphics.beginFill(0xCCCCCC);			_mapBoundary.graphics.drawRect			  (			    0, 0, 			    stage.stageWidth * _scaleFactor, 			    stage.stageHeight * _scaleFactor			  );			_mapBoundary.graphics.endFill();			addChild(_mapBoundary);						//Draw the player position marker			_positionMarker = new Sprite();			_positionMarker.graphics.lineStyle();			_positionMarker.graphics.moveTo(0, 0); 			_positionMarker.graphics.beginFill(0xFF0000);			_positionMarker.graphics.drawRect(-2, -2, 4, 4);			_positionMarker.graphics.endFill();			addChild(_positionMarker);		}				private function changeHandler(event:Event):void		{			_positionMarker.x = _model.xPos * _scaleFactor;			_positionMarker.y = _model.yPos * _scaleFactor;		}	}}