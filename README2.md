# Vancomycin AUC >600 Prediction Models

This repository contains code, data processing, and evaluation results for predicting vancomycin overexposure (AUC >600 mg·h/L) using machine learning models.
Our primary model is **Logistic Regression with Elastic Net regularization**, benchmarked against other ML models and commercial software (PrecisePK).

## 0. Datasets

| Dataset             | Source                   | Period                               | N   | AUC >600 (%) |
|---------------------|--------------------------|--------------------------------------|-----|--------------|
| Training            | Tertiary medical center  | 2020.11–2024.07 (first 80%, by time) | 442 | 17.4%        |
| Internal validation | Tertiary medical center  | 2020.11–2024.07 (last 20%, by time)  | 111 | 16.2%        |
| External validation | Secondary medical center | 2023.07–2023.09                      | 35  | 20.0%        |

* The dataset from the tertiary medical center (2020.11–2024.07) was split chronologically by an 80:20 ratio to create the training and internal validation sets.
* The external validation cohort consists of all eligible cases from the secondary center during 2023.07–2023.09.
* **Variables:** Demographics, renal function/labs, medications, ICU/ward status, initial vancomycin dose.

## 1. Internal Validation (20% hold-out, CV-fixed Youden threshold)

**Primary model:** Logistic Regression (Elastic Net, threshold = 0.482)

* **ROC-AUC 0.893**, **PR-AUC 0.639**
* Sensitivity 0.833, Specificity 0.785, F1 0.566, NPV 0.961
* Counts: **TP 15, FN 3, FP 20, TN 73** (Accuracy 0.793)

| Model                                  | PR-AUC | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV   | NPV   | Accuracy | TP | FN | FP | TN |
| -------------------------------------- | ------ | ------- | -------- | ----------- | ----------- | ----- | ----- | -------- | -- | -- | -- | -- |
| Logistic Regression (L1+L2, thr=0.482) | 0.639  | 0.893   | 0.566    | 0.833       | 0.785       | 0.429 | 0.961 | 0.793    | 15 | 3  | 20 | 73 |
| Logistic Regression (L1, thr=0.500)    | 0.637  | 0.891   | 0.571    | 0.778       | 0.817       | 0.452 | 0.950 | 0.811    | 14 | 4  | 17 | 76 |
| Logistic Regression (L2, thr=0.432)    | 0.603  | 0.860   | 0.508    | 0.889       | 0.688       | 0.356 | 0.970 | 0.721    | 16 | 2  | 29 | 64 |
| Logistic Regression (None, thr=0.352)  | 0.587  | 0.858   | 0.493    | 0.944       | 0.634       | 0.333 | 0.983 | 0.685    | 17 | 1  | 34 | 59 |
| SVM (RBF, thr=0.183)                   | 0.508  | 0.790   | 0.423    | 0.611       | 0.753       | 0.324 | 0.909 | 0.730    | 11 | 7  | 23 | 70 |
| Random Forest (thr=0.384)              | 0.318  | 0.691   | 0.292    | 0.389       | 0.753       | 0.233 | 0.864 | 0.694    | 7  | 11 | 23 | 70 |
| XGBoost (thr=0.334)                    | 0.297  | 0.727   | 0.436    | 0.667       | 0.731       | 0.324 | 0.919 | 0.721    | 12 | 6  | 25 | 68 |
| Gradient Boosting (thr=0.132)          | 0.350  | 0.744   | 0.333    | 0.500       | 0.710       | 0.250 | 0.880 | 0.676    | 9  | 9  | 27 | 66 |
| CatBoost (thr=0.164)                   | 0.322  | 0.704   | 0.345    | 0.556       | 0.677       | 0.250 | 0.887 | 0.658    | 10 | 8  | 30 | 63 |
| Ensemble (thr=0.347)                   | 0.493  | 0.828   | 0.491    | 0.722       | 0.763       | 0.371 | 0.934 | 0.757    | 13 | 5  | 22 | 71 |


**Confusion matrix (20% hold-out):**

|                 | Predicted Positive | Predicted Negative |
| --------------- | ------------------ | ------------------ |
| Actual Positive | 15 (TP)            | 3 (FN)             |
| Actual Negative | 20 (FP)            | 73 (TN)            |

---

## 2. Comparison with PrecisePK

Against the same hold-out set, our Elastic Net model outperformed **PrecisePK**:

* **PrecisePK**: ROC-AUC 0.777, PR-AUC 0.452, Sensitivity 0.667, PPV 0.286
* **LR-ElasticNet**: ROC-AUC 0.893, PR-AUC 0.639, Sensitivity 0.833, PPV 0.429

| Model                                  | PR-AUC | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV   | NPV   | Accuracy | TP | FN | FP | TN |
| -------------------------------------- | ------ | ------- | -------- | ----------- | ----------- | ----- | ----- | -------- | -- | -- | -- | -- |
| Precise PK (AUC>600 rule)              | 0.452  | 0.777   | 0.400    | 0.667       | 0.677       | 0.286 | 0.913 | 0.676    | 12 | 6  | 30 | 63 |
| Logistic Regression (L1+L2, thr=0.482) | 0.639  | 0.893   | 0.566    | 0.833       | 0.785       | 0.429 | 0.961 | 0.793    | 15 | 3  | 20 | 73 |

---

## 3. External Validation

External cohort: **n=35 (positives 7, 20%)**

* **LR-ElasticNet (thr=0.482)**: Sensitivity 0.714, Specificity 0.607, F1 0.435
* ROC-AUC 0.765, PR-AUC 0.402, NPV 0.895, Accuracy 0.629
* Correctly identified **5/7 positives (71.4%)**

## External Validation Performance

| Model                                  | PR-AUC | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV   | NPV   | Accuracy | TP | FN | FP | TN |
| -------------------------------------- | ------ | ------- | -------- | ----------- | ----------- | ----- | ----- | -------- | -- | -- | -- | -- |
| Logistic Regression (L1+L2, thr=0.482) | 0.402  | 0.765   | 0.435    | 0.714       | 0.607       | 0.313 | 0.895 | 0.629    | 5  | 2  | 11 | 17 |
| Logistic Regression (L1, thr=0.500)    | 0.390  | 0.755   | 0.381    | 0.571       | 0.643       | 0.286 | 0.857 | 0.629    | 4  | 3  | 10 | 18 |
| Logistic Regression (L2, thr=0.432)    | 0.420  | 0.791   | 0.462    | 0.857       | 0.536       | 0.316 | 0.938 | 0.600    | 6  | 1  | 13 | 15 |
| Logistic Regression (None, thr=0.352)  | 0.450  | 0.801   | 0.462    | 0.857       | 0.536       | 0.316 | 0.938 | 0.600    | 6  | 1  | 13 | 15 |
| SVM (RBF, thr=0.183)                   | 0.385  | 0.760   | 0.435    | 0.714       | 0.607       | 0.313 | 0.895 | 0.629    | 5  | 2  | 11 | 17 |
| Random Forest (thr=0.384)              | 0.366  | 0.709   | 0.480    | 0.857       | 0.571       | 0.333 | 0.941 | 0.629    | 6  | 1  | 12 | 16 |
| XGBoost (thr=0.334)                    | 0.401  | 0.719   | 0.462    | 0.857       | 0.536       | 0.316 | 0.938 | 0.600    | 6  | 1  | 13 | 15 |
| Gradient Boosting (thr=0.132)          | 0.361  | 0.724   | 0.429    | 0.857       | 0.464       | 0.286 | 0.929 | 0.543    | 6  | 1  | 15 | 13 |
| CatBoost (thr=0.164)                   | 0.456  | 0.745   | 0.429    | 0.857       | 0.464       | 0.286 | 0.929 | 0.543    | 6  | 1  | 15 | 13 |
| Ensemble (thr=0.347)                   | 0.398  | 0.760   | 0.462    | 0.857       | 0.536       | 0.316 | 0.938 | 0.600    | 6  | 1  | 13 | 15 |


**Confusion matrix (external set):**

|                 | Predicted Positive | Predicted Negative |
| --------------- | ------------------ | ------------------ |
| Actual Positive | 5 (TP)             | 2 (FN)             |
| Actual Negative | 11 (FP)            | 17 (TN)            |

---

## 4. Clinical Implications

* Safety-first screening requires **high sensitivity and NPV**.
* LR-ElasticNet achieved:

  * **Sensitivity 0.833 / NPV 0.961 (internal)**
  * **Sensitivity 0.714 / NPV 0.895 (external)**
* Suitable as a **triage tool** to flag patients at risk of vancomycin overexposure before therapeutic drug monitoring (TDM).
* Thresholds can be re-tuned per site depending on prevalence and risk tolerance.

---

## 5. Limitations and Future Work

* External cohort was **small (n=35)** → wide CIs, further validation needed.
* Single-center, retrospective dataset → possible covariate shift.
* Thresholds fixed via training CV to avoid leakage, but calibration may vary by institution.
* Future work:

  * Prospective multicenter validation
  * Site-specific calibration/threshold selection
  * Decision-curve and net-benefit analyses
  * Integration into EHR workflows

---


## 6. SHAP Analysis (Model Interpretation)

* We used SHAP (SHapley Additive exPlanations) to interpret the contribution of individual variables.
* This provided insight into why the model made certain predictions and confirmed consistency with clinical knowledge.

<p align="center"> <img src="figure/Fig. 4. SHAP analysis_internal_external.png" alt="SHAP analysis" width="650"/> </p>

* Key findings:

  * Vancomycin dose and kidney function (CrCl) were the most influential variables, consistent with pharmacokinetic principles.
  * Hemoglobin, albumin, and body weight also contributed, suggesting patients with anemia, hypoalbuminemia, or low body weight may be more vulnerable to overexposure.
  * CRP and diuretic use showed additional influence, reflecting the role of inflammation and renal elimination.

## 7. Conclusion 
- We developed and externally validated machine learning models to predict vancomycin overexposure (AUC >600 mg·h/L).
- Logistic Regression with Elastic Net achieved high sensitivity and strong negative predictive value, supporting its use as a screening tool before TDM.
- Larger multicenter studies are warranted to confirm generalizability and guide clinical adoption.

## Contact

For inquiries, contact Yong Kyun Kim (amoureuxyk@naver.com)

