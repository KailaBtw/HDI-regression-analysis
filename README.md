# Improving women's opportunities in society

Regression analysis linking gender inequality to the UN Human Development Index — STAT 325 final project. Full written report, R code for data cleaning and multiple linear regression, and the datasets used are all here.

## Abstract

Gross Domestic Product (GDP) is the typical shorthand for how well a country is doing, but it says nothing about health, education, or how well individuals actually live. This project uses UNDP data on the Gender Inequality Index (GII) and Human Development Index (HDI) for 170 countries (2021) to study how dimensions of gender equality relate to human development outcomes. After cleaning missing values and checking regression assumptions, a multiple linear regression model relates HDI to adolescent birth rate, maternal mortality, and female secondary education completion. The results make a case for investing in female secondary education and maternal health as high-leverage ways to improve both gender equality and HDI outcomes.

## Full report

The complete write-up — methodology, figures, model interpretation, and references — is in Markdown so it renders on GitHub:

**[Read the full report](./docs/report.md)**

The original Word submission is preserved at [docs/Project01_stats.docx](./docs/Project01_stats.docx).

## Key findings

- Simple linear regression between HDI and GII explains about 83% of variance, which motivates a closer look at GII's individual components.
- Parliamentary and labor-force gender gaps showed weak linear association with HDI and were dropped; adolescent birth rate, maternal mortality, and female secondary education were retained.
- The multiple regression model fits well: adjusted R² ≈ 0.86, low residual standard error, all predictors significant at α = 0.05.
- The conclusion points to female secondary education funding, contraceptive access, and maternal health investment as the most actionable levers - they're interrelated and collectively move the needle on HDI.

## Repository layout

| Path | Contents |
|------|----------|
| [R/](./R/) | `main_Ellie_models.R` — cleaning, correlations, MLR, diagnostics; `main_Ellie_graphs.R` — ggplot2 exploration |
| [data/](./data/) | Analysis-ready CSVs: `combdata.csv`, `GII_Data.csv`, `HDI_Data.csv` |
| [data/source/](./data/source/) | Original Excel sources from UNDP tables |
| [docs/](./docs/) | `report.md` and `Project01_stats.docx` |
| [assets/figures/report/](./assets/figures/report/) | Figures embedded in the report |
| [assets/figures/rstudio/](./assets/figures/rstudio/) | Additional plots exported from RStudio |

## Requirements

R with ggplot2 for the graph script; base R is sufficient for the models script. Open the folder as an RStudio project and run scripts from the repository root so `data/combdata.csv` resolves correctly — or `setwd()` to the root before sourcing.
