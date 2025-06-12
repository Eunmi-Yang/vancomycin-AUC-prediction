# Load required libraries
library(readxl)
library(dplyr)
library(tableone)
library(openxlsx)

# Read datasets
training_data <- read_excel("Vancomycin_auc_prediction_training.xlsx")
external_data <- read_excel("Vancomycin_auc_prediction_external.xlsx")

# Check data dimensions and validate split
cat("Training dataset dimensions:", dim(training_data), "\n")
cat("External dataset dimensions:", dim(external_data), "\n")

# Validate data size for proper split
if(nrow(training_data) != 553) {
  stop("Training data should have 553 rows for 442+111 split!")
}

# Split training data into training (442) and internal validation (111)
train_set <- training_data[1:442, ]
internal_set <- training_data[443:553, ]

cat("Train set dimensions:", dim(train_set), "\n")
cat("Internal set dimensions:", dim(internal_set), "\n")

# Add cohort labels with desired order
train_set$Cohort <- "Training"
internal_set$Cohort <- "Internal"  
external_data$Cohort <- "External"

# Convert to factor with desired level order (Training, Internal, External)
train_set$Cohort <- factor(train_set$Cohort, levels = c("Training", "Internal", "External"))
internal_set$Cohort <- factor(internal_set$Cohort, levels = c("Training", "Internal", "External"))
external_data$Cohort <- factor(external_data$Cohort, levels = c("Training", "Internal", "External"))

# Convert external data Male to numeric (if needed)
external_data$Male <- as.numeric(external_data$Male)

# Create AUC >600 binary variable for all datasets
train_set$AUC_over_600 <- ifelse(train_set$AUC > 600, 1, 0)
internal_set$AUC_over_600 <- ifelse(internal_set$AUC > 600, 1, 0)
external_data$AUC_over_600 <- ifelse(external_data$AUC > 600, 1, 0)

# Combine all datasets
combined_data <- rbind(train_set, internal_set, external_data)

# Define categorical variables
categorical_vars <- c(
  "Male",
  "NSAIDs",
  "Vasopressors", 
  "FLC",
  "FQ",
  "LAB",
  "AG", 
  "TZP",
  "ARB",
  "ACEi",
  "Fusosemide",
  "Diuretics",
  "ICU",
  "AUC_over_600"
)

# Define variable order based on your specified categories
variables_ordered <- c(
  # Patient information
  "Male",           # Gender (will show Male/Female)
  "Age",            # Age (years)
  "BW",             # Weight, kg  
  "Height",         # Height, cm
  "BMI",            # BMI
  
  # Intensive care unit
  "ICU",            # ICU admission
  
  # Lab result
  "WBC",            # WBC, ×10^12/L
  "RBC",            # RBC, ×10^6/µL  
  "Hb",             # Hb, g/L
  "PLT",            # PLT, ×10^12/L
  "CRP",            # CRP, mg/L
  "MDRD",           # eGFR (MDRD), ml/min/1.73m2
  "BUN",            # BUN, mmol/L
  "Scr",            # SCr, µmol/L
  "Albumin",       # Albumin, g/dL (keeping space as requested)
  "TP",             # TP, g/dL
  "UA",             # UA, µmol/L
  
  # Medication information
  "NSAIDs",         # NSAIDs
  "ARB",            # ARB
  "ACEi",           # ACEi
  "Fusosemide",     # Furosemide
  "Diuretics",      # Diuretics
  "Vasopressors",   # Vasopressor
  "LAB",            # LAB
  "AG",             # Aminoglycoside
  "TZP",            # TZP
  "FLC",            # Fluconazole
  "FQ",             # Fluoroquinolone
  
  # Vancomycin information
  "Initial VCM_daily_dose",  # Initial daily dose, mg/day
  "AUC",                     # AUC
  "AUC_over_600"            # AUC >600
)

# Verify all variables exist in the dataset
missing_vars <- setdiff(variables_ordered, names(combined_data))
if(length(missing_vars) > 0) {
  cat("Missing variables:", missing_vars, "\n")
  cat("Available variables:", names(combined_data), "\n")
  stop("Some variables not found in dataset!")
}

# Check for missing data
cat("\n=== Missing Data Check ===\n")
missing_summary <- sapply(combined_data[variables_ordered], function(x) sum(is.na(x)))
if(any(missing_summary > 0)) {
  cat("Variables with missing data:\n")
  print(missing_summary[missing_summary > 0])
} else {
  cat("No missing data found.\n")
}

# Create Table 1
table1 <- CreateTableOne(
  data = combined_data,
  vars = variables_ordered,
  factorVars = categorical_vars,
  strata = "Cohort",
  test = TRUE,
  testApprox = chisq.test,
  argsApprox = list(correct = TRUE),
  testExact = fisher.test,
  argsExact = list(workspace = 2 * 10^5),
  testNormal = oneway.test,
  argsNormal = list(var.equal = TRUE),
  testNonNormal = kruskal.test,
  smd = FALSE
)

# Print table to console with median [IQR] format (remove test indicator)
print(table1, showAllLevels = TRUE, cramVars = categorical_vars, 
      nonnormal = setdiff(variables_ordered, categorical_vars),
      test = FALSE)  # Remove test column to avoid 'nonnorm' indicator

# Or keep test but explain in footnote
print(table1, showAllLevels = TRUE, cramVars = categorical_vars, 
      nonnormal = setdiff(variables_ordered, categorical_vars))

# Convert to matrix for Excel export with median [IQR] format
table1_matrix <- print(table1, 
                       showAllLevels = TRUE, 
                       cramVars = categorical_vars,
                       nonnormal = setdiff(variables_ordered, categorical_vars),
                       printToggle = FALSE)

# Create a workbook and add the table
wb <- createWorkbook()
addWorksheet(wb, "Table1")

# Write the table to Excel
writeData(wb, "Table1", table1_matrix, rowNames = TRUE)

# Add some formatting
addStyle(wb, "Table1", 
         style = createStyle(textDecoration = "bold"), 
         rows = 1, cols = 1:ncol(table1_matrix)+1)

# Save the Excel file
saveWorkbook(wb, "Table1_Baseline_Characteristics.xlsx", overwrite = TRUE)

cat("\n=== Table 1 Generation Complete ===\n")
cat("Excel file saved as: Table1_Baseline_Characteristics.xlsx\n")

# Display summary statistics
cat("\n=== Cohort Summary ===\n")
table(combined_data$Cohort)

cat("\n=== AUC >600 Distribution by Cohort ===\n")
with(combined_data, table(Cohort, AUC_over_600, dnn = c("Cohort", "AUC >600")))