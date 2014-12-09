package org.freescoop.jweeder;

import java.util.*;


public class WeederMotif {

    public String motif;
    public int mismatch;
    
    public Vector instances ; // WInstance objects..
    public SuffTree st; 	// source suffix tree (and strings)
    
    public WeederMotif() {
        instances = new Vector();
        
        
    }
    
    public WeederMotif(String s, int d, SuffTree sufftree,  Vector stnodes ){
        this();
        motif = s;
        mismatch = d;
        st = sufftree;
        Iterator i = stnodes.iterator();
        while ( i.hasNext()){
            STNode stn = (STNode) i.next();
            WInstance wi = new WInstance(stn.pathString());
            instances.add(wi);         
        }
    } // end WeederMotif 
    
    /*
     * Type:  (10,3)
     * Pattern:  ACTATATCGG 	
     * Instance: ACTAAATCGC		765		f	chr2:1000202-1000400:notch2:mus_musculus	 
     * 
     */
     public String toString() {
        String s = "";
        s += "Type: (" + motif.length() + "," + mismatch + ")\n";
        s += "Pattern:  " + motif + "\n";
        Iterator it = instances.iterator();
        WInstance wi; 
        while ( it.hasNext()) 
        {
            wi = (WInstance) it.next();
            s+= wi;
        }
        return s;
        
    }
    
    
    
}
