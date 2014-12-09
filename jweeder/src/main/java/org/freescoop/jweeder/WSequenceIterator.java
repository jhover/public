/*
 * Created on Jan 17, 2005
* Another quick and dirty replacement for BioJava class.
*
*
*
*
 */
package org.freescoop.jweeder;

import java.util.*;

public class WSequenceIterator {
    
    private Vector sequences;
    private Iterator it;
    
    public WSequenceIterator(Vector v){
        it = v.iterator();
        
    }
    
    public boolean hasNext() {
        return it.hasNext();
    }
    
    public WSequence nextSequence(){
        WSequence next = (WSequence) it.next();
        return next;
        
    }

}
