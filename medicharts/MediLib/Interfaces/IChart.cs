using System;
using System.Collections;

namespace MediLib.Interfaces
{
	/// <summary>
	/// Summary description for IChart.
	/// </summary>
	public interface IChart
	{
		ArrayList GetItems();
		void SetItems(ArrayList miItems);
	}
}
