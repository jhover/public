/**
 * Weeder.java
 * 
 * Implementation of the WEEDER subtle motif-finding algorithm:
 * G.Pavesi, G.Mauri, G.Pesole. An Algorithm for Finding Signals of Unknown 
 * Length in Unaligned DNA Sequences.  Bioinformatics  17, S207-S214, 2001. 
 * 
 * @author John R. Hover
 * @author Howard Hughes Medical Institute
 * @author Gail Mandel Lab, Stony Brook University
 * 
 * 
 * Usage: java Weeder 
 * 			-l <#> length of motif pattern to look for 
 * 			-d <#> maximum mismatches in instance 
 * 			-q <#> number of distinct samples motif must appear in
 * 			-s <filename> FASTA formatted DNA sequences 
 * 			-D debug 
 * 			-v verbose
 * 			-R do not consider reverse complement of samples
 * 
 * 
 * 
 * Notes: 
 * 1) Ran into trouble attempting to use gcj to compile to native code  
 * BioJava was too large/interdependent/generated compilation errors to use
 * directly. I substituted local classes prefixed w/ "W" for the BioJava
 * classes and coded minimal functionality. Subsequent benchmarking the 
 * javac vs. gcj version revealed no benefit to native compilation, so I've 
 * reverted to the BioJava classes and removed my custom ones.   
 * 
 *	2) Noticed that expand() is getting called by runSearch numerous times with 
 *  patterns that share a prefix, e.g. with 'AAAAG' and 'AAAAT' the set of nodes
 *  at the fourth position is the same, because in each case they satisfy the 
 *  WEEDER constraints for search for the pattern AAAA in the given suffix tree.
 *  This is a good place to use dynamic programming. A matrix is not necessary, 
 * 	I just use a linked list representing prefixes, and save the sets of nodes
 *  as long as they may be needed for a subsearch. The list behaves as a stack--
 *  at any one time they form a linear chain no longer than the motif size being
 *  searched for.    
 *
 * 3) Jumped too fast to BioJava. Seems the BioJava FASTA readers convert input
 * to BioJava Symbols. Which would be fine if they retained whether or not the
 * original base symbol was uppercase or lowercase (RepeatMasker puts repeats
 * to lowercase), but they don't. Back to custom classes...
 * 
 *
 *
 */
package org.freescoop.jweeder;

//import org.biojava.bio.BioException;
//import org.biojava.bio.seq.Sequence;
//import org.biojava.bio.seq.SequenceIterator;
//import org.biojava.bio.seq.io.SeqIOTools;
//import org.biojava.bio.seq.DNATools;
import java.io.*;
import java.util.*;

/**
 * Top-level class for Weeder search
 * 
 *
 *  
 */
public class Weeder {
    public boolean debug = false;
    public boolean verbose = false;
    public static final String alphabet = "ACGT";
    public int considered;		// number of candidate patterns considered
    public int mlength;			// motif length
    
    private int distinct;		// calculated distinct instances of motif
    							// required to be passed on to phase 2
    							// Equal to  ( distinct/2 ) -1 for a 95%
    							// probability of detecting genuine signal
    	
    public int distinctFinal;	// distinct instances of motif required for
    							// final report
    public int quantum;			// for debugging output
    public SuffTree st;			// suffix tree of input sequences.
        
    public double error;		// error factor
    public int maxMismatch;		// maximum mismatches for mlength
    public int currMax;			// current calculated max mismatch from error
    							// currMax = (int) (( error * position ) + 1 )
    
    public Weeder(SuffTree suffixtree ) {
        considered = 0;
        st = suffixtree;
                
    } // end constructor

   

    /**
     * Performs the WEEDER search on all candidate sequences, collecting all the
     * answers. This version uses the idea of a linked permutation list in order
     * to generate all permutations of length mlength. 
     * 
     * 
     * @param mlength Motif length
     * @param mismatch Maximum mismatches
     * @return Vector containing STNodes, each of which sits at the end of a
     *         string within the suffix tree that satisfies the motif search
     *         criteria.
     *  
     */
    public Vector runSearch(int motiflength, int mismatch, int distinctDesired ) {
        
        long maxMem = Runtime.getRuntime().maxMemory();
        if ( verbose ) System.out.println("Weeder: max JVM memory is " 
                + maxMem + " bytes");
        
        
        distinctFinal = distinctDesired;
        distinct = ((distinctFinal / 2 ) + 1 ); // was -1, tightened to limit candidates
        //distinct = ((distinctFinal / 2 ) - 1 ); // was -1, tightened to limit candidates
        //if ( distinct < 2 ) distinct = 2;
        maxMismatch = mismatch; 
        mlength = motiflength;
        error = (( (double) mismatch / (double) mlength ) + .01 );
        
        quantum = (int) Math.pow(alphabet.length(), mlength - 1); // produces 4 messages
        quantum = quantum / 16; 
        
        if ( verbose ) System.out.println("Weeder: runSearch(): l= " + mlength 
                +" d=" + mismatch 
                + " err= " + error 
                + "\nphase1 distinct= " + distinct
                + " phase2 distinct= " + distinctFinal
                + " display quantum= " + quantum 
        				);
                
     
        Vector answer;
        Vector instances;				// vector of STNodes
        Vector answers = new Vector();  // vector of WeederMotifs
        /*
         * Do PHASE ONE search for all permutations of length mlength, 
         * when a candidate is found, immediately perform a PHASE TWO 
         * search with no constraints.
         * 
         */
        if ( verbose ) System.out.println("Weeder: performing PHASE ONE" +
        		" using permutation list...");
        
        PNode proot = new PNode();
        PNode cursor = proot;
        Vector v = new Vector();
        v.add(st.root);
        cursor.data = v;
        
        int numSrcs;
        int iterations = 0;
        int numCandidates = 0;
        try {
            while (true) 
            {   iterations++;
               	if ( ( ( iterations % 250000 ) == 0 )  &&  verbose ) {
            	    System.out.println("Weeder: Pattern: " + cursor.pathString() 
                       + " Iteration: " + iterations  
            	       + " Candidates: " + numCandidates);
            	    
            	}
            
                // Looks like we've got a potential motif, add to candidates
                if ( cursor.position == ( mlength - 1 ) ) {
                    if ( debug ) System.out.print("Weeder: runSearch: Found a candidate" 
                            +" pattern: " + cursor.pathString() + "\r");
                                        
                    numCandidates++;
                    String pat = cursor.pathString();
                    if (debug) System.out.println("Weeder: Checking pattern " + pat);
                    instances = searchFor(pat);
                    if ( instances != null) {
                        if ( verbose) 
                            System.out.println("Weeder: runSearch(): PHASE TWO Found motif " +pat );
                        WeederMotif wm = new WeederMotif(pat, maxMismatch, st,  instances );
                        answers.add(wm);
                    }
                
                    // continue looking for candidates...
                    cursor = cursor.parent;
                    
                }
                // else we're not at mlength, expand and check numSources...
                else {
                    char nextc = cursor.getNextChild();
                    // yes, jump up
                    if ( nextc != '\0') {
                        if ( debug ) System.out.println("Weeder: doing expand() on pattern "
                                	+ cursor.pathString() + " and letter " + nextc );

                        v = expand( (Vector) cursor.data , nextc , cursor.position + 1  );
                        numSrcs = calcNumSources(v);
                        if (debug)
                            System.out.println("Weeder: numSrcs is: " + numSrcs);
                        if ( numSrcs > distinct) {
                            PNode pn = new PNode(nextc, cursor);
                            pn.data = v;
                            cursor = pn;
                        }
                    }
                    else
                    {
                        cursor = cursor.parent;
                    }
               }               
            } // end while true
        } 
        catch (DoneException de) 
        {
            // This means we have checked all permutations of length l
            if (debug) System.out.println("Weeder: DoneException thrown. OK.");
        }
        
        if (verbose) {
            System.out.println("Weeder: performed " + iterations + " iterations of expand.");
            System.out.println("Weeder: Tested " + numCandidates + " candidates.");
            System.out.println("Weeder: " + answers.size() + " actual motif(s) found.");
        }
        return answers;
    }
    
      
    
    
    /**
     *  Version of searchFor for PHASE TWO
     * 
     * 
     * @param s
     * @return
     */
    public Vector searchFor(String s) {
             
        char[] pattern = s.toCharArray();
        int numsrcs;	
        
        // answer vector will be a vector of STNodes at the end of
        // strings that match pattern with less than errmax error.
        Vector v = new Vector();
        if ( debug ) {
          System.out.println("Weeder: searchForTwo(): " + new String(pattern));
          System.out.println("Weeder: searchForTwo(): maxMismatch is " + this.maxMismatch);
          
        }
      	st.root.mismatch2= 0;
        v.add(st.root);
        
        // for each position in the pattern less than mlength
        for (int i = 0; i < mlength; i++) {
            v = expandTwo(v , pattern, i );
            numsrcs = calcNumSources(v);
            if ( numsrcs < distinctFinal) {
                return null;
            }
        }
        return v;
    }
    
   

/*
 * Calculates number of sources from a Vector of STNodes
 * 
 */
	private int calcNumSources(Vector v){
	    Iterator it = v.iterator();
	    STNode n;
	    BitSet bs = new BitSet(st.numSources());
	    while ( it.hasNext()){
	        n = (STNode) it.next();
	        //i += n.numSources;
	        bs.or(n.sourcemap);
	    }
	    //if (debug) System.out.println("Weeder: Nodes have " + bs.cardinality() 
	    //        + " distinct sources...");
	    return bs.cardinality();
	}

	/**
	 * Core of the WEEDER algorithm. Takes a vector containing suffix tree nodes
	 * (all at a single depth) that *might* be part of a motif, the char array of
	 * the pattern we're looking for, and the current position of interest within
	 * the pattern. expand() checks each child of all the nodes, and compares it to 
	 * the position of interest in the pattern. If it matches, it is stored to be
	 * returned. If it doesn't match, but the total mismatches is less than the
	 * maximum tolerated, it is also stored to be returned. If it doesn't match, 
	 * and the total mismatches now exceeds the maximum tolerated, it is dropped.
	 * 
	 * 
	 * @param current   STNodes from a single level of the Suffix tree that might
	 * 				    be part of a motif described by pattern.
	 * @param pattern	The character pattern we're searching for
	 * @param position	The position with the pattern relevant to this level of the
	 * 					suffix tree.
	 * @return			STNodes from the next level of the Suffix tree that might
	 * 					be part of a motif described by pattern.
	 */
    private Vector expand(Vector current, char c, int position) 
    {
        STNode n, child;
        int i,j;
        // if (debug) System.out.println("Weeder: expand(): " 
        //         + new String(pattern) );
        currMax = (int) (( error * position ) + 1 );
        // if (debug) System.out.println("Weeder: expand(): new maximum error for" +
        //         " position " + position + " is " + currMax 
        //         );
        // if (debug) System.out.println("Weeder: expand(): current has " + current.size() 
        //        + " candidate nodes..."  );
               
        Vector next = new Vector();
        Iterator it = current.iterator();  // for STNodes in set
        j = 0;
        // for all nodes 
        while (it.hasNext()){
            n = (STNode) it.next();
            if (debug) System.out.println("  Handling node " + j );
            // for each child of this node
            for( i = 0; i < STNode.ALPH_SIZE  ; i++){
                child = n.child[i];
                if ( child != null) {
                    if (debug) System.out.println("    Child letter is " + child.letter);
                    if (debug) System.out.println("    Pattern[" + position + "] letter is " 
                           + c);
                    // letter matches, add node to answer vector
                    if (child.letter == c){
                        child.mismatch = n.mismatch;
                        if (debug) System.out.println("      Letter matched--adding child to next...");
                        next.add(child);
                    }
                    // letter doesn't match, but error is low, so add it anyway
                    else if ( (n.mismatch + 1 ) <= this.currMax ) {
                        child.mismatch = n.mismatch + 1;
                        if (debug) System.out.println("      Letter didn't match-- but it's mismatch " 
                                + child.mismatch + " <= " + this.currMax 
                                + " , so add it to next...");
                        next.add(child);
                    } // end if-else-if
                    else 
                    {
                        child.mismatch = n.mismatch + 1;
                        if (debug) System.out.println("      Letter didn't match-- and it's mismatch " 
                                + child.mismatch + " > " + this.currMax 
                                + " , so drop.");
                        // do nothing...
                    }
              //      if (debug) System.out.println("    On to next child...");
                } // end if child not null
            } // end for all children of node
            // if (debug) System.out.println("  On to next node...");
            j++;
        } // end for all remaining nodes at this level
        if (debug) System.out.println("Weeder: expand(): position: " + position + " next: " + next.size() 
                 + " nodes "); 
        return next;  // vector contains all nodes at level i that meet criteria
    } // end expand()

    /**
     * Version of expand for PHASE TWO, where no restriction is made on the 
     * position of mismatches. 
     * 
     * @param current
     * @param pattern
     * @param position
     * @return
     */
    private Vector expandTwo(Vector current, char[] pattern, int position) 
    {
        STNode n, child;
        int i,j;
        if (debug) System.out.println("Weeder: expandTwo(): " 
                + new String(pattern) );
        
        /*
         * This is the key differnce between PHASE ONE and PHASE TWO 
         * Here, currMax is always simply the maximum tolerated mismatches for
         * the entire motif, a less stringent condition than PHASE ONE.
         */
        currMax = maxMismatch;
        
        if (debug) System.out.println("Weeder: expandTwo(): new maximum error for" +
                " position " + position + " is " + currMax 
                );
        if (debug) System.out.println("Weeder: expandTwo(): current has " + current.size() 
                + " candidate nodes..."  );
               
        Vector next = new Vector();
        Iterator it = current.iterator();  // for STNodes in set
        j = 0;
        // for all nodes 
        while (it.hasNext()){
            n = (STNode) it.next();
            if (debug) System.out.println("  Handling node " + j 
                    + " which is letter " + n.letter);
            // for each child of this node
            for( i = 0; i < STNode.ALPH_SIZE  ; i++){
                child = n.child[i];
                if ( child != null) {
                    if (debug) System.out.println("    Child letter is " + child.letter);
                    if (debug) System.out.println("    Pattern[" + position + "] letter is " 
                           + pattern[position]);
                    
                    // letter matches, add node to answer vector
                    if (child.letter == pattern[position]){
                        child.mismatch = n.mismatch;
                        if (debug) System.out.println("      Letter matched--adding child to next...");
                        next.add(child);
                    }
                    // letter doesn't match, but error is low, so add it anyway
                    else if ( (n.mismatch + 1 ) <= currMax ) {
                        child.mismatch = n.mismatch + 1;
                        if (debug) System.out.println("      Letter didn't match-- but it's mismatch " 
                                + child.mismatch + " <= " + currMax 
                                + " , so add it to next...");
                        next.add(child);
                    } // end if-else-if
                    else 
                    {
                        child.mismatch = n.mismatch + 1;
                        if (debug) System.out.println("      Letter didn't match-- and it's mismatch " 
                                + child.mismatch + " > " + currMax 
                                + " , so drop.");
                        // do nothing...
                    }
                    if (debug) System.out.println("    On to next child...");
                } // end if child not null
            } // end for all children of node
            if (debug) System.out.println("  On to next node...");
            j++;
        } // end for all remaining nodes at this level
        if (debug) System.out.println("Weeder: expandTwo(): next has " + next.size() 
                + " nodes"); 
        return next;  // vector contains all nodes at level i that meet criteria
    } // end expandTwo()
    
        
   
    public String toString() {
        String s = "";
        s += "Weeder:";
        s += "mlength: " + mlength;
        //		s += "mismatch: " + mismatch;
        //		s += "distinct: " + distinct;
        //		s += "maxerr: " + maxerr;
        return s;
    }

    
    
    /**
     * 
     * Motif finding program..
     * 
     * 
     * @param args
     */
    public static void main(String[] args) {

        String usage = "Usage: weeder [OPTIONS] -s <INFILE> " 
        		+ 	"\n  -l <INT>     motif length"
            	+ 	"\n  -d <INT>     max mismatch"
                + 	"\n  -q <INT>     minimum distinct sources"
                +	"\n  -s <INFILE>  input file (FASTA)"
                +	"\n  [-D]         debug" 
                + 	"\n  [-v]         verbose" 
                +	"\n  [-R]         exclude reverse complement"
                +	"\n  [-S <INT> ]  randomly choose # from samples"
                + 	"\nReport bugs to <john@saros.us>"                
                	
                ;

        int mlength = 8; 			// pattern length
        int mismatch = 3; 			// maximum mismatch in instance
        int distinct = 0; 			// distinct input sequences patter must appear in
        int considered = 0; 		// number of patterns considered e.g. 4^l
        String filename = "STDIN"; 	// filename with FASTA formatted sample sequences
        boolean revcomp = true; 	// consider reverse complement of samples?
        boolean debug = false;
        boolean verbose = false;
        int subset = 0;					// number of considered samples from input
        WSequenceIterator stream;

        // Get options
        //System.out.println("args.length :" + args.length);
        if ( args.length < 2 ) 
        {
            System.out.println(usage);
        	System.exit(0);
        }
        
        for (int i = 0; i < args.length; i++) {
            if (args[i].compareTo("-s") == 0)
                filename = args[i + 1];
            else if ( (args[i].compareTo("-h") == 0 ) || 
                         (args[i].compareTo("--help") == 0)  )
            {
                System.out.println(usage);
            	System.exit(0);
            }
            else if (args[i].compareTo("-l") == 0)
                mlength = Integer.valueOf(args[i + 1]).intValue();
            else if (args[i].compareTo("-d") == 0)
                mismatch = Integer.valueOf(args[i + 1]).intValue();
            else if (args[i].compareTo("-q") == 0)
                distinct = Integer.valueOf(args[i + 1]).intValue();
            else if (args[i].compareTo("-D") == 0) {
                debug = true;
                verbose = true;
            }
            else if (args[i].compareTo("-R") == 0) 
                revcomp = false;
            else if (args[i].compareTo("-v") == 0) 
                verbose = true;
            else if ( args[i].compareTo("-S") == 0)
                subset = Integer.valueOf(args[i + 1]).intValue();
            
        }

        // make a pair of suffix trees
        SuffTree st = new SuffTree();
        
        //st.debug = debug;
        st.verbose = verbose;
        
        Vector seqs = new Vector();
        
        // Set up sequence iterator
        BufferedReader br;
        try {
            if (filename.compareTo("STDIN") != 0) {
                br = new BufferedReader(new FileReader(filename));
            }
            else {
                br = new BufferedReader(new InputStreamReader(System.in));
           }
           stream = WSeqIOTools.readFastaDNA(br);
           
           Vector sequences = new Vector();
           while ( stream.hasNext()) {
               WSequence seq = stream.nextSequence();
               sequences.add(seq);
               
           }
                                
           // Select random sequences if -S was specified
           // otherwise build suffix tree from all
           
           int toTake = 0;
           if ( subset > 0)
               toTake = subset;
           else
               toTake = sequences.size();
           
           Random rand = new Random();
                    
           while (toTake > 0 ) {
                try {
                    // generate a random index between 0 and sequences.size()
                        
                    int index = rand.nextInt(sequences.size());
                    // pull that sequence out of the vector
                  
                    WSequence seq = ( WSequence ) sequences.get(index);
                    sequences.remove(seq);
                    
                    if (verbose)
                            System.out.println("Weeder: Adding sequence Id: " + seq.getName());
                        if (revcomp) {
                            st.addSequenceAndRC(seq);
                       }
                        else {
                            st.addSequence(seq);
                            
                        }
                        toTake--;
                } catch (Exception e) {
                    System.out.println("Weeder: ERROR: Problem reading sequence...");
                    // catch bioexception
                } // end try-catch
            } // end for all sequences
        } 
        catch (FileNotFoundException fnfe) 
        {
            System.out.println("Weeder: ERROR: No sequence file(s) found...");
            System.out.println(usage);
            System.exit(0);
        }

        if ( verbose) System.out.println("Weeder: Created suffix tree with "
                + STNode.numNodes + " nodes.");
        //if ( debug ) st.printTree();
               
        if ( distinct < 2 ) distinct = st.numSources();
        
        if (verbose) {
            System.out.println("Weeder: filename = " + filename);
            System.out.println("Weeder: motif length = " + mlength);
            System.out.println("Weeder: allowed mismatches = " + mismatch);
            System.out.println("Weeder: minimum distinct source sequences = " + distinct);
        }

        Weeder w = new Weeder(st);
        w.debug = debug;
        w.verbose = verbose;
               
        Vector v = w.runSearch(mlength, mismatch, distinct);
        if ( (verbose) && ( v.size() < 1) ) System.out.println("Weeder: No motifs found.");
        
        Iterator it = v.iterator();
        while ( it.hasNext() ) {
        	WeederMotif wm = (WeederMotif) it.next();
        	System.out.print(wm.toString());
        }
    } // end main
} // end class Weeder
