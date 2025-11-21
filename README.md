# 🍚 Prediksi Harga Beras Medium di Indonesia Menggunakan Metode ARIMA, SARIMA, dan LSTM

<img width="1100" height="350" alt="header project pemro" src="https://github.com/user-attachments/assets/cc96082d-6d0c-4db8-9c5e-1dbf19945447" />

## 📖 Deskripsi Proyek  
Proyek ini bertujuan untuk menganalisis dan membandingkan akurasi tiga metode peramalan deret waktu—**ARIMA, SARIMA, dan LSTM**—dalam memprediksi **harga beras medium di Indonesia**. Data yang digunakan berupa harga beras medium bulanan untuk periode Januari 2013–Oktober 2025, yang diperoleh dari situs resmi Badan Pusat Statistik (BPS). Melalui perbandingan ketiga model tersebut, proyek ini berupaya mengidentifikasi metode yang paling efektif dalam menangkap pola tren, musiman, serta dinamika non-linear pada harga beras. Hasil akhir diharapkan dapat mendukung penyusunan kebijakan stabilisasi harga pangan yang lebih responsif dan berbasis data.

_“Prediksi yang akurat hari ini, untuk ketahanan pangan esok hari.”_

---

## 🇮🇩 Latar Belakang   
Beras merupakan komoditas pangan strategis di Indonesia, sehingga fluktuasi harganya berdampak langsung pada daya beli masyarakat, inflasi, dan stabilitas kebijakan pangan. Data historis menunjukkan adanya tren kenaikan harga beras yang cukup tajam dengan pola musiman dan volatilitas yang meningkat. **Kondisi ini menuntut metode prediksi yang mampu menangkap dinamika tren, musiman, sekaligus pola non-linear**.

Model ARIMA telah lama digunakan untuk memodelkan pola tren dan autokorelasi jangka pendek pada deret waktu (Box, Jenkins, Reinsel, & Ljung, 2015). SARIMA kemudian menjadi perluasan yang relevan ketika pola musiman muncul secara konsisten. Sementara itu, model berbasis LSTM mampu mengenali hubungan non-linear dan ketergantungan jangka panjang yang tidak dapat ditangkap oleh metode statistik tradisional (Hochreiter & Schmidhuber, 1997; Greff et al., 2017). Dengan membandingkan ketiga pendekatan tersebut, penelitian ini bertujuan menentukan metode prediksi harga beras medium yang paling akurat untuk mendukung kebijakan pangan berbasis data.

---

## 🎯 Tujuan  
1. Menganalisis pola historis harga beras medium di Indonesia, termasuk tren jangka panjang, musiman tahunan, dan volatilitas yang meningkat, sebagai dasar untuk pemodelan deret waktu.
2. Membangun dan mengevaluasi model ARIMA, SARIMA, dan LSTM untuk memprediksi harga beras medium, dengan memperhatikan karakteristik data seperti tren kuat, pola musiman, serta kemungkinan hubungan non-linear.
3. Membandingkan performa ketiga model berdasarkan akurasi prediksi, terutama pada periode pengujian dan peramalan ke depan.
4. Menentukan model terbaik yang mampu memberikan prediksi harga beras paling akurat dan representatif terhadap dinamika data, sehingga dapat mendukung penyusunan kebijakan stabilisasi harga beras yang berbasis data.

---

## 📊 Sumber dan Metodologi Analisis Data  
**Sumber Data:**  
- Situs resmi Badan Pusat Statistik [https://www.bps.go.id/id/statistics-table/2/NTAwIzI=/rata-rata-harga-beras-bulanan-di-tingkat-penggilingan-menurut-kualitas.html]

**Langkah Analisis:**  
1. Persiapan dan Pembersihan Data:
   - Mengumpulkan data harga beras medium bulanan (Januari 2013–Oktober 2025) dari BPS.
   - Menyesuaikan format tanggal agar konsisten dan mengonversi ke objek _time series_ dengan frekuensi bulanan.
   - Memastikan tidak terdapat _missing value_ atau duplikasi.
2. Eksplorasi Data
   - Visualisasi pola tren jangka panjang, musiman tahunan, dan fluktuasi periodik.
   - Mengidentifikasi outlier dan potensi structural break.
   - Analisis sifat musiman menggunakan ACF, PACF, dan STL decomposition.
   - Uji stasioneritas (ADF test) untuk menilai apakah diperlukan differencing.
3. Pemisahan Data
   - Data periode Jan 2013 – Des 2023 digunakan sebagai training set.
   - Data periode Jan 2024 – Okt 2025 digunakan sebagai testing set.
   - Menetapkan horizon peramalan masa depan selama 12 bulan untuk prediksi 2025–2026.
4. Pemodelan ARIMA
   - Menjalankan auto.arima(train_ts, seasonal = FALSE) untuk menentukan orde optimal ARIMA (p, d, q) berdasarkan AICc.
   - Estimasi parameter dilakukan dengan Maximum Likelihood Estimation (MLE).
   - Menerapkan diagnostik residual (Ljung–Box, ACF/PACF residual, normalitas) untuk memastikan residual bersifat white noise.
   - Melakukan peramalan in-sample, out-of-sample (test), dan masa depan (2025–2026).
5. Pemodelan SARIMA
   - Menjalankan auto.arima(train_ts, seasonal = TRUE) untuk menangkap pola musiman bulanan (m = 12).
   - Fungsi otomatis menentukan orde terbaik (p, d, q)(P, D, Q)12 berdasarkan AICc dan diagnostik residual.
   - Estimasi parameter dilakukan dengan Maximum Likelihood Estimation (MLE).
   - Menerapkan diagnostik residual (Ljung–Box, ACF/PACF residual, normalitas) untuk memastikan residual bersifat white noise.
   - Melakukan peramalan in-sample, out-of-sample (test), dan masa depan (2025–2026).
6. Pemodelan LSTM
   - Normalisasi data menggunakan Min–Max scaling pada data berdasarkan training set saja untuk menghindari data leakage.
   - Membentuk dataset sekuensial (sliding window) untuk melatih model.
   - Membangun arsitektur LSTM (jumlah neuron, dropout, activation).
   - Kompilasi model (loss = MSE, optimizer = Adam) dan penerapan early stopping untuk mencegah overfitting.
   - Melatih model dengan validation split pada training set dan memonitor kurva training/validation loss.
   - Melakukan peramalan in-sample, out-of-sample (test) secara recursive, serta prediksi masa depan (2025–2026).
   - Mengembalikan skala prediksi ke satuan harga asli (inverse scaling).
7. Evaluasi Kinerja Model
   - Perbandingan model dilakukan menggunakan tiga ukuran kesalahan, yaitu RMSE, MAE, dan MAPE.
   - Menyajikan tabel perbandingan metrik dan plot prediksi vs aktual untuk masing-masing model.
8. Sintesis Hasil & Rekomendasi
   - Menentukan model dengan performa terbaik berdasarkan hasil _error metrics_.
   - Memberikan rekomendasi penggunaan model dalam operasional prediksi harga beras bulanan.

---

## 🧩 Diagram Alur Proyek

(Akan dibuat diagram alur proyek)

---

## 🧠 Teknologi dan Tools yang Digunakan  

| Kategori              | Tools / Library                                                                 |
|-----------------------|----------------------------------------------------------------------------------|
| Bahasa Pemrograman    | R                                                                                |
| Data Input / Output   | `readxl`, `readr`                                                                |
| Pengolahan Data       | `dplyr`, `tidyr`, `tibble`, `lubridate`                                          |
| Visualisasi Data      | `ggplot2`, `gridExtra` (indirect), base R                                        |
| Time Series Model     | `forecast` (ARIMA, SARIMA), `tseries` (ADF), `stats`                             |
| Deep Learning         | `keras`, `tensorflow`                                                            |
| Evaluasi Model        | `Metrics` (RMSE, MAE, MAPE)                                                      |
| Lainnya               | `base`, `cat`, dan fungsi utilitas bawaan R                                     |

---

## 🗂️ Struktur Proyek  

```
📂 Prediksi-Harga-Beras-Harian/
│
├── 📂 data/
│   ├── harga_beras_harian.csv          # Dataset harga beras harian (Agustus 2022–Juli 2025)
│   └── data_preprocessed.csv           # Data setelah preprocessing
│
├── 📂 scripts/
│   ├── arima_model.R                   # Script analisis & pemodelan ARIMA(level)
│   ├── sarima_model.R                  # Script analisis & pemodelan SARIMA(level)
│   ├── lstm_model.R                    # Script analisis & pemodelan LSTM(min-max scaling)
│   ├── evaluation_metrics.R            # Perhitungan RMSE, MAE, MAPE
│   └── visualization.R                 # Visualisasi tren, fitted, dan forecasting
│
├── 📂 outputs/
│   ├── arima_forecast.png              # Grafik hasil prediksi ARIMA
│   ├── sarima_forecast.png             # Grafik hasil prediksi SARIMA
│   ├── lstm_forecast.png               # Grafik hasil prediksi LSTM
│   ├── comparison_plot.png             # Perbandingan ketiga model (test + future)
│   └── model_evaluation.csv            # Tabel evaluasi performa model
│
├── 📂 results/                             # Folder hasil otomatis dari script final
│   ├── predictions_test_per_model_level.csv     # Prediksi test ARIMA/SARIMA/LSTM (level)
│   ├── forecast_future_per_model_level.csv      # Prediksi future 12 bulan
│   ├── metrics_test_level.csv                   # RMSE, MAE, MAPE
│   ├── arima_plot_level.png
│   ├── sarima_plot_level.png
│   ├── lstm_plot_level.png
│   └── compare_forecasts_level.png
│
├── 📂 assets/
│   └── header_beras.png                # Gambar header untuk README
│
├── README.md                           # Dokumentasi proyek utama
├── requirements.txt                    # Daftar library R yang digunakan
└── .gitignore                          # Mengabaikan data sensitif dan file besar
```

---

## 📦 Fitur Proyek
1. 📊 **Visualisasi Data**
   - Menampilkan grafik tren harga beras bulanan.
   - Analisis pola musiman, tren jangka panjang, serta identifikasi outlier menggunakan ggplot2.
   - Menyediakan visual eksploratif sebelum dilakukan pemodelan time series.
2. 🧹 **Preprocessing Data**
   - Membersihkan data dari missing values, duplikasi, dan nilai ekstrem.
   - Mengonversi data menjadi format time series bulanan untuk ARIMA, SARIMA, dan LSTM.
   - Menyimpan hasil preprocessing ke data_preprocessed.csv.
3. 📈 **Pemodelan ARIMA**
   - Membangun model ARIMA sesuai syntax-mu: ARIMA(2,2,0).
   - Menggunakan transformasi log() apabila diperlukan untuk stabilisasi varians.
   - Menyediakan plot hasil prediksi ARIMA dan evaluasinya.
   - Membandingkan performa ARIMA dengan SARIMA dan LSTM.
4. ❄️ **Pemodelan SARIMA**
   - Menentukan parameter optimal (p,d,q)(P,D,Q)m menggunakan auto.arima() dan pemeriksaan pola ACF/PACF.
   - Menangkap pola musiman bulanan dalam data harga beras.
   - Menghasilkan grafik prediksi SARIMA: sarima_forecast.png.
5. 🧠 **Pemodelan LSTM**
   - Membangun jaringan saraf LSTM menggunakan keras dan tensorflow.
   - Menggunakan windowing, min-max scaling, dan reshaping sesuai format input 3D.
   - Menangkap pola non-linear dan dependensi jangka panjang antar waktu.
   - Menghasilkan grafik prediksi LSTM: lstm_forecast.png.
6. 📐 **Evaluasi & Perbandingan Model**
   - Menghitung MAE, RMSE, dan MAPE melalui script evaluation_metrics.R.
   - Membandingkan tiga model sekaligus: ARIMA vs SARIMA vs LSTM.
   - Menyimpan tabel evaluasi di model_evaluation.csv.
   - Menyediakan visual perbandingan performa: comparison_plot.png.
7. 📊 **Visualisasi Hasil Prediksi**
   - Menampilkan overlay antara prediksi dan data aktual dalam grafik yang mudah dibaca.
   - Memberikan visual yang langsung menunjukkan model mana yang paling akurat.
   - Semua grafik disimpan di folder outputs/.
8. 📑 **Laporan & Rekomendasi**
   - Memberikan rekomendasi model prediksi terbaik berdasarkan performa jangka pendek.
   - Dokumentasi lengkap tersedia di README.md.
     
---

## 📊 Hasil dan Implementasi Fitur
### 1. 📊 Visualisasi Data Harian
- Grafik tren harga beras menunjukkan adanya **pola musiman** yang berulang setiap tahun dengan kenaikan harga pada awal dan akhir tahun.  
- Visualisasi interaktif membantu mengidentifikasi **outlier harian** dan periode harga stabil.  
- Tools: `ggplot2`, `plotly`, `dygraphs`

📈 *Contoh Output:*  ...

---

### 2. 🔍 Preprocessing Data
- Data mentah dari Bapanas dibersihkan dari **missing values dan duplikasi**.  
- Format tanggal dikonversi menjadi `Date` agar sesuai untuk analisis time series.  
- Hasil preprocessing disimpan dalam file ...

📁 *Output:* `...`

---

### 3. ⚙️ Pemodelan SARIMA
- Model terbaik diperoleh dengan parameter **(p, d, q)(P, D, Q)m = (1,1,1)(0,1,1)[7]** berdasarkan nilai **AIC terkecil**.  
- Hasil prediksi SARIMA menunjukkan **akurasi tinggi pada pola musiman** tetapi sedikit tertinggal pada perubahan mendadak harga.  
- Tools: `forecast`, `tseries`

📊 *Contoh Grafik Output:*  ...

---

### 4. 🧠 Pemodelan LSTM
- Model LSTM dengan **3 lapisan tersembunyi (hidden layers)** menghasilkan prediksi yang lebih adaptif terhadap fluktuasi harga harian.  
- Akurasi model meningkat setelah proses normalisasi dan optimisasi parameter epoch & batch size.  
- Tools: `keras`, `tensorflow`

📊 *Contoh Grafik Output:*  ...

---

### 5. 📈 Evaluasi dan Perbandingan Model
- Evaluasi dilakukan menggunakan metrik MAE, RMSE, MAPE, dan R².  
- Hasil menunjukkan **LSTM memiliki RMSE dan MAPE lebih rendah** dibandingkan SARIMA, menandakan performa prediksi yang lebih baik.  
- Tools: `Metrics`, `caret`

📊 *Tabel Perbandingan:* ...

---

### 6. 🖼️ Visualisasi Hasil Akhir
- Grafik perbandingan model menampilkan **prediksi vs aktual** secara bersamaan.  
- Hasil menunjukkan bahwa **LSTM** lebih cepat menyesuaikan terhadap perubahan harga mendadak.  
- Tools: `ggplot2`, `plotly`

📊 *Visualisasi Gabungan:*  ...

---

### 7. 📑 Laporan dan Rekomendasi
- Berdasarkan hasil pengujian, metode **LSTM** direkomendasikan untuk **prediksi harga beras harian jangka pendek**.  
- SARIMA tetap relevan untuk prediksi tren musiman jangka menengah.  
- Laporan akhir berisi analisis hasil, grafik, dan rekomendasi kebijakan berbasis data.

📁 *Output Laporan:* `...`

---

## 📚 Referensi

1. Badan Pusat Statistik. (2025). _Rata-Rata Harga Beras Bulanan di Tingkat Penggilingan Menurut Kualitas_. Diakses pada 22 November 2025, dari https://www.bps.go.id/id/statistics-table/2/NTAwIzI=/rata-rata-harga-beras-bulanan-di-tingkat-penggilingan-menurut-kualitas.html.
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
