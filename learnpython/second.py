# second program
def is_even(number):
    if number % 2 == 0:
        return True
    else:
       return False

mynumbers = [ 4, 8, 15, 16, 23, 42] 
for number in mynumbers:
    if is_even(number):
        print("%d is even!" % number)
    else:
       print("%d is odd!" % number)
print("We processed %d numbers." % len(mynumbers) )
