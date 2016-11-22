﻿package{	import flash.events.Event;  import flash.display.*;  import flash.geom.Point;  import flash.geom.Rectangle;  import flash.geom.Matrix;  import flash.utils.getTimer;  import com.friendsofed.utils.*;  import com.friendsofed.vector.*;  [SWF(width="550", height="400",   backgroundColor="#FFFFFF", frameRate="60")]  	public class LotsOfTiles extends Sprite	{	  //Change this variable to determnine the number	  //of times the tiles sheet should be copied to the stage	  private var _timesToRepeat:uint = 100;	   	  //Create a blank BitmapData object as the canvas for this bitmap    private var _stageBitmapData:BitmapData       = new BitmapData(550, 400, true, 0);    private var _stageBitmap:Bitmap       = new Bitmap(_stageBitmapData);        //The size of each tile square in the tileMap image    private var _tileSize:uint = 32;    private var _gridSize:uint = 4;        //Speed limit    private var _speedLimit:int = 3;        //Status box  	private var _statusBox:StatusBox = new StatusBox;  	  	//Create a performance profiler	  private var _performance:PerformanceProfiler 	    = new PerformanceProfiler();  	  	//Variables required to display the tile sheet bitmap		private var _tileBitmap:Bitmap;		private var _tileSheetImage:DisplayObject;		private var _tileBitmapData:BitmapData;	  	  //An array to store the tiles	  private var _tiles:Array = new Array();	  	  //Embed the image of the cave    [Embed(source="../assets/images/charactersTileSheet.png")]    private var TileSheet:Class;				public function LotsOfTiles():void		{ 			//Create a new instance of the TileMap class			_tileSheetImage = new TileSheet();						//Create a BitmapData object to store the image			_tileBitmapData 			  = new BitmapData			  (			    _tileSheetImage.width, 			    _tileSheetImage.height, 			    true, 			    0			  );			_tileBitmapData.draw(_tileSheetImage);					  //Add the stage bitmap		  //this displays the contents of the _stageBitmapData		  //It will be updated automatically when		  //the _stageBitmapData is changed			addChild(_stageBitmap);						//Add the status box			addChild(_statusBox);						initializeTiles();						addEventListener(Event.ENTER_FRAME, enterFrameHandler);		}				//Create tile Models and map them to the		//correct positions on the tile sheet		private function initializeTiles():void		{		  for(var i:int = 0; i < _timesToRepeat; i++)      {		    //Slice the tile sheet into small squares called "tiles"		    for(var column:int = 0; column < _gridSize; column++)        {          for(var row:int = 0; row < _gridSize; row++)          {            //Create a tile object to store the tile's original            //position on the tile sheet and give it initial velocity            //This become's the tile's "Model"            var tileModel:Object = new Object();                        //Record the tile's position on the tileMap image            //so that the correct section of the tileMap can be found            //when the tile is copied onto the stage bitmap            tileModel.tileMap_X = column * _tileSize;            tileModel.tileMap_Y = row * _tileSize;                        //Set the tile's start x and y position on the stage            tileModel.x = tileModel.tileMap_X;            tileModel.y = tileModel.tileMap_Y;		  		        //Give the tile a random velocity		        tileModel.vx 		          = (Math.random() * _speedLimit) - _speedLimit / 2;		        tileModel.vy 		          = (Math.random() * _speedLimit) - _speedLimit / 2;		  		        //Push the tile into the tiles array		        _tiles.push(tileModel);          }        }      }		}		private function enterFrameHandler(event:Event):void		{ 		  //Clear the stage bitmap from the previous frame so that it's		  //blank when you add the new tile positions		  _stageBitmapData.fillRect(_stageBitmapData.rect, 0);		  		  //Loop through all the tiles.		  //Move the tiles by working out their new positions based		  //on the velocity's and positions of the tileModels		  for(var i:int = 0; i < _tiles.length; i++)      {        //1. Update the Models        //Update the position and velocity of the tileModels        _tiles[i].x += _tiles[i].vx;			  _tiles[i].y += _tiles[i].vy;			    			  //Check stage boundaries			  //Check left and right			  if(_tiles[i].x + _tileSize > _stageBitmapData.width			  || _tiles[i].x < 0)			  {			    _tiles[i].vx = -_tiles[i].vx;			  }			  //check top and bottom			  if(_tiles[i].y + _tileSize > _stageBitmapData.height			  || _tiles[i].y < 0)			  {			    _tiles[i].vy = -_tiles[i].vy;			  }			    			  //2. Create the Views and the display on the stage			    			  //Find the tileModel's corresponding tile in the tileMap's			  //BitmapData and plot it to a new position 			  //in the containing stage bitmap			  //This is the tile's "View"			            //Create a Rectangle object that's         //aligned to the right spot on the        //tile sheet. It's top left position         //matches the top left position on the        //tile sheet based on the tile we need.         //These positions are stored in the        //tile Model objects.			  var sourceRectangle:Rectangle = new Rectangle			  (			    _tiles[i].tileMap_X, 				  _tiles[i].tileMap_Y, 				  _tileSize, _tileSize				);									//Create a Point object that defines the new position of the				//tile on on the stage bitmap        var destinationPoint:Point = new Point        (          _tiles[i].x,           _tiles[i].y.         );                  //Copy the tile from the original         //tile sheet and project it onto the        //correct new place on the stage bitmap        //If your original tile bitmap uses         //any areas of transparency, make sure to add the last         //"true" parameter. This is "mergeAlpha".         //It lets transparent areas show through        _stageBitmapData.copyPixels        (          _tileBitmapData,           sourceRectangle,           destinationPoint,          null, null, true        );      }      //Update status box			_statusBox.text = "LOTS OF TILES:"; 			_statusBox.text += "\n" + "TILES ON STAGE: " + _tiles.length; 			_statusBox.text += "\n" + "FPS: " + _performance.fps;  			_statusBox.text 			  += "\n" + "MEMORY: " + _performance.memory + " MB"; 		}	}}