﻿package{  import flash.events.Event;  import flash.media.Sound;  import flash.media.SoundChannel;  import flash.media.SoundTransform;  import com.friendsofed.gameElements.turret.*;    //Sound Effect types:  //1. Long, looped sounds (music)  //2. Short, contineous on/off sounds (thruster)  //3. Single shot sounds (shots, explosions)  //4. Similar types of objects sharing sounds (turrets)    //3 options for sound in games:  //1. Sound View classes for each objet  //2. Global Sound View class for the whole game   //(listeners for each object.. very tricky with dynamic objects)  //3. global Sound controller	public class SoundController	{	  private var _gameModel:GameModel;	  private var _stage:Object;	  	  //Music    [Embed(source="../assets/sounds/music.mp3")]    private var Music:Class;    //Create the _music sound from the Music class    private var _music:Sound = new Music();    private var _musicChannel:SoundChannel = new SoundChannel();        //Thruster    [Embed(source="../assets/sounds/thruster.mp3")]    private var Thruster:Class;    private var _thruster:Sound = new Thruster();    private var _thrusterChannel:SoundChannel = new SoundChannel();    private var _thrusterIsPlaying:Boolean = false;        //Lander Gun    [Embed(source="../assets/sounds/landerTurret.mp3")]    private var LanderTurret:Class;    private var _landerTurret:Sound = new LanderTurret();    private var _landerTurretChannel:SoundChannel       = new SoundChannel();        //Enemy Turret    [Embed(source="../assets/sounds/enemyTurret.mp3")]    private var EnemyTurret:Class;    private var _enemyTurret:Sound = new EnemyTurret();    private var _enemyTurretChannel:SoundChannel = new SoundChannel();        //Small Explosion    [Embed(source="../assets/sounds/smallExplosion.mp3")]    private var SmallExplosion:Class;    private var _smallExplosion:Sound = new SmallExplosion();    private var _smallExplosionChannel:SoundChannel       = new SoundChannel();        //Big Explosion    [Embed(source="../assets/sounds/bigExplosion.mp3")]    private var BigExplosion:Class;    private var _bigExplosion:Sound = new BigExplosion();    private var _bigExplosionChannel:SoundChannel       = new SoundChannel();        //Item Pickup    [Embed(source="../assets/sounds/itemPickup.mp3")]    private var ItemPickup:Class;    private var _itemPickup:Sound = new ItemPickup();    private var _itemPickupChannel:SoundChannel = new SoundChannel();        //UFO Shoot    [Embed(source="../assets/sounds/ufoShoot.mp3")]    private var UfoShoot:Class;    private var _ufoShoot:Sound = new UfoShoot();    private var _ufoShootChannel:SoundChannel = new SoundChannel();	  		public function SoundController(model:GameModel):void		{		  _gameModel = model;						//Start playing the music			//Add the music sound to the _musicChannel and tell it to play		  //it will loop for the longest time it 		  //possibly can, which is the 		  //value of int.MAX_VALUE... 2147483647 times!		  var transform:SoundTransform = new SoundTransform(0.3);		  _musicChannel = _music.play(0, int.MAX_VALUE);		  _musicChannel.soundTransform = transform;		}		    public function thruster():void		{	 		  if(_gameModel.playerModel.thrusterFired)		  {		    if(!_thrusterIsPlaying)		    {		      _thrusterChannel = _thruster.play();		      _thrusterIsPlaying = true;	      }		  }		  else		  {		   _thrusterChannel.stop();		   _thrusterIsPlaying = false;		  }	  }	  	  public function playersTurret():void		{		  _landerTurretChannel = _landerTurret.play();	  }	  	  public function enemyTurret():void		{		  _enemyTurretChannel = _enemyTurret.play();	  }	  	  public function smallExplosion():void		{		  _smallExplosionChannel = _smallExplosion.play();	  }	  public function bigExplosion():void		{		  if (_bigExplosionChannel != null)      {		    var transform:SoundTransform = new SoundTransform(3);  		  _bigExplosionChannel = _bigExplosion.play();  		  _bigExplosionChannel.soundTransform = transform;	    }	  }	  public function itemPickup():void		{		  _itemPickupChannel = _itemPickup.play();	  }	  public function ufoShoot():void		{		  _ufoShootChannel = _ufoShoot.play();	  }	}}