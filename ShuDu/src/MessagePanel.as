package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class MessagePanel extends Sprite
	{
		public function MessagePanel( msg:String )
		{
			(this.getChildByName("_txtMsg") as TextField).text = msg;
			
			(this.getChildByName("btnOK") as MovieClip).addEventListener(MouseEvent.CLICK, onClickOK);
		}
		
		private function onClickOK(evt:MouseEvent):void
		{
			if( this.parent != null )
			{
				this.parent.removeChild( this );
			}
		}
	}
}