
#title: "BTM on wiki titles and summary"
#author: "Shahreen Nawfee"
#date: "21/04/2022"

#tidytext library for tokenization
library(tidytext)
library(tidyverse)
#library for btm model
library(BTM)
#visualize the topicterms
library(textplot)
library(ggraph)


##Run btm on title for kc_wiki---------------
wiki_dbscan_kc <- read.csv(
  "data/data_wiki_clustering/kc_wiki_dbscan_tag_oct.csv")

#some text pre-processing

#remove punctuation
wiki_dbscan_kc$page_title <- gsub(
  "_", " ", wiki_dbscan_kc$page_title)                                 

#remove stopwords
data("stop_words")
wiki_dbscan_kc <- wiki_dbscan_kc %>% 
  rename(doc_id = cluster,
         text = page_title
         ) %>%
  unnest_tokens(output = word, 
                text,
                token = "words") %>%
  anti_join(stop_words)

#delete some common topics
wiki_dbscan_kc <-       
  filter(
    wiki_dbscan_kc, !(word %in% c("london", 
                                   "kensington",
                                   "chelsea")
    ))

#run btm model
model_wiki_tl <- BTM(wiki_dbscan_kc, 
                     k = 9, 
                     iter = 2000, 
                     background = TRUE, 
                     trace = 100,
                     detailed = TRUE)

#visualise 
topicterms_wiki <- terms(model_wiki_tl, top_n = 10)


plot(model_wiki_tl, top_n = 10, 
     title = 'BTM Wiki titles',
     labels = paste(round(model_wiki_tl$theta *100, 2), 
                    "%", sep = ""))


#visualise Intertopic Distance Map
docsize <- table(wiki_dbscan_kc$doc_id)
scores  <- predict(model_wiki_tl, wiki_dbscan_kc)
scores  <- scores[names(docsize), ]
json <- createJSON(
  phi = t(model_wiki_tl$phi), 
  theta = scores, 
  doc.length = as.integer(docsize),
  vocab = model_wiki_tl$vocabulary$token, 
  term.frequency = model_wiki_tl$vocabulary$freq)
serVis(json)
print(model$phi)

#evaluate topics----------------------
#create document-term matrix
library(udpipe)
dtf <- document_term_frequencies(
  wiki_dbscan_kc[, c("doc_id", "word")])
dtm_wiki <- document_term_matrix(dtf)  

library(topicdoc)
tc <- topic_coherence(model_wiki_tl, 
                      dtm_data = dtm, 
                      top_n_tokens = 10)

tc_wiki_tl <- coherenceBTM(model_wiki_tl, dtm_wiki)
mean(tc_wiki_tl)

##Run btm  for wiki kc_summary-----------------------------------------
wiki_kc <- read.csv(
  "data/data_wiki_clustering/kc_wiki_dbscan_tag_oct.csv")


wiki_kc_new <- wiki_kc %>% 
  rename(doc_id = cluster,
         text = clean_summary
  ) %>%
  unnest_tokens(output = word, 
                text,
                token = "words") %>%
  subset( select = -c(X) )

#delete some common topics
#wiki_kc <-       
  #filter(
    #wiki_kc, !(word %in% c("london", 
                                 # "kensington",
                                  #"chelsea")
    #))

#run btm model
model_wiki_sum <- BTM(wiki_kc_new, 
                     k = 6, 
                     iter = 2000, 
                     background = TRUE, 
                     trace = 100,
                     detailed = TRUE)

#visualise 
topicterms_wiki <- terms(model_wiki_sum, top_n = 10)


plot(model_wiki_sum, top_n = 10, 
     title = 'BTM for wiki summary',
     labels = paste(round(model_wiki_sum$theta *100, 2), 
                    "%", sep = ""))
#show the top tokens in each topic
topicterms <- terms(model_wiki_sum, top_n = 10)

#show the probability distribution of topics for each doc
topic_prob_df <- as.data.frame(predict(model_wiki_sum, 
                                       newdata = wiki_kc_new, 
                                       type = "sum_b")) %>%
  mutate(Topic = names(.)[max.col(.)])

topic_prob_df$cluster = rownames(topic_prob_df)

write.csv(topic_prob_df, "data/data_wiki_clustering/wiki_kc_btm_oct.csv")



#evaluate topics
#create document-term matrix
library(udpipe)
dtf <- document_term_frequencies(
  wiki_kc[, c("doc_id", "word")])
dtm_wiki_sum <- document_term_matrix(dtf)  


tc_wiki_sum <- coherenceBTM(model_wiki_sum, dtm_wiki_sum)
mean(tc_wiki_sum)

##Run btm title for wiki lb---------------
wiki_dbscan_lb <- read.csv("data/data_wiki_clustering/lb_wiki_db_tl.csv")

#some text pre-processing
wiki_dbscan_lb$page_title <- gsub("_", " ", wiki_dbscan_lb$page_title)                                 
data("stop_words")

wiki_dbscan_lb <- wiki_dbscan_lb %>% 
  rename(doc_id = cluster,
         text = page_title
         ) %>%
  unnest_tokens(output = word, 
                text,
                token = "words") %>%
  anti_join(stop_words) %>%
  filter(!(word %in% c("london",  "lambeth"))
         )

#run btm model

model_wiki_lb  <- BTM(wiki_dbscan_lb, k = 5, iter = 2000,
                      background = TRUE, trace = 100,
                      detailed = TRUE)
topicterms_wiki_lb <- terms(model_wiki_lb, top_n = 10)

#visualize the topicterms
plot(model_wiki_lb, top_n = 10, 
     labels = paste(round(model_wiki_lb$theta *100, 2), 
                    "%", sep = ""))



##Run btm for title of wiki hk-------------------
wiki_dbscan_hk <- read.csv("data/data_wiki_clustering/hk_wiki_db_tl.csv")

#some text pre-processing
wiki_dbscan_hk$page_title <- gsub("_", " ", wiki_dbscan_hk$page_title)                                 
data("stop_words")

wiki_dbscan_hk <- wiki_dbscan_hk %>% 
  rename(doc_id = cluster,
         text = page_title
  ) %>%
  unnest_tokens(output = word, 
                text,
                token = "words") %>%
  anti_join(stop_words) #%>%
  #filter(!(word %in% c("london",  "lambeth"))
  #)


#run btm model

model_wiki_hk  <- BTM(wiki_dbscan_hk, k = 5, iter = 2000,
                      background = TRUE, trace = 100,
                      detailed = TRUE)
topicterms_wiki_hk <- terms(model_wiki_hk, top_n = 10)

#visualize the topicterms
plot(model_wiki_hk, top_n = 10, 
     labels = paste(round(model_wiki_hk$theta *100, 2), 
                    "%", sep = ""))


