A. Input file for osm_data_collection
This file requires an input of Output Area Boundary File (December 2011) for Kensington and Chelsea. The file is downloaded from the ONS Geography Portal. It can be accessed at https://geoportal.statistics.gov.uk/datasets/417d65831892486bb88002c2e23520c1_0/explore?location=52.042712%2C-1.350081%2C7.98. The lisence statement for the file is https://www.ons.gov.uk/methodology/geography/licences (Source: Office for National Statistics licensed under the Open Government Licence v.3.0 Contains OS data © Crown copyright and database right [2011] ).
The downloading takes place in the following steps:
1. Filtering data for LAD16NM = Kensington and Chelsea
2. Downloading the data as a geojson

B. Input file for kc_wiki_data_collection
This file requires an input of two different files.
1. The borough boundary file of the Kensington and Chelsea. This file is available at  London Datastore (https://data.london.gov.uk/dataset/statistical-gis-boundary-files-london) under liscencing terms(https://www.nationalarchives.gov.uk/doc/open-government-licence/version/2/). From the list of files available in the website the file named  'statistical-gis-boundaries-london.zip' which is the boundary files for the 2011 census is extracted.
From the dowloaded file, the file named 'London_Borough_Excluding_MHW.shp' is used as an input for wiki data collection
3. The geotagged English Wikipedia article list
This file is available in  Wikipedia data dump (https://meta.wikimedia.org/wiki/Data_dumps) which has the following license (https://meta.wikimedia.org/wiki/Meta:Creative_Commons_Attribution-ShareAlike_3.0_Unported_License).
The file is extracted as an sql. The following steps need to be follow to convert it to csv.

