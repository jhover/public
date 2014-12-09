using System;

namespace MediLib.Interfaces
{
	/// <summary>
	/// Summary description for IMediControl.
	/// </summary>
	public interface IMediControl
	{
		string Value
		{
			get;
			set;
		}

		string Key
		{
			get;
			set;
		}

		MediItem Item
		{
			get;
			set;
		}
	}
}
