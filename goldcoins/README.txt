Standard  problem. 
------------------

You have 3 (or more) coins. One (and only one) of them is adulterated and is either heavier or lighter than normal. You also have a balance scale, with which you can weigh any number of coins at a time (typically the same number on either side). The balance thus tells you which coin (or group) is heavier, or lighter, than the other.

The objective is to determine which coin is bad, and whether it is heavy or light, with the fewest number of comparisons using the scale. 


# Some functions and definitions
Sets will be noted as capital letters. Elements in lowercase. 

For set X:
X.divide(<int>) returns <int> sets consisting of X evenly divided into <int> even groups. 
X.compare(Y)    returns status for X of SAME, HEAVY, or LIGHT as result of weighing the two groups.  
x.compare(y)    returns status for x of SAME, HEAVY, or LIGHT as result of weighing the two elements.
X.select(<int>) returns <int> elements of set randomly selected. 

badcoin = <element>
anomalytype = UNKNOWN, LIGHT, HEAVY  # how is the single coin different from the standards?
threshold = 6  # number of remaining undetermineds at which to switch to explicit strategy, for strategies that need it. 
t1, t2, t3  results of comparisons. tX.inverse() is opposite of state, e.g. HEAVY -> LIGHT, LIGHT -> HEAVY


Special cases for small N
------------------------------------

# N = 3
# Maximum comparisons = 2, Minimum comparisons = 2
U =  { a,b,c }

t = a.compare(b) 
if t == SAME:
    # a and b are standards, c is the bad
    badcoin = c
    anomaly = c.compare(a)    
else:    # c is the standard, either a is HEAVY or b is LIGHT
   t2 =  a.compare(c)
   if t2 == SAME:
       badcoin = b
       anomaly = t.inverse()
   else:
       badcoin = a
       anomaly = t


# N = 4 
# Maximum comparisons =   , Minimum comparisons = 



# N = 5



# N = 6



Brute force approach for large N
----------------------------------------

# START
# undetermined coins
U = { all coins }
# known standard coins
S = {} 
# anomaly type
AnomalyType = UNKNOWN

# divide unknown coins into 3 groups (ignore numbers not evenly divisible by 3 for now)
( A,B,C ) = U.divide(3)

if A.compare(B) == SAME:
    S = S + A + B
else:
    S = S + C

# This gives us some standards to use, from now on...
while U.length() > Threshold:
    C = S.select( U.length() )
    ( A, B ) = U.divide(2)
    if A.compare(C) == SAME:
         S = S + A 
    else:
         S = S + B 

   


  
