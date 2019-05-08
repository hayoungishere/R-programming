sms_raw<-read.csv("R-programming/Data/sms_spam_ansi.txt", stringsAsFactors = FALSE)
sms_raw
str(sms_raw)

sms_raw$type

sms_raw$type<-factor(sms_raw$type)

table(sms_raw$type)

# tm(text mining): R에서 텍스트 전처리를 위한 패키지
install.packages("tm")

library(tm)

# 자연어 처리의 1단계 : 코퍼스(말뭉치) 생성 => VCorpus를 사용하면 됨

#Source 객체로 sms_raw$text를 만들어서 VCorpus에 전달.
sms_corpus<-Corpus(VectorSource(sms_raw$text))

#Text를 가지고 Corpus를 생성하기 위해서는 
#VectorSource Object로 만든 후에 작업을 수행 해야함.

inspect(sms_corpus[1:2])















































































