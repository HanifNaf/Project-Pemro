# 🍚 Prediksi Harga Beras Medium di Indonesia Menggunakan Metode ARIMA, SARIMA, dan LSTM

<img width="1100" height="350" alt="header project pemro" src="https://github.com/user-attachments/assets/cc96082d-6d0c-4db8-9c5e-1dbf19945447" />

## 📖 Deskripsi Proyek  
Proyek ini bertujuan untuk menganalisis dan membandingkan akurasi tiga metode peramalan deret waktu—**ARIMA, SARIMA, dan LSTM**—dalam memprediksi **harga beras medium di Indonesia**. Data yang digunakan berupa harga beras medium bulanan untuk periode Januari 2013–Oktober 2025, yang diperoleh dari situs resmi Badan Pusat Statistik (BPS).
Melalui perbandingan ketiga model tersebut, proyek ini berupaya mengidentifikasi pendekatan yang paling efektif dalam menangkap tren jangka panjang, pola musiman, serta dynamika non-linear pada harga beras. Hasil akhir diharapkan dapat mendukung penyusunan kebijakan stabilisasi harga pangan yang lebih responsif dan berbasis bukti.

_“Prediksi yang akurat hari ini, untuk ketahanan pangan esok hari.”_

---

## 🇮🇩 Latar Belakang   
Beras merupakan komoditas pangan strategis di Indonesia. Fluktuasi harganya memiliki dampak langsung terhadap daya beli masyarakat, inflasi, serta stabilitas kebijakan pangan nasional. Data historis menunjukkan adanya tren kenaikan harga, disertai pola musiman tahunan dan volatilitas harga yang semakin meningkat. Kondisi ini menuntut penggunaan metode prediksi yang mampu menangkap dinamika yang kompleks tersebut.

Model ARIMA telah lama menjadi standar dalam pemodelan deret waktu karena kemampuannya mengakomodasi autokorelasi dan tren jangka pendek (Box, Jenkins, Reinsel, & Ljung, 2015). Ketika pola musiman terdeteksi secara konsisten, model SARIMA menjadi pilihan yang relevan sebagai perluasannya. Sementara itu, pendekatan berbasis jaringan saraf seperti LSTM mampu mengenali hubungan non-linear dan ketergantungan jangka panjang yang sulit ditangkap oleh model statistik tradisional (Hochreiter & Schmidhuber, 1997; Greff et al., 2017).

Dengan membandingkan ketiga pendekatan ini, penelitian ini bertujuan mengidentifikasi metode prediksi harga beras yang paling akurat dan adaptif terhadap dinamika data.

---

## 🎯 Tujuan  
1. Menganalisis pola historis harga beras medium, termasuk tren jangka panjang, pola musiman tahunan, dan perubahan volatilitas, sebagai dasar pemodelan deret waktu.
2. Membangun dan mengevaluasi model ARIMA, SARIMA, dan LSTM untuk memprediksi harga beras medium, dengan mempertimbangkan karakteristik data yang mencakup tren, musiman, dan potensi hubungan non-linear.
3. Membandingkan performa ketiga model berdasarkan akurasi prediksi pada periode pengujian serta kemampuan generalisasi untuk peramalan ke depan.
4. Menentukan model terbaik yang mampu memberikan prediksi harga beras paling akurat dan representatif terhadap dinamika historis, sehingga dapat digunakan sebagai dasar penyusunan kebijakan stabilisasi harga yang lebih berbasis data.

---

## 📊 Sumber dan Metodologi Analisis Data  
**Sumber Data:**  
- Situs resmi Badan Pusat Statistik [https://www.bps.go.id/id/statistics-table/2/NTAwIzI=/rata-rata-harga-beras-bulanan-di-tingkat-penggilingan-menurut-kualitas.html]

**Langkah Analisis:**  
1. Persiapan Data: Mengimpor dan membersihkan data harga beras bulanan dari BPS, memastikan konsistensi format tanggal, serta mengonversinya ke dalam struktur deret waktu dengan frekuensi bulanan.
2. Eksplorasi Data: Melakukan eksplorasi awal untuk mengidentifikasi tren jangka panjang, pola musiman tahunan, serta dinamika volatilitas harga sebagai dasar pemilihan metode pemodelan.
3. Pembagian Data: Memisahkan data menjadi bagian pelatihan (2013–2023) dan pengujian (2024–2025) guna mengevaluasi kinerja model secara objektif.
4. Pemodelan ARIMA: Mengestimasi model ARIMA untuk menangkap komponen tren dan autokorelasi jangka pendek, disertai evaluasi diagnostik residual untuk memverifikasi kecocokan model.
5. Pemodelan SARIMA: Membangun model SARIMA guna mengakomodasi pola musiman yang teridentifikasi dan memastikan bahwa karakteristik musiman terwakili dalam model.
6. Pemodelan LSTM: Menerapkan jaringan LSTM untuk memodelkan pola non-linear dan ketergantungan jangka panjang melalui normalisasi data, pembentukan input berurutan, dan pelatihan jaringan.
7. Evaluasi Model: Menilai performa ketiga model pada data pengujian menggunakan metrik akurasi seperti RMSE dan MAE, serta melakukan perbandingan formal antar model.
8. Pemilihan Model dan Peramalan: Menentukan model dengan akurasi terbaik dan menggunakannya untuk menghasilkan proyeksi harga beras ke depan, beserta interpretasi hasil peramalan.

---

## 🧩 Diagram Alur Proyek
<img width="3636" height="2582" alt="Blank diagram (2)" src="https://github.com/user-attachments/assets/67d4c68d-6b22-46f1-8a76-0a4eecf54b66" />

---

## 🧠 Teknologi dan Tools yang Digunakan  

| **Kategori**           | **Tools / Library** |
|------------------------|----------------------|
| **Bahasa Pemrograman** | R |
| **Data Input / Output** | `readxl`, `readr`, `write_csv` |
| **Pengolahan Data** | `dplyr`, `tidyr`, `tibble`, `lubridate`, `zoo` |
| **Visualisasi Data** | `ggplot2`, `ggfortify`, `acf`, `pacf`, *base R plotting* |
| **Model Deret Waktu** | `forecast` (ARIMA, SARIMA, `auto.arima`, `forecast`, `checkresiduals`), `tseries` (ADF test), `stats` (fungsi dasar time series) |
| **Deep Learning** | `keras`, `tensorflow` |
| **Evaluasi Model** | `Metrics` (RMSE, MAE, MAPE) |
| **Lainnya** | `cat`, fungsi utilitas bawaan base R |

---

## 🗂️ Struktur Proyek  

```

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
