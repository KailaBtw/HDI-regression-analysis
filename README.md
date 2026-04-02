# Improving women’s opportunities in society

**Regression analysis linking gender inequality and the UN Human Development Index (HDI)** — STAT 325 final project. The repository contains the full written report, R code for data cleaning, exploratory visualization, and multiple linear regression, plus the datasets used.

## Abstract

GDP is a common shorthand for national success, but it does not capture how well people live across health, education, and income. This project uses United Nations Development Programme data on the Gender Inequality Index (GII) and Human Development Index (HDI) for 170 countries (2021, after cleaning) to study how dimensions of gender equality relate to overall human development. After trimming missing values and checking linearity and regression diagnostics, a multiple linear regression model relates HDI to adolescent birth rate, maternal mortality, and female secondary education completion. The analysis rejects the null that all coefficients are zero, with strong explanatory power and statistically significant predictors. The discussion emphasizes investing in female secondary education and related health measures as high-leverage ways to improve both gender equality and HDI outcomes.

## Full report

The complete write-up (methodology, figures, model interpretation, and references) is in Markdown so it renders on GitHub with a table of contents:

**[Read the full report](./docs/report.md)**

The original Word submission is preserved as [docs/Project01_stats.docx](./docs/Project01_stats.docx).

## Key takeaways

- **HDI vs. GII:** A simple linear relationship between HDI and GII explains a large share of variation (about 83% R² in the report’s simple model), motivating a deeper look at GII components.
- **Predictor choice:** Parliamentary and labor-force gender gaps showed weak linear association with HDI in this dataset; adolescent birth rate, maternal mortality, and female secondary education were retained for multiple regression.
- **Multiple regression:** The fitted model achieves high adjusted R² (about 0.86) with low residual standard error relative to mean HDI; all included predictors are statistically significant at the 0.05 level.
- **Policy thread:** The conclusion stresses funding female secondary education, access to contraception, and maternal health as aligned with both lower adolescent birth rates and higher HDI.

## Repository layout

| Path | Contents |
|------|----------|
| [R/](./R/) | `main_Ellie_models.R` (cleaning, correlations, MLR, diagnostics); `main_Ellie_graphs.R` (ggplot2 exploration) |
| [data/](./data/) | Analysis-ready CSVs (`combdata.csv`, `GII_Data.csv`, `HDI_Data.csv`) |
| [data/source/](./data/source/) | Original Excel sources from UNDP-related tables |
| [docs/](./docs/) | `report.md` (GitHub-rendered report), `Project01_stats.docx` |
| [assets/figures/report/](./assets/figures/report/) | Figures embedded in the report (extracted from the Word document) |
| [assets/figures/rstudio/](./assets/figures/rstudio/) | Additional plots exported from RStudio (`Rplot*.png`) |

## Requirements

- **R** with **ggplot2** for the graph script; base R is enough for the models script.
- **Working directory:** With RStudio, open this folder as the project and run scripts from the **repository root**, or `setwd()` to the root before `source()`-ing, so `data/combdata.csv` resolves correctly.

## Data

Indicators come from UNDP-style statistical annex tables (GII, HDI) for 2021, merged by country; see the report and `data/source/` for the original spreadsheets.
