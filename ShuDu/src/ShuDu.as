package
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	
	public class ShuDu extends Sprite
	{
		public static const MAX_H:int = 9;
		
		public static const MAX_V:int = 9;
		
		//res
		private var matItems:Array = [];
		private var mcNoClick:MovieClip;
		
		private var txtTime:TextField;
		private var gameTimer:Timer;
		private var countTime:int;
		private var isPlaying:Boolean;
		
		//data
		private var tl:StepTimeline;
		
		private var mapGener:MapGenerator;
		
		private var mapQuestion:Array;
		
		public function ShuDu()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onATS );
			
			mapGener = new MapGenerator(  );
		}
		
		protected function onATS(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onATS );
			
			tl = new StepTimeline( setData );
			
			parseRes();
			
			countTime = 0;
			isPlaying = false;
			
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, onTimer );
			gameTimer.start();
		}
		
		protected function onTimer(event:TimerEvent):void
		{
			if( isPlaying == false)
			{
				return ;
			}
			
			countTime++;
			var min:int = int(countTime / 60);
			var sec:int = int(countTime % 60 );
			var strMin:String = min < 10 ? ("0" + min) : min.toString();
			var strSec:String = sec < 10 ? ("0" + sec) : sec.toString();
			txtTime.text = "" + strMin + ":" + strSec;
		}
		
		private function beginGame():void
		{
			countTime = 0;
			isPlaying = true;
		}
		
		private function endGame():void
		{
			isPlaying = false;
		}
		
		private function createMapByLevel( level:int ):void
		{
			beginGame();
			
			mapQuestion = mapGener.generateSudoku( level );
			
			resetMap();
		}
		
		private function resetMap():void
		{
			var item:Item;
			for( var i:int = 0; i < MAX_H; i++ )
			{
				for(var j:int = 0 ;j < MAX_V ;j++)
				{
					item = matItems[i][j];
					if( mapQuestion[i][j] != 0 )
					{
						item.setFix( mapQuestion[i][j] );
					}
					else
					{
						item.init();
					}
				}
			}
		}
		
		private function parseRes():void{
			for( var i:int = 0; i < MAX_H; i++)
			{
				matItems[i] = [];
				for( var j:int = 0; j < MAX_V; j++)
				{
					matItems[i][j] = new Item(new Point(i, j),  this.getChildByName("item" + i + "_" + j ) as MovieClip );
					Item(matItems[i][j]).addClkEve( onClickItem );
					
					setChooseItem( i, j, false );
				}
			}
			
			txtTime = this.getChildByName("_txtTime") as TextField;
			
			mcNoClick = this.getChildByName("_mcNoClick") as MovieClip;
			mcNoClick.visible = false;
			
			addBtnClk( "_btnFirst", onClickFirst );
			addBtnClk("_btnPrev", onClickPrev );
			addBtnClk( "_btnNext", onClickNext );
			addBtnClk( "_btnLast", onClickLast );
			addBtnClk( "_btnClearTl", onClickTl );
			
			this.addEventListener(MouseEvent.CLICK, onClick );
		}
		
		private function onClick(evt:MouseEvent):void
		{
			var clkName:String = evt.target.name;
			if( clkName.indexOf("btnLevel") != -1 )
			{
				var clkIndex:int = GameHelper.getIntFromStr( clkName );
				
				createMapByLevel( clkIndex + 1 );
			}
			
			switch( clkName )
			{
				case "btnReset":
					resetMap();
					break;
				case "btnAi":
					ai();
					break;
			}
		}
		
		private function ai():void
		{
			showDoneMat( mapQuestion );
			
			if( mapQuestion == null || mapQuestion.length == 0 )
			{
				GameHelper.showDlg(this, "Please give me a map");
				return ;
			}
			
//			var done:Array = [];
//			for(var i:int = 0; i < 9; i++)
//			{
//				done[i] = [];
//				for( var j:int = 0; j < 9; j++)
//				{
//					done[i][j] = 0;
//				}
//			}
			
			var done:Array = AI.cal( mapQuestion );
//			AI.Cal( 0, 0 , mapQuestion, done );
			if( done == null || done.length == 0 )
			{
				GameHelper.showDlg(this, "Map Error");
				return ;
			}
			showDoneMat( done );
			
			showMatFix( matItems );
			
			setAiMat( done );
			
			endGame();
		}
		
		private function showDoneMat( arr:Array ):void
		{
			for( var i:int = 0; i < 9; i++)
			{
				var str:String = "";
				for(var j:int = 0; j < 9 ;j++)
				{
					str += (arr[i][j] + " " );
				}
				trace(str);
			}
			
		}
		
		private function showMatFix( arr:Array ):void
		{
			var item:Item;
			for( var i:int = 0; i < 9; i++)
			{
				var str:String = "";
				for(var j:int = 0; j < 9 ;j++)
				{
					item = matItems[i][j];
					str += (item.isFix + " " );
				}
				trace(str);
			}
			
		}

		
		private function setAiMat(done:Array):void
		{
			var item:Item;
			for( var i:int = 0 ; i < 9; i++ )
			{
				for( var j:int = 0 ; j < 9; j++ )
				{
					item = matItems[i][j];
					if( ! item.isFix )
					{
						item.setData(   new StepInfo(new Point(i,j), done[i][j], [])  );
					}
				}
			}
		}
		
		private function setChooseItem( i:int,  j:int, choose:Boolean ):void
		{
			var item:Item = matItems[i][j];
			item.setBg( choose ? Item.LABEL_FOCUS : Item.LABEL_RELEASE );
		}
		
		private function onClickTl():void
		{
			tl.clearAll();
		}
		
		private function onClickFirst():void
		{
			tl.getFirst();
		}
		
		private function onClickPrev():void
		{
			tl.getPrevStep();
		}
		
		private function onClickNext():void
		{
			tl.getNextStep();
		}
		
		private function onClickLast():void
		{
			tl.getLast();
		}
		
		private function addBtnClk( btnName:String, onClickFunc:Function = null ):void
		{
			var btn:SimpleButton = this.getChildByName( btnName ) as SimpleButton;
			btn.addEventListener(MouseEvent.CLICK, function(evt:MouseEvent):void{
				if( onClickFunc != null){
					onClickFunc();
				}
			});
		}
		
		protected function onClickItem(event:MouseEvent):void
		{
			var item:MovieClip = event.currentTarget as MovieClip;
			var index:int = GameHelper.getFirstIntIndex( item.name );
			var nums:String = item.name.substr( index );
			var numsArr:Array = nums.split("_");
			
			var pos:Point = new Point( numsArr[0], numsArr[1] );
			trace("click pos: " + pos);
			
			var itemData:Item = matItems[pos.x][pos.y];
			trace(" is fix : " + itemData.isFix);
			if( itemData.isFix )
			{
				
				return ;
			}
			
			setChooseItem( pos.x, pos.y, true );
			
			
			var oldStepData:StepInfo = getData( pos );
			trace("old step: ");
			oldStepData.display();
			this.mcNoClick.visible = true;
			var panel:ChoosePanel = new ChoosePanel( oldStepData, confirmChoose, function():void{
				setChooseItem( pos.x, pos.y, false );
				mcNoClick.visible = false;
			} );
			panel.alpha = 0.7;
			this.addChild( panel );
		}
		
		private function getData( pos:Point ):StepInfo
		{
//			var item:MovieClip = items[pos.x][pos.y];
			
//			var strMust:String = (item.getChildByName("_txtMust") as TextField).text;
//			var must:int = strMust == "" ? 0 : int(strMust);
//			
//			var strMaybe:String = (item.getChildByName("_txtMaybe") as TextField).text;
//			var maybe:Array = strMaybe.split(",");
			
			var item:Item = matItems[pos.x][pos.y];
			return item.data;
			
//			return new StepInfo( pos, must, maybe);
		}
		
		private function confirmChoose( oldStepData:StepInfo, step:StepInfo ):void
		{
			trace("push old step");
			oldStepData.display();
			tl.pushStep( oldStepData );
			tl.pushStep( step );
			
			setData( step );
		}
		
		private function setData( step:StepInfo ):void
		{
			step.display();
			
			var item:Item = matItems[step.itemPos.x][step.itemPos.y];
			item.setData( step );
			
			checkDone();
			
//			var item:MovieClip = items[step.itemPos.x][step.itemPos.y];
//			(item.getChildByName("_txtMust") as TextField).text = step.must == 0 ? "" : step.must.toString();
//			(item.getChildByName("_txtMaybe") as TextField).text = step.maybe.length == 0 ? "" : step.maybe.toString();
		}
		

		private function checkDone():void
		{
			if( ! isFull() )
			{
				trace("not full yet");
				return ;
			}
			
			tl.clearAll();  // clear timeline after full
			
			trace(" is full ");
			
			if( isCorrect() )
			{
				GameHelper.showDlg(this, "Congratulations!" );
				
				endGame();
			}
			else
			{
				GameHelper.showDlg(this, "What a pity" );
			}
		}
		
		private function isCorrect():Boolean
		{
			for( var i:int = 0 ; i < MAX_H; i++ )
			{
				for( var j:int = 0; j < MAX_V; j++ )
				{
					if( isThisPosCorrect(i,j) == false )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		private function isThisPosCorrect( i:int, j:int ):Boolean
		{
			if( isHLineCorrect(i,j) == false )
			{
				return false;
			}
			if( isVLineCorrect(i,j) == false )
			{
				return false;
			}
			if( isMatCorrect(i,j) == false )
			{
				return false;
			}
			return true;
		}
		
		private function isMatCorrect( i:int, j:int ):Boolean
		{
			var startI:int = int(i / 3) * 3;
			var startJ:int = int(j / 3) * 3;
			
			var itemTarget:Item = matItems[i][j];
			var item:Item;
			
			for( var ii:int = startI; ii < startI + 3; ii++)
			{
				for( var jj:int = startJ; jj < startJ + 3; jj++)
				{
					if( ii != i && jj != j )
					{
						item = matItems[ii][jj];
						if( item.data.must == itemTarget.data.must )
						{
							return false;
						}
					}
				}
			}
			return true;
		}
		
		private function isHLineCorrect( i:int , j:int):Boolean
		{
			var itemTarget:Item = matItems[i][j];
			var item:Item;
			for( var jj:int = 0 ; jj < MAX_H; jj++)
			{
				if( jj != j )
				{
					item = matItems[i][jj];
					if( item.data.must == itemTarget.data.must )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		private function isVLineCorrect( i:int , j:int):Boolean
		{
			var itemTarget:Item = matItems[i][j];
			var item:Item;
			for( var ii:int = 0 ; ii < MAX_V; ii++)
			{
				if( ii != i )
				{
					item = matItems[ii][j];
					if( item.data.must == itemTarget.data.must )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		private function isFull():Boolean
		{
			var item:Item;
			for( var i:int = 0; i < MAX_H; i++)
			{
				for(var j:int = 0; j < MAX_V; j++)
				{
					item = matItems[i][j];
					if( item.data.must == 0 )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		
	}
}