# 🧪 Vancomycin-AUC-prediction  

**Machine learning for prediction of vancomycin overdose (AUC >600 mg·h/L)**

- This repository contains code and results for machine learning models to predict vancomycin overdose (AUC >600 mg·h/L) in hospitalized patients.  
- Models are trained on EMR data, addressing class imbalance with SMOTE, and compared to commercial software (PrecisePK) for clinical decision support.



## 🧠 Overview

- **Goal:** Predict risk of vancomycin AUC >600 mg·h/L at treatment initiation using EMR data.
- **Models:** 9 ML algorithms (logistic regression, Ridge, SVM, tree ensembles, etc.)
- **Interpretability:** SHAP values for feature importance.
- **Performance Comparison:** We compared with a commercial Bayesian dosing software (PrecisePK) as an external reference standard.



## 📊 Datasets

| Dataset             | Source                   | Period                               | N   | AUC >600 (%) |
|---------------------|--------------------------|--------------------------------------|-----|--------------|
| Training            | Tertiary medical center  | 2020.11–2024.07 (first 80%, by time) | 442 | 17.4%        |
| Internal validation | Tertiary medical center  | 2020.11–2024.07 (last 20%, by time)  | 111 | 16.2%        |
| External validation | Secondary medical center | 2023.07–2023.09                      | 35  | 20.0%        |

- The dataset from the tertiary medical center (2020.11–2024.07) was split chronologically by an 80:20 ratio to create the training and internal validation sets.
- The external validation cohort consists of all eligible cases from the secondary center during 2023.07–2023.09.
  
- **Variables:** Demographics, renal function/labs, medications, ICU/ward status, initial vancomycin dose.



## 🤖 Machine Learning Models

- 4 Logistic Regression(L1, L2, L1+L2, None)
- SVM, Random Forest
- XGBoost
- CatBoost
- Gradient Boosting
- Ensemble




## 🔍 Results

#### 1. Internal Validation Performance

<div style="overflow-x:auto">

### 1. Internal Validation Performance

#### Internal Validation Performance (20% hold-out, F1-max threshold)

| Model                                   | PR-AUC | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV   | NPV   | Accuracy | TP | FN | FP | TN |
|-----------------------------------------|--------|---------|----------|-------------|-------------|-------|-------|----------|----|----|----|----|
| Logistic Regression (L1, threshold=0.451)     | 0.606  | 0.861   | 0.596    | 0.778       | 0.839       | 0.483 | 0.951 | 0.829    | 14 | 4  | 15 | 78 |
| Logistic Regression (L1+L2, threshold=0.454) | 0.606 | 0.861   | 0.583    | 0.778       | 0.828       | 0.467 | 0.951 | 0.820    | 14 | 4  | 16 | 77 |
| Logistic Regression (L2, threshold=0.490)     | 0.582  | 0.854   | 0.604    | 0.722       | 0.871       | 0.520 | 0.942 | 0.847    | 13 | 5  | 12 | 81 |
| Logistic Regression (None, threshold=0.490)   | 0.584  | 0.855   | 0.605    | 0.722       | 0.871       | 0.520 | 0.942 | 0.847    | 13 | 5  | 12 | 81 |
| SVM (RBF, threshold=0.377)                    | 0.509  | 0.801   | 0.509    | 0.778       | 0.753       | 0.378 | 0.946 | 0.757    | 14 | 4  | 23 | 70 |
| Random Forest (threshold=0.381)               | 0.314  | 0.722   | 0.464    | 0.889       | 0.624       | 0.314 | 0.967 | 0.667    | 16 | 2  | 35 | 58 |
| XGBoost (threshold=0.313)                     | 0.378  | 0.709   | 0.414    | 0.667       | 0.699       | 0.300 | 0.916 | 0.694    | 12 | 6  | 28 | 65 |
| CatBoost (threshold=0.324)                    | 0.376  | 0.712   | 0.426    | 0.722       | 0.677       | 0.302 | 0.927 | 0.685    | 13 | 5  | 30 | 63 |
| Gradient Boosting (threshold=0.298)           | 0.323  | 0.728   | 0.421    | 0.889       | 0.548       | 0.276 | 0.962 | 0.604    | 16 | 2  | 42 | 51 |
| Ensemble (threshold=0.412)   | 0.475  | 0.839   | 0.556    | 0.833       | 0.774       | 0.417 | 0.960 | 0.784    | 15 | 3  | 21 | 72 |

---

### 2. Comparison with Precise PK Software

| Model                                      | PR-AUC  | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV    | NPV    | Accuracy | TP | FN | FP | TN |
|--------------------------------------------|---------|---------|----------|-------------|-------------|--------|--------|----------|----|----|----|----|
| Precise PK (AUC>600 rule)                   | 0.4520  | 0.7772  | 0.4000   | 0.6667      | 0.6774      | 0.2857 | 0.9130 | 0.6757   | 12 | 6  | 30 | 63 |
| Logistic Regression (L1, threshold=0.549) | 0.6059  | 0.8608  | 0.5957   | 0.7778      | 0.8387      | 0.4828 | 0.9512 | 0.8288   | 14 | 4  | 15 | 78 |

---

### 3. External Validation Performance

| Model                                  | PR-AUC  | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV    | NPV    | Accuracy | TP | FN | FP | TN |
|----------------------------------------|---------|---------|----------|-------------|-------------|--------|--------|----------|----|----|----|----|
| Logistic Regression (L1, threshold=0.549) | 0.4597  | 0.8010  | 0.4762   | 0.7143      | 0.6786      | 0.3571 | 0.9048 | 0.6857   | 5  | 2  | 9  | 19 |

- <small><i>Positives (AUC>600) in external data: 7/35 (20.0%)</i></small>  
- <small><i>Our model correctly identified 5 of the 7 positives (71.4%)</i></small>


</div>



## 🧾 Conclusion 
- We developed and externally validated machine learning models for early prediction of vancomycin overexposure in hospitalized patients.
- The models demonstrated high sensitivity and may assist clinicians in optimizing dosing when TDM is limited.
- Further validation in diverse patient populations is needed before routine clinical adoption.

## 📞 Contact

For inquiries, contact Yong Kyun Kim (amoureuxyk@naver.com)

