package controller
{
	import model.MessageProxy;
	import model.vo.MessageVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class SendMessage extends SimpleCommand
	{
		public function SendMessage()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			var proxy: MessageProxy = MessageProxy(facade.retrieveProxy(MessageProxy.NAME));
			proxy.addNewMessage(notification.getBody() as MessageVO);
		}
	}
}