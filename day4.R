#1. 거래 데이터 특징 파악
#2. 데이터 사이의 연관성 찾기
#3. 패턴 식별
#=> 연관규칙

# 연관 규칙 응용 분야
# - 장바구니 분석
# - DNA 패턴, 염기서열 검색
# - 사기성 결제 파악, 보험 이용 구매 또는 의료비 청구 패턴
# - 고객 서비스 중단, 상품 변경시 선행되는 행동의 조합.

#장바구니 분석 -> 연관규칙(아이템 집합 사이의 관계 패턴) 모음
# 표현식 : {젤리, 우유, 버터} -> {빵} // left-hand-side {조건} -> right-hand-side{조건 만족시 기대되는 결과} {LHS} -> {RHS}
# 데이터 속에 숨어있는 "지식 발견 "

#apriori Algorithm
#==> 작은 데이터셋으로는 유용하지 않다.
# -> 비논리적인 결론이 도출될 가능성이 있다.("맹신하면 안된다!")

#강한규칙: 높은 신뢰도와 지지도를 갖는 규칙
#아프리오리 알고리즘의 원칙 : 자주 구매되는 아이템집합의 부분집합 또는 자주 구매된다는 것.

#A의 지지도 : 0.01이라면,
#A상품을 포함하는 아이템 집합의 지지도는 0.01보다 클수 없다. 
#=> 지지도가 현저하게 낮은 아이템의 경우에는, 해당 아이템을 포함하는 모든 지지도가 현저하게 낮다고 볼 수 있음.
# 따라서, 이 아이템을 포함하는 모든 아이템 집합은 계산에서 제외 
# -> "아프리오리 알고리즘의 핵심"

#Association Rules
install.packages("arules")
library(arules)
groceries<-read.transactions("R-programming/190430Data/groceries.csv", sep=",") 
# transaction:: 희소행렬을 생산함.(item이 있는지 없는지를 표현)
# memory 낭비가 발생.

groceries #(9835 x 169)인 희소행렬 형태.
summary(groceries)

inspect(groceries[1:5])
itemFrequency(groceries[,1:3]) #지지도

itemFrequencyPlot(groceries, support=0.1)
#10개의 item이 최소 지지도인 0.1을 넘겼다.
#최소 지지도를 만족하는 아이템에 대한 지지도 시각화.

itemFrequencyPlot(groceries,topN=20)
#지지도 기반 내림차순, 상위 20개.(topN=20)

image(groceries[1:100])
#희소행렬 ( 1행 ~ 5행까지 출력.)

image(sample(groceries,100))
#임의로 100개의 거래데이터 출력

apriori(groceries)
# 최소 지지도 임계치 설정?
# 고려해야할 점 : 최소 거래 건수 /
# 하루에 최소 2번 거래가 존재해야 "나에게 있어서 이 아이템에 대한 연관규칙 생성이 의미가 있다"라고 전제.
# 지지도 : 60/10000 =-> 0.006 지지도 이상.
# 지지도를 너무 낮게 설정해두면 너무 많은 아이템이 설정된다.
# 따라서 , 신뢰도를 함께 사용해줘야 한다.
# if 신뢰도가 낮으면,
# C(볼펜 -> 맥주) = s(볼펜, 맥주)/S(볼펜) = 0.25
# minlen : 2로 설정, 최소 2개 이상의 아이템을 갖는 규칙을 생성.

grocery_rules<-apriori(groceries, parameter = list(support=0.006, confidence=0.25, minlen=2))
#support: 전체 10000여건 중 하루 2번이상 구매가 이뤄진 지지도, --> 60/10000=0.006
#confidence : 신뢰도가 0.25이상.

inspect(grocery_rules[1:10])

summary(grocery_rules)
#lift 향상도: 아이템 x구매가 되었을때 아이템 y가 어떤 확률과 구매될것인가(-> 분자)를
# y에 대한 구매 확률(->분모)과 비교해서 측정한 척도.
#lift(x->y)=c(x->y)/s(y) = s(x,y)/( s(x)*s(y) ) = ((x,y)가 나타난 횟수)*전체 거래횟수/ (x가 나타난 횟수* y가 나타난 횟수)


#향상도(lift)값은 1보다 큰 경우 : 두 아이템이 함께 구매한것이 우연이 아니다(연관이 있다.)
inspect(sort(grocery_rules, by="confidence")[1:5])
inspect(sort(grocery_rules, by="lift")[1:5])

# berries 구매시 어떤 상품이 많이 구매 되었는지 확인.
#subset():: 규칙-> 하위규칙
berryrules<-subset(grocery_rules, items %in% "berries")
inspect(berryrules)

byrules<-subset(grocery_rules, items %in% c("berries",'yogurt')) #berries나 yogurt가 들어있는 subset이 모두 출력됨.
#연산자 "in"은 규칙에서 아이템을 최소 1개 발견했을시 추출
inspect(byrules)

#부분매칭
fruitrules<-subset(grocery_rules, items %pin% c("fruit")) #"fruit"라는 단어가 포함된 아이템을 모두 출력
# 연산자 "pin"은 규칙에서 해당 이름이 포함된 아이템을 모두 추출.
inspect(fruitrules)

#완전매칭 : 모든 아이템이 반드시 존재해야한다.
by2rules<-subset(grocery_rules, items %ain% c("berries",'yogurt')) #berries나 yogurt가 들어있는 subset이 모두 출력됨.
inspect(by2rules)

#연관규칙을 파일로 저장.
write(grocery_rules, file="R-programming/groceryrules.csv", sep=",", row.names=FALSE)



teens<-read.csv("R-programming/190430Data/snsdata.csv")
str(teens)

table(teens$gender, useNA='ifany')
summary(teens$age)
#고등학생 : 13세 이상 ~ 20세 미만
teens$age<-ifelse(teens$age>=13 & teens$age<20, teens$age, NA)
summary(teens$age)

teens$female<-ifelse(teens$gender=='F' & !is.na(teens$gender),1 , 0 )
table(teens$female)

teens$no_gender<-ifelse(is.na(teens$gender),1,0)
table(teens$no_gender)

table(teens$female)
table(teens$gender, useNA='ifany')
table(teens$no_gender)


mean(teens$age,na.rm=TRUE)

#각 졸업년도에 대한 age의 평균
aggregate(data=teens,age~gradyear,FUN="mean",na.rm=TRUE)
#gradyear컬럼으로 그룹핑을 한 뒤에 age컬럼에서 na를 제외한 값들의 mean을 구함.


#ave_age : gradyear 별로 age에 대한 평균을 저장.
ave_age<-ave(teens$age, teens$gradyear, FUN=function(x) mean(x,na.rm=TRUE))
ave_age

#age중에 na값이 있으면 졸업년도 별 평균 나이로 바꿈.
teens$age<-ifelse(is.na(teens$age), ave_age, teens$age)x

summary(teens$age)

library(stats) #클러스터링 관련 함수가 있는 패키지
str(teens)

interests<-teens[5:40]


#표준화 작업
#scale():: z점수 표준화=> 평균:0, 표준편차:1
interests_z<-as.data.frame(lapply(interests,scale)) #interest 데이터에 scale함수를 적용해라.
#lapply() :: 행렬(리스트로 리턴) => 여기서는 as.data.frame을 씌워서 데이터프레임으로 변환시킴.
set.seed(2345) #난수 설정.
teen_clusters<-kmeans(interests_z,5) #5개의 cluster 생성
teen_clusters

#데이터 차원 : 26차원(basketball, football, ... , drugs)
# 36차원 공간의 점(30000개)이 5개의 그룹으로 묶임.
# 각 그룹마다 centroid 존재(5개)

teen_clusters$centers #중심점

#다양한 신문사 -> 신문기사 스크래핑(10년)
# -> 정치/사회면에서 형태소 분리 -> 자주사용된 단어 추출
# 좌편향/우편향 판단 가능.
teens$cluster<-teen_clusters$cluster
teens$cluster #어느 클러스터에 속해있는지를 확인.
teens[1:5,c("cluster",'gender','age','friends')]
aggregate( data=teens,  age~cluster  ,mean )

#여성데이터만 가지고, 각 그룹에 속하는 여성의 비율
teens$female

aggregate(data=teens, female~cluster, FUN=mean)

#각 그룹에 대한 친구들의 평균
aggregate(data=teens, friends~cluster, mean)

















