# check if running the script --------------------------------------------

if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
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

template <- '- title: "%s"\n  author: %s\n  categories: [%s]\n  description: "description"\n  image: teaching/images/%s\n  link: %s'

image <- list.files("teaching/images/")
image_to_insert <- ifelse(
  teaching$id %in% xfun::sans_ext(image),
  image,
  "0.png"
)

tag <- ifelse(is.na(teaching$tag), "TBD", teaching$tag)
link <- ifelse(is.na(teaching$Link), "", teaching$Link)

sprintf(
  template,
  teaching$Titolo,
  teaching$Docente,
  tag,
  image_to_insert,
  link
) |>
  writeLines(con = "teaching/teachings.yml")
