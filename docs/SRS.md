# SRS — Software Requirements Specification
## Aplikasi Web Tuntunan Tata Cara Sholat

**Versi:** 1.0  
**Tanggal:** 2026  
**Status:** Draft  
**Mata Kuliah:** AIK 4  
**Institusi:** Program Studi Manajemen Bisnis Syariah · FAI · Universitas Muhammadiyah Pontianak  
**Dosen Pengampu:** Dedy Susanto, S.Pd.I., M.M. (NIDN. 1128048303)  
**Standar:** IEEE 830 (adaptasi)

---

## Daftar Isi

1. [Pendahuluan](#1-pendahuluan)
2. [Deskripsi Umum Sistem](#2-deskripsi-umum-sistem)
3. [Kebutuhan Fungsional](#3-kebutuhan-fungsional)
4. [Kebutuhan Non-Fungsional](#4-kebutuhan-non-fungsional)
5. [Kebutuhan Antarmuka](#5-kebutuhan-antarmuka)
6. [Kebutuhan Database](#6-kebutuhan-database)
7. [Kebutuhan Backend / API](#7-kebutuhan-backend--api)
8. [Kebutuhan Frontend](#8-kebutuhan-frontend)
9. [Alur Pengguna (User Flow)](#9-alur-pengguna-user-flow)
10. [Use Case](#10-use-case)
11. [Kebutuhan Media & Aset](#11-kebutuhan-media--aset)
12. [Kebutuhan Deployment](#12-kebutuhan-deployment)
13. [Kebutuhan Keamanan](#13-kebutuhan-keamanan)
14. [Batasan Sistem](#14-batasan-sistem)
15. [Asumsi & Ketergantungan](#15-asumsi--ketergantungan)
16. [Glosarium](#16-glosarium)

---

## 1. Pendahuluan

### 1.1 Tujuan Dokumen

Dokumen ini mendefinisikan seluruh kebutuhan perangkat lunak untuk pembangunan **Aplikasi Web Tuntunan Tata Cara Sholat** sesuai sunnah Rasulullah ﷺ dengan rujukan Himpunan Putusan Tarjih (HPT) Muhammadiyah. Dokumen ini menjadi acuan bagi seluruh anggota tim pengembang selama proses implementasi, pengujian, dan deployment.

### 1.2 Ruang Lingkup

Aplikasi ini adalah sistem web responsif yang:

- Menyajikan 13 gerakan sholat secara terstruktur dan berurutan
- Menampilkan bacaan dalam 4 lapisan: teks Arab, transliterasi Latin, terjemahan, dan audio MP3
- Mendukung dua mode pengguna: **Dewasa** (formal, lengkap) dan **Anak** (visual, ringkas)
- Dibangun dengan arsitektur 3 lapis: Frontend, Backend, dan Database
- Wajib dapat diakses publik melalui URL online

### 1.3 Definisi & Singkatan

| Istilah | Penjelasan |
|---------|-----------|
| HPT | Himpunan Putusan Tarjih Muhammadiyah |
| FE | Frontend (antarmuka pengguna) |
| BE | Backend (logika server) |
| DB | Database (basis data) |
| API | Application Programming Interface |
| MP3 | Format audio digital |
| JSON | JavaScript Object Notation (format response API) |
| WCAG | Web Content Accessibility Guidelines |
| SRS | Software Requirements Specification |
| F-xx | Kode fitur fungsional |
| NF-xx | Kode kebutuhan non-fungsional |

### 1.4 Referensi

- Modul PjBL Pengembangan Aplikasi Web, Pertemuan 1–3, UMP 2026
- PP Muhammadiyah, HPT Kitab Shalat
- IEEE 830-1998: Recommended Practice for SRS
- MDN Web Docs: HTML, CSS, JavaScript

---

## 2. Deskripsi Umum Sistem

### 2.1 Perspektif Sistem

```
┌─────────────────────────────────────────────────────┐
│                   PENGGUNA                          │
│            (Browser: Chrome/Firefox/Safari)         │
└──────────────────────┬──────────────────────────────┘
                       │ HTTPS
┌──────────────────────▼──────────────────────────────┐
│                  FRONTEND                           │
│   Halaman Web Responsif (HTML/CSS/JS atau React)    │
│   ┌────────────┐ ┌──────────────┐ ┌─────────────┐  │
│   │  Beranda   │ │ List Gerakan │ │   Detail    │  │
│   └────────────┘ └──────────────┘ └─────────────┘  │
└──────────────────────┬──────────────────────────────┘
                       │ HTTP Request (JSON)
┌──────────────────────▼──────────────────────────────┐
│                   BACKEND                           │
│        PHP Native / Laravel / Node Express          │
│   ┌─────────────────────────────────────────────┐   │
│   │           Router / Controller               │   │
│   │  /api/gerakan  /api/bacaan  /api/kelompok   │   │
│   └─────────────────────┬───────────────────────┘   │
└─────────────────────────┼───────────────────────────┘
                          │ SQL Query
┌─────────────────────────▼───────────────────────────┐
│                  DATABASE                           │
│              MySQL / PostgreSQL                     │
│  ┌──────────┐ ┌──────────┐ ┌─────────┐ ┌────────┐ │
│  │kelompok  │ │kategori  │ │gerakan  │ │bacaan  │ │
│  └──────────┘ └──────────┘ └─────────┘ └────────┘ │
└─────────────────────────────────────────────────────┘
                          │
┌─────────────────────────▼───────────────────────────┐
│               STORAGE ASET MEDIA                    │
│        /img/gerakan/   /audio/bacaan/               │
└─────────────────────────────────────────────────────┘
```

### 2.2 Fungsi Utama Sistem

- Menampilkan daftar 13 gerakan sholat yang dapat diklik
- Menyajikan detail gerakan: gambar, bacaan (Arab/Latin/terjemah), audio, video
- Navigasi Next/Previous dan autoplay berurutan
- Mode tampilan Dewasa dan Anak yang dapat dipilih pengguna
- Menampilkan identitas kelompok di header setiap halaman

### 2.3 Karakteristik Pengguna

| Pengguna | Literasi Digital | Kebutuhan Khusus |
|----------|-----------------|-----------------|
| Dewasa / Umum | Menengah | Teks lengkap, sumber HPT jelas |
| Mahasiswa | Menengah–Tinggi | Akurasi konten, navigasi cepat |
| Anak-anak | Rendah | Visual menarik, bahasa sederhana |
| Dosen / Penilai | Tinggi | Semua fitur F-01→F-09 berjalan |

### 2.4 Batasan Umum

- Aplikasi berbasis web (bukan native mobile)
- Konten hanya disajikan, tidak ada fitur registrasi/login pengguna
- Data konten dikelola dari backend (tidak ada CMS publik)
- Bahasa antarmuka: Bahasa Indonesia
- Teks Arab menggunakan font Amiri atau Scheherazade New

---

## 3. Kebutuhan Fungsional

### F-01 — Daftar Gerakan Sholat

**Deskripsi:** Sistem menampilkan daftar 13 gerakan sholat secara berurutan dari qiyam hingga salam dalam format kartu yang dapat diklik.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-01.1 | Sistem menampilkan 13 kartu gerakan secara urut (nomor 1–13) |
| F-01.2 | Tiap kartu memuat: nomor urut, nama gerakan, thumbnail gambar |
| F-01.3 | Kartu dapat diklik dan mengarahkan ke halaman detail gerakan |
| F-01.4 | Daftar menyesuaikan mode aktif (Dewasa / Anak) |
| F-01.5 | Sistem menampilkan skeleton loading saat data belum tersedia |
| F-01.6 | Sistem menampilkan pesan empty state jika data kosong |

**Kriteria penerimaan:**
- 13 kartu tampil urut dan dapat diklik
- Data diambil dari endpoint `/api/gerakan?kategori=` bukan hardcode

---

### F-02 — Detail Gerakan

**Deskripsi:** Sistem menampilkan halaman detail satu gerakan sholat lengkap dengan gambar, dan bacaan dalam 4 lapisan.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-02.1 | Sistem menampilkan gambar gerakan beresolusi cukup |
| F-02.2 | Sistem menampilkan teks Arab (font Amiri/Scheherazade, min 28px) |
| F-02.3 | Sistem menampilkan transliterasi Latin (italic, 16px) |
| F-02.4 | Sistem menampilkan terjemahan Bahasa Indonesia (14px) |
| F-02.5 | Sistem menampilkan sumber bacaan (HPT) — wajib tampil di mode Dewasa |
| F-02.6 | Konten menyesuaikan mode aktif (Dewasa: lengkap / Anak: ringkas) |
| F-02.7 | Judul halaman memuat nama gerakan yang sedang ditampilkan |

**Kriteria penerimaan:**
- Semua 4 lapisan bacaan tampil per gerakan
- Mode Dewasa: sumber HPT tampil. Mode Anak: terjemahan ringkas, visual lebih besar

---

### F-03 — Audio Player

**Deskripsi:** Sistem menyediakan pemutar audio MP3 untuk setiap bacaan sholat.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-03.1 | Sistem menyediakan tombol Play / Pause per bacaan |
| F-03.2 | Sistem menampilkan progress bar durasi audio |
| F-03.3 | Sistem menyediakan tombol Replay (putar ulang dari awal) |
| F-03.4 | Sistem menampilkan durasi total dan posisi saat ini |
| F-03.5 | Sistem menampilkan toast error jika file audio gagal dimuat |
| F-03.6 | Audio berhenti saat pengguna berpindah ke gerakan lain |
| F-03.7 | Satu audio yang aktif pada satu waktu (tidak tumpang tindih) |

**Kriteria penerimaan:**
- Audio dapat diputar, dijeda, dan diulang
- Tidak ada dua audio berjalan bersamaan

---

### F-04 — Opsi Video

**Deskripsi:** Sistem menyediakan tombol untuk menampilkan video gerakan / bacaan sebagai alternatif media.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-04.1 | Sistem menampilkan tombol "Tonton Video" di halaman detail |
| F-04.2 | Klik tombol membuka modal / embed video |
| F-04.3 | Modal dilengkapi tombol tutup (X) |
| F-04.4 | Video dapat berasal dari URL eksternal (YouTube embed) atau file lokal |
| F-04.5 | Tombol tidak tampil jika `video_url` kosong / NULL di DB |

**Kriteria penerimaan:**
- Video terbuka dalam modal saat diklik
- Tombol tidak muncul jika tidak ada video

---

### F-05 — Navigasi Next / Previous

**Deskripsi:** Sistem menyediakan navigasi berpindah antar gerakan secara maju dan mundur.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-05.1 | Tombol "Berikutnya" tersedia di halaman detail (menuju gerakan+1) |
| F-05.2 | Tombol "Sebelumnya" tersedia di halaman detail (menuju gerakan-1) |
| F-05.3 | Tombol "Sebelumnya" dinonaktifkan (disabled) pada gerakan pertama |
| F-05.4 | Tombol "Berikutnya" dinonaktifkan (disabled) pada gerakan terakhir |
| F-05.5 | Tombol sticky di bagian bawah layar agar selalu terlihat |
| F-05.6 | Perpindahan mempertahankan mode aktif (Dewasa / Anak) |

**Kriteria penerimaan:**
- Navigasi berjalan dari gerakan 1 hingga 13 dan sebaliknya
- Tombol disabled di ujung pertama dan terakhir

---

### F-06 — Autoplay Berurutan

**Deskripsi:** Sistem dapat memutar gerakan dan audio secara otomatis berurutan dari gerakan pertama hingga terakhir.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-06.1 | Sistem menyediakan tombol toggle Autoplay (aktif / nonaktif) |
| F-06.2 | Saat autoplay aktif: audio bacaan diputar otomatis saat halaman detail dibuka |
| F-06.3 | Setelah audio selesai, sistem otomatis berpindah ke gerakan berikutnya |
| F-06.4 | Autoplay berhenti otomatis pada gerakan terakhir (gerakan 13) |
| F-06.5 | Pengguna dapat menghentikan autoplay kapan saja via tombol toggle |
| F-06.6 | Indikator visual jelas saat autoplay aktif (highlight / pulsing badge) |

**Kriteria penerimaan:**
- Autoplay berjalan dari gerakan 1 sampai 13 tanpa intervensi
- Autoplay berhenti saat toggle dimatikan atau gerakan terakhir selesai

---

### F-07 — Mode Dewasa / Anak

**Deskripsi:** Sistem menyediakan toggle untuk memilih mode tampilan konten — Dewasa atau Anak.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-07.1 | Toggle mode tersedia di header (semua halaman utama) |
| F-07.2 | Mode Dewasa: tampilkan konten lengkap + sumber HPT + font formal |
| F-07.3 | Mode Anak: tampilkan terjemahan ringkas + visual lebih besar + bahasa sederhana |
| F-07.4 | Perubahan mode langsung mengubah konten tanpa reload halaman penuh |
| F-07.5 | Mode aktif disimpan selama sesi (tidak reset saat pindah halaman) |
| F-07.6 | Data per mode diambil dari DB sesuai `id_kategori` (1=dewasa, 2=anak) |
| F-07.7 | Badge indikator mode aktif tampil jelas di UI |

**Kriteria penerimaan:**
- Konten berubah saat toggle diklik
- Mode tidak reset saat navigasi antar halaman

---

### F-08 — Header Identitas Kelompok

**Deskripsi:** Sistem menampilkan identitas kelompok di header setiap halaman utama.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-08.1 | Header memuat: Nama Kelompok, Program Studi, Mata Kuliah, Nama Dosen |
| F-08.2 | Header tampil konsisten di semua halaman utama |
| F-08.3 | Data identitas diambil dari tabel `kelompok` di DB |
| F-08.4 | Header sticky di bagian atas layar saat scroll |

**Kriteria penerimaan:**
- Identitas tampil di beranda, list gerakan, dan detail gerakan
- Data dari DB, bukan hardcode di HTML

---

### F-09 — Konten dari Database

**Deskripsi:** Seluruh konten gerakan dan bacaan diambil dari basis data melalui backend — tidak ada konten yang ditulis statis di HTML.

**Kebutuhan detail:**

| ID | Kebutuhan |
|----|-----------|
| F-09.1 | Frontend mengambil data via request ke endpoint API backend |
| F-09.2 | Backend mengambil data dari DB menggunakan query SQL (PDO / ORM) |
| F-09.3 | Tidak ada teks Arab, Latin, terjemahan, atau URL aset yang ditulis langsung di HTML |
| F-09.4 | Data tabel `kelompok`, `kategori`, `gerakan`, `bacaan` semua dikelola di DB |
| F-09.5 | Perubahan konten cukup dilakukan di DB tanpa ubah kode HTML/PHP |

**Kriteria penerimaan:**
- Inspect HTML tidak menemukan konten sholat yang hardcode
- Saat data DB diubah, tampilan berubah tanpa edit kode

---

## 4. Kebutuhan Non-Fungsional

### NF-01 — Responsivitas

| ID | Kebutuhan |
|----|-----------|
| NF-01.1 | Layout adaptif untuk layar mobile ≤480px (1 kolom, bottom nav) |
| NF-01.2 | Layout adaptif untuk layar tablet ≤1024px |
| NF-01.3 | Layout adaptif untuk layar desktop >1024px (sidebar + panel detail) |
| NF-01.4 | Pendekatan mobile-first dalam penulisan CSS |
| NF-01.5 | Tidak ada elemen yang terpotong atau overflow horizontal di semua ukuran layar |

### NF-02 — Performa

| ID | Kebutuhan |
|----|-----------|
| NF-02.1 | Halaman utama termuat ≤5 detik pada koneksi normal |
| NF-02.2 | Gambar gerakan dioptimasi (compress) sebelum upload |
| NF-02.3 | File audio MP3 dioptimasi (bitrate efisien, tidak oversized) |
| NF-02.4 | Tidak ada blocking resource yang menghambat render halaman |

### NF-03 — Aksesibilitas

| ID | Kebutuhan |
|----|-----------|
| NF-03.1 | Kontras warna memenuhi standar WCAG AA (rasio min 4.5:1 untuk teks) |
| NF-03.2 | Semua tombol interaktif berukuran min 44×44px (touch-friendly) |
| NF-03.3 | Teks Arab menggunakan font yang terbaca jelas (Amiri / Scheherazade New) |
| NF-03.4 | Atribut `aria-label` tersedia pada tombol audio, video, dan navigasi |
| NF-03.5 | Gambar memiliki atribut `alt` yang deskriptif |
| NF-03.6 | Struktur heading HTML semantik (h1 → h2 → h3) |

### NF-04 — Ketersediaan

| ID | Kebutuhan |
|----|-----------|
| NF-04.1 | Aplikasi dapat diakses publik melalui URL online saat penilaian |
| NF-04.2 | Hosting tersedia minimal selama periode penilaian UAS |
| NF-04.3 | Siapkan cadangan hosting jika hosting utama down |

### NF-05 — Keterlacakan Kode

| ID | Kebutuhan |
|----|-----------|
| NF-05.1 | Seluruh kode dikelola di repositori GitHub kelompok |
| NF-05.2 | Setiap anggota memiliki riwayat commit yang dapat dilihat |
| NF-05.3 | README memuat: nama anggota + peran, URL live, cara menjalankan |
| NF-05.4 | Branch utama: `main`. Pengembangan fitur gunakan branch terpisah |

### NF-06 — Maintainability

| ID | Kebutuhan |
|----|-----------|
| NF-06.1 | Kode terstruktur sesuai folder yang telah didefinisikan di PRD |
| NF-06.2 | Fungsi / komponen diberi nama yang deskriptif |
| NF-06.3 | Tidak ada kode duplikat yang signifikan (DRY principle) |
| NF-06.4 | File konfigurasi (DB connection) terpisah dari logika bisnis |

---

## 5. Kebutuhan Antarmuka

### 5.1 Antarmuka Pengguna (UI)

#### Palet Warna

| Token | Warna | HEX |
|-------|-------|-----|
| Primary | Hijau teal islami | `#0F6E56` |
| Secondary | Hijau gelap | `#085041` |
| Accent | Amber emas | `#BA7517` |
| Background | Krem hangat | `#F1EFE8` |
| Surface | Putih | `#FFFFFF` |
| Text Primary | Hampir hitam | `#2C2C2A` |
| Text Muted | Abu tengah | `#5F5E5A` |
| Border | Abu terang | `#D3D1C7` |
| Danger | Merah gelap | `#791F1F` |
| Dark BG | Hitam hangat | `#1C1C1A` |

#### Tipografi

| Elemen | Font | Ukuran | Weight |
|--------|------|--------|--------|
| Heading | Poppins / Inter | 24–32px | 600 |
| Body | Inter | 16px | 400 |
| Teks Arab | Amiri / Scheherazade New | min 28px | 400 |
| Latin | Inter | 16px | 400 italic |
| Terjemahan | Inter | 14px | 400 |
| Label kecil | Inter | 12px | 400 |

#### Komponen UI

| Komponen | Spesifikasi |
|----------|------------|
| Card gerakan | `border-radius: 12px`, shadow tipis, hover elevasi naik |
| Tombol primer | `bg: #0F6E56`, teks putih, `border-radius: 8px`, min 44px tinggi |
| Tombol sekunder | `border: 1px solid #0F6E56`, teks primary, transparan |
| Audio player | Progress bar, play/pause/replay, durasi |
| Toggle mode | Switch button, badge indikator aktif |
| Nav Next/Prev | Floating sticky bottom, disabled state jelas |
| Modal video | Overlay gelap, tombol X sudut kanan atas |
| Toast | Pojok kanan bawah, auto-dismiss 3 detik |
| Skeleton | Animasi shimmer saat loading |

### 5.2 Antarmuka Hardware

- Input: keyboard, mouse, touchscreen
- Output: layar desktop (>1024px), tablet (≤1024px), mobile (≤480px)
- Speaker: untuk pemutaran audio MP3

### 5.3 Antarmuka Komunikasi

- Protokol: HTTP/HTTPS
- Format data API: JSON (UTF-8)
- Header Content-Type: `application/json`

---

## 6. Kebutuhan Database

### 6.1 Skema Lengkap

```sql
-- ============================================
-- DATABASE: tuntunan_sholat
-- ============================================

CREATE DATABASE IF NOT EXISTS tuntunan_sholat
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tuntunan_sholat;

-- --------------------------------------------
-- Tabel: kelompok
-- Menyimpan identitas kelompok untuk header
-- --------------------------------------------
CREATE TABLE kelompok (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nama_kelompok VARCHAR(100)  NOT NULL,
  prodi         VARCHAR(100)  NOT NULL,
  mata_kuliah   VARCHAR(100)  NOT NULL,
  dosen         VARCHAR(100)  NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------
-- Tabel: kategori
-- Nilai: 'dewasa' | 'anak'
-- --------------------------------------------
CREATE TABLE kategori (
  id    INT AUTO_INCREMENT PRIMARY KEY,
  nama  VARCHAR(20) NOT NULL UNIQUE
);

-- --------------------------------------------
-- Tabel: gerakan
-- Satu baris per gerakan sholat per kategori
-- --------------------------------------------
CREATE TABLE gerakan (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  id_kategori  INT          NOT NULL,
  nama         VARCHAR(100) NOT NULL,
  urutan       SMALLINT     NOT NULL,
  deskripsi    TEXT,
  gambar_url   VARCHAR(255),
  video_url    VARCHAR(255),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_kategori) REFERENCES kategori(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_kategori_urutan (id_kategori, urutan)
);

-- --------------------------------------------
-- Tabel: bacaan
-- Satu gerakan bisa punya banyak bacaan
-- --------------------------------------------
CREATE TABLE bacaan (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  id_gerakan   INT          NOT NULL,
  urutan       SMALLINT     NOT NULL,
  teks_arab    TEXT,
  teks_latin   TEXT,
  terjemahan   TEXT,
  audio_url    VARCHAR(255),
  sumber       VARCHAR(150),
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_gerakan) REFERENCES gerakan(id)
    ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_gerakan_urutan (id_gerakan, urutan)
);
```

### 6.2 Relasi Antar Tabel

```
kelompok (berdiri sendiri)
    └─ tidak berelasi ke tabel lain

kategori ──(1)──────────(N)── gerakan
              id_kategori FK

gerakan  ──(1)──────────(N)── bacaan
              id_gerakan FK
```

### 6.3 Seed Data Awal

```sql
-- Kategori
INSERT INTO kategori (nama) VALUES ('dewasa'), ('anak');

-- Kelompok (sesuaikan dengan data kelompok)
INSERT INTO kelompok (nama_kelompok, prodi, mata_kuliah, dosen)
VALUES ('Kelompok [X]',
        'Manajemen Bisnis Syariah',
        'Pengembangan Aplikasi Web',
        'Dedy Susanto, S.Pd.I., M.M.');

-- Gerakan (mode dewasa, id_kategori = 1)
-- ⚠️ Isi deskripsi, gambar_url, video_url sesuai aset yang disiapkan
INSERT INTO gerakan (id_kategori, nama, urutan, deskripsi, gambar_url) VALUES
(1, 'Berdiri tegak (qiyam) + niat',        1,  '[deskripsi]', '/img/gerakan/01-qiyam.jpg'),
(1, 'Takbiratul ihram',                     2,  '[deskripsi]', '/img/gerakan/02-takbir.jpg'),
(1, 'Bersedekap + doa iftitah',             3,  '[deskripsi]', '/img/gerakan/03-sedekap.jpg'),
(1, 'Membaca Al-Fatihah + surah',           4,  '[deskripsi]', '/img/gerakan/04-fatihah.jpg'),
(1, 'Rukuk',                                5,  '[deskripsi]', '/img/gerakan/05-rukuk.jpg'),
(1, 'I''tidal',                             6,  '[deskripsi]', '/img/gerakan/06-itidal.jpg'),
(1, 'Sujud pertama',                        7,  '[deskripsi]', '/img/gerakan/07-sujud1.jpg'),
(1, 'Duduk antara dua sujud',               8,  '[deskripsi]', '/img/gerakan/08-duduk.jpg'),
(1, 'Sujud kedua',                          9,  '[deskripsi]', '/img/gerakan/09-sujud2.jpg'),
(1, 'Berdiri ke rakaat berikutnya',         10, '[deskripsi]', '/img/gerakan/10-berdiri.jpg'),
(1, 'Duduk tasyahud awal',                  11, '[deskripsi]', '/img/gerakan/11-tasyahud-awal.jpg'),
(1, 'Duduk tasyahud akhir',                 12, '[deskripsi]', '/img/gerakan/12-tasyahud-akhir.jpg'),
(1, 'Salam',                                13, '[deskripsi]', '/img/gerakan/13-salam.jpg');

-- Bacaan (contoh struktur — teks WAJIB diverifikasi dari HPT)
-- Ganti [TEKS ARAB], [LATIN], [TERJEMAHAN] dengan teks terverifikasi dari HPT
INSERT INTO bacaan (id_gerakan, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber) VALUES
(2, 1, '[TEKS ARAB TAKBIR]',    'Allāhu Akbar',    '[TERJEMAHAN]', '/audio/bacaan/02-takbir.mp3',    'HPT Muhammadiyah, Kitab Shalat'),
(3, 1, '[TEKS ARAB IFTITAH]',   '[LATIN IFTITAH]', '[TERJEMAHAN]', '/audio/bacaan/03-iftitah.mp3',   'HPT Muhammadiyah, Kitab Shalat'),
(4, 1, '[TEKS ARAB FATIHAH]',   '[LATIN FATIHAH]', '[TERJEMAHAN]', '/audio/bacaan/04-fatihah.mp3',   'HPT Muhammadiyah, Kitab Shalat'),
(5, 1, '[TEKS ARAB RUKUK]',     '[LATIN RUKUK]',   '[TERJEMAHAN]', '/audio/bacaan/05-rukuk.mp3',     'HPT Muhammadiyah, Kitab Shalat'),
(6, 1, '[TEKS ARAB ITIDAL]',    '[LATIN ITIDAL]',  '[TERJEMAHAN]', '/audio/bacaan/06-itidal.mp3',    'HPT Muhammadiyah, Kitab Shalat'),
(7, 1, '[TEKS ARAB SUJUD]',     '[LATIN SUJUD]',   '[TERJEMAHAN]', '/audio/bacaan/07-sujud1.mp3',    'HPT Muhammadiyah, Kitab Shalat'),
(8, 1, '[TEKS ARAB DUDUK]',     '[LATIN DUDUK]',   '[TERJEMAHAN]', '/audio/bacaan/08-duduk.mp3',     'HPT Muhammadiyah, Kitab Shalat'),
(9, 1, '[TEKS ARAB SUJUD]',     '[LATIN SUJUD]',   '[TERJEMAHAN]', '/audio/bacaan/09-sujud2.mp3',    'HPT Muhammadiyah, Kitab Shalat'),
(11,1, '[TEKS ARAB TASYAHUD]',  '[LATIN TASYAHUD]','[TERJEMAHAN]', '/audio/bacaan/11-tasyahud1.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
(12,1, '[TEKS ARAB TASYAHUD2]', '[LATIN SHALAWAT]','[TERJEMAHAN]', '/audio/bacaan/12-tasyahud2.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
(13,1, '[TEKS ARAB SALAM]',     'Assalāmu''alaikum wa raḥmatullāh', '[TERJEMAHAN]', '/audio/bacaan/13-salam.mp3', 'HPT Muhammadiyah, Kitab Shalat');
```

> ⚠️ **WAJIB:** Semua teks dalam `[ ]` harus diganti dengan teks yang sudah diverifikasi dari HPT Muhammadiyah Kitab Shalat. Ulangi INSERT untuk `id_kategori = 2` (mode anak) dengan terjemahan yang disederhanakan.

---

## 7. Kebutuhan Backend / API

### 7.1 Endpoint API

#### GET `/api/kelompok`

```
Response 200:
{
  "status": "success",
  "data": {
    "nama_kelompok": "Kelompok 1",
    "prodi": "Manajemen Bisnis Syariah",
    "mata_kuliah": "Pengembangan Aplikasi Web",
    "dosen": "Dedy Susanto, S.Pd.I., M.M."
  }
}
```

#### GET `/api/gerakan?kategori=dewasa`

```
Response 200:
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nama": "Berdiri tegak (qiyam) + niat",
      "urutan": 1,
      "deskripsi": "...",
      "gambar_url": "/img/gerakan/01-qiyam.jpg",
      "video_url": null
    },
    ...
  ]
}
```

#### GET `/api/gerakan/:id`

```
Response 200:
{
  "status": "success",
  "data": {
    "id": 2,
    "nama": "Takbiratul ihram",
    "urutan": 2,
    "deskripsi": "...",
    "gambar_url": "/img/gerakan/02-takbir.jpg",
    "video_url": null
  }
}

Response 404:
{
  "status": "error",
  "message": "Gerakan tidak ditemukan"
}
```

#### GET `/api/bacaan?id_gerakan=2`

```
Response 200:
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "urutan": 1,
      "teks_arab": "اللهُ أَكْبَرُ",
      "teks_latin": "Allāhu Akbar",
      "terjemahan": "Allah Maha Besar",
      "audio_url": "/audio/bacaan/02-takbir.mp3",
      "sumber": "HPT Muhammadiyah, Kitab Shalat"
    }
  ]
}
```

### 7.2 Kebutuhan Backend Umum

| ID | Kebutuhan |
|----|-----------|
| BE-01 | Semua response API berformat JSON dengan UTF-8 |
| BE-02 | Response menyertakan field `status: success / error` |
| BE-03 | Backend memvalidasi parameter input sebelum query ke DB |
| BE-04 | Koneksi DB menggunakan PDO / prepared statement (cegah SQL injection) |
| BE-05 | Header CORS dikonfigurasi jika FE dan BE beda port/domain |
| BE-06 | File konfigurasi DB tidak di-commit ke GitHub (gunakan `.env`) |

---

## 8. Kebutuhan Frontend

### 8.1 Halaman

| Halaman | Route | Deskripsi |
|---------|-------|-----------|
| Beranda | `/` atau `/index` | Hero, toggle mode, CTA mulai belajar |
| List Gerakan | `/gerakan` | 13 kartu gerakan |
| Detail Gerakan | `/gerakan/:id` | Detail lengkap satu gerakan |

### 8.2 Kebutuhan Frontend Spesifik

| ID | Kebutuhan |
|----|-----------|
| FE-01 | Fetch data dari API backend (bukan hardcode) |
| FE-02 | Tampilkan skeleton loading saat request API berlangsung |
| FE-03 | Tampilkan pesan error jika request API gagal |
| FE-04 | Mode aktif (Dewasa/Anak) tersimpan di `sessionStorage` |
| FE-05 | Audio player mencegah dua audio berjalan bersamaan |
| FE-06 | Autoplay: setelah event `ended` audio, navigasi ke gerakan berikutnya |
| FE-07 | Tombol Next/Prev dalam kondisi `disabled` di ujung list |
| FE-08 | Font Amiri/Scheherazade New dimuat via Google Fonts |
| FE-09 | Semua gambar punya atribut `alt` |
| FE-10 | Layout menggunakan CSS Grid / Flexbox (bukan tabel HTML) |

### 8.3 Breakpoint Responsif

```css
/* Mobile first */
/* Base styles: mobile ≤480px — 1 kolom */

/* Tablet */
@media (min-width: 481px) and (max-width: 1024px) {
  /* 2 kolom grid gerakan */
}

/* Desktop */
@media (min-width: 1025px) {
  /* Sidebar list gerakan + panel detail */
}
```

---

## 9. Alur Pengguna (User Flow)

```
[Buka URL]
    │
    ▼
[Beranda]
    │── Pilih mode: Dewasa / Anak
    │── Klik "Mulai Belajar"
    │
    ▼
[List Gerakan]
    │── Tampil 13 kartu (sesuai mode)
    │── Klik kartu gerakan
    │
    ▼
[Detail Gerakan]
    │── Lihat gambar gerakan
    │── Baca teks Arab / Latin / terjemahan
    │── Klik Play → audio bacaan diputar
    │── (Opsional) Klik "Tonton Video" → modal video
    │── Klik "Berikutnya" → gerakan+1
    │── Klik "Sebelumnya" → gerakan-1
    │── Aktifkan Autoplay → gerakan berjalan otomatis
    │       └── Audio selesai → otomatis ke gerakan berikutnya
    │           └── Gerakan 13 selesai → autoplay berhenti
    │
    └── Kapan saja: toggle mode Dewasa / Anak via header
```

---

## 10. Use Case

### UC-01: Memilih Mode Pengguna

```
Aktor    : Pengguna
Kondisi  : Aplikasi terbuka
Alur     :
  1. Pengguna melihat toggle Dewasa/Anak di header
  2. Pengguna klik toggle
  3. Sistem mengubah mode aktif
  4. Sistem memuat ulang konten sesuai mode
  5. Badge mode aktif berubah
Alternatif: Mode default = Dewasa saat pertama buka
```

### UC-02: Melihat Detail Gerakan

```
Aktor    : Pengguna
Kondisi  : Berada di halaman list gerakan
Alur     :
  1. Pengguna klik kartu gerakan
  2. Sistem navigasi ke halaman detail gerakan
  3. Sistem fetch data gerakan & bacaan dari API
  4. Sistem tampilkan gambar, teks Arab, Latin, terjemahan
  5. Audio player siap digunakan
Alternatif: Jika fetch gagal → tampil pesan error
```

### UC-03: Memutar Audio Bacaan

```
Aktor    : Pengguna
Kondisi  : Berada di halaman detail gerakan
Alur     :
  1. Pengguna klik tombol Play
  2. Sistem memuat file audio dari URL
  3. Audio diputar, progress bar berjalan
  4. Pengguna dapat Pause / Replay
  5. Audio selesai → status kembali ke idle
Alternatif: File tidak ditemukan → toast error muncul
```

### UC-04: Menjalankan Autoplay

```
Aktor    : Pengguna
Kondisi  : Berada di halaman detail gerakan
Alur     :
  1. Pengguna aktifkan toggle Autoplay
  2. Sistem putar audio gerakan saat ini
  3. Audio selesai → sistem navigasi ke gerakan berikutnya
  4. Proses berulang hingga gerakan 13
  5. Gerakan 13 selesai → autoplay berhenti otomatis
Alternatif: Pengguna matikan toggle → autoplay berhenti segera
```

### UC-05: Navigasi Next / Previous

```
Aktor    : Pengguna
Kondisi  : Berada di halaman detail gerakan
Alur     :
  1. Pengguna klik "Berikutnya"
  2. Sistem navigasi ke gerakan urutan+1
  3. Konten gerakan baru dimuat
  4. Tombol "Sebelumnya" di gerakan 1 = disabled
  5. Tombol "Berikutnya" di gerakan 13 = disabled
```

---

## 11. Kebutuhan Media & Aset

### 11.1 Gambar Gerakan

| Ketentuan | Spesifikasi |
|-----------|------------|
| Format | JPG / WebP |
| Resolusi | Min 800×600px |
| Ukuran file | Maks 200KB setelah dioptimasi |
| Penamaan | `[nomor]-[nama-gerakan].jpg` (cth: `01-qiyam.jpg`) |
| Lokasi | `/public/assets/img/gerakan/` |

### 11.2 Audio Bacaan

| Ketentuan | Spesifikasi |
|-----------|------------|
| Format | MP3 |
| Bitrate | 128kbps (cukup untuk audio bacaan) |
| Ukuran file | Maks 500KB per file |
| Penamaan | `[nomor_gerakan]-[nama-bacaan].mp3` (cth: `02-takbir.mp3`) |
| Lokasi | `/public/assets/audio/bacaan/` |

### 11.3 Video (Opsional)

| Ketentuan | Spesifikasi |
|-----------|------------|
| Sumber | YouTube embed URL atau file MP4 lokal |
| Format lokal | MP4 (H.264) |
| Cara embed | `<iframe>` YouTube atau `<video>` HTML5 |

### 11.4 Font

```html
<!-- Tambahkan di <head> semua halaman -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Amiri:ital@0;1&family=Inter:wght@400;600&family=Poppins:wght@600&display=swap" rel="stylesheet">
```

---

## 12. Kebutuhan Deployment

| ID | Kebutuhan |
|----|-----------|
| DEP-01 | Aplikasi wajib dapat diakses publik via URL saat penilaian |
| DEP-02 | URL live dicantumkan di README GitHub |
| DEP-03 | Siapkan minimal 1 hosting cadangan |
| DEP-04 | File `.env` tidak di-commit ke GitHub (masuk `.gitignore`) |
| DEP-05 | Database production terisi seed data terverifikasi |
| DEP-06 | Uji akses URL dari perangkat berbeda sebelum penilaian |

### Opsi Hosting Gratis

| Platform | Cocok Untuk | Catatan |
|----------|------------|---------|
| InfinityFree | PHP + MySQL | Gratis, cukup untuk projek ini |
| Railway | Laravel / Node + MySQL/Postgres | Free tier terbatas, performa baik |
| Render | Node Express / Laravel | Free tier ada sleep mode |
| Vercel | Frontend React/Vue (BE terpisah) | Gratis untuk FE statis |

---

## 13. Kebutuhan Keamanan

| ID | Kebutuhan |
|----|-----------|
| SEC-01 | Gunakan PDO prepared statement untuk semua query DB |
| SEC-02 | Validasi semua parameter input di backend sebelum diproses |
| SEC-03 | File konfigurasi DB (`.env`) masuk `.gitignore` |
| SEC-04 | Tidak menyimpan data sensitif di localStorage / sessionStorage |
| SEC-05 | HTTPS diaktifkan di hosting produksi jika tersedia |

---

## 14. Batasan Sistem

- Tidak ada fitur registrasi atau login pengguna
- Tidak ada fitur komentar atau forum
- Tidak ada fitur pencarian konten
- Tidak ada panel admin / CMS — perubahan konten via SQL langsung
- Tidak ada notifikasi push
- Tidak mendukung offline mode (PWA)
- Konten hanya Bahasa Indonesia (tidak multibahasa)

---

## 15. Asumsi & Ketergantungan

### Asumsi

- Tim memiliki akses ke buku HPT Muhammadiyah Kitab Shalat untuk verifikasi konten
- Tim memiliki akses internet untuk Google Fonts dan YouTube embed
- Hosting gratis yang dipilih mendukung PHP dan MySQL
- File audio MP3 bacaan sholat tersedia atau dapat direkam sendiri

### Ketergantungan

| Ketergantungan | Keterangan |
|---------------|-----------|
| Google Fonts | Font Amiri, Inter, Poppins |
| YouTube | Jika video embed dari YouTube |
| Hosting provider | Ketersediaan layanan saat penilaian |
| HPT Muhammadiyah | Sumber kebenaran konten bacaan |

---

## 16. Glosarium

| Istilah | Definisi |
|---------|----------|
| Qiyam | Berdiri tegak menghadap kiblat |
| Takbiratul ihram | Takbir pembuka sholat dengan mengangkat tangan |
| Iftitah | Doa pembuka setelah takbiratul ihram |
| Rukuk | Membungkuk dengan tangan di lutut |
| I'tidal | Bangkit berdiri tegak dari rukuk |
| Sujud | Meletakkan 7 anggota badan ke lantai |
| Iftirasy | Cara duduk dengan kaki kiri diduduki |
| Tawarruk | Cara duduk tasyahud akhir (kaki kiri ke kanan) |
| Tasyahud | Bacaan duduk pertengahan dan akhir sholat |
| Shalawat | Doa untuk Nabi Muhammad ﷺ di tasyahud akhir |
| Autoplay | Fitur putar otomatis berurutan gerakan + audio |
| Mode Dewasa | Tampilan konten lengkap dan formal |
| Mode Anak | Tampilan konten ringkas dan visual ramah anak |
| Seed data | Data awal yang dimasukkan ke database saat setup |
| Endpoint | URL spesifik pada API backend untuk mengambil data |

---

*Dokumen SRS ini disusun sebagai panduan teknis pembangunan Aplikasi Web Tuntunan Tata Cara Sholat.*  
*Setiap perubahan kebutuhan harus didiskusikan bersama tim dan diperbarui di dokumen ini.*  
*Pontianak, 2026*
