# fetch_dryad.R --------------------------------------------------------------
# Download data files for this analysis from the Dryad package and cache them
# locally under `data/`. Intended to be sourced at the top of any Rmd that
# reads from data/.
#
# Usage:
#   source(here::here("fetch_dryad.R"))
#   fetch_dryad()                       # fetches CHAPTER3_FILES (default)
#   fetch_dryad(c("AC_compiledsheet_full_2022.csv"))  # subset
#
# `CHAPTER3_FILES` lists exactly the files plasticity_analysis.Rmd reads
# from data/. The Dryad package may contain additional files (climate,
# rasters, etc.) — those are NOT downloaded by default.
#
# Behaviour:
#   - First run: hits the Dryad API, downloads files into data/.
#   - Subsequent runs: skips files already present in data/.
#   - If the Dryad package is private/embargoed (HTTP 403/404, or the
#     dataset returns "Identifier cannot be viewed"), the function warns
#     and exits gracefully so that users with a local copy of the data
#     in data/ can still run analyses without internet access.
# ---------------------------------------------------------------------------

DRYAD_DOI <- "10.5061/dryad.pvmcvdp1p"

# Reviewer "share" URL for the in-review Dryad dataset. Reviewers can use
# this in a browser to download files manually while the dataset is private.
# Programmatic download via this URL is NOT possible because Dryad gates
# share-link downloads behind an AWS WAF JavaScript challenge.
DRYAD_SHARE_URL <- "https://datadryad.org/share/LINK_NOT_FOR_PUBLICATION/0AI8JnLR7nXjbFd-suVX_OYr60J4H4TUzmBbLDiiGsk"

# Exact set of files this repo's plasticity_analysis.Rmd reads from data/.
# Update this list if the Rmd starts (or stops) reading new files.
CHAPTER3_FILES <- (function() {
  sites <- c("AC", "BB", "BO", "HR")
  c(outer(sites, c(2022, 2023),
          function(s, y) paste0(s, "_compiledsheet_full_", y, ".csv")),
    paste0(sites, "22_bhat.Donor.mu.csv"),
    paste0(sites, "23_bhat.Donor.mu.csv"))
})()

# Resolve a Dryad DOI to a data.frame of files for the latest published
# version. Returns NULL on any error (including private/embargoed datasets).
.dryad_manifest <- function(doi) {
  ds <- tryCatch(rdryad::dryad_dataset(dois = doi),
                 error = function(e) NULL)
  if (is.null(ds) || length(ds) == 0) return(NULL)
  entry <- ds[[1]]
  if (!is.null(entry$message)) {
    warning("Dryad API says: ", entry$message,
            "\nThe dataset DOI ", doi, " is likely private or in review; ",
            "the public API cannot enumerate its files yet.")
    return(NULL)
  }
  ds_id <- entry$id
  if (is.null(ds_id)) return(NULL)

  versions <- tryCatch(rdryad::dryad_versions(ids = ds_id),
                       error = function(e) NULL)
  if (is.null(versions) || length(versions) == 0) return(NULL)
  vdf <- versions[[1]]
  # Pick the most recent version id
  version_id <- if (is.data.frame(vdf) && "id" %in% names(vdf)) {
    tail(vdf$id, 1)
  } else NULL
  if (is.null(version_id)) return(NULL)

  files <- tryCatch(rdryad::dryad_versions_files(ids = version_id),
                    error = function(e) NULL)
  if (is.null(files) || length(files) == 0) return(NULL)
  fdf <- files[[1]]
  if (!is.data.frame(fdf)) return(NULL)
  fdf
}

fetch_dryad <- function(files = CHAPTER3_FILES,
                        doi      = DRYAD_DOI,
                        data_dir = here::here("data"),
                        overwrite = FALSE) {
  if (!requireNamespace("rdryad", quietly = TRUE)) {
    stop("Package 'rdryad' is required. Install with install.packages('rdryad').")
  }
  dir.create(data_dir, showWarnings = FALSE, recursive = TRUE)

  missing <- if (overwrite) files
             else files[!file.exists(file.path(data_dir, files))]

  if (length(missing) == 0) {
    message("Skipping Dryad — all ", length(files),
            " required files already present in ", data_dir)
    return(invisible(file.path(data_dir, files)))
  }
  message("Fetching ", length(missing), " of ", length(files),
          " files from Dryad (", length(files) - length(missing),
          " already cached)")

  manifest <- .dryad_manifest(doi)
  if (is.null(manifest)) {
    message("Could not enumerate Dryad files for DOI ", doi, ".\n",
            "The dataset is still private/in-review. To populate ",
            data_dir, ":\n",
            "  1. Open the reviewer share link in a browser:\n",
            "       ", DRYAD_SHARE_URL, "\n",
            "  2. Click 'Download all files' (or download each CSV).\n",
            "  3. Move the downloaded CSVs into ", data_dir, ".\n",
            "Programmatic download via the share link is not possible — ",
            "Dryad routes share-link downloads through an AWS WAF JS ",
            "challenge that requires a real browser. Once the dataset is ",
            "published, this script will fetch files automatically via ",
            "the public Dryad API.")
    return(invisible(NULL))
  }

  # rdryad typically returns columns like 'path' (filename) and 'download'
  # (download URL). Be defensive about column names.
  name_col <- intersect(c("path", "name", "title"), names(manifest))[1]
  url_col  <- intersect(c("download", "download_url", "href"),
                       names(manifest))[1]
  if (is.na(name_col) || is.na(url_col)) {
    warning("Unexpected Dryad manifest schema (columns: ",
            paste(names(manifest), collapse = ", "), ")")
    return(invisible(NULL))
  }

  for (f in missing) {
    url <- manifest[[url_col]][manifest[[name_col]] == f]
    if (length(url) == 0) {
      warning("File '", f, "' not found in Dryad package ", doi)
      next
    }
    dest <- file.path(data_dir, f)
    message("Downloading ", f, " from Dryad...")
    tryCatch(
      utils::download.file(url[1], dest, mode = "wb", quiet = TRUE),
      error = function(e) warning("Download failed for ", f, ": ", conditionMessage(e))
    )
  }
  invisible(file.path(data_dir, files))
}
