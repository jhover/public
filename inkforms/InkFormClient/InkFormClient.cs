using System;
using System.Net.Sockets;
using System.IO;
using System.Windows.Forms;
using System.Threading;
using System.Collections;
using System.Runtime.Serialization ;
using System.Runtime.Serialization.Formatters.Binary ;
using System.Runtime.Serialization.Formatters.Soap;

namespace InkForms
{
	/// <summary>
	/// Client component of InkForms. 
	/// </summary>
	public class InkFormClient
	{
		public enum UIType
		{
			DynamicGUI,  // UIML dynamically generated graphic UI -gui
			StaticGUI,   // usable static graphic UI -static
			TestGUI, 	// simple graphic test UI  
			StaticTUI,    // a Console UI -tui
			TestTUI      // a Console UI for testing -testtui 
		}

		private int PORT = 59911;
		public string ServerName = "localhost";
		public bool Debug = false;
		public bool Verbose = false;
		public UIType InterfaceType;
		
		TcpClient socket;
		SoapFormatter sf; 
		BinaryFormatter bf;   					
		NetworkStream nws;
		
		HashTable activeForms;   // a set of InkForms hashed by formID
			
		public InkFormClient()
		{
			sf = new SoapFormatter();
			bf = new BinaryFormatter();
			activeForms = new HashTable();

		} // end InkFormClient()

		public void MainLoop() {
			Console.WriteLine("InkFormsClient: MainLoop started...");

			//IFMessage message = new IFMessage(IFMessage.MessageType.Info, 
			//	"Client sent message");
			socket.NoDelay = true;
			
			//bf.Serialize(nws,message);
			//nws.Flush();
			//Console.WriteLine("InkFormsClient: First server message sent.");	
			
			//Application.Run( new IFStaticGUI(this));	
			while ( true ) {
				// check for server messages
					
				// process messages ...
				
				// update client model/gui
				
				// send out updates to server
				//message = new IFMessage(IFMessage.MessageType.Info, 
				//	"Client sent another message");
				
				//bf.Serialize(nws,message); 
				//Console.WriteLine("InkFormsClient: Another server message sent.");
				Thread.Sleep(1000);	
			}// end while true
		} // end MainLoop()
		
		
		public void ReceiveLoop() {
			if (Verbose)
				Console.WriteLine("InkFormsClient: ReceiveLoop(): started...");
		
			while( true) {
				try {
					if ( nws.DataAvailable ) 
					{
						IFMessage ifm = bf.Deserialize(nws) as IFMessage;
						Console.WriteLine("IFClientHandler: ReceiveLoop(): message recieved: \"" + ifm.Data + "\"" );		
					}
				}
				catch (Exception e) {
					Console.WriteLine("IFClientHandler: ReceiveLoop(): Exception: " + e.Message);
				}
				Thread.Sleep(100);
			}
				
		}

		/// <summary>
		/// Makes connection, starts threads.
		/// </summary>
		public void Start() 
		{
			if (Verbose) 
				Console.WriteLine("InkFormsClient: Connecting to " 
				+ ServerName + " on port " + PORT + "...");
			
			socket = new TcpClient(ServerName,PORT);
			nws = socket.GetStream();
						
			if (Verbose)
				Console.WriteLine("InkFormsClient: Server connection on port " 
				+ PORT);
			
			
			
			new Thread( new ThreadStart(MainLoop) ).Start();	
			//new Thread( new ThreadStart(ReceiveLoop) ).Start();	
			
			if ( InterfaceType == UIType.DynamicGUI )
			{ 
				Console.WriteLine("InkFormsClient: not implement yet.");
				Application.Exit();
			}
			else if ( InterfaceType == UIType.StaticGUI )
				ui = new IFStaticGUI(this);
			else if ( InterfaceType == UIType.TestTUI )
				ui = new IFTextUI(this);
			ui.Start();
				 
		} // end run()
		

		public static void Main(string[] args) 
		{
		
			string Usage = 
			"USAGE:  InkFormClient.exe [OPTIONS]\n" + 
			"   OPTIONS:\n" +
			"   -h              Help. This message.\n" +
			"   -s <hostname>   Server to connect to.\n" +
			"   -d              Debug flag.\n" +
			"   -v              Verbose flag.\n" +
			"   -u gui|static|testgui|testtui Interface type.\n"
			;
					
			InkFormClient ifc = new InkFormClient();
			bool MainVerbose = false;
			
			ifc.InterfaceType = UIType.TestTUI; // by default	
			
			// parse command line arguments and set vars in client
			for (int i = 0 ; i < args.Length ; i++)
			{
				if ( string.Compare( args[i] , "-h") == 0) 
	           	{
	           		Console.WriteLine(Usage);
	           		Application.Exit();
	           	}
				
				// handle debug and verbose output
	           	if ( string.Compare( args[i] , "-d") == 0) 
	           	{
                	ifc.Debug = true;
                	ifc.Verbose = true;
                	MainVerbose = true;
            	} 
            	
            	if (string.Compare( args[i], "-v") == 0)
            	{
                	ifc.Verbose = true;
                	MainVerbose = true;
            	}
				
				// set server hostname
                if (string.Compare( args[i], "-s") == 0 )
                {	
                	ifc.ServerName = args[i + 1];
                	if (MainVerbose)
  		              	Console.WriteLine("InkFormsClient: Main(): Connecting to host " + 
                			ifc.ServerName ) ;
                }
                // choose ui type
				// gui|static|testgui|testtui	
                if (string.Compare( args[i], "-u") == 0 )
                {
                	if (string.Compare( args[i + 1], "gui" )
                		ifc.InterfaceType = UIType.DynamicGUI;

                	if (string.Compare( args[i + 1], "static" )
                		ifc.InterfaceType = UIType.StaticGUI;
                		
                	if (string.Compare( args[i + 1], "testgui" )
                		ifc.InterfaceType = UIType.TestGUI;
                	
                	if (string.Compare( args[i + 1], "testtui" )
                		ifc.InterfaceType = UIType.TestTUI;
                
                }
                	
			} // end for all arguments
			
			// start client					
			ifc.Start();
		} // end Main()
		
	} // end class InkFormClient
} // end namespace InkForms
