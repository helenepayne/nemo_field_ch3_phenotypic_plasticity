# nemo_field_ch3_phenotypic_plasticity

Chapter 3 analysis code for the magnitude, direction, and fitness consequences of plasticity in four functional traits (specific leaf area, δ¹³C, mean seed mass, and corolla diameter) in two environmentally distinct years in four pedigreed populations (Angelo Coast, Bodega Bay, Blue Oak, and Hastings Reserve) of the California annual wildflower *Nemophila menziesii*

## Data dependencies

All inputs live directly in `data/` and are read by
[plasticity_analysis.Rmd](plasticity_analysis.Rmd) via `here("data", ...)`.

### 1. Compiled site×year datasheets (fetched from Dryad)

`*_compiledsheet_full_2022.csv` and `*_compiledsheet_full_2023.csv` for the
four sites (AC, BB, BO, HR) live in the Dryad data package
[10.5061/dryad.pvmcvdp1p](https://doi.org/10.5061/dryad.pvmcvdp1p) and are
fetched on first run by [fetch_dryad.R](fetch_dryad.R) into `data/`. While the
Dryad package is still private, populate `data/` manually from your local copy.

### 2. Aster-model breeding-value outputs from chapter 1 (vendored)

The plasticity analyses use posterior breeding-value estimates produced by
the aster models in
[nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity).
Those outputs are vendored alongside the compiled sheets in `data/`:

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
├── AC22_bhat.Donor.mu.csv           # per-donor breeding values from ch1 aster
├── AC23_bhat.donor.mu.csv
├── BB22_bhat.Donor.mu.csv
├── BB23_bhat.donor.mu.csv
├── BO22_bhat.Donor.mu.csv
├── BO23_bhat.donor.mu.csv
├── HR22_bhat.Donor.mu.csv
├── HR23_bhat.donor.mu.csv
├── vpd-2022.csv                     # site-level VPD covariates
└── vpd-2023.csv
```

The aster outputs are a snapshot — if you regenerate them in
`nemo_field_ch1_*`, copy the new versions over the vendored ones here and
commit.

## Provenance

This repo was split from
[helenepayne/nemo_field](https://github.com/helenepayne/nemo_field) (now
archived). Per-file commit history pre-split lives in that monorepo.

## Sister repositories

- [nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity)
- [nemo_field_ch2_evolvability](https://github.com/helenepayne/nemo_field_ch2_evolvability)

## Authors

Helen E. Payne. See `git log` in the parent monorepo for per-file attribution.
