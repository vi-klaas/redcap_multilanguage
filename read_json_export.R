library(writexl)
library(tidyverse)


IN <- "data_input/"
OUT <- "data_output/"

json_name <- "REDCapTranslation_de_sys_20220317-092907.json"

json <- jsonlite::read_json(paste0(IN, json_name))


trans <- json$uiTranslations %>% map_df(flatten_df) %>%
  select(-hash, -translation) 

# write_xlsx(trans,paste0(OUT, "redcap_de.xlsx"))

de <- readr::read_delim(paste0(IN, "GermanSurvey.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(de) <- c("id", "translation_de")
de2 <- readr::read_delim(paste0(IN, "German_12.0.13.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(de2) <- c("id", "translation_de2")


fr <- readr::read_delim(paste0(IN, "FrenchSurvey.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(fr) <- c("id", "translation_fr")
fr2 <- readr::read_delim(paste0(IN, "Francais_7.2.1.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(fr2) <- c("id", "translation_fr2")
fr3 <- readr::read_delim(paste0(IN, "Francais_5.11.4__v2.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(fr3) <- c("id", "translation_fr3")



it <- readr::read_delim(paste0(IN, "ItalianSurvey.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(it) <- c("id", "translation_it")
it2 <- readr::read_delim(paste0(IN, "Italian_v10_8_4.ini"), delim = "=", skip = 2, col_names = FALSE, trim_ws = TRUE)
colnames(it2) <- c("id", "translation_it2")


trans_all <- trans %>% 
  left_join(de, by="id") %>% 
  left_join(de2, by="id") %>% 
  left_join(fr, by="id") %>% 
  left_join(fr2, by="id") %>% 
  left_join(fr3, by="id") %>% 
  left_join(it, by="id") %>% 
  left_join(it2, by="id") %>%
  replace(is.na(.), "")

trans_all <- trans_all %>% 
  mutate(translation_de = ifelse(translation_de == default, "", translation_de)) %>% 
  mutate(translation_fr = ifelse(translation_fr == default, "", translation_fr)) %>% 
  mutate(translation_it = ifelse(translation_it == default, "", translation_it)) %>% 
  mutate(translation_de = ifelse(translation_de != "", translation_de, translation_de2)) %>% 
  mutate(translation_fr = ifelse(translation_fr != "", translation_fr, translation_fr2)) %>%  
  mutate(translation_fr = ifelse(translation_fr != "", translation_fr, translation_fr3)) %>% 
  mutate(translation_it = ifelse(translation_it != "", translation_it, translation_it2))

trans_all %>% filter(translation_it != "") %>% pull(translation_it)

if (FALSE) {
  trans_all %>%
    select(-translation_de2, -translation_fr2, -translation_fr3, -translation_it2) %>%
    write_xlsx(paste0(OUT, "redcap_translation.xlsx"))
}



# ************* DE ********************
trans_de <- trans_all %>% select(id, prompt, default, translation=translation_de)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_de, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations

jsonlite::write_json(json_translated, paste0(OUT, "redcap_de.json"), pretty = TRUE, auto_unbox = TRUE)

jsonlite::toJSON(json_translated, pretty = TRUE, auto_unbox = TRUE)



# ************* FR ********************
trans_fr <- trans_all %>% select(id, prompt, default, translation=translation_fr)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_fr, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations
json_translated$key <- 'fr'
json_translated$display <- 'Francais'

jsonlite::write_json(json_translated, paste0(OUT, "redcap_fr.json"), pretty = TRUE, auto_unbox = TRUE)

# ************* IT ********************
trans_it <- trans_all %>% select(id, prompt, default, translation=translation_it)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_it, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations
json_translated$key <- 'it'
json_translated$display <- 'Italiano'

jsonlite::write_json(json_translated, paste0(OUT, "redcap_it.json"), pretty = TRUE, auto_unbox = TRUE)

