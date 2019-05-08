f<-function(x){
#  print(x+1)
  return(x*2)
}

res<-f(3)
print(res)

head(iris)

library(help="datasets")
str(Titanic)
AirPassengers

?cars

x<-read.csv("R-programming/a.csv")
x

x<-read.csv("R-programming/b.csv", header = FALSE) #heade가 없다는 걸 명시해줌.
x

names(x)<-c("id",'name','score') #header추가
str(x)

x$name<-as.character(x$name)
str(x)

x<-read.csv("R-programming/a.csv", stringsAsFactors = FALSE)
x
str(x)



x<-read.csv("R-programming/c.csv",na.strings = c("unknown",'모름','몰라'))
x
str(x)

is.na(x$score)
x
write(x,"R-programming/d.csv",row.names=TRUE)

x<-1:5
y<-6:10
x


#두 벡터를 객체로 저장하겠다.
save(x,y,file="R-programming/xy.RData")


ls()
x
y
load("R-programming/xy.Rdata")
x

x<-cbind(c(1,2,3),c("a",'b','c'))
class(x) #두개의 벡터를 bind했기 떄문에 matrix가 됨.
x

#숫자 + 문자 bind를 하면 숫자가 문자형으로 변경됨,.
#숫자 > 문자

d<-matrix(1:9, ncol=3)
d
apply(d,1,sum)
apply(d,2,sum)

cars
#speed와 dist열 합계 출력
apply(cars,2,sum)

str(iris)

apply(iris[,-5],2,sum) #1-4번 컬럼까지만 sum함수 적용
apply(iris[,c(1,4)],2,sum) #1-4번 컬럼까지만 sum함수 적용
apply(iris[,-5],2,max)
apply(iris[,-5],2,sd)
apply(iris[,-5],2,var)

colSums(iris[,-5])
summary(iris)

quantile(iris$Sepal.Length, seq(0,1,by=0.05)) #5%씩 증가.

install.packages("mlbench")

data("Ozone")
str(Ozone)

plot(Ozone$V8, Ozone$V9, xlab = "Temp1", ylab="Temp2", main="Ozone", pch="+",col="#ff0000",
     xlim=c(0,100))

help("plot")

plot(cars,type="o")

#ggplot2 : 시각화 패키지.(3단계로 구성)
#1단계 : 배경설정(축)
#2단계 : 그래프 추가(점, 막대, 선)
#3단계 : 설정 추가(축범위, 색)

#산점도 : 2차원 데이터
install.packages("ggplot2")
library(ggplot2)


#1단계: 배경설정.
ggplot(data=mpg,aes(x=displ,y=hwy))
str(mpg)
#2단계 : 데이터 추가
ggplot(data=mpg,aes(x=displ,y=hwy))+geom_point()
#3단계 : 설정 추가
ggplot(data=mpg,aes(x=displ,y=hwy))+
  geom_point()+
  xlim(3,6)+
  ylim(10,30)


str(mpg)

#x축은 cty, y축은 hwy로 산점도 그래프 그리기

ggplot(data=mpg,aes(x=cty, y=hwy))+
  geom_point()

str(midwest)

ggplot(data=midwest,aes(x=poptotal, y=popasian))+
  geom_point()+
  xlim(0,500000)+
  ylim(0,10000)

#5*10의 5승 = 5e+05
#집단간 차이 표현 :막대그래프
install.packages("dplyr")
library(dplyr)


str(mpg)

#ctrl+shift+m
#pipeline(%>%) : 연결할때 사용. 
#mpg에서 group_by를 한 다음에 summarise를 해라.
#(연속적으로 일을 처리하고 싶을 때 사용.)
df_mpg<-mpg %>% 
  group_by(drv) %>% 
  summarise(mean_hwy=mean(hwy))

#크기순으로 정렬(오름차순)
ggplot(data=df_mpg, aes(x=reorder(drv,mean_hwy), y=mean_hwy))+
  geom_col()
#크기순으로 정렬(내림차순)
ggplot(data=df_mpg, aes(x=reorder(drv,-mean_hwy), y=mean_hwy))+
  geom_col()


#빈도 막대그래프
mpg
ggplot(data=mpg,aes(x=hwy))+geom_bar()

#geom_col(): 데이터 요약 -> 평균표를 그래프로 생성(평균)
#geom_bar() : 원 자료를 그래프로 생성(빈도)

mpg
ggplot(data=mpg, aes(x=class))+geom_bar()


exam<-read.csv("R-programming/Data/csv_exam.csv")

exam %>% filter(class!=1)
exam %>% filter(math>50)

#1반이면서 수학점수가 50점 이상인 데이터 찾기
exam %>% filter(class==1 & math>=50)

#1반이거나 수학점수가 50점이상인 데이터.
exam %>% filter(class==1 | math>=50)

#1,3,5반 추출
exam %>% filter(class%%2==1)
exam %>%  filter(class %in% c(1,3,5))

class1 <- exam %>% filter(class==1)
class2<- exam %>% filter(class==2)

#1반과 2반의 평균 수학점수
mean(class1$math)
mean(class2$math)

exam %>% select(math)
exam %>% select(-math)
exam %>% select(class, english)

#class가 1반인 데이터를 추출한 다음
#english만 추출
exam %>% 
  filter(class==1) %>% 
  select(english)

#id, math만 추출해서 앞에 10개 행만 추출
exam %>% 
  select(id,math) %>% 
  head(10)

#sorting(default order: asc)
exam %>% arrange(math)

#sorting : ordered by desc
exam %>% arrange(desc(math))

#1차 정렬기준=> class는 내림차순으로 , 2차 정렬기준 => math는 오름차순으로
exam %>% arrange(desc(class),math)

exam %>% 
  mutate(total=math+english+science,
         mean=round(total/3,2))

#ifelse(조건, 참, 거짓)
#과학점수가 60점 이상이면 pass, 미만이면 fail을 나타내는 test라는 컬럼 추가

exam %>% 
  mutate(test=ifelse(science>=60,"pass",'fail'))



exam %>% 
  mutate(total=math+english+science) %>% 
  arrange(desc(total)) %>% 
  head()

#반별로 요약(summarize)
#전체 math평균
exam %>% summarise(mean_math=mean(math))

#class별로 math 평균구하기
exam %>% 
  group_by(class) %>% 
  summarise(mean_math=mean(math))


#class별로 math 평균, 합계, 중앙값, 학생수 구하기
exam %>% 
  group_by(class) %>% 
  summarise(mean_math=mean(math),
            sum_math=sum(math),
            median_math=median(math),
            count=n()
            )

#n(): 빈도

#mpg :: 1차 그룹화기준(manufacturer) , 2차 그룹화 기준(drv)한 뒤에 cty값의 평균

mpg %>% 
  group_by(manufacturer,drv) %>% #회사별, 구동방식별 그룹화가 됨됨 
  summarise(mean_cty=mean(cty)) 

#회사별로 "suv"자동차의 도시 및 고속도로 통합 연비 평균을 구해서 내림차순 정렬하고, 
#1위~5위까지 출력.
mpg
mpg %>% 
  group_by(manufacturer) %>%
  filter(class=="suv") %>% 
  mutate(tot=(cty+hwy)/2) %>% 
  summarise(mean_tot=mean(tot)) %>% 
  arrange(desc(mean_tot)) %>% 
  head(5)

test1<-data.frame(id=c(1,2,3), mid=c(60,80,70))
test2<-data.frame(id=c(1,2,3), final=c(30,40,50))
#id 기준으로 합치기
total<-left_join(test1, test2, by="id")
total



#exam에 teacher 컬럼 추가, 각 반에 담임 교사가 모두 입력.
name<-data.frame(class=c(1,2,3,4,5), teacher=c("kim","lee",'park','choi','jung'))
name
exam

exam_new<-left_join(exam,name,by="class")
exam_new

test1<-data.frame(id=c(1,2,3), mid=c(60,80,70))
test2<-data.frame(id=c(4,5,6), mid=c(30,40,50))
test_all<-bind_rows(test1,test2)

#결측치 정제
df<-data.frame(sex=c("M","F",NA,"M","F"),
               score=c(5,4,3,4,NA))
df
is.na(df)

#table() :: 결측치 빈도
table(is.na(df$score))

mean(df$score)
sum(df$score)
#NA가 포함되어 있는 데이터의 연산 결과는 NA로 나옴.

df %>%
  filter(is.na(score))

df_nomiss<-df %>% 
  filter(!is.na(score))
df_nomiss

mean(df_nomiss$score)
sum(df_nomiss$score)

#df에서 score와 sex 결측치를 제외하고 출력
df_clear<-df %>% 
  filter(!is.na(score) & !is.na(sex))
df_clear

na.omit(df) #위와 같은 결과를 가짐.
mean(df$score, na.rm=T) # na는 제외하고 평균
sum(df$score,na.rm=T) #na는 제외하고 합

exam<-read.csv("R-programming/Data/csv_exam.csv")
exam

#3,8,15번의 math를 NA로 만들기.
exam[c(3,8,15),"math"]<-NA
exam

#math 평균
exam %>% 
  summarise(mean_math=mean(math))

exam %>% 
  summarise(mean_math=mean(math, na.rm = T))


#결측치 제외한 math 평균, 합계, 중앙값 출력
exam %>% 
  summarise(mean_math=mean(math, na.rm=T), 
            sum_math=sum(math,na.rm = T), 
            median_math=median(math,na.rm=T))


#연습문제. 
# 평균값으로 결측값(3,8,15번의 math값)을 대체하시오.

exam$math<-ifelse(is.na(exam$math),mean(math, na.rm=T), exam$math)
exam



























