/*
 * Created on Dec 12, 2004
 *
 *
 *
 */
package org.freescoop.jweeder;


import java.util.Vector;
//import org.biojava.bio.seq.*;
//import org.biojava.bio.symbol.*;
//import org.biojava.bio.symbol.FiniteAlphabet;
//import org.biojava.bio.seq.Sequence;
//import org.biojava.bio.seq.DNATools;
//import java.util.*;

/**
 * @author jhover
 *
 */
public class SuffTree {
    public static final int MAX_DEPTH = 30; // Since this is for WEEDER we don't need more 
											// than max motif_length depth.
    public boolean debug = true;
    public boolean verbose = false;    
    
    public STNode root;
	
    public Vector sources; // Original sequence(s) this suffix tree was built
    						//from.
       
	public SuffTree () {
	    root = new STNode();
	    sources = new Vector();
	}

	/**
	 * Adds the string to the suffix tree by adding all substrings
	 * of it to the tree.
	 * 
	 * Substrings are no longer than MAX_DEPTH
	 * 
	 * @param s
	 */
	public void addString(String s) {
	    sources.add(s);
        int srcIdx = sources.indexOf(s);
	    int i;
        int endlimit;
        for (i = 0; i < s.length(); i++) {
            endlimit = i + SuffTree.MAX_DEPTH;
            if (endlimit > s.length())
                endlimit = s.length();
            addSubString(s.substring(i, endlimit), srcIdx);
        }
	}

	public void addSequence(WSequence seq) {
	    
        String s = seq.seqString();
	    if (verbose)
	        System.out.println("SuffTree: addSequence(): adding seq: " 
	                + s.substring(0, 25) + " ...");
	    sources.add(s);
	    int srcIdx = sources.indexOf(s);
	    int i;
        int endlimit;
        for (i = 0; i < s.length(); i++) {
            endlimit = i + SuffTree.MAX_DEPTH;
            if (endlimit > s.length())
                endlimit = s.length();
            addSubString(s.substring(i, endlimit), srcIdx);
        }
	}
	
	
	public void addSequenceAndRC(WSequence seq) {
	    try {
	        String s = seq.seqString();
	        if (verbose)
		        System.out.println("SuffTree: addSequence(): adding seq: " 
		                + s.substring(0, 25) + " ...");
	        sources.add(s);
	        int srcIdx = sources.indexOf(s);
	        int i;
	        int endlimit;
	        for (i = 0; i < s.length(); i++) {
	            endlimit = i + SuffTree.MAX_DEPTH;
	            if (endlimit > s.length())
	                endlimit = s.length();
	            addSubString(s.substring(i, endlimit), srcIdx);
	        }
	        
	        s = seq.revCompString();
	        if (verbose)
		        System.out.println("SuffTree: addSequence(): (revcomp) adding seq: " 
		                + s.substring(0, 25) + " ...");
	        for (i = 0; i < s.length(); i++) {
	            endlimit = i + SuffTree.MAX_DEPTH;
	            if (endlimit > s.length())
	                endlimit = s.length();
	            addSubString(s.substring(i, endlimit), srcIdx);
	        }
	        
	    } catch (Exception e) {
        System.out.println("SuffTree: ERROR: Problem reading sequence...");
        // catch bioexception
    } // end try-catch
	}
	
	
	
	public int numSources() {
	    return sources.size();
	}
	
	public Vector getSources() {
	    return sources;
	}
	
	/**
	 * Adds the specific string to the suffix tree.
	 * 
	 * @param s the String to add to the suffix tree
	 * @param source the index of the sample sequence it came from
	 */
	public void addSubString( String s , int srcIdx ) {
	    //if ( debug ) System.out.println("SuffTree():addSubString(): substring: " 
	      //      + s + " src: " + srcIdx + "\n");
		char[] chararray = s.toCharArray();
		STNode cursor;
		cursor = root;
		for ( int i = 0; i < s.length(); i++){
		    //if ( debug ) System.out.println("SuffTree():addSubString(): char: " 
		    //        + chararray[i] + "\n");
		    cursor = cursor.addChild(chararray[i], srcIdx);
		}
	}
	
	/**
	 * Returns string of path from root to node
	 * 
	 * @param node
	 * @return String from root to node
	 */
	public static String pathString(STNode node) {
	    String r = "";
	    STNode cursor = node;
	    while (cursor.parent != null) { // only the root has a null parent
	        r += cursor.letter;
	        cursor = cursor.parent;
	    }
		    
	    char[] chararray = new char[r.length()];
	    int i,j;
	    for ( i = ( r.length() - 1), j = 0 ; i > -1 ; i--, j++){
	        chararray[j] = r.charAt(i);
	    }
	    return String.valueOf(chararray);
	}

	/**
	 * Prints a debugging schematic to System.out
	 * 
	 */
	public void printTree() {
	   root.printNode(0); 
	}
	
	/**
	 * Gives useful information abouth the tree
	 * 
	 */
	public String toString() {
	String s = "";
	
	
	return s;
	    
	}
}
