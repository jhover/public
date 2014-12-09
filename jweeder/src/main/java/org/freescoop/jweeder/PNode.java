/**
 * PNode.java
 * 
 * @author John R. Hover
 * @author Howard Hughes Medical Institute
 * @author Gail Mandel Lab, Stony Brook University
 * 
 * Data structure to represent a node in an abstract permutation list
 * representing a sequence of characters.
 * 
 * 
 */
package org.freescoop.jweeder;

public class PNode {

    public static final char[] idx2char = { 'A' , 'C' , 'G' , 'T' }; 
    
    /**
	 * Letter to index mapping...
	 * ACGT
	 * 0123
	 * 
	 * A = 65 -> 0 , C = 67 -> 1 , G = 71 -> 2 , T = 84 -> 3 
	 */
	public static final int[] char2idx = 
	{ 
	/*               ASCII char mappings 0 - 255		         */     
	/*      	0    1    2    3    4    5    6    7    8    9   */
	/* 0 */ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*10+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*20+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*30+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*40+*/  	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*50+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*60+*/ 	-1 , -1 , -1 , -1 , -1 ,  0 , -1 ,  1 , -1 , -1 ,
	/*70+*/ 	-1 ,  2 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*80+*/ 	-1 , -1 , -1 , -1 ,  3 , -1 , -1 , -1 , -1 , -1 ,
	/*90+*/  	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*100+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*110+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*120+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*130+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*140+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*150+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*160+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*170+*/  	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*180+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*190+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*200+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*210+*/  	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*220+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*230+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*240+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*250+*/ 	-1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 , -1 
	}; 
    public boolean isRoot;
    
    public int thisChar; 	// index of the character this node represents
    public int position;	// position in string, indexed from left 0 - 1 - 2 ...
    public int nextChild;	// index of the next character to consider in tree
    public PNode parent;	// parent of this Node in stack
    public PNode child;		// child of this Node
    public Object data;		// whatever data this node should hold
    
    /*
     * Pnode constructor for root, has no char, no parent, no position
     * 
     */
    public PNode() {
        thisChar =  -1;
        nextChild = 0;
        parent = null;
        position = -1;
        isRoot = true;
        
    }
    
    /*
     * PNode constructor for non-root, starts at nextchild 0
     * 
     */
    public PNode(char c, PNode initParent) {
        this();
    	thisChar = char2idx[c] ;
        parent = initParent;
        position = initParent.position + 1;
        isRoot = false;
    }
    
    
    public char getNextChild() throws DoneException
    {
        if ( nextChild >= idx2char.length) {
            if ( isRoot ) {
                throw new DoneException();
            }
            else
            {
                return '\0';
            }
        }
        else
        {
            char retChild = idx2char[nextChild];
            nextChild++;
            return retChild;
        }
    }
    
	/**
	 * Provides a String representation of the path to this node from 
	 * the root of the Suffix Tree. 
	 * 
	 * @return the characters leading to this node from the root
	 */
	public String pathString(){
	    String s = "";
	    if ( this.isRoot)
	        s = "ROOT";
	    else {
	       
	        PNode p = this;
	        // climb tree, adding letters at *front*
	        // Note that we don't need to add a letter from the root itself, 
	        // because it doesn't have a letter. 
	    
	        while(! p.isRoot ) {
	            s = idx2char[p.thisChar] + s;
	            p = p.parent;
	        }
	    }
	    return s;
	    
	}
	
	
	public static void main(String[] args) {
	    String usage = "Usage: PNode -l #";
	    
	    int patlen = 0;
	    
	    for (int i = 0; i < args.length ; i++ ){
	        if ( ( args[i].compareTo("-l") == 0) && (( i + 1) < args.length ) )
	            patlen = Integer.parseInt(args[i + 1]);
	    }
	    
	    if ( patlen < 1) {
	        System.out.println(usage);
	        System.exit(0);
	    }
	    
	    
	    System.out.println("PNode: running test...");
	    PNode proot = new PNode();
        PNode cursor = proot;
        try {
            while (true) 
            {  
                if ( cursor.position == patlen ) 
                {
                   //System.out.println(cursor.pathString());
                   cursor = cursor.parent;
                }
                else 
                {
                    char nextc = cursor.getNextChild();
                    if ( nextc != '\0') 
                    {
                        PNode pn = new PNode(nextc, cursor);
                        cursor = pn;
                        System.out.println("Node: (" + idx2char[cursor.thisChar] + "," 
                                + cursor.position + ") : " 
                                + cursor.pathString());
                    }
                    else 
                    {
                        cursor = cursor.parent;
                    } // end if-else
                    
                } // end if-else
            } // end while true
	    } //end while try
	    catch ( DoneException de) {
	        System.out.println("PNode: caught DoneException. OK.");
	        
	    }
	    
	    
	    
	}
	
    
}
