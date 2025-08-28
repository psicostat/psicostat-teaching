# check if running the script --------------------------------------------

if (Sys.getenv("QUARTO_PROJECT_RENDER_ALL") == "0") {
  quit()
}

# packages ---------------------------------------------------------------

library(tidyverse)
library(googledrive)
library(here)
source(here("R", "utils.r"))

# env --------------------------------------------------------------------

options(gargle_oauth_email = Sys.getenv("GMAIL"), googledrive_quiet = TRUE)

# data -------------------------------------------------------------------

teaching <- drive_dowload_read(info$teaching)

teaching$Docente = toupper(teaching$Docente)

template <- '- title: "%s"\n  author: %s\n  description: %s\n  categories: [%s]\n  image: teaching/images/%s\n  link: %s\n  lang: %s'


image <- list.files("teaching/images/")
image_to_insert = vapply(
  teaching$id,
  function(id) {
    match_idx <- match(id, xfun::sans_ext(image))
    if (!is.na(match_idx)) image[match_idx] else "0.png"
  },
  character(1)
)


tag <- ifelse(is.na(teaching$tag), "TBD", teaching$tag)
link <- ifelse(is.na(teaching$Link), "", teaching$Link)
flag <- ifelse(teaching$Lingua == "Inglese", flag("gb"), flag("it"))
description <- paste(teaching$description, flag)
lang <- ifelse(teaching$Lingua == "Inglese", "english", "italian")

sprintf(
  template,
  teaching$Titolo,
  teaching$Docente,
  description,
  tag,
  image_to_insert,
  link,
  lang
) |>
  writeLines(con = "teaching/teachings.yml")
