package
{
	import pg1.Class1;
	
	public class Class1Child2 extends Class1
	{
		public function Class1Child2()
		{
			//super();
			this.func1();
			this.func3();
		}
		override public function func1():void
		{}
		internal function func2():void
		{}
		override protected function func3():void
		{}
		private function func4():void
		{}
	}
}