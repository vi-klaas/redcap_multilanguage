library(tidyverse)


IN <- "data_input/"
IN_TRANSLATIONS <- paste0(IN, "official_translations/")
OUT <- "data_output/"

json_name <- "REDCapTranslation_de_sys_20220510-080332.json"

json <- jsonlite::read_json(paste0(IN, json_name))

de_file <- paste0(IN_TRANSLATIONS, "redcap_translation_de_v1.xlsx")
it_file <- paste0(IN_TRANSLATIONS, "redcap_translation_it.xlsx")
fr_file <- paste0(IN_TRANSLATIONS, "redcap_translation_fr.xlsx")

xlsx_de <- readxl::read_xlsx(de_file)
xlsx_it <- readxl::read_excel(it_file)
xlsx_fr <- readxl::read_excel(fr_file)





# ************* DE ********************
trans_de <- xlsx_de %>% select(id, prompt, default, translation=translation_de)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_de, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations

jsonlite::write_json(json_translated, paste0(OUT, "redcap_de_v1.json"), pretty = TRUE, auto_unbox = TRUE)

jsonlite::toJSON(json_translated, pretty = TRUE, auto_unbox = TRUE)



# ************* FR ********************
trans_fr <- xlsx_fr %>% select(id, prompt, default, translation=translation_fr)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_fr, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations
json_translated$key <- 'fr'
json_translated$display <- 'Francais'

jsonlite::write_json(json_translated, paste0(OUT, "redcap_fr.json"), pretty = TRUE, auto_unbox = TRUE)

# ************* IT ********************
trans_it <- xlsx_it %>% select(id, prompt, default, translation=translation_it)
uiTranslations <- jsonlite::fromJSON(jsonlite::toJSON(trans_it, pretty = FALSE), simplifyVector = FALSE)

json_translated <- json
json_translated$uiTranslations <- uiTranslations
json_translated$key <- 'it'
json_translated$display <- 'Italiano'

jsonlite::write_json(json_translated, paste0(OUT, "redcap_it.json"), pretty = TRUE, auto_unbox = TRUE)
