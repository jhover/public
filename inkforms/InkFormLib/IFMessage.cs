using System;

namespace InkForms
{

	/// <summary>
	/// Encapsulates all messages sent between clients and server.
	/// </summary>
	[Serializable]
	public class IFMessage
	{
		public enum MessageType 
		{
			Info,    // informational messages
			Update,  // update request
			Query,   // request for information
			Response // answer to query
		}
	
		public MessageType Id;
		public object Data;
		
		public IFMessage(MessageType code, string initData){
			Id = code;
			Data = initData;
				
		}	
	}

} // end namespace InkForms