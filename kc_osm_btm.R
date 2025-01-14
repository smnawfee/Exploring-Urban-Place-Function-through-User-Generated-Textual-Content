---
  title: "BTM on KC_OSM tags"
author: "Shahreen Nawfee"
date: "12/11/2023"
---

  #install packages
install.packages('BTM')
install.packages('udpipe')
install.packages('textplot')
install.packages('ggraph')
install.packages('LDAvis')
install.packages('tidytext')
install.packages('topicdoc')


#call libraries--------------------------
library(tidytext)
library(tidyverse)
library(BTM)
library(textplot)
library(ggraph)

##Run btm on tag list for kc_osm---------------
#load data
kc_osm_dbscan_tag <- read.csv(
  "data/data_ohsome/kc_osm_dbscan_tag.csv")

#pre-process data
kc_osm_dbscan_tag$value   <- gsub("_", " ", kc_osm_dbscan_tag$value)

#tidytext library for tokenization
kc_osm_dbscan_tag2 <- kc_osm_dbscan_tag %>% 
  rename(doc_id = cluster,
         text = value
  )%>% 
  unnest_tokens(output = token, 
                text, 
                token = "words" )

#run btm model for kc
model_osm_kc <- BTM(kc_osm_dbscan_tag2, 
                    k = 10, 
                    iter = 2000,
                    detailed = TRUE)


#visualize the topicterms
plot(model_osm_kc, top_n = 10, 
     title = 'BTM for OSM tags',
     labels = paste(round(model_osm_kc$theta *100, 2), 
                    "%", sep = ""))


topicterms_osm <- terms(model_osm_kc, top_n = 10)

topic_prob_df <- as.data.frame(predict(model_osm_kc, 
                             newdata = kc_osm_dbscan_tag2, 
                             type = "sum_b")) %>%
                 mutate(Topic = names(.)[max.col(.)])

topic_prob_df$cluster = rownames(topic_prob_df)


write.csv(topic_prob_df, "data/data_ohsome/topic_prob_df_oct.csv")
