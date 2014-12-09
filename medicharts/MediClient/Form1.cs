using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;

namespace MediClient
{
	/// <summary>
	/// Summary description for Form1.
	/// </summary>
	public class Form1 : System.Windows.Forms.Form
	{
		private System.Windows.Forms.Label label1;
		private System.Windows.Forms.Label label2;
		private System.Windows.Forms.TextBox txtId;
		private System.Windows.Forms.Button cmdSubmit;
		private System.Windows.Forms.TextBox txtResult;
		/// <summary>
		/// Required designer variable.
		/// </summary>
		private System.ComponentModel.Container components = null;

		public Form1()
		{
			
			//
			// Required for Windows Form Designer support
			//
			InitializeComponent();

			//
			// TODO: Add any constructor code after InitializeComponent call
			//
		}

		/// <summary>
		/// Clean up any resources being used.
		/// </summary>
		protected override void Dispose( bool disposing )
		{
			if( disposing )
			{
				if (components != null) 
				{
					components.Dispose();
				}
			}
			base.Dispose( disposing );
		}

		#region Windows Form Designer generated code
		/// <summary>
		/// Required method for Designer support - do not modify
		/// the contents of this method with the code editor.
		/// </summary>
		private void InitializeComponent()
		{
			this.txtId = new System.Windows.Forms.TextBox();
			this.cmdSubmit = new System.Windows.Forms.Button();
			this.txtResult = new System.Windows.Forms.TextBox();
			this.label1 = new System.Windows.Forms.Label();
			this.label2 = new System.Windows.Forms.Label();
			this.SuspendLayout();
			// 
			// txtId
			// 
			this.txtId.Location = new System.Drawing.Point(136, 80);
			this.txtId.Name = "txtId";
			this.txtId.TabIndex = 0;
			this.txtId.Text = "";
			// 
			// cmdSubmit
			// 
			this.cmdSubmit.Location = new System.Drawing.Point(8, 112);
			this.cmdSubmit.Name = "cmdSubmit";
			this.cmdSubmit.TabIndex = 1;
			this.cmdSubmit.Text = "Get Patient";
			this.cmdSubmit.Click += new System.EventHandler(this.cmdSubmit_Click);
			// 
			// txtResult
			// 
			this.txtResult.Location = new System.Drawing.Point(136, 200);
			this.txtResult.Name = "txtResult";
			this.txtResult.TabIndex = 2;
			this.txtResult.Text = "";
			// 
			// label1
			// 
			this.label1.Location = new System.Drawing.Point(8, 80);
			this.label1.Name = "label1";
			this.label1.TabIndex = 3;
			this.label1.Text = "Patient Id";
			// 
			// label2
			// 
			this.label2.Location = new System.Drawing.Point(16, 200);
			this.label2.Name = "label2";
			this.label2.TabIndex = 4;
			this.label2.Text = "Result";
			this.label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
			// 
			// Form1
			// 
			this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
			this.ClientSize = new System.Drawing.Size(292, 273);
			this.Controls.Add(this.label2);
			this.Controls.Add(this.label1);
			this.Controls.Add(this.txtResult);
			this.Controls.Add(this.cmdSubmit);
			this.Controls.Add(this.txtId);
			this.Name = "Form1";
			this.Text = "Form1";
			this.ResumeLayout(false);

		}
		#endregion

		/// <summary>
		/// The main entry point for the application.
		/// </summary>
		[STAThread]
		static void Main() 
		{
			Application.Run(new Form1());
		}

		private void cmdSubmit_Click(object sender, System.EventArgs e)
		{
			ChartService.ChartService cs = new MediClient.ChartService.ChartService();
			string s = cs.GetChart(Convert.ToInt32(txtId.Text));
			txtResult.Text = s;
		}
	}
}
