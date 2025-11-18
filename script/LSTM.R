#Libraries
library(keras3)
library(tensorflow)
library(readr)
library(tidyverse)
library(lubridate)
library(abind)
setwd("E:/S2/Pemrograman Statistika/Tugas/kelompok")

# Initialize TensorFlow backend
#tensorflow::install_tensorflow() #--Run This for First Initilization
use_virtualenv("r-tensorflow", required = FALSE)

#Data
set.seed(123)
data <- read_csv("harga_beras_nasional.csv")

# Ensure date formatting
df <- data %>%
  mutate(tanggal = ymd(tanggal)) %>%
  arrange(tanggal)

# Extract the target variable
data_series <- df$harga_nasional

# Min-max normalization
min_val <- min(data_series, na.rm = TRUE)
max_val <- max(data_series, na.rm = TRUE)

scaled <- (data_series - min_val) / (max_val - min_val)


#Create sliding window
create_dataset <- function(data_series, timesteps = 30) {
  X <- array(0, dim = c(length(data_series) - timesteps, timesteps))
  y <- numeric(length(data_series) - timesteps)
  
  for (i in 1:(length(data_series) - timesteps)) {
    X[i, ] <- data_series[i:(i + timesteps - 1)]
    y[i]   <- data_series[i + timesteps]
  }
  
  return(list(X = X, y = y))
}


timesteps <- 30

dataset <- create_dataset(scaled, timesteps)
X <- dataset$X
y <- dataset$y

#train test split 80-20
train_size <- floor(0.8 * nrow(X))

X_train <- X[1:train_size, , drop = FALSE]
y_train <- y[1:train_size]

X_test  <- X[(train_size+1):nrow(X), , drop = FALSE]
y_test  <- y[(train_size+1):nrow(X)]

#reshape data format
X_train <- array(X_train, dim = c(nrow(X_train), timesteps, 1))
X_test  <- array(X_test,  dim = c(nrow(X_test), timesteps, 1))


#Build LSTM Model
model <- keras_model_sequential()
model$add(layer_lstm(units = 50, input_shape = c(timesteps,1)))
model$add(layer_dropout(rate = 0.2))
model$add(layer_dense(units = 1))

model$compile(
  optimizer = "adam",
  loss = "mse"
)

summary(model)

#Train Model
history <- model %>% fit(
  X_train, y_train,
  epochs = 50,
  batch_size = 16,
  validation_split = 0.1,
  verbose = 1
)

#Predict with Acquired Model
scaled_pred <- model %>% predict(X_test)

#Reverse-Scale Predictions
pred <- scaled_pred * (max_val - min_val) + min_val
actual <- y_test * (max_val - min_val) + min_val

#Visualize Predictioins
plot(actual, type = "l", col = "black", lwd = 2, main = "LSTM Forecast",
     ylab = "Harga Nasional", xlab = "Time")
lines(pred, col = "blue", lwd = 2)
legend("topleft", legend = c("Actual", "Prediction"),
       col = c("black", "blue"), lwd = 2)


#Goodness of Fit
evaluate_lstm <- function(actual, pred) {
  rmse <- sqrt(mean((pred - actual)^2))
  mae  <- mean(abs(pred - actual))
  mape <- mean(abs((pred - actual) / actual)) * 100
  
  ss_res <- sum((actual - pred)^2)
  ss_tot <- sum((actual - mean(actual))^2)
  r2     <- 1 - ss_res/ss_tot
  
  naive_error <- mean(abs(diff(actual)))
  mase <- mae / naive_error
  
  data.frame(
    RMSE = rmse,
    MAE = mae,
    MAPE = mape,
    R2 = r2,
    MASE = mase
  )
}

evaluate_lstm(actual, pred)


#Residual Check
residuals <- actual - pred
#plot of residual
plot(residuals, type = "l", main = "Residuals")
abline(h=0, col="red")

#histogram of residual
hist(residuals, main="Residual Distribution")

#ACF of Residual
acf(residuals, main="ACF of Residuals")