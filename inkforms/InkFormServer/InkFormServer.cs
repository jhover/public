using System;
using System.Net.Sockets;
using System.IO;
using System.Collections;
using System.Threading;


namespace InkForms
{
	/// <summary>
	/// Server component of InkForms. Currently memory-only.
	/// </summary>
	public class InkFormServer
	{
		private static int PORT = 59911;
		private ArrayList clients;
		private Queue messages;
		private IDatabase db;
		
		public InkFormServer()
		{
			clients = new ArrayList();
			messages = new Queue();	
			new Thread( new ThreadStart( ListenerLoop) ).Start();
			
		} // end InkFormServer()

		// main Server network Listener thread method
		public void ListenerLoop() 
		{
			Console.WriteLine("InkFormsServer: ListenerLoop(): ...");
			new Thread( new ThreadStart(MainLoop) ).Start();
			
			TcpListener listener = new TcpListener(PORT);
			listener.Start();
			
			Console.WriteLine("InkFormsServer: ListenerLoop(): Listening on port " + PORT);
			while (true) 
			{
				TcpClient connectedClient = listener.AcceptTcpClient();
				Console.WriteLine("InkFormsServer: ListenerLoop(): Accepted connection.");
				IFClientHandler client = new IFClientHandler(connectedClient , this);
				clients.Add(client);
				Console.WriteLine("InkFormsServer: ListenerLoop(): Client connection on port " 
					+ PORT);
 				Console.WriteLine("InkFormsServer: ListenerLoop(): There are now " + clients.Count 
 					+ " clients connected.");
 					
			}
		} // end ListenerLoop()

		// main Server Work thread method
		/// <summary>
		/// Main processing loop. 
		///
		/// </summary>
		public void MainLoop()
		{
			Console.WriteLine("InkFormsServer: MainLoop started...");
			while ( true ) {
				// check for messages in Queue
				
				// process messages ...
				
				// update database
				
				// send out updates to clients
				

				// send updates to DB

				// sleep
				Thread.Sleep(100);	
			} // end while true
		}
	
		/// <summary>
		/// Called by ClientHandler upon receipt of message
		/// </summary>
		public void update(IFMessage ifm)
		{
			lock(messages)
			{
				messages.Enqueue(ifm);
			}
		} // end update()

		public  static void Main() 
		{
					
			InkFormServer ifs = new InkFormServer();
			
		} // end Main()

	} // end class InkFormServer

} // end namespace InkForms
