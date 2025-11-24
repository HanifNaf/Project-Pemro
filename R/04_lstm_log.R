# ==================================================================
# 4/6: PEMODELAN LSTM (log + min-max)
# ==================================================================
library(keras)
library(tensorflow)
library(tidyverse)
library(ggplot2)
load("data/01_ts_objects.RData")

# 7) LSTM (min-max) pada Data LOG
cat("\n>>> 7) PEMODELAN LSTM(log) <<<\n")
# Re-assign min_train dan max_train (penting agar fungsi helper bekerja)
min_train <<- min(as.numeric(train_ts_log))
max_train <<- max(as.numeric(train_ts_log))

train_scaled <- scale01(as.numeric(train_ts_log))
ds_train <- create_dataset(train_scaled, look_back); X_train <- ds_train$x; y_train <- ds_train$y

keras::k_clear_session()
model_lstm <- keras_model_sequential() %>%
  layer_lstm(units = 32, input_shape = c(look_back, 1), return_sequences = FALSE) %>%
  layer_dropout(rate = 0.1) %>% layer_dense(units = 1)
model_lstm %>% compile(loss = "mse", optimizer = optimizer_adam())
es <- callback_early_stopping(monitor = "val_loss", patience = 12, restore_best_weights = TRUE)
history <- model_lstm %>% fit(X_train, y_train, epochs = 200, batch_size = 8, validation_split = 0.12, callbacks = list(es), verbose = 0)
save_model_hdf5(model_lstm, "models/lstm_model_log.h5")

# Plot Loss Curve
df_loss <- data.frame(epoch = 1:length(history$metrics$loss), loss = history$metrics$loss, val_loss = history$metrics$val_loss) %>% pivot_longer(cols = -epoch, names_to = "Metric", values_to = "Value")
p_loss <- ggplot(df_loss, aes(x = epoch, y = Value, color = Metric)) + geom_line(size = 1) + labs(title = "LSTM Training and Validation Loss Curve", y = "MSE Loss") + theme_minimal()
ggsave("plots/lstm/lstm_loss_curve.png", p_loss, width = 8, height = 5)

# FITTED VALUE TRAINING
train_pred_scaled <- as.numeric(model_lstm %>% predict(X_train, verbose = 0)); train_pred_log <- inv_scale01(train_pred_scaled)
train_pred_rescaled <- exp(train_pred_log)
idx_fitted_train <- (look_back + 1):length(dates_train_all)

# PREDIKSI TEST SET (Rekursif)
last_window_test <- train_scaled[(length(train_scaled) - look_back + 1):length(train_scaled)]
pred_test_scaled <- numeric(h_test)
for(i in 1:h_test){
  input <- array(last_window_test, dim = c(1, look_back, 1)); pr <- as.numeric(model_lstm %>% predict(input, verbose = 0))
  pred_test_scaled[i] <- pr; last_window_test <- c(last_window_test[-1], pr)
}
pred_test_log <- inv_scale01(pred_test_scaled); pred_lstm_test <- exp(pred_test_log)

# Simpan hasil LSTM dan parameter scaling
save(pred_lstm_test, train_pred_rescaled, idx_fitted_train, min_train, max_train, file = "data/04_lstm_results.RData")