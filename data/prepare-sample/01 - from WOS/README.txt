# Information about how these data files were obtained

## File: wos_search_02-10-2023.csv

Person who obtained the data: Tom Hardwicke 

NOTE: this data file cannot be publicly shared because it contains large portions of a proprietary database.

Instructions: 

1. On 2nd October 2023, we used the Web of Science API tool (https://github.com/clarivate/wos-excel-converter) to search the databases included in the Core Collection, specifically, the Social Sciences Citation Index (SSCI), the Science Citation Index Expanded (SCIE), the Arts and Humanities Citation Index (AHCI), and the Emerging Sources Citation Index (ESCI). We also ran the search using the Web of Science advanced search tool (https://www.webofscience.com/wos/woscc/advanced-search) to double check the same number of records were returned.

2. An affiliation (with University of Melbourne) and an account was required to use the API tool and advanced search tool. 
 
3. We searched for records published in 2022 that had been categorised as belonging to the field of psychology, had a document type classification of 'article', and were published in English. 

This search returned 75,683 records. The specific search string was:

“WC=psychology and PY=2022 and DT=article and LA=english”

Note that the search field tag Year Published (PY) includes a search of both Published Early Access Year and Final Publication Year fields. Thus some items may be included in the output that were early access before 2022, but finally published in 2022, and some items that were early access in 2022, but finally published in 2023 (see https://doi.org/10.1007/s11192-020-03697-x)

4. The records were downloaded using the API tool.


## File: journals_byJIF_empirical.csv

Person who obtained the data: Tom Hardwicke 

NOTE: this data file cannot be publicly shared because it contains large portions of a proprietary database.

Instructions: 

1. On 2nd October 2023, we used Clarivate Journal Citation Reports (JCR) to download psychology journals and their 2022 Journal Impact Factors (JIFs).

2. To do this, we went to the JCR website (https://jcr.clarivate.com/jcr/home), clicked on the "Journals" tab. Use the "filter" tool on the left hand side to select all of the psychology sub-fields (there are 11 including one called "psychology"). This returns 854 journals
