# ==================================================================
# 3/6: PEMODELAN SARIMA (log)
# ==================================================================
library(forecast)
library(tidyverse)
library(tseries)
load("data/01_ts_objects.RData")

# 6) SARIMA (log)
cat("\n>>> 6) PEMODELAN & DIAGNOSTIK SARIMA(log) <<<\n")
model_sarima_log <- auto.arima(train_ts_log, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
saveRDS(model_sarima_log, "models/sarima_model_log.rds")
print(summary(model_sarima_log))

# Prediksi Test Set
fc_sarima_test_log <- forecast(model_sarima_log, h = h_test, level = c(80, 95))
pred_sarima_test <- exp(as.numeric(fc_sarima_test_log$mean))
fitted_sarima_train <- exp(fitted(model_sarima_log))
pi_sarima_test <- tibble(lower95 = exp(fc_sarima_test_log$lower[, 2]), upper95 = exp(fc_sarima_test_log$upper[, 2]))

# --- DIAGNOSTIK RESIDUAL SARIMA(log) ---
png("plots/sarima/sarima_residual_check.png", width = 800, height = 600); checkresiduals(model_sarima_log); dev.off()
png("plots/sarima/sarima_acf_pacf_residual.png", width = 800, height = 400); par(mfrow = c(1, 2)); acf(residuals(model_sarima_log), main = "ACF Residual SARIMA(log)"); pacf(residuals(model_sarima_log), main = "PACF Residual SARIMA(log)"); par(mfrow = c(1,1)); dev.off()

# Simpan hasil SARIMA
save(pred_sarima_test, fitted_sarima_train, pi_sarima_test, file = "data/03_sarima_results.RData")