package
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.sampler.getInvocationCount;
	import flash.text.TextField;

	public class ChoosePanel extends Sprite
	{
		//res
		private var mclMust:Array = [];
		private var mclMaybe:Array = [];
		
		//data
		private var step:StepInfo;
		private var oldStep:StepInfo;
		
		private var callBack:Function;
		
		private var cbClearChoose:Function;
		
		
		public function ChoosePanel( step:StepInfo, callBack:Function, clearChoose:Function )
		{
			this.oldStep = step;
			this.step = step.copy();
			this.callBack = callBack;
			this.cbClearChoose = clearChoose;
			this.addEventListener(Event.ADDED_TO_STAGE, onATS );
		}
		
		protected function onATS(event:Event):void
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onATS );
			
			parseRes();
			
			setData();
		}
		
		private function parseRes():void{
			for( var i:int = 0; i < 9; i++ ){
				mclMust[i] = this.getChildByName("must" + i ) as MovieClip;
				mclMaybe[i] = this.getChildByName("maybe" + i ) as MovieClip;
				
				(MovieClip(mclMaybe[i]).getChildByName("_txtNum") as TextField ).text = "" + ( i + 1);
				(MovieClip(mclMust[i]).getChildByName("_txtNum") as TextField ).text = "" + ( i + 1);
				
				MovieClip(mclMaybe[i]).buttonMode = true;
				MovieClip(mclMust[i]).buttonMode = true;
				
				MovieClip(mclMaybe[i]).addEventListener(MouseEvent.CLICK, onClickMaybe );
				MovieClip(mclMust[i]).addEventListener(MouseEvent.CLICK, onClickMust );
				
			}
			
			addEve( "delMust", onClickDelMust );
			addEve( "delMaybe", onClickDelMaybe );
			
			addEve( "btnOK", onClickOk );
			addEve( "btnCancel", onClickCancel );
		}
		
		private function setData():void
		{
			
			clearAllNum( mclMust );
			checkHasThisNum( this.step.must, mclMust );
			
			clearAllNum( mclMaybe );
			for each( var num:int in this.step.maybe ){
				checkHasThisNum( num, mclMaybe );
			}
		}
		
		private function clearAllNum( items:Array ):void
		{
			var item:MovieClip;
			for( var i:int = 0; i < 9; i++ ){
				item = items[i];
				(item.getChildByName("_mcBg") as MovieClip).gotoAndStop( 2 );
			}
		}
		
		private function checkHasThisNum( num:int, items:Array ):void{
			var item:MovieClip;
			for( var i:int = 0; i < 9; i++ ){
				item = items[i];
				if( num == (i+1) ){
					(item.getChildByName("_mcBg") as MovieClip).gotoAndStop( 1 );
				}
			}
		}
		
		private function onClickDelMust(event:MouseEvent):void
		{
			step.must = 0;
			
			setData();
		}
		
		private function onClickDelMaybe(event:MouseEvent):void
		{
			step.maybe = [];
			
			setData();
		}
		
		private function onClickOk(event:MouseEvent):void
		{
			dispose();
			
			if( callBack != null ){
				callBack( this.oldStep, this.step );
			}
		}
		
		private function onClickCancel(event:MouseEvent):void
		{
			dispose();
		}
		
		private function addEve( mcName:String, onClickFunc:Function = null ):void{
			var target:DisplayObject = this.getChildByName( mcName );
			if( onClickFunc != null )
				target.addEventListener(MouseEvent.CLICK, onClickFunc );
		}
		
		protected function onClickMaybe(event:MouseEvent):void
		{
			var item:DisplayObject = event.currentTarget as DisplayObject;
			var itemIndex:int = GameHelper.getIntFromStr( item.name );
			
			this.step.addMaybe( itemIndex + 1 );
			
			setData();
		}
		
		protected function onClickMust(event:MouseEvent):void
		{
			var item:DisplayObject = event.currentTarget as DisplayObject;
			var itemIndex:int = GameHelper.getIntFromStr( item.name );
			
			step.must = itemIndex + 1;
			
			setData();
		}
		
		private function dispose():void{
			if( this.parent != null ){
				this.parent.removeChild( this );
			}
			
			cbClearChoose();
		}
	}
}