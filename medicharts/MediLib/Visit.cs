using System;

namespace MediLib
{
	/// <summary>
	/// Summary description for Visit.
	/// </summary>
	public class Visit
	{
		private int _iId;
		private DateTime _dtVisit;
		private int _iDoctorId;

		public int VisitId
		{
			get
			{
				return _iId;
			}
			set
			{
				_iId = value;
			}
		}

		public DateTime VisitDate
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

		public int DoctorId
		{
			get
			{
				return _iDoctorId;
			}
			set
			{
				_iDoctorId = value;
			}
		}

		public Visit(int iDoctorId, DateTime dtVisitDate, int iVisitId)
		{

			VisitId = iVisitId;
			DoctorId = iDoctorId;
			VisitDate = dtVisitDate;
			
		}

		public Visit()
		{
		}
	}
}
