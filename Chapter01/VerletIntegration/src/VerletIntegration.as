﻿package {	import flash.events.Event;	import flash.display.Sprite;	import com.friendsofed.utils.StatusBox;	import com.friendsofed.utils.StageBoundaries;		[SWF(backgroundColor="0xFFFFFF", frameRate="60",   width="550", height="400")]	public class VerletIntegration extends Sprite	{		private var _player:Player;		private var _status:StatusBox;				public function VerletIntegration()		{			_player = new Player();			addChild(_player);						//Set the _player object's position on the 			//stage without affecting its velocity			_player.setX = 275;			_player.setY = 200;						_status = new StatusBox();			addChild(_status)					addEventListener(Event.ENTER_FRAME,enterFrameHandler);		}				private function enterFrameHandler(event:Event):void		{			//1. Update the player's position			_player.update();						//2. Check collisions (like stage boundaries)  		StageBoundaries.stop(_player, stage);						//3. Change the player's position			_player.x = _player.xPos;			_player.y = _player.yPos;						//4. Display player's velocity			_status.text = "VX: " + _player.vx + " VY: " + _player.vy; 		}	}}