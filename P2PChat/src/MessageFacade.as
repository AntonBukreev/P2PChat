package
{
	import controller.ApplicationStart;
	import controller.SendMessage;
	
	import mx.states.OverrideBase;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	import org.puremvc.as3.patterns.observer.Notification;
	
	public class MessageFacade extends Facade implements IFacade
	{
		
		/**
		 * make it singleton
		 */ 
		
		private static var _instance:MessageFacade = null;
		
		/**
		 * make it singleton 
		 */
		
		public static function get instance():MessageFacade
		{
			if(_instance==null) _instance = new MessageFacade();
			return _instance;
		}
		
		/**
		 * constructor
		 */ 
		
		public function MessageFacade()
		{
			super();
		}
		
		/**
		 * on start application
		 */ 
		
		public function start(component:Object):void
		{
			notifyObservers(new Notification(MEvent.APPLICATION_START, component));
		}
		
		/**
		 * initialise controllers
		 */
		
		override protected function initializeController():void
		{
			super.initializeController();
			registerCommand(MEvent.VIEW_SEND_MESSAGE, SendMessage);
			registerCommand(MEvent.APPLICATION_START, ApplicationStart);
			
		}
	}
}