library(tidyverse)
library(here)
source(here('analysis','functions.R'))

# load the list of top-50 psychology journals (ranked by Impact Factor) classified as publishing empirical research
d_journals <- read_csv(here('data','prepare-sample','01 - from WOS','journals_byJIF_empirical.csv'), show_col_types = F) %>%
  filter(publishes_empirical == T) %>%
  slice_head(n = 50)

# load the articles returned by the Web of Science search.
d_articles <- read_csv(here('data','prepare-sample','01 - from WOS','wos_search_02-10-2023.csv'), col_types = cols(.default = "c"))

# give every article a unique ID and create coder columns
d_articles <- d_articles %>%
  mutate(article_id = seq(1,nrow(d_articles)),
         primary_coder = NA,
         secondary_coder = NA) %>%
  select(article_id, everything())

# standardize journal name format
d_articles <- d_articles %>%
  mutate(journal_name = str_to_upper(`Source title`))
  
d_journals <- d_journals %>%
  mutate(journal_name = str_to_upper(`Journal name`))

# de-duplication of articles

# Create a custom function that returns only distinct rows while ignores missing values
distinct_ignore_missing <- function(d_in, col_name, report = F) {
  
  # extract rows that have missing data in this column
  d_missing <- d_in %>%
    filter(is.na({{col_name}}))
  
  # select distinct rows based on this column (retains first row by default)
  d_distinct <- d_in %>%
    distinct({{col_name}}, .keep_all = TRUE)

  # restore the rows with missing data
  d_out <- bind_rows(d_distinct,d_missing)
  
  # Calculate how many rows were removed
  removals <- paste0("Rows removed: ", nrow(d_in) - nrow(d_out))
  
  # Report how many rows were removed if user asks for this
  if(report == T){
    print(removals)
  }
  
  # Output
  return(d_out)
  
}

# identify records that have the same DOI and remove the second record (ignore missing values)
d_articles <- d_articles %>%
  distinct_ignore_missing(DOI)

# identify records that have the same abstract and remove the second record (ignore missing values)
d_articles <- d_articles %>%
  distinct_ignore_missing(Abstract)

# make list of articles for field-wide sample
d_field_wide <- d_articles

# make a list of articles for prominent journals sample
d_prominent <- d_field_wide %>%
  filter(journal_name %in% d_journals$journal_name)


# randomly shuffle the lists
set.seed(42) # set the seed for reproducibility of random sampling
d_field_wide_random <- slice_sample(d_field_wide, n = 400) # randomly select 400 rows (we're doing more than the target sample of 200 to allow for exclusions)

set.seed(42) # set the seed for reproducibility of random sampling
d_prominent_random <- slice_sample(d_prominent, n = 400) # randomly select 400 rows (we're doing more than the target sample of 200 to allow for exclusions)

# check for articles appearing in both lists
list_duplicates <- semi_join(d_field_wide_random, d_prominent_random) # return rows appearing in both lists
nrow(list_duplicates)

# save the data files with all of the WOS bibliographic information
write_csv(d_field_wide_random, here('data','prepare-sample','02 - modified','field-wide-list.csv'))
write_csv(d_prominent_random, here('data','prepare-sample','02 - modified','prominent-list.csv'))

# now create slimmed down versions of these files ready for the coders

# Define a vector of the columns to select and rename
columns_to_select_rename <- c("article_id", "primary_coder", "secondary_coder", "DOI", "journal_name", "title" = "Title", "wos_id" = "Accession Number (UT)") # column name mappings

# Select and rename columns
d_field_wide_random_slim <- d_field_wide_random %>%
  select(!!!columns_to_select_rename) %>%
  mutate(DOI = paste0('https://doi.org/',DOI)) # convert dois to links

d_prominent_random_slim <- d_prominent_random %>%
  select(!!!columns_to_select_rename) %>%
  mutate(DOI = paste0('https://doi.org/',DOI)) # convert dois to links

# save the data files with all of the WOS bibliographic information
write_csv(d_field_wide_random_slim, here('data','prepare-sample','03 - final','field-wide-list.csv'))
write_csv(d_prominent_random_slim, here('data','prepare-sample','03 - final','prominent-list.csv'))

