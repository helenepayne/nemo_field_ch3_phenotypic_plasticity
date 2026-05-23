# nemo_field_ch3_phenotypic_plasticity

Chapter 3 analysis code for the magnitude, direction, and fitness consequences of plasticity in four functional traits (specific leaf area, δ¹³C, mean seed mass, and corolla diameter) in two environmentally distinct years in four pedigreed populations (Angelo Coast, Bodega Bay, Blue Oak, and Hastings Reserve) of the California annual wildflower *Nemophila menziesii*

## Data dependencies

This chapter has two kinds of inputs:

### 1. Compiled site×year datasheets (fetched from Dryad)

`*_compiledsheet_full_2022.csv` and `*_compiledsheet_full_2023.csv` for the
four sites (AC, BB, BO, HR) live in the Dryad data package
[10.5061/dryad.pvmcvdp1p](https://doi.org/10.5061/dryad.pvmcvdp1p) and are
fetched on first run by `R/fetch_dryad.R` into `data/`. The Rmds reference
them via `here::here("data/compiled_sheets", ...)` (legacy path) — for
new analyses, prefer reading from `data/` directly. While the Dryad package is
still private, populate `data/` manually from your local copy.

### 2. Aster-model breeding-value outputs from chapter 1 (vendored)

The plasticity analyses use posterior breeding-value estimates produced by
the aster models in
[nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity).
Those outputs are vendored in this repo under `data/aster_outputs/`:

```
data/aster_outputs/
├── AC22_bhat.Donor.mu.csv     # 2022 BVs per donor, by site
├── AC23_bhat.donor.mu.csv
├── BB22_bhat.Donor.mu.csv
├── BB23_bhat.donor.mu.csv
├── BO22_bhat.Donor.mu.csv
├── BO23_bhat.donor.mu.csv
├── HR22_bhat.Donor.mu.csv
├── HR23_bhat.donor.mu.csv
├── AC_22.csv .. HR_22.csv     # processed datasheets from ch1
└── w_bothyears.csv
```

These are a snapshot — if you regenerate them in `nemo_field_ch1_*`, copy the
new versions over the vendored ones here and commit.

> **Note on existing Rmd paths:** several Rmds in this repo currently
> reference these aster outputs by absolute path
> (`/Users/Helen/Desktop/nemo_field/aster/processed_data/…`). Update those
> reads to `here::here("data", "aster_outputs", …)` to make the analyses
> portable.

## Provenance

This repo was split from
[helenepayne/nemo_field](https://github.com/helenepayne/nemo_field) (now
archived). Per-file commit history pre-split lives in that monorepo.

## Sister repositories

- [nemo_field_ch1_adaptive_capacity](https://github.com/helenepayne/nemo_field_ch1_adaptive_capacity)
- [nemo_field_ch2_evolvability](https://github.com/helenepayne/nemo_field_ch2_evolvability)

## Authors

Helen E. Payne. See `git log` in the parent monorepo for per-file attribution.
