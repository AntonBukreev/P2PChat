package model.vo
{
	public class MessageVO extends Object
	{
		public var time:Date;
		public var text:String;
		public var name:String;
		
		public function MessageVO(obj:Object = null)
		{
			if (obj != null)
			{
				time = obj.time;
				text = obj.text;
				name = obj.name;
			}
			super();
		}
	}
}