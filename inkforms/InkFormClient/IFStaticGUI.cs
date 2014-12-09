using System;
using System.Drawing;
using System.Reflection;
using System.Windows.Forms;
// using Microsoft.Ink;

namespace InkForms
{

	public class IFStaticGUI : Form {
	
		private Panel pnlInput;
		private System.Windows.Forms.Button button1;
		private InkFormClient client;

		private void InitializeComponent()
		{
			this.button1 = new System.Windows.Forms.Button();
			this.SuspendLayout();
			// 
			// button1
			// 
			this.button1.Location = new System.Drawing.Point(96, 104);
			this.button1.Name = "button1";
			this.button1.TabIndex = 0;
			this.button1.Text = "button1";
			this.button1.Click += new System.EventHandler(this.button1_Click);
			// 
			// IFStaticGUI
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 266);
			this.Controls.Add(this.button1);
			this.Name = "IFStaticGUI";
			this.ResumeLayout(false);

		}
		
		public IFStaticGUI(InkFormClient ifc)
		{
			InitializeComponent();
			SuspendLayout();
			
			client = ifc;
			
			pnlInput = new Panel();
			pnlInput.Location = new Point(8,8);
			pnlInput.Size = new Size( 352,192);
			Text = "HelloInkForms";
		
			ResumeLayout(false);

		}

		private void button1_Click(object sender, System.EventArgs e)
		{
			MessageBox.Show("TaDa!!");
			
		} // end IFStaticGui()
	
	} // end mainForm

} // end namespace InkForms