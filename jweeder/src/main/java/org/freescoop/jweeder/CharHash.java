/*
 * Simple implementation of a hash table that accepts chars as keys and values.
 * Uses array of size 256 to cover ASCII
 *  
 * 
 * 
 */


package org.freescoop.jweeder;


public class CharHash {
	
	private char[] table;
	
	public CharHash(){
		table = new char[256];
	}
	


	
	public void set( char key, char value) {
		table[key] = value;
		
	}
	
	public char get( char c) {
		return table[c];
		
	}
} // end class CharHash