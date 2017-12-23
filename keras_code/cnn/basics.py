def double(x):
    """this is where you put an optional docstring
    that explains what the function does.
    for example, this function multiplies its input by 2"""
    return x * 2

def apply_to_one(f):
    """calls the function f with 1 as its argument"""
    return f(100)
X  = apply_to_one(double)
Y  = apply_to_one(lambda X:X+4)
print (Y)

def DoubleNum(x): return 2*x

d = DoubleNum(100)
print (d)

""" Lists"""
L=[2, 3, 4, "Yeman"]
print (len(L))
print (L[3])

if 1 in [1,3,4]:
    print ('Yes present')

print (type(L))

L.extend([1,3,100])
print (L)
L.append(100000)
x,_ = [200,1000]
print (x)
L[-2]='Brhane'
print (L)

""" Tuples"""

t = (2,4,5)
print ('type of t is ', type(t))

print('value of L[0] is %d',format(L[0]))

""" Dictionaries"""
NN = {"W":[1,2,3], "b":0}
if "W" in NN:print (NN["W"])
print (NN.get("W"))

X = NN.items()
print (type(X))

for ii in range(3):
    print (ii)




