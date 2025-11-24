# ==================================================================
# 1/6: LOAD, PREPROCESSING, TS OBJECTS, SPLIT & EDA
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
library(gridExtra)

# Setup Environment dan Reproducible Seed
set.seed(4)
tf$random$set_seed(4)

# Membuat direktori hasil jika belum ada
dir.create("data", recursive = TRUE, showWarnings = FALSE)
dir.create("models", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/eda", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/arima", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/sarima", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/lstm", recursive = TRUE, showWarnings = FALSE)
dir.create("plots/compare", recursive = TRUE, showWarnings = FALSE)
dir.create("results", recursive = TRUE, showWarnings = FALSE)

# --- FUNGSI LSTM HELPER ---
# Variabel min_train dan max_train akan dihitung di skrip 04
min_train <- 0
max_train <- 0
look_back <- 12

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
cat(">>> 1) LOAD DATA & CLEANING <<<\n")
# setwd("C:/0. S2/PEMROGRAMAN STATISTIKA/TUGAS GITHUB") # Hapus atau sesuaikan jika perlu
df <- read_excel("harga_beras_clean.xlsx")
colnames(df)[1:2] <- c("tanggal","harga")
df <- df %>%
  mutate(tanggal = as.Date(tanggal)) %>%
  arrange(tanggal) %>%
  na.omit()

# 2) TIME SERIES OBJECT & LOG TRANSFORMATION
cat(">>> 2) TIME SERIES OBJECT & LOG TRANSFORMATION <<<\n")
start_year <- year(min(df$tanggal))
start_month <- month(min(df$tanggal))
ts_all_level <- ts(df$harga, start = c(start_year, start_month), frequency = 12)
ts_all_log <- ts(log(df$harga), start = c(start_year, start_month), frequency = 12)

# 4) SPLIT TRAIN / TEST
cat(">>> 4) SPLIT TRAIN / TEST (T: 2024.1) <<<\n")
train_ts_log <- window(ts_all_log, end = c(2023,12))
test_ts_log <- window(ts_all_log, start = c(2024,1))
test_ts_level <- window(ts_all_level, start = c(2024,1))
h_test <- length(test_ts_log)
test_dates <- as.Date(as.yearmon(time(test_ts_log)))
dates_train_all <- seq(as.Date(sprintf("%04d-%02d-01", start_year, start_month)), by = "month", length.out = length(train_ts_log))

# --- EDA (Eksplorasi Data) ---
cat("\n==================================================================\n")
cat(">>> 3) EKSPLORASI DATA & DETEKSI POLA MUSIMAN <<<\n")
cat("==================================================================\n")

# ... (Kode EDA Anda, Ganti window(...) dengan train_ts_log) ...
df_train_log_temp <- df %>% filter(tanggal <= as.Date("2023-12-31")) %>%
  mutate(Tanggal = tanggal, Log_Harga = log(harga))

# G. ACF/PACF Data Log Level
p_acf_level <- ggAcf(train_ts_log, lag.max = 36) + labs(title = "ACF Log-Harga (Level)", x = "Lag (Bulan)")
p_pacf_level <- ggPacf(train_ts_log, lag.max = 36) + labs(title = "PACF Log-Harga (Level)", x = "Lag (Bulan)")
p_combined_level <- grid.arrange(p_acf_level, p_pacf_level, ncol = 2)
ggsave("plots/eda/acf_pacf_level_log.png", p_combined_level, width = 10, height = 4)

# H. ACF/PACF setelah Differencing Non-Musiman d=1
train_ts_log_diff1 <- diff(train_ts_log, differences = 1)
p_acf_diff1 <- ggAcf(train_ts_log_diff1, lag.max = 36) + labs(title = "ACF Setelah d=1", x = "Lag (Bulan)")
p_pacf_diff1 <- ggPacf(train_ts_log_diff1, lag.max = 36) + labs(title = "PACF Setelah d=1", x = "Lag (Bulan)")
p_combined_diff1 <- grid.arrange(p_acf_diff1, p_pacf_diff1, ncol = 2)
ggsave("plots/eda/acf_pacf_diff1_log.png", p_combined_diff1, width = 10, height = 4)

# I. ACF/PACF setelah Differencing Non-Musiman d=1 dan Musiman D=1
train_ts_log_diff1_diff12 <- diff(train_ts_log_diff1, lag = 12, differences = 1)
p_acf_diff1_12 <- ggAcf(train_ts_log_diff1_diff12, lag.max = 36) + labs(title = "ACF Setelah d=1 & D=1", x = "Lag (Bulan)")
p_pacf_diff1_12 <- ggPacf(train_ts_log_diff1_diff12, lag.max = 36) + labs(title = "PACF Setelah d=1 & D=1", x = "Lag (Bulan)")
p_combined_diff1_12 <- grid.arrange(p_acf_diff1_12, p_pacf_diff1_12, ncol = 2)
ggsave("plots/eda/acf_pacf_diff1_D1_log.png", p_combined_diff1_12, width = 10, height = 4)

# Simpan objek utama
save(df, ts_all_level, ts_all_log, train_ts_log, test_ts_log, test_ts_level, h_test, test_dates, dates_train_all, 
     min_train, max_train, look_back, scale01, inv_scale01, create_dataset, 
     file = "data/01_ts_objects.RData")