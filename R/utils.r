create_R_env <- function() {
  if (!file.exists(".Renviron")) {
    file.create(".Renviron")
    writeLines(
      "GMAIL=youraccount@gmail.com\nQUARTO_PROJECT_RENDER_ALL=1",
      con = ".Renviron"
    )
  }
  utils::file.edit(".Renviron")
}

info <- list(
  teaching = list(
    online = "https://docs.google.com/spreadsheets/d/1SOk3o1hlZ0X0D2_R-MAkV3g3tDz2mhwN/edit?gid=1048575007#gid=1048575007",
    local = "database/teaching.rds"
  )
)

read_all_sheets <- function(x) {
  sheets <- readxl::excel_sheets(here::here(x))
  file <- lapply(sheets, function(s) {
    readxl::read_xlsx(here::here(x), sheet = s)
  })
  names(file) <- sheets
  if (length(file) == 1) {
    file <- file[[1]]
  }
  return(file)
}

drive_dowload_read <- function(x) {
  file <- googledrive::drive_download(
    x$online,
    xfun::with_ext(x$local, "xlsx"),
    overwrite = TRUE
  )
  xlsx <- read_all_sheets(file$local_path)
  saveRDS(xlsx, x$local)
  readRDS(x$local)
}

flag <- function(x){
  sprintf('<span class="fi fi-%s"></span>', x)
}
