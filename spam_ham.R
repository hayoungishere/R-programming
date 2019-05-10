sms_raw<-read.csv("R-programming/Data/sms_spam_ansi.txt", stringsAsFactors = FALSE)
sms_raw
str(sms_raw)

sms_raw$type

sms_raw$type<-factor(sms_raw$type)

table(sms_raw$type)

# tm(text mining): R에서 텍스트 전처리를 위한 패키지
#install.packages("tm")

library(tm)

# 자연어 처리의 1단계 : 코퍼스(말뭉치) 생성 => VCorpus를 사용하면 됨

#Source 객체로 sms_raw$text를 만들어서 VCorpus에 전달.
sms_corpus<-VCorpus(VectorSource(sms_raw$text))

#Text를 가지고 Corpus를 생성하기 위해서는 
#VectorSource Object로 만든 후에 작업을 수행 해야함.

inspect(sms_corpus[1:2])

#type : VCorpus -> Char 로 변환해야만 내용을 확인할수 있다.
as.character(sms_corpus[[4]])

#만약, 여러개의 문서들을 한번에 타입을 변환하려면 
# lapply() 를 사용하면됨. => 변환되어진 결과가 list로 나온다

lapply(sms_corpus[1:5], as.character)

# 텍스트 분석
# 1) 메시지 -> 단어 단위로 분리
#   * 점 제거
#   * "hi", "Hi", "HI", ... => 동일한 단어로 변환(대소문자 -> 소문자 or 대문자)
#   * 오늘은 일괄적으로 소문자로 변환하겠다.

sms_corpus_clean<-tm_map(sms_corpus, content_transformer(tolower))
#tm_map( Corpus, 적용할 함수)

lapply(sms_corpus_clean[1:5], as.character)



# 2) 숫자는 모두 제거
as.character(sms_corpus[[4]])

sms_corpus_clean<-tm_map(sms_corpus_clean, removeNumbers)

as.character(sms_corpus_clean[[4]])

# 3) 불용어 제거
stopwords()

sms_corpus_clean<-tm_map(sms_corpus_clean, removeWords, stopwords())
#tm_map( Corpus, removeWords, 제거할 단어)

# 4) 구두점 제거
sms_corpus_clean<-tm_map(sms_corpus_clean, removePunctuation)

removePunctuation("hi.... hello")

# 5) wordStem함수 : 어근 추출
# ex. learn, learned, learning, ... => learn
#install.packages("SnowballC")
library(SnowballC)

wordStem(c("learn", "learned", "learning", 'learns'))

#tm 내부에서 wordStem을 사용하려면, stemDocument()를 이용해서 변환시켜줘야됨.

sms_corpus_clean<-tm_map(sms_corpus_clean, stemDocument)

as.character(sms_corpus_clean[[5]])

# 6) 추가 여백 제거
sms_corpus_clean<-tm_map(sms_corpus_clean,stripWhitespace)

lapply(sms_corpus_clean[1:10], as.character)


# 7) 텍스트 문서를 단어로 나누기 (토큰화)
sms_dtm<-DocumentTermMatrix(sms_corpus_clean)
sms_dtm

# 8) sms_dtm을 훈련용/ 테스트용으로 분리(1~4169 , 4179~끝)
sms_dtm_train<-sms_dtm[1:4196,]
sms_dtm_test<-sms_dtm[4197:5559,]

sms_train_labels<-sms_raw[1:4196,]$type
sms_test_labels<-sms_raw[4197:5559,]$type

# 1. sms_dtm_train, sms_train_labels를 가지고 모델 생성
# 2. sms_dtm_test, sms_test_labels를 가지고 모델 평가
# 3. 1번에서 만든 모델에 sms_dtm_test를 입력하면 예측결과가 생성됨.
#   이 예측 결과와 sms_test_lables를 비교해서 모델 평가를 진행함

table(sms_train_labels)
table(sms_test_labels)

prop.table(table(sms_train_labels)) #비율을 반환

#install.packages("wordcloud")
library(wordcloud)

wordcloud(sms_corpus_clean, min.freq = 50, random.order = FALSE, colors = brewer.pal(5, "Dark2"))


spam<-subset(sms_raw,type=="spam")
str(spam)
ham<-subset(sms_raw,type=="ham")
str(ham)

wordcloud(spam$text, max.words = 50, scale = c(5,0.5), random.order =  FALSE, colors = brewer.pal(5, "Dark2"))
wordcloud(ham$text, max.words = 50, scale = c(5,0.5), random.order =  FALSE, colors = brewer.pal(5, "Dark2"))

# 희소 행렬을 나이브 베이즈 분류기를 훈련시키기 위해 사용하는 데이터구조로 변환

findFreqTerms(sms_dtm_train,50)
# 자주 등장하는 단어를 검색하는 함수, 최소 등장 횟수 n을 같이 전달.

sms_freq_words<-findFreqTerms(sms_dtm_train,5) #최소 5번 이상 등장한 단어들 저장
str(sms_freq_words)

sms_dtm_freq_train<-sms_dtm_train[ ,sms_freq_words]
sms_dtm_freq_train

sms_dtm_freq_test<-sms_dtm_test[ ,sms_freq_words]
sms_dtm_freq_test

#나이브 베이즈 분류기는 범주형 특징으로 된 데이터에 대해서 트레이닝

convert_counts<-function(x){
  #단어의 빈도수가 0이면 "No", 0보다 크면 "Yes"로 치환
  x<-ifelse(x>0, "Yes", "No")
}

sms_train<-apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)
sms_test<-apply(sms_dtm_freq_test, MARGIN = 2, convert_counts)

sms_train


#베이즈 이론 기반의 나이브 베이즈 필터기 생성
#install.packages("e1071")
library(e1071)

sms_classifier<-naiveBayes(sms_train,sms_train_labels)

#모델 평가
sms_test_pred<-predict(sms_classifier, sms_test)
sms_test_pred


#모델 정확도 계산
#install.packages("gmodels")
library(gmodels)

CrossTable(sms_test_pred, sms_test_labels, dnn=c("predicted", "actual"), prop.chisq = FALSE, prop.t=FALSE, prop.r = FALSE)




sms_classifier2<-naiveBayes(sms_train,sms_train_labels, laplace = 1)
sms_test_pred2<-predict(sms_classifier2, sms_test)
CrossTable(sms_test_pred2, sms_test_labels, dnn=c("predicted", "actual"), prop.chisq = FALSE, prop.t=FALSE, prop.r = FALSE)


























































