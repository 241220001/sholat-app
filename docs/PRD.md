# PRD — Tuntunan Tata Cara Sholat
**Versi:** 1.0  
**Tanggal:** 2026  
**Mata Kuliah:** AIK 4  
**Institusi:** Program Studi Manajemen Bisnis Syariah · Fakultas Agama Islam · Universitas Muhammadiyah Pontianak  
**Dosen Pengampu:** Dedy Susanto, S.Pd.I., M.M. (NIDN. 1128048303)

---

## Daftar Isi

1. [Ringkasan Produk](#1-ringkasan-produk)
2. [Pengguna](#2-pengguna)
3. [Fitur Fungsional](#3-fitur-fungsional-f-01--f-09)
4. [Kebutuhan Non-Fungsional](#4-kebutuhan-non-fungsional)
5. [Arsitektur Sistem](#5-arsitektur-sistem)
6. [Data Model](#6-data-model)
7. [Konten — 13 Gerakan Sholat](#7-konten--13-gerakan-sholat)
8. [Halaman & Komponen](#8-halaman--komponen)
9. [API Endpoint](#9-api-endpoint)
10. [Stack Teknologi](#10-stack-teknologi)
11. [Struktur Folder](#11-struktur-folder)
12. [Timeline](#12-timeline)
13. [Peran Tim](#13-peran-tim)
14. [Definition of Done](#14-definition-of-done)
15. [Risiko & Mitigasi](#15-risiko--mitigasi)
16. [Rubrik Penilaian](#16-rubrik-penilaian)
17. [Referensi](#17-referensi)

---

## 1. Ringkasan Produk

Aplikasi web edukasi tata cara sholat sesuai sunnah Rasulullah ﷺ dengan rujukan gerakan dan bacaan dari **Himpunan Putusan Tarjih (HPT) Muhammadiyah**.

Aplikasi dirancang untuk dua segmen pengguna — **Dewasa** dan **Anak-anak** — dikerjakan secara berkelompok menggunakan pendekatan Project-Based Learning (PjBL), dan menjadi **dasar penilaian UAS (100%)**.

| Atribut | Nilai |
|---------|-------|
| Tipe produk | Aplikasi web responsif (edukasi ibadah) |
| Sumber konten | HPT Muhammadiyah, Kitab Shalat |
| Mode pengguna | Dewasa (formal, lengkap) · Anak (visual, ringkas) |
| Arsitektur | 3 lapis: Frontend · Backend · Database |
| Deployment | Wajib online dengan URL publik aktif |
| Repositori | GitHub kelompok (commit tiap anggota terlacak) |

---

## 2. Pengguna

| Segmen | Karakteristik | Kebutuhan Utama |
|--------|--------------|-----------------|
| **Dewasa** | Umum, mahasiswa, orang tua | Teks Arab lengkap, transliterasi Latin, terjemahan, sumber HPT, audio |
| **Anak-anak** | Usia sekolah dasar | Ilustrasi ramah anak, bahasa sederhana, terjemahan ringkas, visual menarik |

---

## 3. Fitur Fungsional (F-01 → F-09)

| Kode | Nama Fitur | Deskripsi | Prioritas |
|------|-----------|-----------|-----------|
| F-01 | Daftar gerakan | 13 gerakan urut qiyam → salam, dapat diklik | P0 |
| F-02 | Detail gerakan | Gambar gerakan + bacaan Arab / Latin / terjemahan | P0 |
| F-03 | Audio player | Pemutar MP3 untuk setiap bacaan | P0 |
| F-04 | Opsi video | Tombol tampilkan video gerakan / bacaan (modal / embed) | P0 |
| F-05 | Navigasi Next / Previous | Berpindah maju / mundur antar gerakan dan bacaan | P0 |
| F-06 | Autoplay berurutan | Memutar gerakan + audio otomatis sesuai urutan | P0 |
| F-07 | Toggle mode | Pilihan mode Dewasa / Anak yang mengubah penyajian konten | P0 |
| F-08 | Header identitas | Nama Kelompok, Prodi, Mata Kuliah, Dosen di tiap halaman utama | P0 |
| F-09 | Konten dari DB | Data diambil dari basis data, bukan hardcode di HTML | P0 |

> **Semua fitur berstatus P0 — wajib berjalan saat penilaian UAS.**

---

## 4. Kebutuhan Non-Fungsional

| Aspek | Ketentuan |
|-------|-----------|
| **Responsif** | Mobile-first; layout adaptif ≤480px (mobile), ≤1024px (tablet), >1024px (desktop) |
| **Performance** | Halaman utama termuat ≤5 detik pada koneksi normal; aset gambar dioptimasi |
| **Aksesibilitas** | Kontras warna WCAG AA, tombol min 44×44px (touch-friendly), teks Arab terbaca jelas |
| **Deployment** | URL publik aktif dan dapat diakses penguji saat penilaian |
| **Keterlacakan** | Seluruh kode di GitHub; commit hadir dari setiap anggota |
| **Keamanan data** | Input dari backend divalidasi; tidak ada SQL injection |

---

## 5. Arsitektur Sistem

```
┌─────────────────────────────────────────┐
│               Browser                   │
│  ┌───────────────────────────────────┐  │
│  │         Frontend                  │  │
│  │  HTML/CSS/JS  atau  React/Vue     │  │
│  └────────────┬──────────────────────┘  │
└───────────────┼─────────────────────────┘
                │ HTTP Request (JSON)
┌───────────────▼─────────────────────────┐
│               Backend                   │
│  PHP Native / Laravel / Node Express    │
│  ┌───────────────────────────────────┐  │
│  │         Route / Controller        │  │
│  │  /api/gerakan  /api/bacaan        │  │
│  └────────────┬──────────────────────┘  │
└───────────────┼─────────────────────────┘
                │ Query
┌───────────────▼─────────────────────────┐
│               Database                  │
│  MySQL / PostgreSQL                     │
│  ┌──────────┐ ┌──────────┐             │
│  │ kelompok │ │ kategori │             │
│  └──────────┘ └────┬─────┘             │
│               ┌────▼─────┐             │
│               │ gerakan  │             │
│               └────┬─────┘             │
│               ┌────▼─────┐             │
│               │  bacaan  │             │
│               └──────────┘             │
└─────────────────────────────────────────┘
```

---

## 6. Data Model

### Skema Tabel

```sql
-- Identitas kelompok (tampil di header tiap halaman)
CREATE TABLE kelompok (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nama_kelompok VARCHAR(100) NOT NULL,
  prodi         VARCHAR(100) NOT NULL,
  mata_kuliah   VARCHAR(100) NOT NULL,
  dosen         VARCHAR(100) NOT NULL
);

-- Segmen pengguna
CREATE TABLE kategori (
  id   INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(20) NOT NULL  -- 'dewasa' | 'anak'
);

-- Gerakan sholat
CREATE TABLE gerakan (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  id_kategori  INT NOT NULL,
  nama         VARCHAR(100) NOT NULL,
  urutan       SMALLINT NOT NULL,
  deskripsi    TEXT,
  gambar_url   VARCHAR(255),
  video_url    VARCHAR(255),
  FOREIGN KEY (id_kategori) REFERENCES kategori(id)
);

-- Bacaan per gerakan
CREATE TABLE bacaan (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  id_gerakan   INT NOT NULL,
  urutan       SMALLINT NOT NULL,
  teks_arab    TEXT,
  teks_latin   TEXT,
  terjemahan   TEXT,
  audio_url    VARCHAR(255),
  sumber       VARCHAR(150),
  FOREIGN KEY (id_gerakan) REFERENCES gerakan(id)
);
```

### Relasi

```
kategori  ──(1)──────(N)──  gerakan
gerakan   ──(1)──────(N)──  bacaan
kelompok  (berdiri sendiri — sumber identitas header)
```

---

## 7. Konten — 13 Gerakan Sholat

> ⚠️ **Teks Arab, transliterasi Latin, dan terjemahan wajib diverifikasi langsung dari HPT Muhammadiyah Kitab Shalat. Tabel di bawah adalah kerangka — bukan konten final.**

| No | Gerakan | Bacaan Terkait |
|----|---------|---------------|
| 1 | Berdiri tegak menghadap kiblat (qiyam) + niat | — |
| 2 | Takbiratul ihram (mengangkat kedua tangan) | Takbir: *Allāhu Akbar* |
| 3 | Bersedekap (tangan kanan di atas kiri) | Doa iftitah |
| 4 | Berdiri membaca Al-Fatihah + surah / ayat | Al-Fatihah + surah pilihan |
| 5 | Rukuk (membungkuk, thuma'ninah) | Tasbih rukuk |
| 6 | I'tidal (bangkit dari rukuk) | Doa i'tidal (*sami'allāhu… rabbanā lakal-ḥamd*) |
| 7 | Sujud pertama (thuma'ninah) | Tasbih sujud |
| 8 | Duduk di antara dua sujud (iftirāsy) | Doa duduk antara dua sujud |
| 9 | Sujud kedua | Tasbih sujud |
| 10 | Berdiri ke rakaat berikutnya | — |
| 11 | Duduk tasyahud awal (iftirāsy) | Tasyahud awal |
| 12 | Duduk tasyahud akhir (tawarruk) | Tasyahud akhir + shalawat |
| 13 | Salam (menoleh kanan & kiri) | *Assalāmu'alaikum wa raḥmatullāh* |

**Mode penyajian:**

| Aspek | Dewasa | Anak |
|-------|--------|------|
| Teks Arab | Lengkap, ukuran besar | Lengkap |
| Transliterasi | Lengkap | Ringkas |
| Terjemahan | Lengkap + keterangan sumber | Ringkas, bahasa sederhana |
| Visual | Foto / ilustrasi formal | Ilustrasi ramah anak |
| Keterangan sumber | Wajib tampil | Opsional |

---

## 8. Halaman & Komponen

### 8.1 Beranda
- Hero section + deskripsi singkat aplikasi
- Toggle mode **Dewasa / Anak** (switch button)
- CTA "Mulai Belajar" → menuju list gerakan
- Header identitas: Nama Kelompok · Prodi · Mata Kuliah · Dosen

### 8.2 List Gerakan
- 13 kartu gerakan (nomor urut, nama, thumbnail gambar)
- Klik kartu → masuk halaman detail
- Indikator mode aktif (badge Dewasa / Anak)
- Loading state: skeleton card

### 8.3 Detail Gerakan
- Gambar besar gerakan (dioptimasi)
- Teks Arab (font Amiri / Scheherazade New, min 28px, line-height longgar)
- Teks Latin (italic, 16px)
- Terjemahan (14px, muted color)
- Audio player custom (play / pause / replay / progress bar)
- Tombol "Tonton Video" → modal / embed
- Navigasi Next / Previous (sticky bottom)
- Toggle autoplay (gerakan + audio jalan otomatis berurutan)
- Sumber bacaan (HPT) — mode Dewasa wajib tampil

### 8.4 Komponen Global

| Komponen | Keterangan |
|----------|-----------|
| Header | Identitas kelompok, toggle mode, nav utama |
| Card gerakan | Shadow tipis, rounded 12px, hover elevasi naik |
| Audio player | Play / pause / replay / progress bar |
| Video modal | Embed video, overlay gelap, tombol tutup |
| Nav Next / Prev | Floating button sticky bottom |
| Badge mode | Indikator Dewasa / Anak |
| Skeleton loading | Placeholder saat data belum siap |
| Toast error | Notifikasi audio / video gagal load |
| Empty state | Tampil jika data kosong |

---

## 9. API Endpoint

| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/kelompok` | Data identitas kelompok untuk header |
| GET | `/api/gerakan?kategori=dewasa` | Semua gerakan mode dewasa |
| GET | `/api/gerakan?kategori=anak` | Semua gerakan mode anak |
| GET | `/api/gerakan/:id` | Detail satu gerakan |
| GET | `/api/bacaan?id_gerakan=:id` | Semua bacaan milik gerakan tertentu |

**Response format:** JSON. Semua data dari database — tidak ada hardcode konten di HTML.

---

## 10. Stack Teknologi

### Opsi A — PHP Native

| Layer | Teknologi |
|-------|-----------|
| Frontend | HTML5, CSS3, JavaScript, Bootstrap / Tailwind CSS |
| Backend | PHP Native (PDO / mysqli) |
| Database | MySQL / MariaDB |
| Hosting | InfinityFree / shared hosting PHP |

> Pilih satu opsi. Yang terpenting: tiga lapis arsitektur terpenuhi dan data dari DB.

---

## 11. Struktur Folder

### Opsi A (PHP Native)

```
tuntunan-sholat/
├── public/                    ← document root
│   ├── index.php              ← beranda
│   ├── gerakan.php            ← list gerakan
│   ├── detail.php             ← detail gerakan + bacaan
│   └── assets/
│       ├── css/style.css
│       ├── js/
│       │   ├── audio-player.js
│       │   ├── autoplay.js
│       │   └── navigasi.js
│       ├── img/gerakan/       ← gambar tiap gerakan
│       └── audio/bacaan/      ← file MP3
├── app/
│   ├── config/database.php    ← koneksi PDO
│   ├── models/
│   │   ├── Gerakan.php
│   │   ├── Bacaan.php
│   │   └── Kelompok.php
│   ├── controllers/
│   │   ├── GerakanController.php
│   │   └── BacaanController.php
│   └── partials/
│       ├── header.php
│       ├── nav.php
│       └── footer.php
├── api/
│   ├── gerakan.php            ← endpoint JSON
│   └── bacaan.php
├── database/
│   ├── schema.sql
│   └── seed.sql
├── docs/laporan/              ← draft BAB I–VI per pertemuan
├── .env.example
├── .gitignore
└── README.md
```
---

## 12. Timeline

| Pertemuan | Fokus | Target | Deliverable |
|-----------|-------|--------|-------------|
| **P1** | Inisiasi & Perancangan | Analisis kebutuhan, wireframe, ERD, repo GitHub aktif | Dokumen perencanaan · Wireframe 3 halaman · ERD · README awal |
| **P2** | Implementasi FE & Konten | Layout responsif jalan, DB terisi data kedua mode | FE responsif · DB seed dewasa & anak · Audio bisa diputar |
| **P3** | BE + Integrasi + Deploy | Semua fitur jalan, aplikasi online | URL live · F-01→F-09 berfungsi · Laporan PDF lengkap |

---

## 13. Peran Tim

| No | Peran | Tanggung Jawab Utama | Luaran Individual |
|----|-------|---------------------|------------------|
| 1 | **Ketua / PM** | Koordinasi, jadwal, integrasi modul, kelola repo & branch, pimpin presentasi | Papan tugas (kanban), notulen, riwayat merge |
| 2 | **Frontend Dev** | Layout responsif, komponen navigasi Next/Prev, autoplay, toggle mode Dewasa/Anak | Halaman & komponen UI responsif |
| 3 | **Backend Dev** | Logika server, route/endpoint, pengambilan data dari DB, integrasi audio/video | Modul backend & API/route |
| 4 | **DB & Content Engineer** | Skema DB, seed data gerakan & bacaan dari HPT, manajemen aset media | Skema DB + seed data terverifikasi |
| 5 | **QA & Deployment** | Uji lintas perangkat, deployment online, laporan, README & demo | Laporan uji · URL live · Dokumentasi |

> Untuk kelompok 4 anggota: gabungkan peran QA/Deployment ke Ketua, atau bagi ke FE dan BE. Pembagian wajib tertulis di laporan.

---

## 14. Definition of Done

```
Fitur
☐  F-01 → F-09 semua berjalan tanpa error
☐  Klik gerakan mana pun masuk ke detail yang benar
☐  Next / Previous berpindah antar gerakan & bacaan
☐  Autoplay memutar gerakan + audio berurutan otomatis
☐  Toggle mode Dewasa / Anak mengubah penyajian konten

Data & Arsitektur
☐  100% data konten dari DB — nol hardcode di HTML
☐  Teks Arab / Latin / terjemahan terverifikasi dari HPT
☐  Sumber HPT tercantum per bacaan (minimal di mode Dewasa)

Kualitas
☐  Responsif diuji di minimal 3 ukuran layar (mobile / tablet / desktop)
☐  Audio MP3 dapat diputar di browser modern
☐  Load halaman utama ≤5 detik

Kolaborasi & Dokumentasi
☐  Commit hadir dari tiap anggota (terlacak di GitHub)
☐  URL live publik aktif dan dapat diakses penguji
☐  README lengkap: anggota + peran, URL live, cara menjalankan
☐  Laporan PDF BAB I–VI + Lampiran selesai dan diunggah ke Classroom
```

---

## 15. Risiko & Mitigasi

| # | Risiko | Dampak | Kemungkinan | Mitigasi |
|---|--------|--------|-------------|----------|
| 1 | Verifikasi konten HPT membutuhkan waktu lama | P1 molor, konten salah | Tinggi | Mulai paralel sebelum P1 selesai; DB & Content Engineer mulai dari hari pertama |
| 2 | Sinkronisasi autoplay gerakan + audio kompleks | Fitur F-06 gagal | Sedang | Buat proof of concept di P2, jangan tunda ke P3 |
| 3 | Hosting gratis down saat penilaian | Nilai 0 deployment | Sedang | Siapkan 2 hosting cadangan; uji URL H-1 sebelum penilaian |
| 4 | Commit tidak merata antar anggota | Nilai individual drop | Sedang | PM pantau commit tiap pertemuan; ingatkan anggota yang belum commit |
| 5 | Aset gambar / audio besar, load lambat | Gagal SLA ≤5 detik | Sedang | Compress semua aset sebelum upload ke repo / hosting |
| 6 | Konflik kode di GitHub (merge conflict) | Integrasi terhambat | Rendah | Gunakan branch per fitur; PM review sebelum merge ke main |

---

## 16. Rubrik Penilaian

### Komponen Kelompok (70%)

| Aspek | Indikator | Bobot |
|-------|-----------|-------|
| Kelengkapan fitur | F-01 s.d. F-09 berfungsi | 25% |
| Responsivitas & UI/UX | Tampil baik di mobile, tablet, desktop; navigasi jelas | 15% |
| Arsitektur FE/BE/DB | Pemisahan lapisan, data dari DB, kode rapi | 15% |
| Akurasi konten & sumber | Bacaan/gerakan sesuai HPT dan dicantumkan sumbernya | 10% |
| Deployment & laporan | Aplikasi daring berfungsi + laporan terstruktur lengkap | 5% |

### Komponen Individual (30%)

| Aspek | Indikator | Bobot |
|-------|-----------|-------|
| Kontribusi kode / karya | Bukti commit & hasil sesuai peran | 15% |
| Penguasaan & presentasi | Mampu menjelaskan bagian yang dikerjakan | 10% |
| Kerja sama & tanggung jawab | Disiplin, memenuhi tenggat, kolaboratif | 5% |

### Skala Konversi

| Huruf | A | B | C | D | E |
|-------|---|---|---|---|---|
| Rentang | >81 | 61–80 | 41–60 | 21–40 | 0–20 |

> **Nilai UAS = (Nilai Kelompok × 70%) + (Nilai Individual × 30%)**

---

## 17. Referensi

1. PP Muhammadiyah. *Himpunan Putusan Tarjih Muhammadiyah (Kitab Shalat)*. Yogyakarta: Suara Muhammadiyah.
2. PP Muhammadiyah. *Tuntunan Shalat sesuai Tarjih Muhammadiyah*.
3. MDN Web Docs. Dokumentasi HTML, CSS, JavaScript responsif. [developer.mozilla.org](https://developer.mozilla.org)
4. Dokumentasi resmi framework/teknologi yang dipilih (Laravel, React, Bootstrap, Tailwind, dst).
5. Git & GitHub Docs — kolaborasi dan manajemen repositori. [docs.github.com](https://docs.github.com)

---

*Dokumen ini disusun berdasarkan Modul PjBL Pertemuan 1–3, Pengembangan Aplikasi Web, Universitas Muhammadiyah Pontianak.*  
*Pontianak, 2026*
