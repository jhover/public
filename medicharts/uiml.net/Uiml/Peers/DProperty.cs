/*
    Uiml.Net: a .Net UIML renderer (http://lumumba.luc.ac.be/kris/research/uiml.net)

	 Copyright (C) 2003  Kris Luyten (kris.luyten@luc.ac.be)
	                     Expertise Centre for Digital Media (http://edm.luc.ac.be)
								Limburgs Universitair Centrum

	This program is free software; you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public License
	as published by the Free Software Foundation; either version 2.1
	of	the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU Lesser General Public License
	along with this program; if not, write to the Free Software
	Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

	Author: 
		Jo Vermeulen
		jo.vermeulen@student.luc.ac.be
*/

using System;
using System.Xml;
using System.Collections;

namespace Uiml.Peers
{
	/// <summary>
	/// This class represents a &lt;d-property&gt; element in the vocabulary, specified by the following DTD:
	/// &lt;!ELEMENT d-property (d-method*,d-param*)&gt;
	/// &lt;!ATTLIST d-property
	///           id NMTOKEN #REQUIRED
	///           maps-type (attribute|getMethod|setMethod|method) #REQUIRED
	///           maps-to CDATA #REQUIRED
	///           return-type CDATA #IMPLIED&gt;
	/// </summary>
	public class DProperty : IUimlElement
	{
		protected ArrayList m_children = null;

		protected string m_identifier;
		protected string m_mapsType;
		protected string m_mapsTo;
		protected string m_returnType;

		public enum MAPS_TYPE_VALS { Attribute, GetMethod, SetMethod, Method };
		public const string ATTRIBUTE = "attribute";
		public const string GET_METHOD = "getMethod";
		public const string SET_METHOD = "setMethod";
		public const string METHOD = "method";

		public DProperty()
		{}

		public DProperty(XmlNode n)
		{
			Process(n);
		}

		public void Process(XmlNode n)
		{
			if(n.Name != IAM)
				return;

			XmlAttributeCollection attr = n.Attributes;
			if(attr.GetNamedItem(ID) != null)
				Identifier = attr.GetNamedItem(ID).Value;
			
			if(attr.GetNamedItem(MAPS_TYPE) != null)
				MapsType = attr.GetNamedItem(MAPS_TYPE).Value;
			

			if(attr.GetNamedItem(MAPS_TO) != null)
				MapsTo = attr.GetNamedItem(MAPS_TO).Value;
			
			if(attr.GetNamedItem(RETURN_TYPE) != null)
				ReturnType = attr.GetNamedItem(RETURN_TYPE).Value;
			
			ProcessChildren(n.ChildNodes);
		}

		protected void ProcessChildren(XmlNodeList l)
		{
			IEnumerator enumChildren = l.GetEnumerator();

			while(enumChildren.MoveNext())
			{
				XmlNode c = (XmlNode) enumChildren.Current;
				switch(c.Name)
				{
					case DMethod.IAM:
						AddChild(new DMethod(c));
						break;
					case DParam.IAM:
						AddChild(new DParam(c));
						break;
				}
			}
		}

		public bool HasChildren
		{
			get { return m_children != null; }
		}

		public void AddChild(object o)
		{
			if(m_children == null)
				m_children = new ArrayList();
			m_children.Add(o);
		}

		public IEnumerator GetEnumerator()
		{
			return m_children.GetEnumerator();
		}

		public ArrayList Search(Type t)
		{
			ArrayList l = new ArrayList();

			if(HasChildren)
			{
				IEnumerator e = GetEnumerator();

				while(e.MoveNext())
				{
					if(e.Current.GetType().Equals(t))
					{
						l.Add(e.Current);
					}
				}
			}

			return l; 						
		}

		public ArrayList Children
		{
			get { return m_children; }
		}

		public string Identifier
		{
			get { return m_identifier;}
			set { m_identifier = value; }
		}

		public string MapsType
		{
			get { return m_mapsType; }
			set { m_mapsType = value; }
		}

		public string MapsTo
		{
			get { return m_mapsTo; }
			set { m_mapsTo = value;	}
		}

		public string ReturnType
		{
			get { return m_returnType;	}
			set { m_returnType = value;	}
		}

		public const string ID				= "id";
		public const string MAPS_TYPE		= "maps-type";
		public const string MAPS_TO			= "maps-to";
		public const string RETURN_TYPE		= "return-type";

		public const string IAM				= "d-property";		
	}
}
