using System;
using System.Collections;


namespace MediLib
{
	/// <summary>
	/// Summary description for PatientForm.
	/// </summary>
	public class Chart
	{
		private string _sChartId;
		private int _iPatientId;
		private DateTime _dtVisit;

		private ArrayList _alItems;


		public string ChartId
		{
			get
			{
				return _sChartId;
			}
			set
			{
				_sChartId = value;
			}
		}

		public int PatientId
		{
			get
			{
				return _iPatientId;
			}
			set
			{
				_iPatientId = value;
			}
		}

		public DateTime Visit
		{
			get
			{
				return _dtVisit;
			}
			set
			{
				_dtVisit = value;
			}
		}

		public MediItem[] ChartItems
		{
			get
			{
				return (MediItem[])(_alItems.ToArray(typeof(MediItem)));
			}
		}
		
		public void AddItem(MediItem miItem)
		{
			_alItems.Add(miItem);
		}

		public Chart()
		{
			PatientId = -1;
			ChartId = "";
			Visit = DateTime.Now;
			this._alItems = new ArrayList();
		}

		public Chart(int iPatientId, DateTime dtVisit)
		{
			Visit = dtVisit;
			ChartId = "";
			PatientId = iPatientId;
		}
	}
}
