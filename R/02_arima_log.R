# ==================================================================
# 2/6: PEMODELAN ARIMA (log)
# ==================================================================
library(forecast)
library(tidyverse)
library(tseries)
load("data/01_ts_objects.RData")

# 5) ARIMA (log)
cat("\n>>> 5) PEMODELAN & DIAGNOSTIK ARIMA(log) <<<\n")
model_arima_log <- auto.arima(train_ts_log, seasonal = FALSE, stepwise = FALSE, approximation = FALSE)
saveRDS(model_arima_log, "models/arima_model_log.rds")
print(summary(model_arima_log))

# Prediksi Test Set
fc_arima_test_log <- forecast(model_arima_log, h = h_test, level = c(80, 95))
pred_arima_test <- exp(as.numeric(fc_arima_test_log$mean))
fitted_arima_train <- exp(fitted(model_arima_log))
pi_arima_test <- tibble(lower95 = exp(fc_arima_test_log$lower[, 2]), upper95 = exp(fc_arima_test_log$upper[, 2]))

# --- DIAGNOSTIK RESIDUAL ARIMA(log) ---
png("plots/arima/arima_residual_check.png", width = 800, height = 600); checkresiduals(model_arima_log); dev.off()
png("plots/arima/arima_acf_pacf_residual.png", width = 800, height = 400); par(mfrow = c(1, 2)); acf(residuals(model_arima_log), main = "ACF Residual ARIMA(log)"); pacf(residuals(model_arima_log), main = "PACF Residual ARIMA(log)"); par(mfrow = c(1,1)); dev.off()

# Simpan hasil ARIMA
save(pred_arima_test, fitted_arima_train, pi_arima_test, file = "data/02_arima_results.RData")