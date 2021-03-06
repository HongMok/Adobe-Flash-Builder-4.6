package
{
	import flash.display.DisplayObjectContainer;

	public class GameHelper
	{
		public function GameHelper()
		{
		}
		
		public static function getIntFromStr( str:String ):int{
			var startIndex:int = getFirstIntIndex( str );
			
			return int( str.substr(startIndex) );
		}
		
		public static function getFirstIntIndex( str:String ):int
		{
			var startIndex:int = -1;
			for( var i:int = 0; i < str.length; i++ ){
				if( charIsInt(str.charAt(i)) ){
					startIndex = i;
					break;
				}
			}
			
			if( startIndex == -1 ){
				return -1;
			}
			
			return startIndex;
		}
		
		private static function charIsInt( ch:String ):Boolean{
			if( ch.charCodeAt(0) >= ("0").charCodeAt(0) && ch.charCodeAt(0) <= ("9").charCodeAt(0) ){
				return true;
			}
			return false;
		}
		
		public static function showDlg(con:DisplayObjectContainer, msg:String):void
		{
			var dlg:MessagePanel = new MessagePanel(msg);
			con.addChild( dlg );
			
		}
		
		
	}
}