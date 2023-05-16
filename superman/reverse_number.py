num=1234567
dig=0
rev=0
print(num)

while(num>0):
    dig=num%10
    rev=rev*10+dig
    num=num//10

print(rev)