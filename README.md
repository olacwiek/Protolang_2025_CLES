# Experiments in Language Evolution: Closed vs Open-Ended Semantic Space Paradigms

This repository contains data, code, and analysis scripts for a study on how participants interpret novel vocalizations when given **free-text responses** instead of multiple-choice options.  

📄 The associated abstract accepted for Protolang 2025: *Experiments in language evolution: inferences from closed- vs open-ended semantic space paradigms*.

---

## Repository structure

- **Coders/**  
  Materials and coding sheets used by human annotators (4-point similarity judgments).  

- **data/**  
  Raw and cleaned datasets. Includes participants’ free-text responses, metadata, and ConceptNet-derived cosine similarity values.  

- **models/**  
  Placeholder folder for fitted Bayesian models (`.rds`).  
  ⚠️ Models are **not tracked on GitHub** because of their size (>100 MB).  
  ➡️ Download models from [this OneDrive link](https://1drv.ms/f/c/866160e2e6235955/EtfhxFnrXQ1Fs1EICJPUdFIBQXCoesiW_JeYOJg0rklfdw?e=UyA8bi) and place them into `models/`.  

- **plots/**  
  Auto-saved figures (numbered `Figure_01`, `Figure_02`, …) generated during knitting of the analysis notebooks.  

- **scripts/**  
  Main R Markdown files for data preparation and modeling:  
  - `1_preparation.Rmd` – data cleaning and merging (outputs `final_df.csv`)  
  - `2_modeling.Rmd` – baseline Bayesian models (Bernoulli, ordinal, Beta) and posterior summaries  

- **scripts_SH/** and **SH_HHU/**  
  Scripts from another analysis by Stefan Hartmann.

- **Vocalization study participants answers/**  
  Original free-text responses from participants in the vocalization experiment.

---

## Analysis workflow

1. **Preparation** (`scripts/1_preparation.Rmd`)  
   - Loads raw responses, metadata, and ConceptNet similarity scores.  
   - Cleans and harmonizes IDs/variables.  
   - Outputs a single analysis-ready file: `data/final_df.csv`.

2. **Modeling** (`scripts/2_modeling.Rmd`)  
   - Fits baseline hierarchical models for each outcome:  
     - Binary accuracy (`Bernoulli`)  
     - 4-point similarity (`Gaussian`-normalized)  
     - Cosine similarity (`Beta`)  
   - Summarizes population-level intercepts (μ), Bayesian R², and credible intervals.  
   - Produces comparison tables and plots.

3. **Outputs**  
   - Figures auto-saved in `plots/` (subfolder named after Rmd).  
   - Models saved to `models/` (not in repo, see download link above).  
   - Cleaned dataset in `data/final_df.csv`.

---

## Reproducibility

- Analyses are run in R (≥4.3) with **brms**, **tidyverse**, and supporting packages.  
- Random seed fixed at 1708.  
- Figures and models auto-save with stable filenames for easy reference.  
- Session info is recorded at the end of each R Markdown notebook.

---

## How to use this repo

1. Clone the repository:  
   ```bash
   git clone https://github.com/USERNAME/REPO_NAME.git
   cd REPO_NAME
   ```

2. Download the model objects (RDS) from:
➡️ [this OneDrive link](https://1drv.ms/f/c/866160e2e6235955/EtfhxFnrXQ1Fs1EICJPUdFIBQXCoesiW_JeYOJg0rklfdw?e=UyA8bi)
and place them in the `models/` folder.

3. Open `scripts/1_preparation.Rmd` and `scripts/2_modeling.Rmd` in RStudio.

4. Knit the notebooks to reproduce cleaned data, models, and plots.
