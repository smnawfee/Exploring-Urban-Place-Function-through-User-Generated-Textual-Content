#!/usr/bin/env python
# coding: utf-8


import torch

# Check device
if torch.cuda.is_available():
    print('Run on CUDA')
    print(f'Device count: {torch.cuda.device_count()}')
    print(f'Current device: {torch.cuda.current_device()}')
    print(f'Current device name: {torch.cuda.get_device_name(torch.cuda.current_device())}')
else:
    print('Run on CPU')

from transformers import AutoTokenizer, AutoModelForCausalLM, pipeline

#load tokenizer and model
token = "hf_...."
model_name = 'mistralai/Mistral-7B-Instruct-v0.3'
tokenizer = AutoTokenizer.from_pretrained(model_name,
                                          token = token)
	                                    
model = AutoModelForCausalLM.from_pretrained(
        model_name,
        token = token,
        torch_dtype=torch.bfloat16,
        device_map="auto",
        trust_remote_code=True)
        
    

#create a transformer pipeline
# Pipeline
generator = pipeline(
    model=model, tokenizer=tokenizer,
    task='text-generation',
    max_new_tokens=500,
    torch_dtype=torch.bfloat16,
    batch_size = 8, 
    repetition_penalty=1.1)



#load dataset
import pandas as pd
kc_wiki_with_summary = pd.read_csv('R:../../kc_wiki_dbscan_tag_llm.csv')



#create prompt
system_prompt =  """
<s> [INST] <<SYS>>
You are a helpful assistant capable of generating keywords and topic lable for documents.
Your task is to: 
1. Generate a topic label that best describes the topic of the document based on its content on place type and place function.
2. Return the topic label starting with '<l>' and ending in '</l>'
3. Give reasons for chosing why the topic label best describes the document, start by saying, 'Let's think step by step'. 
4. In the explanation of the reasons give a list of keywords that best describes the reasons for chosing the keywords.Give the list of keywords
seperated by commas and starting with '<k>' and ending in '</k>'
5. Exclude place names like London, England, Kensington and Chelsea as the Topic label and as keywords. 
6. Exclude any person's name as a topic label and keywords
 
[/INST] <</SYS>>
"""
example_prompt = """
<s>[INST]
I have the following document:
'Zaika is an Indian restaurant in Kensington, London.From 2001 to 2004 it was awarded a Michelin star, making it along with the Tamarind in London the first Indian restaurants to be 
awarded stars. In 2012 it was taken over and joined the same group that also owned the Tamarind restaurant. Shortly after, Zaika was launched as an Italian restaurant but this was not successful and in 2013, 
reopened once again as an Indian restaurant'. 'Hilton is a hotel in the centre of Kensington borough in London. It is a popular accomodation option for tourists in the place. It was established in 1935;. 
'The Tate is a modern art museum in kensington borough.It has a display of numerous contemporary art'. 'The Glory is an indoor children park. It act as a centre of attraction for many in the area. The ticket price
to enter is £5 per person.'

Give me the topic label that best describes the place type and function mentioned in these documents. 
[/INST] 
The topic label for the the document is <l> 'Tourist Area' </l> Let's think step by step, the documents are about place types visited by tourists, for example the keywords for the documents are  
<k> Restaurants, Hotels, Museums </k>.  </s>"""

keyword_prompt = """
[INST]

I have the following document:
- [DOCUMENT]

Give me the topic label that best describes the place type and function mentioned in these documents. 
[/INST]
"""

prompt = system_prompt + example_prompt + keyword_prompt


#loading llm through keybert.llm.textgeneration
from keybert.llm import TextGeneration
from keybert import KeyLLM, KeyBERT

# Load it in KeyLLM
llm = TextGeneration(generator, prompt=prompt)
kw_model = KeyLLM(llm)


#METHOD-1 
#use all documents seperately to generate keywords
#function to run keyllm simple model
def simple_model(text):
  keywords1 = kw_model.extract_keywords(text)
  return keywords1

kc_wiki_with_summary['llm_output'] = kc_wiki_with_summary['page_summary'].apply(simple_model)

#save new dataframe
kc_wiki_with_summary.to_csv('R:/../../Mistral-7b_output.csv')




