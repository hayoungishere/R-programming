basic_url<-"http://news.donga.com/search?query=%ED%99%98%EC%9C%A8&check_news=1&more=1&sorting=1&search_date=1&v1=&v2=&range=1&p="

urls<-NULL

paste0("abc","1")

for(x in 0:5){
  y=x*15+1
  urls[x+1]<-paste0(basic_url, y)
}

#install.packages("rvest")
library(rvest)

html<-read_html(urls[1])
html2<-html_nodes(html, ".searchCont")
#클래스는 앞에 점(.)을 찍고 id는 앞에 해시태그(#)를 붙여준다.
html2

html3<-html_nodes(html2, ".txt")
html3

html3<-html_nodes(html3, 'a')
html3

links<-html_attr(html3, "href")
links


html5<-read_html(links[2])
html6<-html_nodes(html5, ".article_txt")


html_text(html6)


for(link in links){
  addr<-read_html(link)
  article<-html_nodes(addr, ".article_txt")
  txt<-html_text(article)
  txt<-str_extract_all(txt,"[가-힣]")
  print(txt)
  print("============================================================================================================================")
}

install.packages("stringr")
library(stringr)

str_extract_all("123abc가나다이힌힌순신,.,!?#$%","[가-힣]")



