package
{
	public class StepTimeline
	{
		private var _line:Array;
		
		private var _currIndex:int;
		
		private var setData:Function;
		
		public function StepTimeline( setData:Function )
		{
			this.setData = setData;
			resetTimeline();
		}
		
		private function resetTimeline():void{
			_line = [];
			_currIndex = 0;
		}
		
		public function pushStep( step:StepInfo ):void{
			_line.push( step );
			_currIndex = _line.length - 1;
			
			trace("curr time line length: " + _line.length);
			
//			step.display();
		}
		
		public function getCurrStep():StepInfo{
			if( _currIndex >= _line.length || _currIndex < 0 ){
				return null;
			}
			
			return _line[_currIndex];
		}
		
		public function getPrevStep():void
		{
			_currIndex--;
			var step:StepInfo = getCurrStep();
			if( step != null )
			{
				setData( step );
			}
			else
			{
				_currIndex++;
			}
		}
		
		public function getNextStep():void{
			_currIndex++;
			var step:StepInfo = getCurrStep();
			if( step != null )
			{
				setData( step );
			}
			else
			{
				_currIndex--;
			}
		}
		
		public function getFirst():void{
			var step:StepInfo;
			for( ; _currIndex >= 0; _currIndex--)
			{
				step = getCurrStep();
				if( step != null)
				{
					setData( step );
				}
			}
			_currIndex = 0;
		}
		
		public function getLast():void{
			var step:StepInfo;
			for( ; _currIndex < _line.length; _currIndex++)
			{
				step = getCurrStep();
				if( step != null)
				{
					setData( step );
				}
			}
			_currIndex = _line.length - 1;
		}
		
		public function clearAll():void
		{
			resetTimeline();
		}
		
		public function dispose():void{
			resetTimeline();
		}
	}
}