using System;


namespace InkForms
{
	interface IDatabase
	{
		InkForm query(int formID);
		void update(InkForm form);
		void update(InkFormItem[]);	
	}
	
} // end namespace InkForms