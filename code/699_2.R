test
length(row.names(test))

a=test[1,]
b=test[5,]
d=b[test[1,]>2];d
length(d[b[test[1,]>2]>2])

 ######first step to get the denominator
type1=""
for(i in 1:length(row.names(test1)))
{
  a=test1[i,]
  type1[i]=length(a[test1[i,]>0.0826])
}
type1
max(type1)
#####second step to get the numerator
Ud=0.0222
T_= 1
type2=""
for(i in 1:(length(row.names(test1))-T_))
{
  q=test1[i+T_,]
   o=q[test1[i,]>Ud]>Ud
  type2[i]=length(which(o=='TRUE')) 
}
type2
length(type2)
max(type2)
