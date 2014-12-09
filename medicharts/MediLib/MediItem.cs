using System;

namespace MediLib
{
	/// <summary>
	/// Summary description for MediItem.
	/// </summary>
	public class MediItem
	{
		private string _sKey;
		private string _sValue;

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

		public string Value
		{
			get
			{
				return _sValue;
			}
			set
			{
				_sValue = value;
			}
		}

		public MediItem()
		{
		}
	
		public MediItem(string sKey, string sValue)
		{
			Key = sKey;
			Value = sValue;
		}
	}
}
