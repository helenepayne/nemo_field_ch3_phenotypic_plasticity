# nemo_field_ch3_phenotypic_plasticity

Chapter 3 analysis code for the magnitude, direction, and fitness consequences of plasticity in four functional traits (specific leaf area, δ¹³C, mean seed mass, and corolla diameter) in two environmentally distinct years in four pedigreed populations (Angelo Coast, Bodega Bay, Blue Oak, and Hastings Reserve) of the California annual wildflower *Nemophila menziesii*.

## Quick start

```sh
Rscript build.R
```

`build.R` does the whole pipeline:

1. Sources [fetch_dryad.R](fetch_dryad.R) and downloads the 16 input files this repo needs from Dryad into `data/` (skipping anything already cached).
2. Hard-stops with a clear error if any required file is missing after the fetch.
3. Knits [plasticity_analysis.Rmd](plasticity_analysis.Rmd) to `plasticity_analysis.html`, writing figures to `figures/` and supplement tables (S4, S6–S17) to `tables/` as CSVs.

While the Dryad dataset is still private (in review), `fetch_dryad()` cannot download automatically — Dryad gates its share-link downloads behind a browser-only JavaScript challenge. Reviewers can manually populate `data/` from the reviewer share link: <https://datadryad.org/share/LINK_NOT_FOR_PUBLICATION/0AI8JnLR7nXjbFd-suVX_OYr60J4H4TUzmBbLDiiGsk> — open it in a browser, click "Download all files", and move the CSVs into `data/`. Once the dataset is published, `build.R` will fetch them automatically.

## Data dependencies

All inputs live directly in `data/` (flat, no subdirectories) and are read by [plasticity_analysis.Rmd](plasticity_analysis.Rmd) via `here("data", ...)`. The full set is enumerated as `CHAPTER3_FILES` in [fetch_dryad.R](fetch_dryad.R):

```
data/
├── AC_compiledsheet_full_2022.csv   # compiled site×year datasheets (Dryad)
├── AC_compiledsheet_full_2023.csv
├── BB_compiledsheet_full_2022.csv
├── BB_compiledsheet_full_2023.csv
├── BO_compiledsheet_full_2022.csv
├── BO_compiledsheet_full_2023.csv
├── HR_compiledsheet_full_2022.csv
├── HR_compiledsheet_full_2023.csv
├── AC22_bhat.Donor.mu.csv           # per-donor aster breeding values from ch1
├── AC23_bhat.Donor.mu.csv
├── BB22_bhat.Donor.mu.csv
├── BB23_bhat.Donor.mu.csv
├── BO22_bhat.Donor.mu.csv
├── BO23_bhat.Donor.mu.csv
├── HR22_bhat.Donor.mu.csv
└── HR23_bhat.Donor.mu.csv
```

All 16 files are part of the Dryad package [10.5061/dryad.pvmcvdp1p](https://doi.org/10.5061/dryad.pvmcvdp1p). The aster outputs are a snapshot from the chapter-1 pipeline — if you regenerate them in [nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity), drop the new versions into `data/` and re-run `build.R`.

The Dryad package also includes climate covariates (`vpd-*.csv`, rainfall/temperature, PRISM rasters) and a combined fitness file (`w_bothyears.csv`). These are **not** read by [plasticity_analysis.Rmd](plasticity_analysis.Rmd) and so are not fetched by default. To pull them anyway, pass an explicit `files` argument to `fetch_dryad()`.

## Outputs

- `plasticity_analysis.html` — full knitted report
- `figures/` — PNG + PDF for each numbered figure (Fig. 5–8)
- `tables/` — CSVs for supplement tables S4, S6–S17 and primary/sensitivity comparisons

Both `figures/` and `tables/` are gitignored; they're rebuilt fresh on every knit.

## Provenance

This repo was split from [helenepayne/nemo_field](https://github.com/helenepayne/nemo_field) (now archived). Per-file commit history pre-split lives in that monorepo.

## Sister repositories

- [nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity)
- [nemo_field_ch2_evolvability](https://github.com/helenepayne/nemo_field_ch2_evolvability)

## Authors

Helen E. Payne. See `git log` in the parent monorepo for per-file attribution.
