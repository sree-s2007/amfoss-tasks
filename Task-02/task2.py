## CODEFORCES CONTEST


T=int(input())
for i in range(T):
    s=0
    z=input()
    y=z.split()
    n=[int(a) for a in y]
    for j in n:
        s=s+j
    if s>=16:
        print("YES")
    else:
        print("NO")
        
        
## INSURANCE


 T=int(input())
for i in range (T):
    xy=input()
    s=xy.split()
    n=[int(a) for a in s]
    if n[0]>=n[1]:
        print(n[1])
    else:
        print (n[0])
 
        
   
   
## BIG HOTEL 

        
T= int(input())
for i in range(T):
    r=input()
    g=r.split()
    s=[int(a) for a in g]
    s1=(s[0]-1)//10
    s2=(s[1]-1)//10
    k=s1-s2
    k1=abs(k)
    print(k1)
    
## MINE GOLD


   T=int(input())
for i in range(T):
    z=input()
    y=z.split()
    n=[int(a) for a in y]
    if (n[0]+1)*n[2]>=n[1]:
        print("YES")
    else:
        print("NO") 
    
## ESCAPE FALSE ALARM


T=int(input())
for g in range(T):
    nx=input()
    z=nx.split()
    y=[int(a) for a in z]
    s=input()
    r=s.split()
    f=[int(a) for a in r]
    for i in range(y[0]):
        if f[i] == 1:
            if y[0]-(i+1) <= y[1]:
                print("YES")
            else:
                print("NO")
            break
    else:
        print("YES")
 
## REMOVE CARDS


T=int(input())
for i in range(T):
    N=int(input())
    a=input()
    s=a.split()
    z=[int(i) for i in s]
    maxfreq= max(z.count(x) for x in z)
    sol=N-maxfreq
    print(sol)
