# 🍚 Prediksi Harga Beras Medium di Indonesia Menggunakan Metode ARIMA, SARIMA, dan LSTM

<img width="1100" height="350" alt="header project pemro" src="https://github.com/user-attachments/assets/cc96082d-6d0c-4db8-9c5e-1dbf19945447" />

## 📖 Deskripsi Proyek  
Proyek ini menganalisis dan membandingkan akurasi tiga metode peramalan deret waktu—**ARIMA, SARIMA, dan LSTM**—dalam memprediksi **harga beras medium di Indonesia** menggunakan data bulanan Januari 2013–Oktober 2025 dari BPS. Tujuan utamanya adalah mengidentifikasi model yang paling efektif dalam menangkap tren jangka panjang, pola musiman, dan dinamika non-linear pada harga beras.
Hasil analisis diharapkan dapat memberikan dasar yang lebih kuat bagi perumusan kebijakan stabilisasi harga pangan berbasis data.

_“Prediksi yang akurat hari ini untuk ketahanan pangan esok hari.”_

---

## 🇮🇩 Latar Belakang   
Beras merupakan komoditas pangan strategis di Indonesia karena perannya yang langsung memengaruhi daya beli masyarakat, inflasi, dan stabilitas kebijakan pangan nasional. Pergerakan harga beras dalam satu dekade terakhir menunjukkan adanya tren kenaikan yang dibarengi pola musiman serta volatilitas yang cukup tinggi, sehingga menuntut metode peramalan yang lebih adaptif terhadap dinamika tersebut.

Model ARIMA telah menjadi pendekatan klasik yang efektif dalam menangkap autokorelasi dan tren jangka pendek pada deret waktu (Box et al., 2015). Ketika struktur musiman terdeteksi, model SARIMA menjadi perluasan yang relevan untuk memodelkan pola berulang dalam data. Di sisi lain, model berbasis jaringan saraf seperti Long Short-Term Memory (LSTM) menawarkan kemampuan untuk mengenali hubungan non-linear dan ketergantungan jangka panjang yang sering tidak tertangkap oleh model statistik tradisional (Hochreiter & Schmidhuber, 1997; Greff et al., 2017).

Dengan membandingkan ketiga pendekatan tersebut, penelitian ini bertujuan mengidentifikasi metode prediksi harga beras yang paling akurat dan mampu menggambarkan dinamika kompleks pasar beras Indonesia.

---

## 🎯 Tujuan  
1. Menganalisis pola historis harga beras medium di Indonesia, meliputi tren jangka panjang, pola musiman, dan dinamika volatilitas
2. Membangun dan mengevaluasi model ARIMA, SARIMA, dan LSTM dalam memprediksi harga beras medium berdasarkan karakteristik deret waktunya
3. Menentukan model prediksi yang paling akurat dan paling representatif terhadap dinamika harga beras medium
4. Menghasilkan proyeksi harga beras medium untuk 12 bulan ke depan menggunakan model terbaik

---

## 📊 Data dan Variabel  

<img width="200" height="200" alt="LOGO BPS" src="https://github.com/user-attachments/assets/ca492381-5db4-4498-b4a6-62c22ad27207" />

**Variabel:** harga beras medium bulanan dari Januari 2013 s.d. Oktober 2025

---

## 💡 Metodologi
<p align="center">
  <img width="3000" height="2000" alt="Blank diagram (2)" src="https://github.com/user-attachments/assets/67d4c68d-6b22-46f1-8a76-0a4eecf54b66" />
<p align="center"><i>Gambar 1. Flowchart Metode Prediksi Harga Beras Medium di Indonesia</i></p>

---

## 📝 Prosedur Analisis
**1. Pengumpulan dan Persiapan Data**
- Mengumpulkan data harga beras medium bulanan periode Januari 2013–Oktober 2025
- Memastikan konsistensi format tanggal
- Menghapus inkonsistensi dan memastikan data siap dianalisis sebagai deret waktu
  
**2. Transformasi dan Pra-pengolahan**
- Menerapkan transformasi logaritmik untuk menstabilkan varians dan mengurangi heteroskedastisitas
- Melakukan normalisasi min–maks khusus untuk model LSTM
  
**3. Pembentukan Deret Waktu dan Pembagian Data**
- Mengonversi data menjadi objek deret waktu dengan frekuensi bulanan
- Membagi data menjadi:
  - **Training set:** Jan 2013 – Des 2023
  - **Test set:** Jan 2024 – Okt 2025
  
**4. Eksplorasi Data**
- Menampilkan statistik deskriptif awal seperti nilai minimum, maksimum, rata-rata, dan tren umum harga
- Membuat visualisasi deret waktu untuk mengidentifikasi tren jangka panjang
- Memeriksa kestasioneran awal dengan:
  - Plot ACF dan PACF harga asli dan harga log
  - Pemeriksaan visual perubahan varians sebelum dan sesudah transformasi log
- Mengidentifikasi potensi outlier atau perubahan struktural pada grafik deret waktu
- Mengevaluasi pola musiman secara visual berdasarkan puncak dan lembah yang berulang tahunan
  
**5. Pemodelan ARIMA (Log)**
- Mengestimasi model ARIMA log menggunakan fungsi `auto.arima()` untuk pemilihan orde (p, d, q) secara otomatis berdasarkan AIC/AICc/BIC
- Setelah model terpilih, dilakukan estimasi parameter dan diagnostik residual (ACF residual, uji Ljung–Box, uji normalitas) untuk memastikan asumsi white-noise terpenuhi
  
**6. Pemodelan SARIMA (Log)**
- Menggunakan fungsi `auto.arima(..., seasonal = TRUE)` untuk menangkap pola musiman. Pemilihan komponen musiman (P, D, Q, s) dilakukan otomatis oleh algoritma
- Model SARIMA yang dihasilkan dievaluasi melalui AIC/AICc/BIC dan diuji diagnostik residual (khususnya autocorrelation pada lag musiman dan non-musiman)
  
**7. Pemodelan LSTM (Log)**
- Menyiapkan dataset dalam format supervised (sequence-to-one)
- Melakukan normalisasi min–maks pada data
- Membentuk jendela sliding window untuk input jaringan
- Melatih model LSTM untuk mempelajari pola non-linier harga
- Memantau training loss dan validation loss untuk menghindari overfitting
- Melakukan inverse normalization pada hasil prediksi
  
**8. Evaluasi Kinerja Model**
- Menghitung RMSE, MAE, dan MAPE pada test set
- Melakukan evaluasi visual antara nilai aktual dan prediksi
- Membandingkan performa ARIMA(log), SARIMA(log), dan LSTM
  
**9. Peramalan Periode Mendatang**
- Memilih model dengan performa terbaik pada test set
- Melakukan peramalan ke depan (November 2025 - Oktober 2026) dengan menggunakan model terbaik
  
---

## 🧠 Teknologi dan Tools yang Digunakan  

| **Kategori**               | **Tools / Library** |
|---------------------------|----------------------|
| **Bahasa Pemrograman**    | R |
| **Data Input / Output**   | `readxl`, `readr`, `write_csv` |
| **Pengolahan Data**       | `dplyr`, `tidyr`, `tibble`, `lubridate`, `zoo` |
| **Visualisasi Data**      | `ggplot2`, `acf`, `pacf`, `stl`, *base R plotting* |
| **Model Deret Waktu**     | `forecast` (ARIMA, SARIMA, `auto.arima`, `forecast`, `checkresiduals`), `tseries` (`adf.test`, `jarque.bera.test`), `stats` (fungsi dasar time series) |
| **Deep Learning**         | `keras`, `tensorflow` |
| **Evaluasi Model**        | `Metrics` (RMSE, MAE, MAPE) |
| **Transformasi & Scaling**| `log()`, `exp()`, normalisasi *min–max* manual |

---

## 🗂️ Struktur Proyek  

```
forecast-harga-beras/
│
├── data/
│   ├── Data Harga Beras 2013-2025.xlsx
│   └── harga_beras_clean.xlsx                 # hasil cleaning tanggal
│
├── R/
│   ├── 01_load_clean_preprocess.R             # load, cleaning, tambah log
│   ├── 02_make_ts_and_split.R                 # ts(), window(), train/test
│   ├── 03_arima_log.R                         # ARIMA(log) + residual check
│   ├── 04_sarima_log.R                        # SARIMA(log) + residual check
│   ├── 05_lstm_log.R                          # LSTM (log + min-max)
│   ├── 06_forecast_each_model.R               # gabungkan semua forecast
│   ├── 07_plot_compare_models.R               # visualisasi perbandingan model
│   └── 08_export_results.R                    # export CSV & PNG
│
├── models/
│   ├── arima_model_log.rds
│   ├── sarima_model_log.rds
│   └── lstm_model_log.h5
│
├── plots/
│   ├── eda/
│   │   ├── ts_plot_level.png
│   │   ├── ts_plot_log.png
│   │   ├── stl_decomposition_log.png
│   │   ├── seasonal_boxplot_log.png
│   │   ├── acf_pacf_level_log.png
│   │   ├── acf_pacf_diff1_log.png
│   │   └── acf_pacf_diff1_D1_log.png
│   ├── arima/
│   │   ├── arima_residual_check.png
│   │   ├── arima_acf_pacf_residual.png
│   │   └── arima_evaluation_plot.png
│   ├── sarima/
│   │   ├── sarima_residual_check.png
│   │   ├── sarima_acf_pacf_residual.png
│   │   └── sarima_evaluation_plot.png
│   ├── lstm/
│   │   ├── lstm_loss_curve.png
│   │   └── lstm_evaluation_plot.png
│   └── compare/
│       ├── compare_evaluation_forecast.png
│       └── final_forecast_lstm.png
│
├── results/
│   ├── descriptive_stats_harga_asli.csv
│   ├── outliers_identified_dates.csv
│   ├── predictions_test_per_model_log.csv
│   ├── metrics_test_log.csv
│   └── final_forecast_model_terbaik.csv
│
└── run_all.R

```
---

## ⭐ Fitur Proyek
1. Identifikasi tren harga beras medium di Indonesia
2. Pembangunan model peramalan harga beras medium dengan ARIMA, SARIMA, dan LSTM
3. Evaluasi model dengan menggunakan metrik RMSE, MAE, dan MAPE
4. Visualisasi hasil peramalan harga beras bulan November 2025 s.d Oktober 2026 dengan model terbaik
     
---

## 📊 Cuplikan Visual
<p align="center">
  <img width="3000" height="1500" alt="ts_plot_level" src="https://github.com/user-attachments/assets/a191d11e-abb3-47a3-8222-47c604bae256" />
<p align="center"><i>Gambar 2. Tren Harga Beras Medium di Indonesia</i></p>

<p align="center">
  <img width="3600" height="1800" alt="compare_evaluation_forecasts" src="https://github.com/user-attachments/assets/9bb42580-be7e-4266-abfb-30134d371c4c" />
<p align="center"><i>Gambar 3. Pemodelan Harga Beras Medium dengan ARIMA, SARIMA, dan LSTM</i></p>

<p align="center">
  <img width="3600" height="1800" alt="final_forecast_lstm" src="https://github.com/user-attachments/assets/df9afd80-9a34-4302-b665-cc46d43b9531" />
<p align="center"><i>Gambar 4. Hasil Peramalan Harga Beras Medium Bulan November 2025-Oktober 2026 (Model Terbaik)</i></p>

---

## 🔬 Evaluasi Model Terbaik
```
  Model        RMSE   MAE   MAPE
  <chr>       <dbl> <dbl>  <dbl>
1 ARIMA(log)  1064. 1016. 0.0796
2 SARIMA(log) 1549. 1393. 0.109 
3 LSTM(log)    968.  779. 0.0589
```
  
---

## 📚 Referensi

1. Badan Pusat Statistik. (2025). _Rata-Rata Harga Beras Bulanan di Tingkat Penggilingan Menurut Kualitas_. Diakses pada 15 November 2025, dari https://www.bps.go.id/id/statistics-table/2/NTAwIzI=/rata-rata-harga-beras-bulanan-di-tingkat-penggilingan-menurut-kualitas.html.
2. Box, G. E. P., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M. (2015). *Time Series Analysis: Forecasting and Control* (5th ed.). Wiley.  
3. Greff, K., Srivastava, R. K., Koutník, J., Steunebrink, B. R., & Schmidhuber, J. (2017). LSTM: A Search Space Odyssey. *IEEE Transactions on Neural Networks and Learning Systems*, 28(10), 2222-2232.  
4. Hochreiter, S., & Schmidhuber, J. (1997). Long Short-Term Memory. *Neural Computation*, 9(8), 1735-1780.  

---

## 👥 Anggota Kelompok  
- [Nur Aulia Maknunah](https://github.com/nurauliamaknunah) (M0501251009)
- [Inria Purwaningsih](https://github.com/inriap8) (M0501251025)
- [Markazul Adabiyah](https://github.com/markazuladabiyah) (M0501251035)
- [Viren Marcellya Clarenda Siboro](https://github.com/virenmarcellya12) (M0501251047)
- [Muhammad Hanif Nafiis](https://github.com/HanifNaf) (M0501251055)
