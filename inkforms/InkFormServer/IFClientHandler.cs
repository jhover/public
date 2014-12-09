using System;
using System.Net.Sockets;
using System.IO;
using System.Collections;
using System.Threading;
using System.Runtime.Serialization ;
using System.Runtime.Serialization.Formatters.Binary ;
using System.Runtime.Serialization.Formatters.Soap;

namespace InkForms
{
	/// <summary>
	/// Encapsulates the communication with a particular connected client.
	/// </summary>
	public class IFClientHandler
	{
		NetworkStream nws;
		TcpClient socket;
		InkFormServer server;
		BinaryFormatter bf;
		IFMessage ifm;
		
		public IFClientHandler(TcpClient tcpc, InkFormServer ifs) 
		{
				Console.WriteLine("IFClientHandler: new client being constructed..." );
				server = ifs;
				socket = tcpc;
				socket.NoDelay = true;
				bf = new BinaryFormatter();
				new Thread( new ThreadStart(MainLoop) ).Start();
				new Thread( new ThreadStart(ReceiveLoop) ).Start();
				Console.WriteLine("IFClientHandler: Constructor complete." );

		} // end IFClientHandler() constructor

		public void ReceiveLoop() 
		{
			Console.WriteLine("IFClientHandler: ReceiveLoop started..." );
			
			while (true) 
			{
				try {
					NetworkStream nws = socket.GetStream();						
					if ( nws.DataAvailable ) 
					{
						Console.WriteLine("IFClientHandler: ReceiveLoop(): Data detected...");
						ifm = (IFMessage) bf.Deserialize(nws);
						Console.WriteLine("IFClientHandler: ReceiveLoop(): message recieved: \"" + ifm.Data + "\"" );		
					}
				}
				catch (Exception e) {
				
					Console.WriteLine("IFClientHandler: ReceiveLoop(): Exception: " + e.Message);
				}
				Thread.Sleep(100);	
			} // end while true 
		}
		
		public void SendMessage(IFMessage ifm) 
		{
			NetworkStream nws = socket.GetStream();
			bf.Serialize(nws, ifm);
					
		}
		
		public void MainLoop()
		{
			Console.WriteLine("IFClientHandler: MainLoop started..." );
			while (true) {
				
				
				Thread.Sleep(100);	
			}
		
		
		}
	
	
	} // end class IFClientHandler
} // end namespace InkForms