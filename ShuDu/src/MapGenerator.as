package
{
	public class MapGenerator
	{
		public function MapGenerator(  )
		{
			init(  );
		}
		
		
		
		
		private static const N:int = 9;
		private var  src:Array = [];
//		int table[N][N];
		private var table:Array = [];
		
		private function ouput():void
		{
			var i:int;
			var j:int;
			for (i = 0; i < 9; ++i)
			{
				var str:String = "";
				for (j = 0; j < 9; ++j)
				{
					str += (table[i][j] + " ");
				}
				trace(str);
			}
		}
		
		// 初始化中间的九宫格
		private function centerInit():void
		{
			var i:int;
			for (i = 0; i < N; ++i)
				src[i] = (i + 1);
			random_shuffle(src);
			
			var k:int = 0;
			var j:int;
			for (i = 3; i < 6; ++i)
				for ( j = 3; j < 6; ++j)
					table[i][j] = src[k++];
		}
		
		private function random_shuffle( arr:Array ):void
		{
			var len:int = arr.length;
			var rand1:int;
			var rand2:int;
			var t:int;
			for(var i:int = 0; i < N * 2; i++)
			{
				rand1 = int( Math.random() * N );
				rand2 = int( Math.random() * N );
				
				t = arr[rand1];
				arr[rand1] = arr[rand2];
				arr[rand2] = t;
			}
		}
		
		// 由中间的九宫格交叉变换，初始化上下左右四个九宫格
		private function crossInit():void
		{
			var i:int;
			var l:int;
			var j:int;
			for (i = 3; i < 6; ++i)
			{
				l = 0;
				for (j = 3; j < 6; ++j)
				{
					if (i == 3)
					{
						table[i + 1][l] = table[i][j];
						table[i + 2][l + 6] = table[i][j];
						++l;
					}
					else if (i == 4)
					{
						table[i + 1][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
					else if (i == 5)
					{
						table[i - 2][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
				}
			}
			for ( j = 3; j < 6; ++j)
			{
				 l = 0;
				for (i = 3; i < 6; ++i)
				{
					if (j == 3)
					{
						table[l][j + 1] = table[i][j];
						table[l + 6][j + 2] = table[i][j];
						++l;
					}
					else if (j == 4)
					{
						table[l][j + 1] = table[i][j];
						table[l + 6][j - 1] = table[i][j];
						++l;
					}
					else if (j == 5)
					{
						table[l][j - 2] = table[i][j];
						table[l + 6][j - 1] = table[i][j];
						++l;
					}
				}
			}
		}
		
		// 初始化四个角上的四个九宫格
		private function cornerInit():void
		{
			var i:int;
			var l:int;
			var j:int;
			for (i = 0; i < 3; ++i)
			{
				l = 0;
				for (j = 3; j < 6; ++j)
				{
					if (i == 0)
					{
						table[i + 1][l] = table[i][j];
						table[i + 2][l + 6] = table[i][j];
						++l;
					}
					else if (i == 1)
					{
						table[i + 1][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
					else if (i == 2)
					{
						table[i - 2][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
				}
			}
			for (i = 6; i < 9; ++i)
			{
				l = 0;
				for (j = 3; j < 6; ++j)
				{
					if (i == 6)
					{
						table[i + 1][l] = table[i][j];
						table[i + 2][l + 6] = table[i][j];
						++l;
					}
					else if (i == 7)
					{
						table[i + 1][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
					else if (i == 8)
					{
						table[i - 2][l] = table[i][j];
						table[i - 1][l + 6] = table[i][j];
						++l;
					}
				}
			}
		}
		
		// 根据设定的难度随机挖数
		public function generateSudoku( difficulty:int):Array
		{
			init();
			
			difficulty *= 20;
			var rand1:int;
			var rand2:int;
			while (difficulty--)
			{
				rand1  = int( Math.random() * N );
				rand2 = int( Math.random() * N);
				table[rand1][rand2] = 0;
			}
			return table;
//			ouput();
		}
		
		
		// 初始化数独
		// 先随机生成中间的九宫格，再通过交叉生成上下左右四个九宫格，<br>// 最后通过交叉生成四个角上的九宫格
		/*
		交叉顺序如下：
		9  7  8  3  1  2  6  4  5
		3  1  2  6  4  5  9  7  8
		6  4  5  9  7  8  3  1  2
		7  8  9  1  2  3  4  5  6
		1  2  3  4  5  6  7  8  9
		4  5  6  7  8  9  1  2  3
		8  9  7  2  3  1  5  6  4
		2  3  1  5  6  4  8  9  7
		5  6  4  8  9  7  2  3  1
		*/
		//Please select the difficulty(1~4), input 0 to exit: 
		private function init( ):void
		{
//			srand(time(NULL));
			table = [];
			for( var i:int = 0; i < N; i++ )
			{
				table[i] = [];
				for( var j:int = 0; j < N ;j++)
				{
					table[i][j] = 0;
				}
			}
			centerInit();
			crossInit();
			cornerInit();
//			generateSudoku(difficulty);
		}
		
//		int main()
//		{
//			int d;
//			while (true)
//			{
//				cout << "Please select the difficulty(1~4), input 0 to exit: ";
//				cin >> d;
//				if (d == 0)
//				{
//					break;
//				}
//				init(d);
//				ouput();
//			}
//			
//			return 0;
//		}
	}
}