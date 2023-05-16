#factorial
def funcThree():
    print('Three')

def funcTwo():
    funcThree()
    print('Two')

def funcOne():
    funcTwo()
    print('One')

funcOne()


#factorial with recursion
def factorial(n):
    if n == 1:
        return n
    return n * factorial(n-1)

print(factorial(10))


#factorial without recursion
num = 3
c=num-1
while(c>1):
    num = num * c
    c=c-1

print(num)