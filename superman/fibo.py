#num = int(input("Enter number"))
num=10
first=0
second=1
next=0

while (num > 0):
    print(first)
    next=first+second
    num = num - 1
    first = second
    second = next

#first 0 1 1 2
#second 1 1 2 3
#next 1 2 3 5