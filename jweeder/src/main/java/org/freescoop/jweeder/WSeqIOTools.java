/*
 * Created on Jan 17, 2005
 *
 *	Quick and dirty class to replace BioJava class in order to allow gcj 
 *	compilation.
 *
 */
package org.freescoop.jweeder;

/**
 * @author jhover
 *
 */
import java.io.BufferedReader;
import java.io.IOException;
import java.io.FileNotFoundException;
import java.io.FileReader;

import java.util.Vector;

public class WSeqIOTools {
    
    public static  WSequenceIterator readFastaDNA(BufferedReader br) throws FileNotFoundException {
        String line = "";
        Vector v = new Vector();
        WSequence ws = null;
        String currents = new String("");
        
        try {
            while(line != null) {
                line = br.readLine();
                if (line == null){
                    if ( ws != null) {
                        ws.setSeqString(currents);
                        v.add(ws);
                    }
                    break;
                }
                else if (line.trim().charAt(0) == '>')
                {
                    if ( ws != null) {
                        ws.setSeqString(currents);
                        v.add(ws);
                    }
                    ws = new WSequence();
                    ws.setName(line);
                    currents = new String("");
                }
                else 
                {
                    currents = currents + line;
                }
                //System.out.println(line);               
            }
        } catch (IOException ioe) 
        {
            // expected, do nothing...
        }
                           
        WSequenceIterator wsi = new WSequenceIterator(v);
        
        
        return wsi;
        
        
    }
    
    public static void main(String[] args) {
        
        WSequenceIterator stream;
        
        try {
            BufferedReader br = new BufferedReader(new FileReader(args[0]));
            stream = WSeqIOTools.readFastaDNA(br);
            while ( stream.hasNext()) {
                WSequence ws = stream.nextSequence();
                System.out.println("Sequence: " + ws.seqString());
          
                
            }
            
            
            
        }
        catch (FileNotFoundException fnfe) {
            System.out.println("ERROR: No sequence file(s) found named " + args[0]);
            System.exit(0);
        }
        
    }
    
    
}
