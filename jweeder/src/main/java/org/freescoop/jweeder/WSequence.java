package org.freescoop.jweeder;



/**
 * Quick and dirty class to replace BioJava Sequence class for Weeder use.
 * 
 * @author jhover
 *
 */
public class WSequence {
    public static final int FASTA_LINELEN = 50;
    
    /*
	 * A = 65 -> 0 , C = 67 -> 1 , G = 71 -> 2 , T = 84 -> 3
	 * a = 97 -> 4 , c = 99 -> 5 , g = 103 -> 6 , t = 116 -> 7
	 * N = 78 -> 8
	 * 
	 */
    
       	public static final char comp_char[] = 
    	{ 
    	/*               ASCII char mappings 0 - 255		         */     
    	/*      	 0     1     2     3     4     5     6     7     8     9   */
    	/* 0 */ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*10+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*20+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*30+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*40+*/  	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*50+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*60+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'T' , 'X' , 'G' , 'X' , 'X' ,
    	/*70+*/ 	'X' , 'C' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'N' , 'X' ,
    	/*80+*/ 	'X' , 'X' , 'X' , 'X' , 'A' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*90+*/  	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 't' , 'X' , 'g' ,
    	/*100+*/ 	'X' , 'X' , 'X' , 'c' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*110+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'a' , 'X' , 'X' , 'X' ,
    	/*120+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*130+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*140+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*150+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*160+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*170+*/  	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*180+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*190+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*200+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*210+*/  	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*220+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*230+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*240+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' , 'X' ,
    	/*250+*/ 	'X' , 'X' , 'X' , 'X' , 'X' , 'X' 
    	}; 
    
      
    private String header;
    private String sequence;
   
    public WSequence() {
        
    }
    
    public void setName(String s) {
        header = s;
    }
    
    public String getName() {
       	return header;
    }
    
    public String seqString() {
        return sequence;
    }

    public String revCompString() {
        char[] strbuf = sequence.toCharArray();
        char[] rbuff = new char[sequence.length()];
        for ( int i = 0, j = ( sequence.length() -1 ); i < strbuf.length ; i++, j-- ) {
            rbuff[j] = comp_char[ (int) strbuf[i]];
        }
        return new String(rbuff);
    }
    
    public String getURN() {
        String s = "WSequence URN";
        return s;
    }
    
    public void setSeqString(String s){
        sequence = s;
     
    }
    
    public String getFastaSeq() {
       String s = ">" + this.header + "\n"; 
       for ( int i = 0; i < sequence.length() ; i++) {
           s += sequence.charAt(i);
           if ( ( i % FASTA_LINELEN == 0 ) && ( i != 0 ) )
               s += "\n";
       }
       return s;		
    }
    
    public static void main(String[] args) {
        WSequence ws = new WSequence();
        ws.header = "TEST_SEQUENCE";
        ws.sequence = "ACGGccTTaAAgAG";
        
        System.out.println("Header: " + ws.getName());
        System.out.println("Sequence: " + ws.seqString());
        System.out.println("FASTA:\n" + ws.getFastaSeq());
        System.out.println("Reverse Complement:" + ws.revCompString());
    }
    
    
}
