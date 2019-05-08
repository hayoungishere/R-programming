seq(1:100)
print("hi")

source("R-day1.R") #다른 파일에 있는 내용 실행 가능.

install.packages("randomForest")
library(help=randomForest)
x<-6
# 스칼라 : 길이가 1인 벡터
a<-3
b<-4.5
c<- a+b
c
d<-NA 
a+d #NA랑 연산하면 NA가 나옴
is.na(d)
e<-NULL

is.null(e)
is.na(e)
e<-NULL #Null 은 아직 초기화되지 못한 상태를 의미함.
e<-NA
if(1%%2==0){
  e<-TRUE
}else{
  e<-FALSE
}
print(e)

a<-'hi'
a<-"HELLO"


x<-c(1,2,3)
x

#factor: 범주형 자료형(성별, 학년...)
# -명목형 (값들 간 크기 비교가 불가능, ordered=False),
# -순서형(값들 간 크기 비교가 가능 , ordered=True)
# 수치형 (Numerical) : 범주형의 상반되는 자료형

sex<-factor('m',c("m",'f'))
sex

levels(sex)[1]
levels(sex)[2]

#레벨값을 변경하고자 할때
levels(sex)<-c("male",'female')
sex
a<-factor(c('m','m','f'), c("m",'f'))
#범주형(m,f), 데이터(m,m,f)
a[2]

b<-factor((c("m",'m','f')))
b

ordered("c",c("a",'b','c','d'))
factor("c",c('a','b','c','d','f'))

x<-c("1","2",3) #서로 다른 데이터 타입 -> 동일한 타입으로 자동변환환
x #x vector
x2<-c(1,2,3)
names(x2)<-c("a",'b','c')
x2[1]
x2[-1] #"-"는 특정자리의 요소를 제외하고 출력하라는 의미

x3<-c(10,20,30,40,50)
x3[-3]
x3[1:4]
x3[-1:-3]
x3[c(2,4)]
names(x3)<-c('a','b','c','d','e')
x3
x3[1]
x3['a']
names(x3)
names(x3)[4]
length(x3)
NROW(x3)

identical(c(1,2,3),c(1,3,2))
identical(c(1,2,3),c(1,2,3,3))

setequal(c(1,2,3),c(1,2,3,3)) #같은 집합인지 확인

data<-c(1,2,3,4,5,6,7)

"a" %in% c("a","b","c") #("a","b","c")벡터에 a가 있는지 확인.

x<-c(1,2,3)
x+1

y<-c(1,2,4)
x==y

c(1,2,3) != c(1,2,4)
x<-seq(3,7,2)
x
NROW(x)
1:3
1:NROW(x)

seq_along(x) #1부터 시작되는 수치 벡터를 x의 길이로 생성.

rep(1:2,3)

rep(1:5, times=3) #1부터 5까지 3번 반복
rep(1:5, each=3) #각각의 숫자를 3번씩 반봅
rep(1:5, times=2, each=3) #each 부터 수행되서, 각 숫자를 3번 반복한걸 2개 출력.

#리스트 : (키, 값)의 형태로 데이터를 저장, 파이썬의 딕셔너리와 바슷함.

(x<-list(name="foo", height=70)) #바깥쪽 소괄호는 print를 의미
a<-list(val=c(1,2,3))
b<-list(val=c(1,2,3,4))
x<-list(a,b)
x
a$val
x<-list(key1=a, key2=b) #list에 list를 넣음.
x$key1
x$key2

x$key1$val[2]
x<-list(name="foo", height=c(1,3,5))
x$height[3]

x[[2]][3]

#행렬 : 한가지 데이터 타입으로 구성된 데이터를
#2차원 (행, 열)으로 구성.

matrix(c(1:12)) #2차원 행렬.(12x1)
#c(1:9) #요소 9개가 일렬로 나열된 1차원 벡터


matrix(c(1:12),nrow=4) #2차원 행렬.(12x1)=> (4x3)
#저장방향 : 행증가(위-> 아래)


matrix(c(1:12),ncol=4) #2차원 행렬.(12x1) =>(3x4)
#저장방향 : 행증가(위->아래)

matrix(c(1:12),ncol=4, byrow=TRUE) #2차원 행렬.(12x1) -> (3x4)
#byrow=TRUE:: 저장방향 : 열증가(오른쪽-> 왼쪽)


matrix(c(1:12),ncol=4, byrow=TRUE, dimnames = list(c("r1","r2",'r3') ,c("c1",'c2','c3','c4') ))
#dimnames를 사용해서 행과 열의 이름을 지정해 줄 수 있다.
#list=(row names, col names)


x<-matrix(c(1:12),ncol=4)
dimnames(x)<-list(c("r1","r2",'r3') ,c("c1",'c2','c3','c4') )
x

x<-matrix(c(1:12),ncol=4)
rownames(x)<-c("r1",'r2','r3')
x


x<-matrix(c(1:12),ncol=4)
colnames(x)<-c("c1",'c2','c3','c4')
x
x[2:3,]
x[-2,]
x[c(1,3),2]

x["r2",]
x<-matrix(c(1:9), nrow = 3)
x/2 #벡터화 연산을 수행
x+x #행렬간 덧셈을 수행
x*x #행렬 간 곱셈(요소간, element wise product) != 행렬의 곱셈.
x%*%x #행렬의 곱셈
t(x) #전치 행렬.

#solve()를 사용하면 역행렬을 구할수 있다.
x<- matrix(c(1:4),ncol=2, byrow=TRUE)
x
solve(x)

dim(x)




x<-array(1:12, dim=c(2,2,3)) #dim(행,열, depth)
x[1,2,3]
x[1,,3]



d<-data.frame(x=c(1,2,3,4,5), y=c(2,4,6,8,10))
d
str(d) #str:: Note information
d$z<-c("a",'b','c','d','e')
d
str(d)

d<-data.frame(x=c(1,2,3,4,5), y=c(2,4,6,8,10), z=c("a",'b','c','d','e')) #dataframe을 만들때 문자열을 넣으면 factor로 저장함.
str(d)

d<-data.frame(x=c(1,2,3,4,5), y=c(2,4,6,8,10), z=c("a",'b','c','d','e'),stringsAsFactors = FALSE)
str(d)
class(d[, c("x")]) #class -> typeof와 같은 역할
typeof(d[, c("x")])
class(d[,'x',drop=FALSE])

d<-c(1:100)

head(d,10)
tail(d)
View(d)
x<-c(1,2)
class(x)
typeof(x)
x<-matrix(c(1,2))
class(x)
x

x<-data.frame(a=c(1,2))
class(x)
x
str(x)
class(1:5)
is.numeric(1:5)
is.character(c(a,b))
x<-c("a","b")
xf<-as.factor(x)
xf

x<-matrix(1:6, ncol=2)
dfx<-as.data.frame(x)
dfx

x<-as.matrix(dfx)
x
if(3>5){
 print("3 is bigger than 1") 
}else{
  print("3 is smaller than 1")
}

x<-c(1:10)
ifelse(x%%2==0, "짝수", "홀수")

for(i in 1:10){
  print(i)
}

i<-1
while(i<=5){
  print(i)
  i<-i+1
}

d<- data.frame(x=c(1:5), y=c("a","a","a","a","a"))
d
d[c(TRUE,TRUE,TRUE,TRUE,FALSE),]
d[d$x%%2==0,] #true인 행만 출력됨.

sum(c(1,2,3,NA))
sum(c(1,2,3,NA),na.rm = TRUE) #Na를 제외한 값이 계산됨.

x<-data.frame(a=c(1,2,3), b=c("a",NA,'c'), c=c("a",'b',NA))
x
na.fail(x) #x에 NA가 포함되어있으면 error를 발생시키는 함수
na.omit(x) #x에 NA가 포함되어 있으면 행을 제외시킴.
na.exclude(x) #x에 NA가 포함된 행을 제외.
na.pass(x)

df<-data.frame(x=1:5, y=seq(2,10,2))
df[3,2]<-NA
df
resid(lm(y~x, df, na.action = na.omit)) #lm : linear model(연속적인 값을 출력)
resid(lm(y~x, df, na.action = na.exclude))
print("********************************************************")














