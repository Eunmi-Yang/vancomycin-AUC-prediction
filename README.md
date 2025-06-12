# 🧪 Vancomycin-AUC-prediction  

**Machine learning for prediction of vancomycin overexposure (AUC >600 mg·h/L)**

- This repository contains code and results for machine learning models to predict vancomycin overexposure (AUC >600 mg·h/L) in hospitalized patients.  
- Models are trained on EMR data, addressing class imbalance with SMOTE, and compared to commercial software (PrecisePK) for clinical decision support.



## 🧠 Overview

- **Goal:** Predict risk of vancomycin AUC >600 mg·h/L at treatment initiation using EMR data.
- **Models:** 10 ML algorithms (logistic regression, Ridge, SVM, tree ensembles, etc.) with/without SMOTE.
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

- **Logistic Regression** (L2 regularization)
- **RidgeClassifier**
- **K-Nearest Neighbors**
- **SVM** (RBF kernel)
- **Random Forest**
- **Extra Trees**
- **XGBoost**
- **CatBoost**
- **Gradient Boosting**
- **VotingClassifier**



## 🔍 Results

#### 1. Internal Validation Performance

<div style="overflow-x:auto">

| Model              | PR-AUC   | ROC-AUC  | F1 Score | Sensitivity | Specificity | PPV      | NPV      | Accuracy | TP | FN | FP | TN |
|--------------------|----------|----------|----------|-------------|-------------|----------|----------|----------|----|----|----|----|
| LogisticRegression | 0.5640   | 0.8232   | 0.4643   | 0.7222      | 0.7312      | 0.3421   | 0.9315   | 0.7297   | 13 | 5  | 25 | 68 |
| RidgeClassifier    | 0.5855   | 0.8375   | 0.5172   | 0.8333      | 0.7312      | 0.3750   | 0.9577   | 0.7477   | 15 | 3  | 25 | 68 |

**(a) Binary Classification – No SMOTE**

| Model              | PR-AUC   | ROC-AUC  | F1 Score | Sensitivity | Specificity | PPV      | NPV      | Accuracy | TP | FN | FP | TN |
|--------------------|----------|----------|----------|-------------|-------------|----------|----------|----------|----|----|----|----|
| LogisticRegression | 0.5640   | 0.8232   | 0.4643   | 0.7222      | 0.7312      | 0.3421   | 0.9315   | 0.7297   | 13 | 5  | 25 | 68 |
| RidgeClassifier    | 0.5855   | 0.8375   | 0.5172   | 0.8333      | 0.7312      | 0.3750   | 0.9577   | 0.7477   | 15 | 3  | 25 | 68 |
| KNN                | 0.2749   | 0.7100   | 0.2069   | 0.1667      | 0.9140      | 0.2727   | 0.8500   | 0.7928   | 3  | 15 | 8  | 85 |
| SVM                | 0.3832   | 0.7186   | 0.3556   | 0.4444      | 0.7957      | 0.2963   | 0.8810   | 0.7387   | 8  | 10 | 19 | 74 |
| RandomForest       | 0.3556   | 0.7715   | 0.0000   | 0.0000      | 1.0000      | 0.0000   | 0.8378   | 0.8378   | 0  | 18 | 0  | 93 |
| GradientBoosting   | 0.5009   | 0.7658   | 0.3333   | 0.2222      | 0.9785      | 0.6667   | 0.8667   | 0.8559   | 4  | 14 | 2  | 91 |
| XGBoost            | 0.3143   | 0.7246   | 0.2857   | 0.2222      | 0.9355      | 0.4000   | 0.8614   | 0.8198   | 4  | 14 | 6  | 87 |
| CatBoost           | 0.4460   | 0.7497   | 0.1053   | 0.0556      | 1.0000      | 1.0000   | 0.8455   | 0.8468   | 1  | 17 | 0  | 93 |
| ExtraTrees         | 0.3652   | 0.7279   | 0.0000   | 0.0000      | 1.0000      | 0.0000   | 0.8378   | 0.8378   | 0  | 18 | 0  | 93 |
| VotingClassifier   | 0.4767   | 0.8256   | 0.2400   | 0.1667      | 0.9570      | 0.4286   | 0.8558   | 0.8288   | 3  | 15 | 4  | 89 |

**(b) Regression Models**

| Model            | ±20% Accuracy | ±30% Accuracy | RMSE    | MAE     | R²      |
|------------------|----------------|----------------|---------|---------|---------|
| LinearRegression | 0.6036         | 0.7477         | 132.56  | 95.22   | 0.2812  |
| Ridge            | 0.5946         | 0.7477         | 131.81  | 94.85   | 0.2892  |
| CatBoost         | 0.5766         | 0.7387         | 146.30  | 100.17  | 0.1243  |
| GradientBoosting | 0.5586         | 0.7117         | 153.64  | 105.44  | 0.0343  |
| ExtraTrees       | 0.5586         | 0.7207         | 144.77  | 99.03   | 0.1426  |
| XGBoost          | 0.5225         | 0.6847         | 159.49  | 113.27  | -0.0406 |
| RandomForest     | 0.5135         | 0.7117         | 146.30  | 104.16  | 0.1244  |
| KNN              | 0.5045         | 0.6667         | 169.99  | 119.83  | -0.1821 |
| SVR              | 0.4685         | 0.7297         | 158.35  | 113.17  | -0.0258 |

**(c) Binary Classification – SMOTE Applied**

| Model              | PR-AUC   | ROC-AUC  | F1 Score | Sensitivity | Specificity | PPV      | NPV      | Accuracy | TP | FN | FP | TN |
|--------------------|----------|----------|----------|-------------|-------------|----------|----------|----------|----|----|----|----|
| LogisticRegression | 0.4312   | 0.7706   | 0.4898   | 0.6667      | 0.7957      | 0.3871   | 0.9250   | 0.7748   | 12 | 6  | 19 | 74 |
| RidgeClassifier    | 0.4359   | 0.7718   | 0.4583   | 0.6111      | 0.7957      | 0.3667   | 0.9136   | 0.7658   | 11 | 7  | 19 | 74 |
| KNN                | 0.2037   | 0.6251   | 0.3175   | 0.5556      | 0.6237      | 0.2222   | 0.8788   | 0.6126   | 10 | 8  | 35 | 58 |
| SVM                | 0.2254   | 0.6314   | 0.1333   | 0.1111      | 0.8925      | 0.1667   | 0.8384   | 0.7658   | 2  | 16 | 10 | 83 |
| RandomForest       | 0.3698   | 0.7234   | 0.3448   | 0.2778      | 0.9355      | 0.4545   | 0.8700   | 0.8288   | 5  | 13 | 6  | 87 |
| GradientBoosting   | 0.3365   | 0.7216   | 0.3333   | 0.2778      | 0.9247      | 0.4167   | 0.8687   | 0.8198   | 5  | 13 | 7  | 86 |
| XGBoost            | 0.3055   | 0.6959   | 0.4118   | 0.3889      | 0.9032      | 0.4375   | 0.8842   | 0.8198   | 7  | 11 | 9  | 84 |
| CatBoost           | 0.3046   | 0.6846   | 0.3030   | 0.2778      | 0.8925      | 0.3333   | 0.8646   | 0.7928   | 5  | 13 | 10 | 83 |
| ExtraTrees         | 0.1994   | 0.5896   | 0.1290   | 0.1111      | 0.8817      | 0.1538   | 0.8367   | 0.7568   | 2  | 16 | 11 | 82 |
| VotingClassifier   | 0.3912   | 0.7766   | 0.3750   | 0.3333      | 0.9140      | 0.4286   | 0.8763   | 0.8198   | 6  | 12 | 8  | 85 |



#### 2. Comparison with Precise PK Software

|       Model               | PR-AUC  | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV    | NPV    | Accuracy | TP | FN | FP | TN |
|----------------------|---------|---------|----------|-------------|-------------|--------|--------|----------|----|----|----|----|
| Precise PK           | 0.4520  | 0.7772  | 0.4000   | 0.6667      | 0.6774      | 0.2857 | 0.9130 | 0.6757   | 12 | 6  | 30 | 63 |
| No SMOTE best: RidgeClassifier | 0.5855  | 0.8375  | 0.5172   | 0.8333      | 0.7312      | 0.3750 | 0.9577 | 0.7477   | 15 | 3  | 25 | 68 |
| SMOTE best: LogisticRegression | 0.4312  | 0.7706  | 0.4898   | 0.6667      | 0.7957      | 0.3871 | 0.9250 | 0.7748   | 12 | 6  | 19 | 74 |



#### 3. External Validation Performance

|                                 | PR-AUC  | ROC-AUC | F1 Score | Sensitivity | Specificity | PPV    | NPV    | Accuracy | TP | FN | FP | TN |
|---------------------------------|---------|---------|----------|-------------|-------------|--------|--------|----------|----|----|----|----|
| External - RidgeClassifier (No SMOTE)  | 0.2292  | 0.5255  | 0.3871   | 0.8571      | 0.3571      | 0.2500 | 0.9091 | 0.4571   | 6  | 1  | 18 | 10 |
| External - LogisticRegression (SMOTE)  | 0.3789  | 0.7194  | 0.4545   | 0.7143      | 0.6429      | 0.3333 | 0.9000 | 0.6571   | 5  | 2  | 10 | 18 |

</div>



## 🧾 Conclusion 
- We developed and externally validated machine learning models for early prediction of vancomycin overexposure in hospitalized patients.
- The models demonstrated high sensitivity and may assist clinicians in optimizing dosing when TDM is limited.
- Further validation in diverse patient populations is needed before routine clinical adoption.

## 📞 Contact

For inquiries, contact Yong Kyun Kim (amoureuxyk@naver.com)

