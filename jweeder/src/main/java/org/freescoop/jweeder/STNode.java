/**
 * STNode.java
 * 
 * @author John R. Hover
 * @author Howard Hughes Medical Institute
 * @author Gail Mandel Lab, Stony Brook University
 * 
 * Class representing a Suffix Tree node in a DNA suffix tree.
 * Children are currently stored in an array, with the indices
 * determined by a CharToIndex method. 
 *
 *
 */
package org.freescoop.jweeder;

import java.util.BitSet;

public class STNode {
    
    /* Class vars  */
    public static int numNodes = 0;
    public static boolean debug = false;
    
     
    /* Vars needed for any tree/node object  */
    public STNode parent;
	public STNode[] child;
	public boolean isRoot;
	public boolean isLeaf;
	public int position; 
	public int numChild;
	
    /* Vars needed for use as a generic DNA/sequence node */
    public static final int ALPH_SIZE = 9;
    
    /* Vars needed for use as a suffix tree node  */
	public BitSet sourcemap;	// bitmap of sample sequences this node appears in
	public char letter;
	public int numSources;		// number of distinct source *sequences* this node
								// is from...
	public int mismatch;       	// used for constrained WEEDER algorithm
	public int mismatch2;		// used for unconstrained
	
	public static final char[] idx2char = {'A','C','G','T','a','c','g','t','N'};
		
	/**
	 * Letter to index mapping...
	 * ACGTacgtN
	 * 012345678
	 * 
	 * A = 65 -> 0 , C = 67 -> 1 , G = 71 -> 2 , T = 84 -> 3
	 * a = 97 -> 4 , c = 99 -> 5 , g = 103 -> 6 , t = 116 -> 7
	 * N = 78 -> 8
	 * 
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
	/*70+*/ 	-1 ,  2 , -1 , -1 , -1 , -1 , -1 , -1 ,  8 , -1 ,
	/*80+*/ 	-1 , -1 , -1 , -1 ,  3 , -1 , -1 , -1 , -1 , -1 ,
	/*90+*/  	-1 , -1 , -1 , -1 , -1 , -1 , -1 ,  4 , -1 ,  5 ,
	/*100+*/ 	-1 , -1 , -1 ,  6 , -1 , -1 , -1 , -1 , -1 , -1 ,
	/*110+*/ 	-1 , -1 , -1 , -1 , -1 , -1 ,  7 , -1 , -1 , -1 ,
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
	                              
		
	/*
	 * Constructor for making a root node
	 * 
	 * 
	 */
	public STNode() {
	    if ( debug ) System.out.println("STNode(): made raw node...\n");
	    child = new STNode[ALPH_SIZE];
	    parent = null;
	    sourcemap = new BitSet();
	    mismatch = 0;
	    STNode.numNodes++;
	}
	
	/*
	 * Constructor for making a non-root node
	 * 
	 */
	public STNode(char initLetter, STNode initParent, int source) {
	    this();
	    if ( debug ) System.out.println("STNode(): char: " + letter + " seqno: " + source + " \n");
	    parent = initParent;
		letter = initLetter;
		isLeaf = true;
		numChild = 0;
		sourcemap.set(source); 
		numSources = 1;
	}
	
	public void addSource (int source ){
	    if ( debug ) System.out.println("STNode():addSource(): seqno: " + source + " \n");
	    int mask = 1;
	    mask = mask << source;
	    sourcemap.set(source);
	    numSources = sourcemap.cardinality();
	} // end addsource

	
	public STNode addChild(char c, int source ) {
	    int idx = char2idx[c];
	    if (child[idx] != null ) {
	        if ( debug ) System.out.println("Node: addChild(): found " + 
	                "pre-existing node for letter " + c);
	        STNode node = child[idx];
	        node.addSource(source);
	        return node;
	    }
	    else
	    {
	        if ( debug ) System.out.println("Node: addChild(): found " + 
	                "no node for letter " + c + ", making new one...");
	        STNode node = new STNode(c,this,source);
	        node.addSource(source);
	        isLeaf = false;
	        numChild++;
	        child[idx] = node;
	        return node;
	    }
	} // end addChild
	
	public STNode getChild(char c){
	    if ( debug ) System.out.println("STNode(): getting child for character \"" + c + "\".\n");
	    return child[char2idx[c]];
	}
	
	
	public boolean isLeaf() {
	    return isLeaf;
	}
	
	public int numChildren() {
	    int num = 0;
	    for (int i = 0 ; i < ALPH_SIZE ; i++ ){
	        if ( child[i] != null ) num++;
	    }
	    return num;
	}

	
	public String toString() {
	    String s = "";
	    s+= "STNode: ";
	    s += "letter: " + letter ;
	    s += "numSources: " + numSources;
	    return s;
	}
	

	/**
	 *	Recursively print node info 
	 * 
	 * @param level
	 */
	public void printNode(int level) {
	    int i;
	    // print whatever is appropriate for this node
	    if ( level == 0 ) { 
	        System.out.print("ROOTNODE\n"); 
	    } else {
	        for ( i = 0; i < level ; i++) System.out.print("  ");
	        System.out.print(letter + ": (" + level + ") " + sourcemap );
	        if ( isLeaf ) 
	            System.out.print(" Leaf!\n");
	        else
	            System.out.print(numChild + " children.\n" );
	    }
	    // print all children
	    for ( i = 0; i < ALPH_SIZE ; i++  ){
	            if ( child[i] != null ) child[i].printNode(level + 1); 
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
	    STNode n = this;
	    // climb tree, adding letters at *front*
	    // Note that we don't need to add a letter from the root itself, 
	    // because it doesn't have a letter. 
	    
	    while(n.parent != null) {
	        s = n.letter + s;
	        n = n.parent;
	    }
	    return s;
	    
	}
	
} // end class STNode
