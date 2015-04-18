package view
{
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.setTimeout;
	
	import model.MessageProxy;
	import model.vo.MessageVO;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.patterns.observer.Notification;
	
	import view.components.MessagePanel;
	
	public class MessageMediator extends Mediator implements IMediator
	{
		
		private var _name:String = "";

		/**
		 * constructor
		 */ 
		
		public function MessageMediator(viewComponent:Object=null)
		{
			super('MessageMediator', viewComponent);
			initConnection();
			(viewComponent as MessagePanel).btnSend.addEventListener(MouseEvent.CLICK,sendMessage);
		}
		
		/**
		 * on press send button in view component
		 */
		
		public function sendMessage(e:MouseEvent):void
		{
			if (_name != viewComponent.inpName.text)
			{
				send(_name, "Changed name to " + viewComponent.inpName.text);
				_name = viewComponent.inpName.text;
			}
			
			send(viewComponent.inpName.text, viewComponent.inpNew.text);
			(viewComponent as MessagePanel).clearInp();
		}
		
		/**
		 * send mesage to stream
		 */ 
		private function send(name:String, text:String):void
		{
			var message:MessageVO = new MessageVO();
			message.name = name;
			message.text = text;
			message.time = new Date();
			facade.notifyObservers(new Notification(MEvent.VIEW_SEND_MESSAGE, message));
		}
		
		/**
		 * start loading data from server
		 */ 

		public function initConnection():void
		{
			MessageProxy(facade.retrieveProxy(MessageProxy.NAME)).initConnection();
		}
		
		/**
		 * model listeners 
		 */
		
		override public function listNotificationInterests():Array
		{
			return [MEvent.MODEL_CHANGE_MESSAGE, MEvent.MODEL_CONNECT_TO_P2P];
		}
		
		/**
		 * model handlers 
		 */ 
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName())
			{
				case MEvent.MODEL_CHANGE_MESSAGE:
					//chang view
					(viewComponent as MessagePanel).messageProvider = notification.getBody() as ArrayCollection;
					(viewComponent as MessagePanel).messageProvider.refresh();
				break;
				
				case MEvent.MODEL_CONNECT_TO_P2P:
					//init first message
					setTimeout(function():void
					{
						_name = viewComponent.inpName.text = "New User"+ new Date().time;
						send(_name, "Connected to chat...");
					},500);
					break;
			}
		}
				
		
	}
}