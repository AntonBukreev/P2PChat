package model
{
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.net.NetStream;
	
	import model.vo.MessageVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.observer.Notification;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class MessageProxy extends Proxy implements IProxy
	{
		
		public static var NAME:String = "MessageProxy";
	
		//p2p config
		private const SERVER:String = "rtmfp://p2p.rtmfp.net/";
		private const DEVKEY:String = "e3fbe5c7a8125625d9e1d39e-ab0db57d592e";
		private const GROUP:String = "bukreev_examples_chat";
		
		private var _netConnection:NetConnection;
		private var _netStream:NetStream;
		private var _netGroup:NetGroup;
		
		private const ALLCONNECTION:int = 3;
		private var _connections:int = 0;
		
		/**
		 * constructor
		 */ 
		
		public function MessageProxy()
		{
			super(NAME, null);
		}
		
		/**
		 * model
		 */ 
		
		private var _messages:ArrayCollection = new ArrayCollection();

		/**
		 * init connection to p2p
		 */ 
		public function initConnection():void
		{
			_netConnection = new NetConnection();
			_netConnection.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			_netConnection.connect(SERVER + DEVKEY);	
			
		}
		
		/**
		 * net connection status
		 */ 
		private function onNetStatus(e:NetStatusEvent):void 
		{
			switch(e.info.code) 
			{
				case "NetConnection.Connect.Success" :
					onNetConnect();
					break
				case "NetStream.Connect.Success" :
					onStreamConnect();
					break
				case "NetGroup.Connect.Success" :
					onConnect();
					break
				case "NetGroup.Posting.Notify" :
					onGetNewMessage(e.info.message);
					break
			}
		}
		
		/**
		 * onNetConnect
		 */ 
		private function onNetConnect():void 
		{
			var gs:GroupSpecifier = new GroupSpecifier(GROUP)
			gs.multicastEnabled = true
			gs.postingEnabled = true
			gs.serverChannelEnabled = true
			
			_netStream = new NetStream(_netConnection, gs.groupspecWithAuthorizations());
			_netStream.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			
			_netGroup = new NetGroup(_netConnection, gs.groupspecWithAuthorizations());
			_netGroup.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			onConnect();
		}
		
		/**
		 * onStreamConnect
		 */ 
		private function onStreamConnect():void 
		{
			_netStream.client = this;
			onConnect();
		}
		
		/**
		 * onGroupConnect
		 */ 
		private function onConnect():void 
		{
			_connections += 1;
			if (_connections >= ALLCONNECTION)
			{
				facade.notifyObservers(new Notification(MEvent.MODEL_CONNECT_TO_P2P));
			}
		}
		
		/**
		 * get new message from streem
		 */
		public function onGetNewMessage(response:Object):void
		{
			var message:MessageVO = new MessageVO(response);
			_messages.addItem(message);
			
			facade.notifyObservers(new Notification(MEvent.MODEL_CHANGE_MESSAGE, _messages));
		}
		
		/**
		 * add new message
		 */
		
		public function addNewMessage(message:MessageVO):void
		{
			_messages.addItem(message);
			facade.notifyObservers(new Notification(MEvent.MODEL_CHANGE_MESSAGE, _messages));
			
			var mes:Object = new Object()
			mes.name = message.name;
			mes.text = message.text;
			mes.time = message.time;
			mes.sender = _netConnection.nearID;
			_netGroup.post(mes)
		}
		
		
	}
}