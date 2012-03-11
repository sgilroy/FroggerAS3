package frogger
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	
	public class Sounds
	{
		
		public static const SOUND_HIT:int = 0;
		public static const SOUND_JUMP:int = 1;
		public static const SOUND_PICKUP:int = 2;
		public static const SOUND_SPLASH:int = 3;
		public static const SOUND_TARGET:int = 4;
		public static const SOUND_OUTOFBOUNDS:int = 5;
		
		[Embed(source='../assets/hit.mp3')]
		private var Sound_Hit:Class;
				
		[Embed(source='../assets/jump.mp3')]
		private var Sound_Jump:Class;
		
		[Embed(source='../assets/pickup.mp3')]
		private var Sound_PickUp:Class;
		
		[Embed(source='../assets/splash2.mp3')]
		private var Sound_Splash:Class;
		
		[Embed(source='../assets/target.mp3')]
		private var Sound_Target:Class;
		
		[Embed(source='../assets/outofbounds.mp3')]
		private var Sound_OutOfBounds:Class;
		
		
		private var _channel:SoundChannel;
		private var _sounds:Vector.<Sound>;
		
		public function Sounds() {
			_sounds = new Vector.<Sound>;
			_sounds.push(new Sound_Hit(), new Sound_Jump(),
						new Sound_PickUp(), new Sound_Splash(), 
						new Sound_Target(), new Sound_OutOfBounds());
		}
		
		public function play (type:int):void {
			if (_sounds.length -1 < type) return;
			_channel = _sounds[type].play();
		}
		
		public function stop ():void {
			if (_channel)
				_channel.stop();
		}	
	}
}