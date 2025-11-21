# 🍚 Prediksi Harga Beras Harian di Indonesia Menggunakan Metode SARIMA dan LSTM

<img width="1100" height="350" alt="header project pemro" src="https://github.com/user-attachments/assets/cc96082d-6d0c-4db8-9c5e-1dbf19945447" />

## 📖 Deskripsi Proyek  
Proyek ini bertujuan untuk **membandingkan performa dua metode prediksi time series — SARIMA (Seasonal Autoregressive Integrated Moving Average) dan LSTM (Long Shot Term Memory) — dalam memperkirakan harga beras harian di Indonesia**.  Data yang digunakan adalah **harga harian beras medium** untuk periode **Agustus 2022–Juli 2025**, yang bersumber dari **Badan Pangan Nasional (Bapanas)** melalui situs [panelharga.badanpangan.go.id](https://panelharga.badanpangan.go.id). Diharapkan dapat diperoleh metode yang paling akurat terbaik untuk memprediksi harga beras guna mendukung kebijakan stabilitas harga pangan. _“Prediksi yang akurat hari ini, untuk ketahanan pangan esok hari.”_

---

## 🇮🇩 Latar Belakang   
Beras merupakan komoditas strategis untuk menjaga **ketahanan pangan dan stabilitas ekonomi nasional**. Fluktuasi harga beras harian berdampak signifikan terhadap **daya beli masyarakat**, **inflasi**, dan **kebijakan pangan nasional**. Faktor-faktor seperti kondisi cuaca, distribusi antar daerah, kebijakan impor, dan biaya transportasi memengaruhi dinamika harga beras. Prediksi harga berbasis data menjadi penting untuk mendeteksi perubahan harga secara cepat dan akurat.  
Metode **SARIMA** cocok untuk menangkap pola musiman dan tren jangka pendek dalam data time series (Box, Jenkins, & Reinsel, 2015). Sementara itu, **LSTM** memiliki kemampuan mengenali pola non-linear dan ketergantungan jangka panjang dalam data harian (Greff et al., 2017).
Dengan membandingkan dua metode ini, diharapkan proyek dapat memberikan **rekomendasi model terbaik** untuk prediksi harga beras harian dan mendukung kebijakan pangan yang berbasis data.

---

## 🎯 Tujuan  
1. Menganalisis pola fluktuasi harga beras harian di Indonesia periode Agustus 2022–Juli 2025.  
2. Membangun dua model prediksi — SARIMA dan LSTM — menggunakan data harian.  
3. Membandingkan performa kedua model berdasarkan metrik evaluasi **MAE, RMSE, MAPE, dan R²**.  
4. Menentukan metode paling efektif untuk prediksi harga beras jangka pendek (harian).  
5. Memberikan rekomendasi berbasis data untuk pemantauan dan stabilisasi harga pangan nasional.

---

## 📊 Sumber dan Metodologi Analisis Data  
**Sumber Data:**  
- Badan Pangan Nasional (Bapanas) – Panel Harga Pangan: [panelharga.badanpangan.go.id](https://panelharga.badanpangan.go.id)  

**Langkah Analisis:**  
1. Pengumpulan data harga beras medium harian Agustus 2022–Juli 2025.  
2. Integrasi dan preprocessing data untuk memastikan kelengkapan dan konsistensi.  
3. Eksplorasi data: visualisasi tren musiman, outlier, dan korelasi.  
4. Penerapan model SARIMA dengan pemilihan parameter optimal (p, d, q)(P, D, Q)m.  
5. Pembangunan model LSTM dengan arsitektur yang dioptimalkan untuk data time series.  
6. Evaluasi performa model menggunakan MAE, RMSE, MAPE, dan koefisien determinasi (R²).  
7. Interpretasi hasil dan rekomendasi metode terbaik untuk prediksi harga beras.

---

## 🧩 Diagram Alur Proyek

(Akan dibuat diagram alur proyek)

---

## 🧠 Teknologi dan Tools yang Digunakan  

| Kategori           | Tools / Library                                |
|--------------------|-----------------------------------------------|
| Bahasa Pemrograman  | R                                             |
| Time Series Analisis| `forecast`, `tseries`, `stats`, `keras`, `tensorflow` |
| Visualisasi Data    | `ggplot2`, `plotly`, `dygraphs`               |
| Pengelolaan Data    | `dplyr`, `tidyr`, `readr`                      |
| Evaluasi Model      | MAE, RMSE, MAPE, R²                            |

---

## 🗂️ Struktur Proyek  

Prediksi-Harga-Beras-Harian/
├── 📁 data/  
│   ├── harga_beras_harian.csv                # Dataset harga beras harian (Agustus 2022–Juli 2025)  
│   └── data_preprocessed.csv                 # Data setelah preprocessing  
│
├── 📁 scripts/  
│   ├── sarima_model.R                        # Script analisis dan pemodelan SARIMA  
│   ├── lstm_model.R                          # Script analisis dan pemodelan LSTM  
│   ├── evaluation_metrics.R                  # Perhitungan MAE, RMSE, MAPE, R²  
│   └── visualization.R                       # Visualisasi tren dan hasil prediksi  
│
├── 📁 outputs/  
│   ├── sarima_forecast.png                   # Grafik hasil prediksi SARIMA  
│   ├── lstm_forecast.png                     # Grafik hasil prediksi LSTM  
│   ├── comparison_plot.png                   # Perbandingan kedua model  
│   └── model_evaluation.csv                  # Hasil evaluasi performa model  
│
├── 📁 assets/  
│   └── header_beras.png                      # Gambar header untuk README  
│
├── README.md                                 # Dokumentasi proyek utama  
├── requirements.txt                          # (opsional) daftar library R yang digunakan  
└── .gitignore                                # File untuk mengabaikan data sensitif / besar

---

## 📦 Fitur Proyek
1. 📊 **Visualisasi Data Harian**
   - Menampilkan grafik tren harga beras harian dari Agustus 2022–Juli 2025.
   - Analisis pola musiman, tren, dan deteksi outlier menggunakan `ggplot2` dan `plotly`.
2. 🔍 **Preprocessing Data**
   - Membersihkan data mentah dari nilai kosong (missing values) dan duplikasi.
   - Transformasi data menjadi format time series yang siap dipakai untuk pemodelan.
3. ⚙️ **Pemodelan SARIMA**
   - Menentukan parameter optimal (p, d, q)(P, D, Q)m.
   - Menganalisis pola musiman dan tren jangka pendek dengan library `forecast`.
4. 🧠 **Pemodelan LSTM**
   - Membangun model berbasis jaringan saraf berulang menggunakan `keras` dan `tensorflow`.
   - Menangkap hubungan non-linear dan dependensi jangka panjang antar waktu.
5. 📈 **Evaluasi dan Perbandingan Model**
   - Menghitung metrik performa seperti MAE, RMSE, MAPE, dan R².
   - Membandingkan akurasi hasil prediksi antara SARIMA dan LSTM.
6. 🖼️ **Visualisasi Hasil Prediksi**
   - Menampilkan hasil prediksi vs data aktual dalam grafik interaktif.
   - Menyediakan visual perbandingan performa antara kedua metode.
7. 📑 **Laporan dan Rekomendasi**
   - Menyajikan hasil akhir analisis dalam format tabel, grafik, dan kesimpulan.
   - Memberikan rekomendasi metode terbaik untuk prediksi harga beras jangka pendek.

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

1. Badan Pangan Nasional (Bapanas). Panel Harga Pangan. [https://panelharga.badanpangan.go.id](https://panelharga.badanpangan.go.id).
2. Box, G. E. P., Jenkins, G. M., Reinsel, G. C., & Ljung, G. M. (2015). *Time Series Analysis: Forecasting and Control* (5th ed.). Wiley.  
3. Greff, K., Srivastava, R. K., Koutník, J., Steunebrink, B. R., & Schmidhuber, J. (2017). LSTM: A Search Space Odyssey. *IEEE Transactions on Neural Networks and Learning Systems*, 28(10), 2222-2232.  
4. Hochreiter, S., & Schmidhuber, J. (1997). Long Short-Term Memory. *Neural Computation*, 9(8), 1735-1780.  
5. Hyndman, R. J., & Athanasopoulos, G. (2018). *Forecasting: Principles and Practice* (2nd ed.). OTexts. Available at: https://otexts.com/fpp3/.
6. Zhang, G., Patuwo, B. E., & Hu, M. Y. (1998). Forecasting with artificial neural networks: The state of the art. *International Journal of Forecasting*, 14(1), 35-62.  

---

## 👥 Anggota Kelompok  
- [Nur Aulia Maknunah](https://github.com/nurauliamaknunah) (M0501251009)
- [Inria Purwaningsih](https://github.com/inriap8) (M0501251025)
- [Markazul Adabiyah](https://github.com/markazuladabiyah) (M0501251035)
- [Viren Marcellya Clarenda Siboro](https://github.com/virenmarcellya12) (M0501251047)
- [Muhammad Hanif Nafiis](https://github.com/HanifNaf) (M0501251055)
