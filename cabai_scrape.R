message('Loading Packages')
library(rvest)
library(tidyverse)
library(mongolite)

message('Scraping Data')
url<-"https://simhp.purbalinggakab.go.id/kategori/Cabai3"
cabai<-read_html(url)
cabai2<-cabai %>% html_nodes(".block2-txt") %>% html_text2()
cabai3<-as.list(strsplit(cabai2, "\n"))
cabai4<-rbind(as.vector(cabai3[[1]]),as.vector(cabai3[[2]]),as.vector(cabai3[[3]]))
cabai4<-as.data.frame(cabai4)
colnames(cabai4)<-c("Jenis","Harga","Tanggal_Update","Status")
cabai4$Harga<-as.numeric(gsub("\\D","",cabai4$Harga))

#mongodb
message('Input Data to MongoDB Atlas')
atlas_conn <- mongo(
  collection = Sys.getenv("ATLAS_COLLECTION"),
  db         = Sys.getenv("ATLAS_DB"),
  url        = Sys.getenv("ATLAS_URL")
)

atlas_conn$insert(cabai4)
rm(atlas_conn)