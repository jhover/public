using System;

namespace MediLib
{
	/// <summary>
	/// Summary description for Patient.
	/// </summary>
	public class Patient
	{
		private string _sPatientId;
		private string _sFirstName;
		private string _sLastName;

		public string PatientId
		{
			get
			{
				return _sPatientId;
			}
			set
			{
				_sPatientId = value;
			}
		}

		public string FirstName
		{
			get
			{
				return _sFirstName;
			}
			set
			{
				_sFirstName = value;
			}

		}

		public string LastName
		{
			get
			{
				return _sLastName;
			}
			set
			{
				_sLastName = value;
			}
		}

		public Patient()
		{
			FirstName = "";
			LastName = "";
			PatientId = "";
		}

		public Patient(string sFirstName, string sLastName)
		{
			FirstName = sFirstName;
			LastName = sLastName;
			PatientId = "";
		}

	}
}
