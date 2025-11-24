# ==================================================================
# Forecast Harga Beras (Log Transformed): ARIMA(log) | SARIMA(log) | LSTM(log)
# TAHAP 1: EVALUASI HANYA PADA DATA HISTORIS (Training + Testing)
# ==================================================================

# 0) LIBRARIES & SETUP
library(readxl)
library(tidyverse)
library(lubridate)
library(forecast)
library(tseries)
library(Metrics)
library(keras)
library(tensorflow)
library(ggplot2)
library(zoo)
library(gridExtra) # Diperlukan untuk menggabungkan plot ggAcf/ggPacf

# Setup Environment dan Reproducible Seed
set.seed(4)
tf$random$set_seed(4)

# Membuat direktori hasil jika belum ada (recursive agar subfolder aman dibuat)
dir.create("data", recursive = TRUE, showWarnings = FALSE)
dir.create("models", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/eda", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/arima", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/sarima", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/lstm", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/compare", recursive = TRUE, showWarnings = FALSE)
dir.create("results", recursive = TRUE, showWarnings = FALSE)

# --- FUNGSI LSTM HELPER ---
min_train <- 0
max_train <- 0
scale01 <- function(x) (x - min_train) / (max_train - min_train)
inv_scale01 <- function(x) (x * (max_train - min_train) + min_train)

create_dataset <- function(series, look_back = 12){
  n <- length(series) - look_back
  if(n <= 0) stop("Series shorter than look_back")
  x <- array(0, dim = c(n, look_back, 1)); y <- numeric(n)
  for(i in 1:n){ x[i,,1] <- series[i:(i + look_back - 1)]; y[i] <- series[i + look_back] }
  return(list(x = x, y = y))
}

# 1) LOAD DATA & CLEANING
setwd("C:/0. S2/PEMROGRAMAN STATISTIKA/TUGAS GITHUB")
df <- read_excel("harga_beras_clean.xlsx")
colnames(df)[1:2] <- c("tanggal","harga")
df <- df %>%
  mutate(tanggal = as.Date(tanggal)) %>%
  arrange(tanggal) %>%
  na.omit()

# 2) TIME SERIES OBJECT & LOG TRANSFORMATION
start_year <- year(min(df$tanggal))
start_month <- month(min(df$tanggal))
ts_all_level <- ts(df$harga, start = c(start_year, start_month), frequency = 12)
ts_all_log <- ts(log(df$harga), start = c(start_year, start_month), frequency = 12)

# -------------------------------------------------------------
# 3) EKSPLORASI DATA & DETEKSI POLA MUSIMAN (DISIMPAN KE plots/eda)
# -------------------------------------------------------------
cat("\n==================================================================\n")
cat(">>> 3) EKSPLORASI DATA & DETEKSI POLA MUSIMAN <<<\n")
cat("==================================================================\n")

# A. Statistik Deskriptif Awal
cat("\n--- Statistik Deskriptif Harga Asli ---\n")
print(summary(df$harga))
write.csv(as.data.frame(t(summary(df$harga))), "results/descriptive_stats_harga_asli.csv", row.names = FALSE)

# B. Time Series Plot Harga Asli
p_ts_level <- ggplot(df, aes(x = tanggal, y = harga)) +
  geom_line(color = "black", linewidth = 0.8) +
  labs(title = "Time Series Plot: Harga Beras Medium (2013-2025)", x = "Tahun", y = "Harga (Rp)") +
  theme_minimal()
ggsave("plots/eda/ts_plot_level.png", p_ts_level, width = 10, height = 5)

# C. Time Series Plot Log Harga
df_log_all <- tibble(
  log_harga = as.numeric(ts_all_log),
  date = as.Date(as.yearmon(time(ts_all_log)))
)
p_ts_log <- ggplot(df_log_all, aes(x = date, y = log_harga)) +
  geom_line(color = "#0072B2", linewidth = 0.8) +
  labs(title = "Time Series Plot: Log(Harga Beras)", x = "Tahun", y = "Log(Harga)") +
  theme_minimal()
ggsave("plots/eda/ts_plot_log.png", p_ts_log, width = 10, height = 5)

# D. Uji ADF pada Data Log Level (Train Set)
cat("\n--- Uji ADF pada Data Log Level (Train Set) ---\n")
adf_result <- adf.test(window(ts_all_log, end = c(2023,12)), alternative = "stationary")
print(adf_result)

# E. Dekomposisi STL
decomp <- stl(window(ts_all_log, end = c(2023,12)), s.window = "periodic")
png("plots/eda/stl_decomposition_log.png", width = 800, height = 600)
plot(decomp, main = "STL Decomposition of Log(Harga)")
dev.off()

# F. Deteksi Pola Musiman dengan Boxplot
df_train_log_temp <- df %>% filter(tanggal <= as.Date("2023-12-31")) %>%
  mutate(Tanggal = tanggal, Log_Harga = log(harga))
df_train_log <- data.frame(
  Bulan = factor(month(df_train_log_temp$Tanggal), levels = 1:12, labels = month.abb),
  Log_Harga = df_train_log_temp$Log_Harga,
  Tanggal = df_train_log_temp$Tanggal
)
p_boxplot_seasonality <- ggplot(df_train_log, aes(x = Bulan, y = Log_Harga)) +
  geom_boxplot(fill = "lightblue", alpha = 0.7) +
  labs(title = "Seasonal Boxplot of Log(Harga) by Month", x = "Bulan", y = "Log(Harga)") +
  theme_minimal()
ggsave("plots/eda/seasonal_boxplot_log.png", p_boxplot_seasonality, width = 8, height = 5)

# G. ACF/PACF Data Log Level
# PENYESUAIAN 1: Menggunakan ggAcf/ggPacf (untuk memastikan sumbu X adalah Lag (Integer))
cat("\n--- G) ACF/PACF Data Log Level (Menggunakan ggAcf/ggPacf) ---\n")
p_acf_level <- ggAcf(window(ts_all_log, end = c(2023,12)), lag.max = 36) +
  labs(title = "ACF Log-Harga (Level)", x = "Lag (Bulan)")
p_pacf_level <- ggPacf(window(ts_all_log, end = c(2023,12)), lag.max = 36) +
  labs(title = "PACF Log-Harga (Level)", x = "Lag (Bulan)")
p_combined_level <- grid.arrange(p_acf_level, p_pacf_level, ncol = 2)
ggsave("plots/eda/acf_pacf_level_log.png", p_combined_level, width = 10, height = 4)

# H. ACF/PACF setelah Differencing Non-Musiman d=1
# PENYESUAIAN 1: Menggunakan ggAcf/ggPacf (untuk memastikan sumbu X adalah Lag (Integer))
cat("\n--- H) ACF/PACF Setelah Differencing Non-Musiman d=1 ---\n")
train_ts_log_diff1 <- diff(window(ts_all_log, end = c(2023,12)), differences = 1)
p_acf_diff1 <- ggAcf(train_ts_log_diff1, lag.max = 36) +
  labs(title = "ACF Setelah d=1", x = "Lag (Bulan)")
p_pacf_diff1 <- ggPacf(train_ts_log_diff1, lag.max = 36) +
  labs(title = "PACF Setelah d=1", x = "Lag (Bulan)")
p_combined_diff1 <- grid.arrange(p_acf_diff1, p_pacf_diff1, ncol = 2)
ggsave("plots/eda/acf_pacf_diff1_log.png", p_combined_diff1, width = 10, height = 4)

# I. ACF/PACF setelah Differencing Non-Musiman d=1 dan Musiman D=1
# PENYESUAIAN 2: Menambahkan eksplorasi setelah seasonal differencing
cat("\n--- I) ACF/PACF Setelah d=1 dan D=1 (Musiman) ---\n")
train_ts_log_diff1_diff12 <- diff(train_ts_log_diff1, lag = 12, differences = 1)
p_acf_diff1_12 <- ggAcf(train_ts_log_diff1_diff12, lag.max = 36) +
  labs(title = "ACF Setelah d=1 & D=1", x = "Lag (Bulan)")
p_pacf_diff1_12 <- ggPacf(train_ts_log_diff1_diff12, lag.max = 36) +
  labs(title = "PACF Setelah d=1 & D=1", x = "Lag (Bulan)")
p_combined_diff1_12 <- grid.arrange(p_acf_diff1_12, p_pacf_diff1_12, ncol = 2)
ggsave("plots/eda/acf_pacf_diff1_D1_log.png", p_combined_diff1_12, width = 10, height = 4)
cat("\n--- Uji ADF pada Data Log Setelah d=1 dan D=1 ---\n")
adf_result_d1_D1 <- adf.test(train_ts_log_diff1_diff12, alternative = "stationary")
print(adf_result_d1_D1)

# J. Deteksi Tanggal Outlier (Urutan diubah)
df_train_log_full <- df_train_log_temp %>% mutate(Bulan = factor(month(Tanggal), levels = 1:12))
outlier_limits <- df_train_log_full %>% group_by(Bulan) %>%
  summarise(Q1 = quantile(Log_Harga, 0.25, na.rm = TRUE),
            Q3 = quantile(Log_Harga, 0.75, na.rm = TRUE),
            IQR = Q3 - Q1,
            Upper_Fence = Q3 + 1.5 * IQR,
            Lower_Fence = Q1 - 1.5 * IQR) %>% ungroup()
outliers_identified <- df_train_log_full %>% left_join(outlier_limits, by = "Bulan") %>%
  filter(Log_Harga > Upper_Fence | Log_Harga < Lower_Fence) %>%
  select(Tanggal, Bulan, Log_Harga, Upper_Fence, Lower_Fence) %>% arrange(Tanggal)
write_csv(outliers_identified, "results/outliers_identified_dates.csv")

# ----------------------------
# 4) SPLIT TRAIN / TEST
# ----------------------------
train_ts_log <- window(ts_all_log, end = c(2023,12))
test_ts_log <- window(ts_all_log, start = c(2024,1))
test_ts_level <- window(ts_all_level, start = c(2024,1))
h_test <- length(test_ts_log)
test_dates <- as.Date(as.yearmon(time(test_ts_log)))

# ----------------------------
# 5) ARIMA (log)
# ----------------------------
cat("\n==================================================================\n")
cat(">>> 5) PEMODELAN & DIAGNOSTIK ARIMA(log) <<<\n")
cat("==================================================================\n")
model_arima_log <- auto.arima(train_ts_log, seasonal = FALSE, stepwise = FALSE, approximation = FALSE)
saveRDS(model_arima_log, "models/arima_model_log.rds")
print(summary(model_arima_log))

fc_arima_test_log <- forecast(model_arima_log, h = h_test, level = c(80, 95))
pred_arima_test <- exp(as.numeric(fc_arima_test_log$mean))
fitted_arima_train <- exp(fitted(model_arima_log))
pi_arima_test <- tibble(lower95 = exp(fc_arima_test_log$lower[, 2]), upper95 = exp(fc_arima_test_log$upper[, 2]))

# --- DIAGNOSTIK RESIDUAL ARIMA(log) ---
cat("\n--- Diagnostik Residual Model ARIMA(log) ---\n")
png("plots/arima/arima_residual_check.png", width = 800, height = 600)
checkresiduals(model_arima_log)
dev.off()
# Menggunakan plot base R untuk residual ACF/PACF (karena checkresiduals menggunakan base plot)
png("plots/arima/arima_acf_pacf_residual.png", width = 800, height = 400)
par(mfrow = c(1, 2))
acf(residuals(model_arima_log), main = "ACF Residual ARIMA(log)")
pacf(residuals(model_arima_log), main = "PACF Residual ARIMA(log)")
par(mfrow = c(1,1))
dev.off()
cat("Uji Normalitas Residual ARIMA (log - Jarque-Bera):\n")
print(jarque.bera.test(residuals(model_arima_log)))

# ----------------------------
# 6) SARIMA (log)
# ----------------------------
cat("\n==================================================================\n")
cat(">>> 6) PEMODELAN & DIAGNOSTIK SARIMA(log) <<<\n")
cat("==================================================================\n")
model_sarima_log <- auto.arima(train_ts_log, seasonal = TRUE, stepwise = FALSE, approximation = FALSE)
saveRDS(model_sarima_log, "models/sarima_model_log.rds")
print(summary(model_sarima_log))

fc_sarima_test_log <- forecast(model_sarima_log, h = h_test, level = c(80, 95))
pred_sarima_test <- exp(as.numeric(fc_sarima_test_log$mean))
fitted_sarima_train <- exp(fitted(model_sarima_log))
pi_sarima_test <- tibble(lower95 = exp(fc_sarima_test_log$lower[, 2]), upper95 = exp(fc_sarima_test_log$upper[, 2]))

# --- DIAGNOSTIK RESIDUAL SARIMA(log) ---
cat("\n--- Diagnostik Residual Model SARIMA(log) ---\n")
png("plots/sarima/sarima_residual_check.png", width = 800, height = 600)
checkresiduals(model_sarima_log)
dev.off()
# Menggunakan plot base R untuk residual ACF/PACF
png("plots/sarima/sarima_acf_pacf_residual.png", width = 800, height = 400)
par(mfrow = c(1, 2))
acf(residuals(model_sarima_log), main = "ACF Residual SARIMA(log)")
pacf(residuals(model_sarima_log), main = "PACF Residual SARIMA(log)")
par(mfrow = c(1,1))
dev.off()
cat("Uji Normalitas Residual SARIMA (log - Jarque-Bera):\n")
print(jarque.bera.test(residuals(model_sarima_log)))

# ----------------------------
# 7) LSTM (min-max) pada Data LOG
# ----------------------------
cat("\n==================================================================\n")
cat(">>> 7) PEMODELAN LSTM(log) <<<\n")
cat("==================================================================\n")
min_train <- min(as.numeric(train_ts_log)); max_train <- max(as.numeric(train_ts_log))
train_scaled <- scale01(as.numeric(train_ts_log))
look_back <- 12; ds_train <- create_dataset(train_scaled, look_back); X_train <- ds_train$x; y_train <- ds_train$y
keras::k_clear_session()
model_lstm <- keras_model_sequential() %>%
  layer_lstm(units = 32, input_shape = c(look_back, 1), return_sequences = FALSE) %>%
  layer_dropout(rate = 0.1) %>% layer_dense(units = 1)
model_lstm %>% compile(loss = "mse", optimizer = optimizer_adam())
es <- callback_early_stopping(monitor = "val_loss", patience = 12, restore_best_weights = TRUE)
history <- model_lstm %>% fit(X_train, y_train, epochs = 200, batch_size = 8, validation_split = 0.12, callbacks = list(es), verbose = 0)
save_model_hdf5(model_lstm, "models/lstm_model_log.h5")

# Plot Loss Curve
df_loss <- data.frame(
  epoch = 1:length(history$metrics$loss),
  loss = history$metrics$loss,
  val_loss = history$metrics$val_loss
) %>% pivot_longer(cols = -epoch, names_to = "Metric", values_to = "Value")
p_loss <- ggplot(df_loss, aes(x = epoch, y = Value, color = Metric)) +
  geom_line(size = 1) + labs(title = "LSTM Training and Validation Loss Curve", y = "MSE Loss") + theme_minimal()
ggsave("plots/lstm/lstm_loss_curve.png", p_loss, width = 8, height = 5)

# FITTED VALUE TRAINING
train_pred_scaled <- as.numeric(model_lstm %>% predict(X_train, verbose = 0)); train_pred_log <- inv_scale01(train_pred_scaled)
train_pred_rescaled <- exp(train_pred_log)
# index tanggal untuk seluruh train
dates_train_all <- seq(as.Date(sprintf("%04d-%02d-01", start_year, start_month)), by = "month", length.out = length(train_ts_log))
idx_fitted_train <- (look_back + 1):length(dates_train_all)
# PREDIKSI TEST SET (Rekursif)
last_window_test <- train_scaled[(length(train_scaled) - look_back + 1):length(train_scaled)]
pred_test_scaled <- numeric(h_test)
for(i in 1:h_test){
  input <- array(last_window_test, dim = c(1, look_back, 1)); pr <- as.numeric(model_lstm %>% predict(input, verbose = 0))
  pred_test_scaled[i] <- pr; last_window_test <- c(last_window_test[-1], pr)
}
pred_test_log <- inv_scale01(pred_test_scaled); pred_test_rescaled <- exp(pred_test_log)

# ----------------------------
# 8) EVALUATION on TEST
# ----------------------------
cat("\n==================================================================\n")
cat(">>> 8) EVALUASI KINERJA (Metrik pada Skala Harga Asli) <<<\n")
cat("==================================================================\n")
actual_test <- as.numeric(test_ts_level); pred_arima_test <- pred_arima_test; pred_sarima_test <- pred_sarima_test; pred_lstm_test <- pred_test_rescaled
metrics_table <- tibble(
  Model = c("ARIMA(log)","SARIMA(log)","LSTM(log)"),
  RMSE = c(rmse(actual_test, pred_arima_test), rmse(actual_test, pred_sarima_test), rmse(actual_test, pred_lstm_test)),
  MAE = c(mae(actual_test, pred_arima_test), mae(actual_test, pred_sarima_test), mae(actual_test, pred_lstm_test)),
  MAPE = c(mape(actual_test, pred_arima_test), mape(actual_test, pred_sarima_test), mape(actual_test, pred_lstm_test))
)
print(metrics_table)
write_csv(metrics_table, "results/metrics_test_log.csv")

# ----------------------------
# 9) PREPARE DATAFRAMES FOR PLOTTING
# ----------------------------
df_hist <- tibble(date = df$tanggal, actual = as.numeric(df$harga))
df_fitted_arima <- tibble(date = dates_train_all, fitted = as.numeric(fitted_arima_train))
df_fitted_sarima <- tibble(date = dates_train_all, fitted = as.numeric(fitted_sarima_train))
df_fitted_lstm <- tibble(date = dates_train_all[idx_fitted_train], fitted = as.numeric(train_pred_rescaled))
df_fitted_long <- bind_rows(
  df_fitted_arima %>% mutate(Model = "ARIMA"),
  df_fitted_sarima %>% mutate(Model = "SARIMA"),
  df_fitted_lstm %>% mutate(Model = "LSTM")
)
df_pred_test <- tibble(
  date = test_dates, actual = actual_test, ARIMA = pred_arima_test, SARIMA = pred_sarima_test, LSTM = pred_lstm_test,
  ARIMA_L95 = pi_arima_test$lower95, ARIMA_U95 = pi_arima_test$upper95,
  SARIMA_L95 = pi_sarima_test$lower95, SARIMA_U95 = pi_sarima_test$upper95,
  LSTM_L95 = NA_real_, LSTM_U95 = NA_real_
)
write_csv(df_pred_test, "results/predictions_test_per_model_log.csv")

# ----------------------------
# 10) PLOTTING: FITTED + TEST FORECAST (Per Model & Comparison)
# ----------------------------
theme_set(theme_minimal(base_size = 12))

# Fungsi Plotting ARIMA & SARIMA (Evaluasi)
plot_model_arima_sarima_eval <- function(model_name, df_fitted, pred_col_name, pi_lower_col, pi_upper_col, output_file){
  p <- ggplot() +
    geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
    geom_ribbon(data = df_pred_test, aes_string(x = "date", ymin = pi_lower_col, ymax = pi_upper_col), fill = "grey", alpha = 0.4) +
    geom_line(data = df_fitted, aes(x = date, y = fitted), color = "forestgreen", linewidth = 0.9) +
    geom_point(data = df_pred_test, aes(x = date, y = actual), color = "blue", size = 1.2) +
    geom_line(data = df_pred_test, aes_string(x = "date", y = pred_col_name), color = "red", linetype = "dashed", linewidth = 0.9) +
    geom_vline(xintercept = as.numeric(min(test_dates)), linetype = "dotted", color = "black") +
    labs(title = paste0(model_name, " Evaluation: Fitted & Test Forecast vs Actual"), x = "Date", y = "Harga") +
    scale_x_date(date_breaks = "6 months", date_labels = "%b-%Y") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(output_file, p, width = 12, height = 6)
  return(p)
}

# Fungsi Plotting LSTM (Evaluasi)
plot_model_lstm_eval <- function(model_name, df_fitted, pred_col_name, output_file){
  p <- ggplot() +
    geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
    geom_line(data = df_fitted, aes(x = date, y = fitted), color = "forestgreen", linewidth = 0.9) +
    geom_point(data = df_pred_test, aes(x = date, y = actual), color = "blue", size = 1.2) +
    geom_line(data = df_pred_test, aes_string(x = "date", y = pred_col_name), color = "red", linetype = "dashed", linewidth = 0.9) +
    geom_vline(xintercept = as.numeric(min(test_dates)), linetype = "dotted", color = "black") +
    labs(title = paste0(model_name, " Evaluation: Fitted & Test Forecast vs Actual"), x = "Date", y = "Harga") +
    scale_x_date(date_breaks = "6 months", date_labels = "%b-%Y") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  ggsave(output_file, p, width = 12, height = 6)
  return(p)
}

p_arima <- plot_model_arima_sarima_eval("ARIMA (log)", df_fitted_arima, "ARIMA", "ARIMA_L95", "ARIMA_U95", "plots/arima/arima_evaluation_plot.png")
p_sarima <- plot_model_arima_sarima_eval("SARIMA (log)", df_fitted_sarima, "SARIMA", "SARIMA_L95", "SARIMA_U95", "plots/sarima/sarima_evaluation_plot.png")
p_lstm <- plot_model_lstm_eval("LSTM (log)", df_fitted_lstm, "LSTM", "plots/lstm/lstm_evaluation_plot.png")

# Plot Perbandingan Semua Model (Fitted + Test Forecast)
df_test_long <- df_pred_test %>% select(date, actual, ARIMA, SARIMA, LSTM) %>%
  pivot_longer(cols = c(ARIMA, SARIMA, LSTM), names_to = "Model", values_to = "Forecast")

p_compare_eval <- ggplot() +
  geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
  geom_line(data = df_fitted_long, aes(x = date, y = fitted, color = Model), linewidth = 0.9, linetype = "dotted") +
  geom_line(data = df_test_long, aes(x = date, y = Forecast, color = Model), linewidth = 1, linetype = "solid") +
  geom_vline(xintercept = as.numeric(min(test_dates)), linetype = "dashed", color = "gray50") +
  labs(title = "Comparison: Fitted Values & Test Set Forecast vs Actual",
       subtitle = "Black = actual history; Dotted = Fitted; Solid = Forecast",
       x = "Date", y = "Harga") +
  scale_x_date(date_breaks = "6 months", date_labels = "%b-%Y") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("plots/compare/compare_evaluation_forecasts.png", p_compare_eval, width = 12, height = 6)

# ----------------------------
# 11) FINAL FORECAST (MENGGUNAKAN LSTM - MODEL TERBAIK)
# ----------------------------
cat("\n==================================================================\n")
cat(">>> 11) FINAL FORECAST 12 BULAN KE DEPAN (MODEL TERBAIK: LSTM) <<<\n")
cat("==================================================================\n")

# Set nama best model
BEST_MODEL_NAME <- "LSTM"

# A. SETUP PARAMETER PERAMALAN
h_future <- 12
future_dates <- seq(max(df_hist$date) + months(1), by = "month", length.out = h_future)

# B. GENERATE FINAL FORECAST (Menggunakan model_lstm yang sudah dilatih)

# 1. Scaling ulang seluruh data (termasuk train + test) menggunakan parameter min/max dari data train awal
# Walaupun model dilatih hanya pada train, untuk forecasting, window harus menggunakan data terkini (termasuk test)
# Kita akan menggunakan min_train dan max_train yang sudah dihitung di Tahap 7.

ts_all_log_numeric <- as.numeric(ts_all_log) # Data log seluruhnya (Train + Test)
all_scaled <- scale01(ts_all_log_numeric)    # Scaling menggunakan min/max dari data train

# 2. Ambil window terakhir dari data seluruhnya (Train + Test)
# look_back = 12 (dari Tahap 7)
last_window_future <- all_scaled[(length(all_scaled) - look_back + 1):length(all_scaled)]

# 3. Prediksi rekursif
pred_future_scaled <- numeric(h_future)
for(i in 1:h_future){
  input <- array(last_window_future, dim = c(1, look_back, 1))
  pr <- as.numeric(model_lstm %>% predict(input, verbose = 0))
  pred_future_scaled[i] <- pr
  last_window_future <- c(last_window_future[-1], pr) # Update window untuk langkah berikutnya
}

# 4. Inverse Scaling dan Inverse Log Transformation
pred_future_log <- inv_scale01(pred_future_scaled)
Forecast_Harga <- exp(pred_future_log)

# C. INVERSE TRANSFORMATION (Log -> Harga Asli)
# Catatan: LSTM tidak menyediakan confidence interval (PI) standar, 
# sehingga kolom Lower95 dan Upper95 diisi NA atau dihitung menggunakan metode bootstapping/MCDropout
# Untuk keperluan ini, kita isi NA
df_future_forecast <- tibble(
  date = future_dates,
  Forecast_Harga = Forecast_Harga,
  Lower95 = NA_real_, # Tidak tersedia PI standar dari metode ini
  Upper95 = NA_real_  # Tidak tersedia PI standar dari metode ini
)

# D. PLOT FINAL FORECAST
p_final_forecast <- ggplot() +
  geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
  geom_line(data = df_future_forecast, aes(x = date, y = Forecast_Harga), color = "limegreen", linewidth = 1.0) +
  # geom_ribbon dihilangkan/dikomentari karena Lower95/Upper95 adalah NA
  # geom_ribbon(data = df_future_forecast, aes(x = date, ymin = Lower95, ymax = Upper95), fill = "red", alpha = 0.2) +
  geom_vline(xintercept = as.numeric(min(future_dates)), linetype = "dashed", color = "gray50") +
  labs(title = paste("Final 12-Month Forecast:", BEST_MODEL_NAME),
       subtitle = "Black = Actual History; Green = Forecast", # Subtitle disesuaikan
       x = "Date", y = "Harga Beras (Rp)") +
  scale_x_date(
    date_breaks = "1 year",
    date_labels = "%Y"
  ) +
  scale_y_continuous(
    labels = scales::label_number(big.mark = ".", decimal.mark = ",")
  ) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold")
  )
ggsave(paste0("plots/compare/final_forecast_", tolower(BEST_MODEL_NAME), ".png"), p_final_forecast, width = 12, height = 6)


# E. EXPORT FINAL RESULT
write_csv(df_future_forecast, paste0("results/final_forecast_", tolower(BEST_MODEL_NAME), ".csv"))
