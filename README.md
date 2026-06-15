# Vancomycin AUC >600 Prediction Model

This repository contains the analysis code and output files for developing and validating an interpretable machine learning model to predict vancomycin overexposure, defined as an area under the concentration-time curve (AUC) >600 mg·h/L, in hospitalized patients.

The primary model was Logistic Regression with Elastic Net regularization. The model was developed using routinely available clinical variables and evaluated as a screening tool to identify patients at risk of vancomycin overexposure before or alongside therapeutic drug monitoring (TDM).

---

## 1. Dataset Overview

| Dataset             | Source                   |                             Period |   N | AUC >600, n (%) |
| ------------------- | ------------------------ | ---------------------------------: | --: | --------------: |
| Training            | Tertiary medical center  | 2020.11–2024.07, first 80% by time | 442 |      77 (17.4%) |
| Internal validation | Tertiary medical center  |  2020.11–2024.07, last 20% by time | 111 |      18 (16.2%) |
| External validation | Secondary medical center |                    2023.07–2023.09 |  35 |       7 (20.0%) |

The internal cohort from the tertiary medical center was split chronologically into training and internal validation datasets using an 80:20 ratio. The external validation cohort included all eligible cases from the secondary medical center during the study period.

Candidate predictors included demographics, renal function, laboratory findings, concomitant medications, ICU/ward status, and initial vancomycin dosing information.

---

## 2. Primary Model

**Selected model:** Logistic Regression with Elastic Net regularization
**Primary threshold:** 0.482
**Target outcome:** AUC >600 mg·h/L

The threshold was selected using cross-validation within the training dataset and then fixed for internal and external validation.

---

## 3. Internal Validation Performance

Internal validation was performed using the chronologically separated 20% hold-out dataset.

| Metric      | LR-ElasticNet |
| ----------- | ------------: |
| AUROC       |         0.893 |
| AUPRC       |         0.638 |
| Sensitivity |         0.833 |
| Specificity |         0.785 |
| PPV         |         0.429 |
| NPV         |         0.961 |
| F1 score    |         0.566 |
| Accuracy    |         0.793 |

**Confusion matrix**

|                   | Predicted AUC >600 | Predicted AUC ≤600 |
| ----------------- | -----------------: | -----------------: |
| Observed AUC >600 |                 15 |                  3 |
| Observed AUC ≤600 |                 20 |                 73 |

---

## 4. Comparison with Bayesian Software

The selected LR-ElasticNet model was compared with commercial Bayesian software using the same internal validation dataset.

| Model         | AUROC | AUPRC | Sensitivity | Specificity |   PPV |   NPV |
| ------------- | ----: | ----: | ----------: | ----------: | ----: | ----: |
| LR-ElasticNet | 0.893 | 0.638 |       0.833 |       0.785 | 0.429 | 0.961 |
| PrecisePK     | 0.777 | 0.452 |       0.667 |       0.677 | 0.286 | 0.913 |

The LR-ElasticNet model showed better discrimination and higher sensitivity and NPV than the Bayesian software in the internal validation dataset.

---

## 5. Exploratory External Validation

External validation was performed in a small secondary-hospital cohort and should be interpreted as exploratory.

| Metric      | LR-ElasticNet |
| ----------- | ------------: |
| AUROC       |         0.765 |
| AUPRC       |         0.402 |
| Sensitivity |         0.714 |
| Specificity |         0.607 |
| PPV         |         0.312 |
| NPV         |         0.895 |
| F1 score    |         0.435 |
| Accuracy    |         0.629 |

**Confusion matrix**

|                   | Predicted AUC >600 | Predicted AUC ≤600 |
| ----------------- | -----------------: | -----------------: |
| Observed AUC >600 |                  5 |                  2 |
| Observed AUC ≤600 |                 11 |                 17 |

Because the external validation cohort was small, with only seven overexposure events, the external performance estimates should not be interpreted as confirmatory evidence of generalizability.

---

## 6. Model Interpretation

SHAP analysis was used to interpret the selected LR-ElasticNet model.

The most influential predictors were:

* Initial daily vancomycin dose
* Cockcroft-Gault creatinine clearance
* Body weight
* Diuretic use
* C-reactive protein
* Hemoglobin
* Albumin

These findings are consistent with known pharmacokinetic determinants of vancomycin exposure, especially the importance of dose and renal function.

---

## 7. Observed AUC Distribution by Predicted Risk Group

The selected model was also evaluated by examining the observed AUC distribution within predicted low-risk and high-risk groups.

| Cohort              | Predicted risk group | Total n |   AUC <400 | AUC 400–600 |   AUC >600 |
| ------------------- | -------------------- | ------: | ---------: | ----------: | ---------: |
| Internal validation | Predicted low risk   |      76 | 40 (52.6%) |  33 (43.4%) |   3 (3.9%) |
| Internal validation | Predicted high risk  |      35 |   2 (5.7%) |  18 (51.4%) | 15 (42.9%) |
| External validation | Predicted low risk   |      19 | 10 (52.6%) |   7 (36.8%) |  2 (10.5%) |
| External validation | Predicted high risk  |      16 |  2 (12.5%) |   9 (56.2%) |  5 (31.2%) |

This analysis supports the model’s intended role as a screening tool for identifying patients at increased risk of overexposure.

---

## 8. Repository Structure

The notebook is organized as follows:

```text
Part 0. Configuration and helper functions
Part 1. Data preprocessing and cohort construction
Part 2. Model development and validation
Part 3. Additional reviewer-requested analyses
Part 4. Figure generation
Part 5. Manuscript table generation
Part 6. Final export
```

Final outputs include:

```text
figures/
tables/
supplementary_tables/
source_data/
model/
final_export_manifest.csv
```

---

## 9. Main Figures

The final manuscript figures include:

* Figure 1. Dataset flow diagram
* Figure 2. Observed vancomycin AUC distribution and cohort-specific outcome class counts
* Figure 3. Confusion matrices of the selected LR-ElasticNet model
* Figure 4. ROC and precision-recall curves of the selected LR-ElasticNet model
* Figure 5. SHAP analysis of the selected LR-ElasticNet model

---

## 10. Main Tables and Supplementary Tables

Main tables:

* Table 1. Baseline characteristics of the internal analytic cohort and external validation cohort
* Table 2. Primary LR-ElasticNet model performance with 95% confidence intervals
* Table 3. Comparison between LR-ElasticNet and PrecisePK
* Table 4. Observed AUC distribution according to predicted risk group

Supplementary tables:

* Supplementary Table S1. Baseline characteristics of the training, internal validation, and external validation datasets
* Supplementary Table S2. Candidate model performance in the internal validation dataset
* Supplementary Table S3. Exploratory candidate model performance in the external validation dataset
* Supplementary Table S4. Variance inflation factor analysis
* Supplementary Table S5. Exploratory association between AUC >600 mg·h/L and AKI
* Supplementary Table S6. Variable-level missingness summary

---

## 11. Clinical Interpretation

The model is intended as a screening tool rather than a standalone dosing algorithm. Its high sensitivity and NPV suggest that it may help identify patients at low or high risk of vancomycin overexposure before TDM results are available.

Potential clinical use cases include:

* Early risk stratification before TDM
* Prompt dose reassessment in high-risk patients
* More efficient allocation of monitoring resources
* Support for individualized vancomycin dosing workflows

---

## 12. Limitations

Important limitations include:

* Retrospective study design
* Single-center model development
* Small external validation cohort
* Potential covariate shift between internal and external cohorts
* Need for prospective multicenter validation before clinical implementation

The external validation should be considered exploratory because of the small sample size and limited number of overexposure events.

---

## 13. Conclusion

We developed and validated an interpretable machine learning model for predicting vancomycin overexposure using routinely collected clinical data. The selected LR-ElasticNet model showed high sensitivity and NPV in internal validation and maintained exploratory performance in an external cohort. Larger multicenter studies are needed to confirm generalizability and support clinical implementation.

---

## Contact

For inquiries, contact Yong Kyun Kim: [amoureuxyk@naver.com](mailto:amoureuxyk@naver.com)
