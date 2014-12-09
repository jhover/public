using System;
using MediLib.Interfaces;
using MediLib;

namespace MediLib.Controls
{
	/// <summary>
	/// Summary description for MediTextbox.
	/// </summary>
	public class MediTextbox : System.Windows.Forms.TextBox, IUIMLControl, IMediControl
	{

		//private string _sValue;
		private string _sKey;

		public string Value
		{
			get
			{
				return this.Text;
			}
			set
			{
				this.Text = value;
			}
		}

		public string Key
		{
			get
			{
				return _sKey;
			}
			set
			{
				_sKey = value;
			}
		}

		public MediLib.MediItem Item
		{
			get
			{
				return new MediItem(_sKey, this.Text);
			}
			set
			{
				_sKey = value.Key;
				this.Text = value.Value;
			}
		}


		public MediTextbox()
		{
			//
			// TODO: Add constructor logic here
			//
		}

		public string GetStructure()
		{
			return "";
		}

		public string GetStyle()
		{
			return "";
		}
	}
}
