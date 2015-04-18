package util
{
	import mx.formatters.DateFormatter;

	public class DateUtil
	{
		public function DateUtil()
		{
		}
		/**
		 * String time format
		 */ 
		private static var TIME_FIRMAT:String = "HH:NN:SS";
		/**
		 * private formatter 
		 */
		private static var _timeFormatter:DateFormatter = null;
		private static function get timeFormatter():DateFormatter
		{
			if (_timeFormatter==null) 
			{
				_timeFormatter = new DateFormatter();
				_timeFormatter.formatString = TIME_FIRMAT;
			}
			return _timeFormatter;
		}
		/**
		 * Get format string HH:NN:SS from date
		 */ 
		public static function timeFormat(date:Date):String
		{
			if (date) return DateUtil.timeFormatter.format(date);
			return "";
		}
		
	}
}