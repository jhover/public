/*
 * Candidate.java
 * 
 * Generates all permutations of length L a given alphabet A.
 * 
 * NOTES:
 * 
 * To simplify candidate generation, this class does NOT return the first
 * sequence expected, i.e. for alphabet {A,B,C} and length 5, the first call
 * to nextCandidate() returns AAAAB, not AAAAA.
 * 
 * Candidate generation is halted by the indexOutOfBoundsException thrown when
 * increment() is called.  
 * 
 * 
 */
package org.freescoop.jweeder;

public class Candidate {
	
	public boolean DEBUG = false;
	private char[] buffer;
	private char[] alph;
	private int bufmaxidx;
	private int alphmaxidx;
	private CharHash ch;
	
	
	public Candidate(int length, String alphabet) {
		buffer = new char[length];
		bufmaxidx = buffer.length - 1;
		alph = alphabet.toCharArray();
		alphmaxidx = alph.length - 1;
		sortCharArray(alph);
		ch = new CharHash();
		for ( int i = 0; i < ( alph.length - 1)  ; i++ ) {
			ch.set(alph[i], alph[i + 1]);
		}
				
		for ( int i = 0; i < buffer.length ; i++) {
			buffer[i] = alph[0];
		}
		if ( DEBUG ) System.out.println("Candidate: bufmaxidx= " + bufmaxidx 
				+ " alph=" + new String(alph)  + " buffer=" + new String(buffer) );
	}
	
	public char[] nextCandidate() throws DoneException {
		try {
			increment(bufmaxidx);
			return buffer;
		} catch (IndexOutOfBoundsException ioe) {
			throw new DoneException();
		}
	}
	
	private void increment(int position){
		if ( buffer[position] == alph[alphmaxidx]) {
			buffer[position] = alph[0];
			increment(position - 1);
		}
		else
		{
			buffer[position] = ch.get(buffer[position]); 
		}
	}
	
	// Brutally simple sort
	private void sortCharArray(char[] array){
		if ( DEBUG ) System.out.println("Candidate: sort(): got " + new String(array));
		
		for ( int i = 0; i < array.length ; i ++) {
			for (int j = i; j < array.length ; j++) {
				if ( array[j] < array[i]) {
					char t = array[i];
					array[i] = array[j];
					array[j] = t;
				}
			}
		}
		if ( DEBUG ) System.out.println("Candidate: sort(): gave " + new String(array));
	} // end sortCharArray
	
	public String toString() {
	    return new String(buffer);
	}
	
} // end Candidate