stores<-read.csv(choose.files(),header = T)

data<-stores


# DESCRIPTIVE sTATISTICS

View(data)
summary(data)
names(data)
mean(data$TotalSales)
with(data,mean(TotalSales))
var(data$TotalSales)
quantile(data$TotalSales,c(.3,.6,.9))
quantile(data$TotalSales,probs = seq(0,1,0.2))
which.max(data$TotalSales)
data$Sales_rank<-rank(data$TotalSales,ties.method = 'first')
View(data)

describe(data)

# Ties.method specifies the method rank uses to break ties. 
# Suppose you have a vector c(1,2,3,3,4,5). It's obvious that 1 is first, and 2 is second. However,
# it's not clear what ranks should be assigned to the first and second 3s. 
# Ties.method determines how this is done. There are a few options:
#   
# average assigns each tied element the "average" rank. The ranks would therefore be 1, 2, 3.5, 3.5, 5, 6
# first lets the "earlier" entry "win", so the ranks are in numerical order (1,2,3,4,5,6)
# min assigns every tied element to the lowest rank, so you get 1,2,3,3,5,6 
# max does the opposite: tied elements get the highest rank (1,2,4,4,5,6)
# random breaks ties randomly, so you'd get either (1,2,3,4,5,6) or (1,2,4,3,5,6).

# FREQUENCY TABLES

# UNIVARIATE

s1<-table(stores$StoreType)
View(s1)
s2<-prop.table(s1)
View(s2)
s2<-prop.table(table(stores$StoreType))
View(s2)
rbind(s1,s2)
cbind(s1,s2)

# install.packages('gmodels',dependencies = T)
require(gmodels)

CrossTable(stores$StoreType)

# BIVARIATE

table(stores$StoreType,stores$Location)
prop.table(table(stores$StoreType,stores$Location))

CrossTable(stores$StoreType,stores$Location)
CrossTable(stores$StoreType,stores$Location,prop.r=F,prop.c=F,prop.chisq = F)

install.packages('vcd',dependencies = T)
require(vcd)

xtabs(~stores$Location+stores$StoreType)
xtabs(stores$TotalSales~stores$Location+stores$StoreType)
prop.table(xtabs(stores$TotalSales~stores$Location+stores$StoreType))


# SUMMARIZATON OF NUMERICAL VARIABLES

require(psych)
data.frame(stores)


# User Defined Function

mystatistics<-function(x){
  nmiss<-sum(is.na(x))
  a<-x[!is.na(x)]
  m<-mean(a)
  n<-length(a)
  s<-sd(a)
  v<-var(a)
  min<-min(a)
  q1<-quantile(a,.25)
  q3<-quantile(a,.75)
  max<-max(a)
  UL<-m+3*s
  LL<-m-3*s
  outlier_flag<-max>UL | min<LL
  
  return(c(n=n,nmiss=nmiss,outlier_flag=outlier_flag,mean=m,stdev=s,min=min,max=max,UL=UL,LL=LL))
}

mystats(stores$OperatingCost)
data_audit_report<-data.frame(t(apply(stores[6:15],2,mystatistics)))
View(data_audit_report)

