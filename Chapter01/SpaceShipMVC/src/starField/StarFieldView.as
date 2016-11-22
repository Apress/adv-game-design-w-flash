﻿package starField{	import flash.display.Shape;	import flash.display.Sprite;	import flash.filters.*;	import flash.events.Event;	import com.friendsofed.utils.StageBoundaries;		//Required for creating a gradient fill	import flash.display.GradientType;	import flash.geom.Matrix;	public class StarFieldView extends Sprite 	{		private var _model:Object;		private var _numberOfStars:uint;		private var _starSize:uint		private var _starColor:uint		private var _backgroundColorOne:uint;		private var _backgroundColorTwo:uint;		private var _starArray:Array;		private var _backgroundFill:Shape;		public function StarFieldView		  (		    model:Object = null, 		    numberOfStars:uint = 60, 		    starSize:uint = 10, 		    starColor:uint = 0xCCFF66, 		    backgroundColorOne:uint = 0x0000CC, 		    backgroundColorTwo:uint = 0x3366FF		  )		{			this._model = model			this._model.addEventListener(Event.CHANGE, changeHandler);			this._numberOfStars = numberOfStars;			this._starSize = starSize;			this._starColor = starColor;			this._backgroundColorOne = backgroundColorOne;			this._backgroundColorTwo = backgroundColorTwo;						addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function onAddedToStage(event:Event):void		{		  createStarfield();		  removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}		private function createStarfield():void		{			//Paint the background fill			//Create the gradient fill for the background			var matrix:Matrix = new Matrix();			matrix.createGradientBox			  (			    stage.stageWidth, 			    stage.stageHeight, 			    45, 0, 0			  );			var colors:Array = [_backgroundColorOne, _backgroundColorTwo];			var alphas:Array = [100, 100]; 			var ratios:Array = [0, 255];							_backgroundFill = new Shape();			_backgroundFill.graphics.lineStyle();			_backgroundFill.graphics.beginGradientFill			  (			    GradientType.LINEAR, colors, alphas, ratios, matrix			  );			_backgroundFill.graphics.drawRect			  (0, 0, stage.stageWidth, stage.stageHeight);			_backgroundFill.graphics.endFill();			addChild(_backgroundFill);						_starArray = [];						//1. This system creates stars of different sizes on 			//a wide range of planes						for (var i:uint = 0; i < Math.round(_numberOfStars); i++)			{				//Find a random star size. The random number will be weighted				//to smaller sizes so that more stars appear in the background				var starSize:uint = weightedRandomNumber(_starSize/2);								//Create a new star and position it randomly				var star:Star = new Star(starSize, _starColor);				star.x = Math.random() * stage.stageWidth;				star.y = Math.random() * stage.stageHeight;				_starArray.push(star);				addChild(star);			}						//2. This second optional system creates stars 			//of three different sizes			//They appear to be on three seperate planes			/*			for (var i:uint = 0; i < Math.round(_numberOfStars/3); i++)			{				//Create a new big star Star(size:uint, color:uint)				var bigStar:Star = new Star(_starSize, 0x000000);				bigStar.x = Math.random() * stage.stageWidth;				bigStar.y = Math.random() * stage.stageHeight;				_starArray.push(bigStar);				addChild(bigStar);								//Create a new medium star				var mediumStar:Star 				  = new Star((uint(_starSize/3) * 2), 0x000000);				mediumStar.x = Math.random() * stage.stageWidth;				mediumStar.y = Math.random() * stage.stageHeight;				_starArray.push(mediumStar);				addChild(mediumStar);								//Create a new small star				var smallStar:Star 				  = new Star(uint(_starSize/3), 0x000000);				smallStar.x = Math.random() * stage.stageWidth;				smallStar.y = Math.random() * stage.stageHeight;				_starArray.push(smallStar);				addChild(smallStar);			}			*/		}				//This method finds a random number between 3 and the maximum size		//of each star. Most of the stars will be the smallest size, 3,		//which is good because it means that there 		//will be more stars in the 		//background than in the foreground, for a natural looking effect		private function weightedRandomNumber(weight:uint):uint		{			var randomNumber:int 			  = Math.ceil(Math.random() * _starSize);			var weightedNumber:int 			  = randomNumber - (uint(Math.random() * weight));			  			if(weightedNumber < 3)			{				weightedNumber = 3;			}			//trace(randomNumber, weightedNumber);			return weightedNumber;		}				private function changeHandler(event:Event):void		{			for (var i:uint = 0; i < _starArray.length; i++)			{				//Scale the speed of the star based on its size				var scale:Number = _starArray[i].size / _starSize;								//Move stars				_starArray[i].x -=  _model.vx * scale;				_starArray[i].y -=  _model.vy * scale;								//Screen wrapping				//"wrapSprite" is used to wrap Sprites with				//x and y properties				StageBoundaries.wrapSprite(_starArray[i], stage);			}		}	}}