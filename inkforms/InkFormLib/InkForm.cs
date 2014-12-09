using System;

namespace InkForms
{

	/// <summary>
	/// An InkForm is the abstract (non-GUI) representation
	/// of a particular form, containing an unordered set of InkFormItems.
	/// </summary>
	public class InkForm
	{
		private string id;  // a permanent, unique identifier for this form instance  		
		HashTable items;	// a set of InkFormItems, hashed by itemCode
		
		
		public InkForm(string initID)
		{
			formID = initID;
		}

		public string formID 
		{
			get
			{
				return id;
			}
		}

		public override string ToString() 
		{
			return "InkForm: ID: " + formID;

		} // end ToString()

	} // end class InkForm
} // end namespace InkForms
