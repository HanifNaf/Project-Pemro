# ==================================================================
# 5/6: EVALUASI, PLOTTING PERBANDINGAN & FINAL FORECAST
# ==================================================================
library(Metrics)
library(tidyverse)
library(ggplot2)
load("data/01_ts_objects.RData")
load("data/02_arima_results.RData")
load("data/03_sarima_results.RData")
load("data/04_lstm_results.RData")
model_lstm <- load_model_hdf5("models/lstm_model_log.h5") # Muat model LSTM untuk Final Forecast

# 8) EVALUATION on TEST
cat("\n>>> 8) EVALUASI KINERJA (Metrik pada Skala Harga Asli) <<<\n")
actual_test <- as.numeric(test_ts_level); pred_lstm_test <- pred_lstm_test # Pastikan pred_lstm_test termuat
metrics_table <- tibble(
  Model = c("ARIMA(log)","SARIMA(log)","LSTM(log)"),
  RMSE = c(rmse(actual_test, pred_arima_test), rmse(actual_test, pred_sarima_test), rmse(actual_test, pred_lstm_test)),
  MAE = c(mae(actual_test, pred_arima_test), mae(actual_test, pred_sarima_test), mae(actual_test, pred_lstm_test)),
  MAPE = c(mape(actual_test, pred_arima_test), mape(actual_test, pred_sarima_test), mape(actual_test, pred_lstm_test))
)
print(metrics_table)
write_csv(metrics_table, "results/metrics_test_log.csv")
BEST_MODEL_NAME <- metrics_table %>% arrange(RMSE) %>% slice(1) %>% pull(Model) %>% gsub("\\(log\\)", "", .)

# 9) PREPARE DATAFRAMES FOR PLOTTING
df_hist <- tibble(date = df$tanggal, actual = as.numeric(df$harga))
df_fitted_arima <- tibble(date = dates_train_all, fitted = as.numeric(fitted_arima_train), Model = "ARIMA")
df_fitted_sarima <- tibble(date = dates_train_all, fitted = as.numeric(fitted_sarima_train), Model = "SARIMA")
df_fitted_lstm <- tibble(date = dates_train_all[idx_fitted_train], fitted = as.numeric(train_pred_rescaled), Model = "LSTM")
df_fitted_long <- bind_rows(df_fitted_arima, df_fitted_sarima, df_fitted_lstm)
df_pred_test <- tibble(
  date = test_dates, actual = actual_test, ARIMA = pred_arima_test, SARIMA = pred_sarima_test, LSTM = pred_lstm_test,
  ARIMA_L95 = pi_arima_test$lower95, ARIMA_U95 = pi_arima_test$upper95,
  SARIMA_L95 = pi_sarima_test$lower95, SARIMA_U95 = pi_sarima_test$upper95, LSTM_L95 = NA_real_, LSTM_U95 = NA_real_
)
write_csv(df_pred_test, "results/predictions_test_per_model_log.csv")

# 10) PLOTTING: PERBANDINGAN MODEL
theme_set(theme_minimal(base_size = 12))
df_test_long <- df_pred_test %>% select(date, actual, ARIMA, SARIMA, LSTM) %>% pivot_longer(cols = c(ARIMA, SARIMA, LSTM), names_to = "Model", values_to = "Forecast")
p_compare_eval <- ggplot() +
  geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
  geom_line(data = df_fitted_long, aes(x = date, y = fitted, color = Model), linewidth = 0.9, linetype = "dotted") +
  geom_line(data = df_test_long, aes(x = date, y = Forecast, color = Model), linewidth = 1, linetype = "solid") +
  geom_vline(xintercept = as.numeric(min(test_dates)), linetype = "dashed", color = "gray50") +
  labs(title = "Comparison: Fitted Values & Test Set Forecast vs Actual", subtitle = "Black = actual history; Dotted = Fitted; Solid = Forecast", x = "Date", y = "Harga") +
  scale_x_date(date_breaks = "6 months", date_labels = "%b-%Y") + theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("plots/compare/compare_evaluation_forecasts.png", p_compare_eval, width = 12, height = 6)


# 11) FINAL FORECAST (MENGGUNAKAN LSTM)
cat(paste("\n>>> 11) FINAL FORECAST 12 BULAN KE DEPAN (MODEL TERBAIK:", BEST_MODEL_NAME, ") <<<\n"))
h_future <- 12; future_dates <- seq(max(df_hist$date) + months(1), by = "month", length.out = h_future)

# --- Prediksi Rekursif LSTM (Disalin dari Tahap 7) ---
ts_all_log_numeric <- as.numeric(ts_all_log)
# NOTE: Menggunakan min_train/max_train dari skrip 04
all_scaled <- scale01(ts_all_log_numeric)
last_window_future <- all_scaled[(length(all_scaled) - look_back + 1):length(all_scaled)]
pred_future_scaled <- numeric(h_future)
for(i in 1:h_future){
  input <- array(last_window_future, dim = c(1, look_back, 1)); pr <- as.numeric(model_lstm %>% predict(input, verbose = 0))
  pred_future_scaled[i] <- pr; last_window_future <- c(last_window_future[-1], pr)
}
Forecast_Harga <- exp(inv_scale01(pred_future_scaled))

# C. INVERSE TRANSFORMATION & EXPORT
df_future_forecast <- tibble(date = future_dates, Forecast_Harga = Forecast_Harga, Lower95 = NA_real_, Upper95 = NA_real_)
write_csv(df_future_forecast, paste0("results/final_forecast_", tolower(BEST_MODEL_NAME), ".csv"))

# D. PLOT FINAL FORECAST
p_final_forecast <- ggplot() +
  geom_line(data = df_hist, aes(x = date, y = actual), color = "black", linewidth = 0.6) +
  geom_line(data = df_future_forecast, aes(x = date, y = Forecast_Harga), color = "limegreen", linewidth = 1.0) +
  geom_vline(xintercept = as.numeric(min(future_dates)), linetype = "dashed", color = "gray50") +
  labs(title = paste("Final 12-Month Forecast:", BEST_MODEL_NAME), subtitle = "Black = Actual History; Green = Forecast", x = "Date", y = "Harga Beras (Rp)") +
  scale_x_date(date_breaks = "1 year", date_labels = "%Y") +
  scale_y_continuous(labels = scales::label_number(big.mark = ".", decimal.mark = ",")) +
  theme_minimal() + theme(axis.text.x = element_text(angle = 45, hjust = 1), plot.title = element_text(face = "bold"))
ggsave(paste0("plots/compare/final_forecast_", tolower(BEST_MODEL_NAME), ".png"), p_final_forecast, width = 12, height = 6)