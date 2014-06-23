package
{
	import flash.geom.Point;

	public class AI
	{
		public function AI()
		{
		}
		
		public var integers:Array;
		private var complete:Boolean = false;
		
		public function inputData( data:Array ):Boolean
		{
			integers = [];
			for( var i:int = 0; i < data.length; i++)
			{
				integers[i] = [];
				for( var j:int = 0; j < data[i].length; j++ )
				{
					integers[i][j] = data[i][j];
				}
			}
			
			return isLegalMap( integers );
		}
		
		private function is_or_not( y:int, x:int):Boolean
		{
			var m:int= int( y/9);  
			var n:int= int(y%9);  
			trace("m : " + m + ",  n: " + n);
			var m1:int = int (m / 3) * 3;  
			var n1:int = int( n / 3) * 3 ; 
			var row:int;
			var col:int;
			for( row=0;row!=9;row++)   
				if(integers[m][row]==x){
					trace("error row: row = " + row);
					return false;
				}
			for(col=0;col!=9;col++) 
				if(integers[col][n]==x){
					trace("error col = " + col);
					return false;
				}
			for ( row=m1;row!=m1+3;row++)  
				for ( col=n1;col!=n1+3;col++)
					if (integers[row][col] == x){
						trace("error row: " + row + ", col:" + col);
						return false;
					}
			
			return true;
		}
		
		public function digui( n:int):void
		{
			if (n > 80)
			{
				complete=true;
				return;
			}
			var i:int;
			trace("[ x : "+int(n/9)+", y : "+int(n%9)+"] = "+ integers[int(n/9)][int(n%9)] );
			if (integers[int(n/9)][int(n%9)] != 0) //找为零的空格
				digui(n+1);
			else  
			{
				var vals = getFirstEmptyVals( integers, new Point(int(n/9), int(n%9)));
			for each( i in vals) 
			{
				if ( is_or_not(n,i) )//能填则填入
				{
					trace("set pos: I:" + (n/9) + "J:" + (n%9));
					integers[int(n/9)][int(n%9)] = i;
					digui(n+1); ///继续填空
					if (complete) {
						trace(" is complete");
						return;
					}
					integers[int(n/9)][int(n%9)] = 0; //递归返回时如果n+1空格1-9都不能填，则将n清零重填
				}
				else
				{
					trace(" cannot be here : i = "  + i);
				}
			}
			}
		}
		
		
		//m,n分别为行和列，a代表待解决的矩阵，空白要填0，b为最终结果，初始化为0
		//使用方法：Cal(0, 0, a, b);这样b里面就是最后的答案了
		public static function Cal( m:int,  n:int, a:Array, b:Array):void
		{
			//下面的while用来查找下一个a[m][n]不是零的位置，也就是要填入数值的位置
			while(m <= 8 && n <= 8 && a[m][n] != 0)
			{
				n++; m += n / 9; n %= 9;
			}
			var i:int;
			var j:int;
			if(m > 8 || n > 8)//这里说明问题解决完了，所以m,n才大于8嘛
			{
				//用for循环保存计算的结果
				for(i = 0; i < 9; i++)
					for(j = 0; j < 9; j++){
						b[i][j] = a[i][j];
						trace("set b:" + b[i][j]);
					}
				return;
			}
			if(b[0][0]) //b[0][0]有数据了，说明结果保存完毕，那当然计算完成了，直接返回
				return;
			var k:int;
			for (k = 1; k <= 9; k++)//对于一个要填入的位置a[m][n]，一定要从1试到9
			{
				var flag:int = 1;
				for(i = 0; i < 9; i++)//检查是不是a[m][n]所在的行和列中这个数值已经存在了
					if(a[m][i] == k || a[i][n] == k)//存在就不能这么填了啊，flag就置零
					{
						flag = 0;
						break;
					}
				//下面是检查a[m][n]所在的那个小的3x3的方块，同样的道理
				for(i = m / 3 * 3; i < m / 3 * 3 + 3; i++)
					for(j = n / 3 * 3; j < n / 3 * 3 + 3; j++)
						if(a[i][j] == k)
						{
							flag = 0;
							break;
						}
				if(flag == 1)//这个位置可以填k，没有矛盾
				{
					a[m][n] = k;//填入数据
					Cal(m + (n + 1) / 9, (n + 1) % 9, a, b);//继续计算吧
					a[m][n] = 0;//呵呵，下次要试k+1了，如果这里不恢复到0，那程序开始那个判断不就认为这里已经填过了，跳到下一个要填的a去了，k的这层for循环，岂不是总是只能执行一次？
				}
			}
		}
		

		private function getFirstEmptyVals( map:Array, pos:Point ):Array
		{
			
			var all:Array = getSerialList();
			
			var i:int;
			var j:int;
			trace("empty all: " + all.toString());
			for( i = 0; i < 9; i++ )
			{
				if( map[i][pos.y] > 0 )
				{
					delFromList( all, map[i][pos.y]);
				}
			}
			trace("empty all del  h: " + all.toString());
			
			for( j = 0; j < 9; j++)
			{
				if( map[pos.x][j] > 0 )
				{
					delFromList( all, map[pos.x][j] );
				}
			}
			trace(" v list: " + map[pos.x].toString());
			trace("empty all del v: " + all.toString());
			
			var startI:int = int( int(pos.x / 3) * 3 );
			var startJ:int = int( int(pos.y / 3) * 3 );
			for( i = startI; i < startI + 3; i++ )
			{
				for( j = startJ; j < startJ + 3; j++ )
				{
					if( map[i][j] > 0 )
					{
						delFromList( all, map[i][j] );
					}
				}
			}
			trace("empty all del mat: " + all.toString());
			
			return all;
		}
		
		private static function getFirstEmptyPos( map:Array ):Point
		{
			for( var i:int = 0; i < 9; i++ )
			{
				for( var j:int = 0; j < 9; j++ )
				{
					if( map[i][j] == 0 )
					{
						return new Point(i,j);
					}
				}
			}
			return null;
		}
		
		private static function isFullMap( map:Array ):Boolean
		{
			for( var i:int = 0; i < 9; i++ )
			{
				for( var j:int = 0; j < 9; j++ )
				{
					if( map[i][j] == 0 )
					{
						return false;
					}
				}
			}
			return true;
		}
		
		private function isLegalMap( map:Array ):Boolean
		{
			if( map == null || map.length == 0 )
			{
				return false;
			}
			
			var i:int;
			var j:int;
			for( i = 0; i <= 6; i = i + 3)
			{
				for( j = 0; j <= 6; j = j + 3)
				{
					if( ! isLegalMat(map, i, j) )
					{
						return false;
					}
				}
			}
			
			for( i = 0; i < 9; i++ )
			{
				if( ! isLegalH(map, i ) )
				{
					return false;
				}
			}
			
			for( j = 0; j < 9; j++)
			{
				if( ! isLegalV(map, j) )
				{
					return false;
				}
			}
			
			return true;
		}
		
		private function isLegalMat( map:Array, startI:int, startJ:int ):Boolean
		{
			var all:Array = getSerialList();
			for(var i:int = startI; i < startI + 3; i++)
			{
				for( var j:int = startJ; j < startJ + 3; j++ )
				{
					if( map[i][j] > 0 )
					{
						if( ! delFromList(all, map[i][j]) )
						{
							trace("illegal mat");
							return false;
						}
					}
					
				}
			}
			return true;
		}
		
		private  function isLegalH( map:Array, i:int):Boolean
		{
			var all:Array = getSerialList();
			for( var j:int = 0; j < 9; j++ )
			{
				if( map[i][j] > 0 )
				{
					if( ! delFromList(all, map[i][j]) )
					{
						trace("illegal h");
						return false;
					}
				}
			}
			return true;
		}
		
		private  function isLegalV( map:Array, j:int):Boolean
		{
			var all:Array = getSerialList();
			for( var i:int = 0; i < 9; i++ )
			{
				if( map[i][j] > 0 )
				{
					if( ! delFromList(all, map[i][j]) )
					{
						trace("illegal v");
						return false;
					}
				}
			}
			return true;
		}
		
		private function delFromList( arr:Array, target:int ):Boolean
		{
			for(var i:int = 0; i < arr.length; i++ )
			{
				if( arr[i] == target )
				{
					arr.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		
		private static function getSerialList():Array
		{
			var arr:Array = [];
			for( var i:int = 1; i <= 9; i++)
			{
				arr.push( i );
			}
			return arr;
		}
		
		private static function cloneMat( map:Array ):Array
		{
			var copy:Array = [];
			for( var i:int = 0; i < map.length; i++ )
			{
				copy[i] = [];
				for( var j:int = 0; j < map[i].length; j++)
				{
					copy[i][j] = map[i][j];
				}
			}
			return copy;
		}
	}
}