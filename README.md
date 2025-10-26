# 🍚 Prediksi Harga Beras Harian di Indonesia Menggunakan Metode SARIMA dan LSTM

<img width="1100" height="350" alt="header project pemro" src="https://github.com/user-attachments/assets/cc96082d-6d0c-4db8-9c5e-1dbf19945447" />

## 📖 Deskripsi Proyek  
Proyek ini bertujuan untuk **membandingkan performa dua metode prediksi time series — SARIMA (Seasonal Autoregressive Integrated Moving Average) dan LSTM (Long Shot Term Memory) — dalam memperkirakan harga beras harian di Indonesia**.  Data yang digunakan adalah **harga harian beras medium** untuk periode **Januari 2022–Desember 2024**, yang bersumber dari **Badan Pangan Nasional (Bapanas)** melalui situs [panelharga.badanpangan.go.id](https://panelharga.badanpangan.go.id). Diharapkan dapat diperoleh metode yang paling akurat terbaik untuk memprediksi harga beras guna mendukung kebijakan stabilitas harga pangan. _“Prediksi yang akurat hari ini, untuk ketahanan pangan esok hari.”_

---

## 🇮🇩 Latar Belakang   
Beras merupakan komoditas strategis untuk menjaga **ketahanan pangan dan stabilitas ekonomi nasional**. Fluktuasi harga beras harian berdampak signifikan terhadap **daya beli masyarakat**, **inflasi**, dan **kebijakan pangan nasional**. Faktor-faktor seperti kondisi cuaca, distribusi antar daerah, kebijakan impor, dan biaya transportasi memengaruhi dinamika harga beras. Prediksi harga berbasis data menjadi penting untuk mendeteksi perubahan harga secara cepat dan akurat.  
Metode **SARIMA** cocok untuk menangkap pola musiman dan tren jangka pendek dalam data time series (Box, Jenkins, & Reinsel, 2015). Sementara itu, **LSTM** memiliki kemampuan mengenali pola non-linear dan ketergantungan jangka panjang dalam data harian (Greff et al., 2017).
Dengan membandingkan dua metode ini, diharapkan proyek dapat memberikan **rekomendasi model terbaik** untuk prediksi harga beras harian dan mendukung kebijakan pangan yang berbasis data.

---

## 🎯 Tujuan  
1. Menganalisis pola fluktuasi harga beras harian di Indonesia periode 2022–2024.  
2. Membangun dua model prediksi — SARIMA dan LSTM — menggunakan data harian.  
3. Membandingkan performa kedua model berdasarkan metrik evaluasi **MAE, RMSE, MAPE, dan R²**.  
4. Menentukan metode paling efektif untuk prediksi harga beras jangka pendek (harian).  
5. Memberikan rekomendasi berbasis data untuk pemantauan dan stabilisasi harga pangan nasional.

---

## 📊 Sumber dan Metodologi Analisis Data  
**Sumber Data:**  
- Badan Pangan Nasional (Bapanas) – Panel Harga Pangan: [panelharga.badanpangan.go.id](https://panelharga.badanpangan.go.id)  

**Langkah Analisis:**  
1. Pengumpulan data harga beras medium harian Januari 2022–Desember 2024.  
2. Integrasi dan preprocessing data untuk memastikan kelengkapan dan konsistensi.  
3. Eksplorasi data: visualisasi tren musiman, outlier, dan korelasi.  
4. Penerapan model SARIMA dengan pemilihan parameter optimal (p, d, q)(P, D, Q)m.  
5. Pembangunan model LSTM dengan arsitektur yang dioptimalkan untuk data time series.  
6. Evaluasi performa model menggunakan MAE, RMSE, MAPE, dan koefisien determinasi (R²).  
7. Interpretasi hasil dan rekomendasi metode terbaik untuk prediksi harga beras.

---

## 🧩 Diagram Alur Proyek

ddd

---

## 🧠 Teknologi dan Tools Digunakan  

| Kategori           | Tools / Library                                |
|--------------------|-----------------------------------------------|
| Bahasa Pemrograman  | R                                             |
| Time Series Analisis| `forecast`, `tseries`, `stats`, `keras`, `tensorflow` |
| Visualisasi Data    | `ggplot2`, `plotly`, `dygraphs`               |
| Pengelolaan Data    | `dplyr`, `tidyr`, `readr`                      |
| Evaluasi Model      | MAE, RMSE, MAPE, R²                            |

---

## 📈 Hasil yang Diharapkan dan Rencana Output  
- Grafik visualisasi tren harga beras harian 2022–2024  
- Model SARIMA dan LSTM dengan parameter terbaik  
- Tabel dan grafik perbandingan performa model dalam metrik evaluasi  
- Laporan analisis mendalam prediksi harga beras 2025  
- Rekomendasi model terbaik yang dapat digunakan oleh pemangku kebijakan

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
