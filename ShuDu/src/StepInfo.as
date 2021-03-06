package
{
	import flash.geom.Point;

	public class StepInfo
	{
		public static const MAX_MAYBE_NUM:int = 3;
		
		private var _itemPos:Point;
		
		private var _must:int;
		
		private var _maybe:Array;
		
		public function StepInfo( itemPos:Point, must:int, maybe:Array )
		{
			this._itemPos = itemPos;
			this._must = must;
			this._maybe = maybe;
		}
		
		public function copy():StepInfo{
			var newMaybe:Array = [];
			for each( var val:int in this.maybe)
			{
				newMaybe.push( val );
			}
			return new StepInfo( this.itemPos, this.must, newMaybe );
		}
		
		public function get must():int
		{
			return _must;
		}

		public function set must(value:int):void
		{
			_must = value;
		}

		public function get maybe():Array
		{
			return _maybe;
		}

		public function set maybe(value:Array):void
		{
			_maybe = value;
		}
		
		public function addMaybe( num:int ):void{
			if( checkInMaybe(num) )
			{
				return ;
			}
			if( maybe.length == 0 ){
				maybe[0] = num;
				return ;
			}
			else if( maybe.length < 3 )
			{
				maybe[maybe.length] = num;
				return;
			}
			else
			{
				for( var i:int = 0; i < 3; i++){
					if( i < maybe.length -1 ){
						maybe[i] = maybe[i+1];
					}
					else
					{
						maybe[i] = num;
						return ;
					}
				}
			}
		}
		
		private function checkInMaybe( num:int ):Boolean
		{
			for(var i:int = 0; i < maybe.length; i++)
			{
				if( maybe[i] == num )
				{
					maybe.splice(i, 1 );
					return true;
				}
			}
			return false;
		}

		public function get itemPos():Point
		{
			return _itemPos;
		}

		public function set itemPos(value:Point):void
		{
			_itemPos = value;
		}
		
		public function display():void
		{
			trace("[ pos = x:"+this.itemPos.x+", y:"+ itemPos.y+"], [must:"+ must+"], [ maybe:"+maybe.toString()+"]");
		}


	}
}