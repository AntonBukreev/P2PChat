package controller
{
	import model.MessageProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.MessageMediator;
	import view.components.MessagePanel;
	
	public class ApplicationStart extends SimpleCommand
	{
		public function ApplicationStart()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var viewComponent:* = notification.getBody();
			
			var proxy:MessageProxy = new MessageProxy()
			facade.registerProxy(proxy);
			facade.registerMediator(new MessageMediator(viewComponent.panel));
		}
	}
	
	
}