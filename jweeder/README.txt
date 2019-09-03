WEEDER motif-finding algorithm implemented in Java.

CITIATION:
G.Pavesi, G.Mauri, G.Pesole. An Algorithm for Finding Signals of Unknown Length 
in Unaligned DNA Sequences.  Bioinformatics  17, S207-S214, 2001. 


mvn compile
mvn package
java -jar target/jweeder-1.0-SNAPSHOT-jar-with-dependencies.jar
Usage: weeder [OPTIONS] -s <INFILE> 
  -l <INT>     motif length
  -d <INT>     max mismatch
  -q <INT>     minimum distinct sources
  -s <INFILE>  input file (FASTA)
  [-D]         debug
  [-v]         verbose
  [-R]         exclude reverse complement
  [-S <INT> ]  randomly choose # from samples
Report bugs to <jhover@pobox.com>

java -jar target/jweeder-1.0-SNAPSHOT-jar-with-dependencies.jar -s src/main/resource/sample-s20-l15-d2.fa -l 15 -d 2

