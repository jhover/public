/*
 * Created on Mar 31, 2005
 * WInstance.java
 * @author jhover
 *
 */
package org.freescoop.jweeder;

import java.util.*;

/**
 *  Weeder Motif Instance:
 *  Represents a particular instance of a discovered motif 
 *
 * 
 *
 */
public class WInstance {
    
    public String instance;				// actual forward instance
    public WSequence parentSequence;	// sequence this instance is in
    public int location;				// index of beginning of this instance
    									// within the parent sequence
    public int strand;  				// 1 = forward, -1 = reverse
    
    public static final int FORWARD = 1;
    public static final int REVERSE = -1;
    
    
    public WInstance() {
        
        
    }
    
    public WInstance(String s ){
        instance = s;
        
        
        
    }
    
    public String toString() {
        String s = "";
        s += "Instance: " + instance + "\n";
       
        
        return s;
    } // end toString()
    
    
    /*
     * Static factory method to find all occurrences of a particular 
     * motif instance within a set of sequences (from a suffix tree)
     * searches within *forward* sequences for forward motif pattern 
     * and revcomp of the motif pattern. Should find multiple instances,
     * but ignore forward/reverse hits at the same position (which should
     * always occur).
     * 
     * 
     */
    public static Vector findAllDistinct( String seq, SuffTree st){
        Vector v = new Vector();
        
        return v;
        
    }
    
    

}
