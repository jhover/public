/// Was MediItem. Serves the same purpose. 

using System;

namespace InkForms
{
	/// <summary>
	/// Class representing a single item (typically a label, InkArea, checkbox, radiobutton, or
	/// ListBox) within an InkForm, independent of graphic presentation. 
	/// </summary>
	public class InkFormItem
	{
		private string itemCode; // unique global identifier for this
								 // form item, i.e. what it is.
		
		private string itemData; // XML-formatted data for this item. 
		public DateTime itemDate; // time this item was created.


		/// <summary>
		/// Constructs
		/// </summary>
		public InkFormItem(string initCode)
		{
			itemCode = initCode;
			itemData = "";
			
		}
		
		public string Code 
		{
			get
			{
				return itemCode;
			}
		} // end property Code
		
		public string Data
		{
			get
			{
				return itemData;
			}
			set
			{
				itemData = value;
			}
		
		} // end property Data
		
	} // end class InkFormItem
} // end namespace InkForms
