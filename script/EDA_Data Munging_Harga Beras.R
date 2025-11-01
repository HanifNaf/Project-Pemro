# ========================================
# LOAD DAN EXPLORASI DATA
# ========================================

# Load libraries
library(readxl)
library(dplyr)
library(tidyr)
library(zoo)
library(imputeTS)
library(lubridate)
library(ggplot2)

# Load data dari Excel
df_wide <- read_excel("Imputasi Excel - DATA ALL 2022-2024.xlsx")

# Lihat struktur data
dim(df_wide)
str(df_wide)
head(df_wide)

# Cek dimensi
cat("Jumlah provinsi:", nrow(df_wide), "\n")
cat("Jumlah kolom tanggal:", ncol(df_wide) - 2, "\n")  # -2 untuk No dan Provinsi



# ========================================
# CONVERT WIDE TO LONG
# ========================================

df_long <- df_wide %>%
  # Hapus kolom No
  select(-No) %>%
  
  # Pivot longer
  pivot_longer(
    cols = -Provinsi,          
    names_to = "tanggal",      
    values_to = "harga"      
  )

# Membuang data "INDONESIA" dari kolom provinsi
df_long <- df_long %>%
  filter(Provinsi != "INDONESIA")

# Lihat hasil
dim(df_long)
str(df_long)
head(df_long, 20)
cat("\nFormat baru:\n")
cat("Rows:", nrow(df_long), "\n")



# ========================================
# CLEAN TANGGAL
# ========================================

# Ubah tipe data di tanggal

data <- df_long %>%
  mutate(
    tanggal = case_when(
      grepl("^[0-9]{5}$", tanggal) ~ as.Date(as.numeric(tanggal), origin = "1899-12-30"),
      TRUE ~ as.Date(tanggal, format = "%d-%m-%Y")
    )
  )


# Validasi
cat("\nValidasi Data:\n")
cat("Min:", as.character(min(data$tanggal, na.rm = TRUE)), "\n")
cat("Max:", as.character(max(data$tanggal, na.rm = TRUE)), "\n")
str(data)
colSums(is.na(data))



# ========================================
# EXPLORATORY ANALYSIS
# ========================================

cat("\n=== DATA SUMMARY ===\n")
cat("Unique provinsi:", length(unique(data$Provinsi)), "\n")
cat("Date range:", as.character(min(data$tanggal)), "to", as.character(max(data$tanggal)), "\n")
cat("Total observations:", nrow(data), "\n\n")

# Cek nilai 0
cat("=== ZERO VALUES ===\n")
zeros_count <- sum(data$harga == 0, na.rm = TRUE)
cat("Total nilai 0:", zeros_count, "\n")

# Provinsi dengan nilai 0
provinsi_dengan_0 <- data %>%
  filter(harga == 0) %>%
  group_by(Provinsi) %>%
  summarise(n_zeros = n()) %>%
  arrange(desc(n_zeros))

cat("\nProvinsi dengan nilai 0:\n")
print(provinsi_dengan_0)

# Visualisasi distribusi 0
ggplot(provinsi_dengan_0, aes(x = reorder(Provinsi, n_zeros), y = n_zeros)) +
  geom_col(fill = "red") +
  coord_flip() +
  labs(title = "Jumlah Nilai 0 per Provinsi",
       x = "Provinsi",
       y = "Jumlah nilai 0") +
  theme_minimal()

# Cek NA yang sudah ada
cat("\nNA yang sudah ada:", sum(is.na(data$harga)), "\n")



# ========================================
# CONVERT 0 TO NA
# ========================================

cat("\n=== CONVERTING 0 TO NA ===\n")

# Ubah data nol menjadi NA
data_NA <- data %>%
  mutate(harga = ifelse(harga == 0, NA, harga))

# Summary after conversion
cat("Sebelum konversi:\n")
cat("  - Nilai 0:", sum(data$harga == 0, na.rm = TRUE), "\n")
cat("  - NA:", sum(is.na(data$harga)), "\n")

cat("\nSetelah konversi:\n")
cat("  - Nilai 0:", sum(data_NA$harga == 0, na.rm = TRUE), "\n")
cat("  - NA:", sum(is.na(data_NA$harga)), "\n")
cat("  - Total missing:", sum(is.na(data_NA$harga)), "\n")
cat("  - Persentase missing:", 
    round(sum(is.na(data_NA$harga)) / nrow(data_NA) * 100, 2), "%\n")

# Missing per provinsi
missing_per_provinsi <- data_NA %>%
  group_by(Provinsi) %>%
  summarise(
    n_total = n(),
    n_missing = sum(is.na(harga)),
    pct_missing = (n_missing / n_total) * 100
  ) %>%
  arrange(desc(pct_missing))

cat("\nMissing values per provinsi:\n")
print(missing_per_provinsi)

# Visualisasi
ggplot(missing_per_provinsi, aes(x = reorder(Provinsi, pct_missing), 
                                 y = pct_missing)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Persentase Missing Values per Provinsi",
       x = "Provinsi",
       y = "% Missing") +
  geom_hline(yintercept = 5, linetype = "dashed", color = "red",
             alpha = 0.5) +
  theme_minimal()



# ========================================
# IMPUTASI
# ========================================

# Metode Linear interpolation + kalman
data_clean_all <- data_NA %>%
  mutate(harga = na_kalman(na_interpolation(harga, option = "linear"), model = "StructTS"))


# Summary after Imputasi
cat("Setelah Imputasi:\n")
cat("Total observations:", nrow(data_clean_all), "\n")
cat("Original NA:", sum(is.na(data_NA$harga)), "\n")
cat("After imputation NA:", sum(is.na(data_clean_all$harga)), "\n")
cat("Nilai 0:", sum(data_clean_all$harga == 0, na.rm = TRUE), "\n")
cat("Success rate:", 
    round((1 - sum(is.na(data_clean_all$harga)) / sum(is.na(data_NA$harga))) * 100, 2),
    "%\n")

str(data_clean_all)



# ====================================================================
# Rata-rata harga dari semua provinsi per tanggal
# ====================================================================

# Setelah data berhasil di-imputasi (data_imputed)
harga_beras_nasional <- data_clean_all %>%
  group_by(tanggal) %>%
  summarise(
    harga_nasional = mean(harga, na.rm = TRUE),
    n_provinsi = n(),
    sd_harga = sd(harga, na.rm = TRUE),
    min_harga = min(harga, na.rm = TRUE),
    max_harga = max(harga, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(tanggal)

# Lihat hasil
head(harga_beras_nasional, 20)

# Summary
cat("=== HARGA RATA-RATA NASIONAL ===\n")
cat("Periode:", as.character(min(harga_beras_nasional$tanggal)), "to",
    as.character(max(harga_beras_nasional$tanggal)), "\n")
cat("Mean nasional (keseluruhan):", round(mean(harga_beras_nasional$harga_nasional), 2), "\n")
cat("Min:", round(min(harga_beras_nasional$harga_nasional), 2), "\n")
cat("Max:", round(max(harga_beras_nasional$harga_nasional), 2), "\n")



# ========================================
# EXPORT RESULTS
# ========================================

write.csv(harga_beras_nasional, 
          "harga_beras_nasional.csv", 
          row.names = FALSE)

cat("✓ Saved: harga_beras_nasional.csv\n")



# ========================================
# EDA (EXPLORATORY DATA ANALYSIS)
# ========================================

## ====== A. PEMAHAMAN STRUKTUR DATA ======
# Dimensi
dim(harga_beras_nasional); nrow(harga_beras_nasional); ncol(harga_beras_nasional)

# Tipe data
str(harga_beras_nasional)

# Nama kolom
names(harga_beras_nasional)

# Sample baris pertama & terakhir
head(harga_beras_nasional, 10)
tail(harga_beras_nasional, 10)


## ====== B. ANALISIS STATISTIK DESKRIPTIF ======
# Fungsi modus (untuk numeric diambil nilai yang paling sering)
Mode_ <- function(x){
  x <- x[!is.na(x)]
  if(length(x)==0) return(NA_real_)
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}
# Statistik
mean_harga   <- mean(harga_beras_nasional$harga_nasional, na.rm = TRUE)
median_harga <- median(harga_beras_nasional$harga_nasional, na.rm = TRUE)
mode_harga   <- Mode_(harga_beras_nasional$harga_nasional)
sd_harga     <- sd(harga_beras_nasional$harga_nasional, na.rm = TRUE)
summary_stats <- data.frame(mean_harga, median_harga, mode_harga, sd_harga)
summary_stats

# Range & kuartil
min_harga <- min(harga_beras_nasional$harga_nasional, na.rm = TRUE)
max_harga <- max(harga_beras_nasional$harga_nasional, na.rm = TRUE)
kuartil   <- quantile(harga_beras_nasional$harga_nasional, probs = c(.25,.5,.75), na.rm = TRUE)
list(min = min_harga, max = max_harga, kuartil = kuartil)

# Distribusi: histogram & density
ggplot(harga_beras_nasional, aes(x = harga_nasional)) +
  geom_histogram(bins = 30) +
  labs(title = "Histogram Harga Nasional", x = "Harga (Rp/kg)", y = "Frekuensi") +
  theme_minimal()
ggsave("Distribusi harga (histogram).png", width = 12, height = 6, dpi = 300)

ggplot(harga_beras_nasional, aes(x = harga_nasional)) +
  geom_density(color="blue", size=1) +
  labs(title = "Density Harga Nasional", x = "Harga (Rp/kg)", y = "Kepadatan") +
  theme_minimal()
ggsave("Density harga nasional.png", width = 12, height = 6, dpi = 300)


# Melihat outlier dengan boxplot
boxplot(harga_beras_nasional$harga_nasional,
        main = "Boxplot Harga Nasional",
        ylab = "Harga (Rp/kg)",
        col = "lightblue")
ggsave("Boxplot harga nasional.png", width = 12, height = 6, dpi = 300)


# Outlier: IQR method (numerik)
Q1  <- quantile(harga_beras_nasional$harga_nasional, 0.25, na.rm = TRUE)
Q3  <- quantile(harga_beras_nasional$harga_nasional, 0.75, na.rm = TRUE)
IQRv <- Q3 - Q1
bawah <- Q1 - 1.5*IQRv
atas  <- Q3 + 1.5*IQRv
idx_iqr <- which(harga_beras_nasional$harga_nasional < bawah | harga_beras_nasional$harga_nasional > atas)
outliers_iqr <- harga_beras_nasional[idx_iqr, ]
nrow(outliers_iqr); head(outliers_iqr)

# Outlier: Z-score (|z| > 3; ubah ke 2.5 bila ingin lebih sensitif)
z <- scale(harga_beras_nasional$harga_nasional)
idx_z <- which(abs(z) > 3)
outliers_z <- harga_beras_nasional[idx_z, ]
nrow(outliers_z); head(outliers_z)

outlier_z <- which(abs(z) > 2.5)  # misalnya ubah threshold ke 2.5
harga_beras_nasional[outlier_z, ]

# Tandai outlier pada data (opsional)
harga_beras_nasional <- harga_beras_nasional %>%
  mutate(outlier_iqr = harga_nasional < bawah | harga_nasional > atas,
         outlier_z   = abs(as.numeric(z)) > 3)


## ====== C. ANALISIS TEMPORAL ======
# 1) Tren harga (time series)
ggplot(harga_beras_nasional, aes(x = tanggal, y = harga_nasional)) +
  geom_line(color = "steelblue", size = 1) +
  geom_smooth(method = "loess", color = "red", se = TRUE, alpha = 0.2) +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Time Series Harga Beras Rata-rata Nasional",
    subtitle = "Simple mean dari semua provinsi",
    x = "Tanggal",
    y = "Harga Rata-rata (Rp/Kg)",
    caption = "Garis merah = trend (loess smoothing)"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
ggsave("harga_nasional_timeseries.png", width = 12, height = 6, dpi = 300)


# 2) Buat data harian lintas tahun
df_harian <- harga_beras_nasional %>%
  mutate(
    tahun = year(tanggal),
    hari_ke = yday(tanggal)  # urutan hari ke-berapa dalam satu tahun (1–365)
  ) %>%
  group_by(tahun, hari_ke) %>%
  summarise(harga_mean = mean(harga_nasional, na.rm = TRUE), .groups = "drop")

# Plot pola musiman harian per tahun
ggplot(df_harian, aes(x = hari_ke, y = harga_mean, color = factor(tahun), group = tahun)) +
  geom_line(size = 0.8) +
  labs(title = "Pola Musiman Harian Harga Beras Nasional per Tahun",
       x = "Hari ke- (1–365)", y = "Harga Rata-rata (Rp/kg)", color = "Tahun") +
  theme_minimal() +
  theme(legend.position = "bottom")
ggsave("harga_nasional_per_tahun.png", width = 12, height = 6, dpi = 300)
