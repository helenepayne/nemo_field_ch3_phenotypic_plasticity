#!/usr/bin/env Rscript
# build.R --------------------------------------------------------------------
# Reproducible build: fetches the data this repo needs from Dryad (or skips
# if already cached locally), then knits plasticity_analysis.Rmd to HTML.
#
# Usage:
#   Rscript build.R
# ---------------------------------------------------------------------------

# Ensure we run from the project root (where this script lives), so that
# `here::here()` and relative paths inside the Rmd resolve correctly.
script_dir <- tryCatch(
  dirname(normalizePath(sys.frame(1)$ofile, mustWork = FALSE)),
  error = function(e) getwd()
)
if (nzchar(script_dir) && dir.exists(script_dir)) setwd(script_dir)

stopifnot(
  "fetch_dryad.R not found in project root"      = file.exists("fetch_dryad.R"),
  "plasticity_analysis.Rmd not found"            = file.exists("plasticity_analysis.Rmd")
)

# ---- 1. fetch data ----------------------------------------------------------
message("==> Fetching data from Dryad (cached files are skipped)...")
source("fetch_dryad.R")
fetch_dryad()  # defaults to CHAPTER3_FILES — exactly what the Rmd reads

# ---- 2. sanity-check that required files are present ------------------------
missing <- CHAPTER3_FILES[
  !file.exists(file.path("data", CHAPTER3_FILES))
]
if (length(missing)) {
  stop("Required data files missing from data/:\n  ",
       paste(missing, collapse = "\n  "),
       "\nDryad is currently inaccessible and the cache is incomplete.",
       call. = FALSE)
}

# ---- 3. knit Rmd to HTML ----------------------------------------------------
message("==> Knitting plasticity_analysis.Rmd to HTML...")
rmarkdown::render("plasticity_analysis.Rmd", quiet = FALSE)

message("==> Done. Output: plasticity_analysis.html")
