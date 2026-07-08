# SSD — System Design Document
## Aplikasi Web Tuntunan Tata Cara Sholat

**Versi:** 1.0
**Tanggal:** 2026
**Turunan dari:** SRS v1.0, PRD v1.0
**Stack baseline:** PHP Native (PDO) + MySQL — Opsi A pada PRD §10
**Status:** Draft untuk Pertemuan 1 (dilengkapi bertahap di P2–P3)

---

## Daftar Isi

1. [Tujuan & Ruang Lingkup Dokumen](#1-tujuan--ruang-lingkup-dokumen)
2. [Gambaran Arsitektur Sistem](#2-gambaran-arsitektur-sistem)
3. [Perancangan Basis Data](#3-perancangan-basis-data)
4. [Perancangan API](#4-perancangan-api)
5. [Perancangan Backend (Struktur & Pola)](#5-perancangan-backend-struktur--pola)
6. [Sequence Diagram — Alur Kritis](#6-sequence-diagram--alur-kritis)
7. [Keamanan](#7-keamanan)
8. [Performa & Caching](#8-performa--caching)
9. [Konfigurasi Lingkungan (Environment)](#9-konfigurasi-lingkungan-environment)
10. [Strategi Deployment](#10-strategi-deployment)
11. [Konvensi Kode](#11-konvensi-kode)
12. [Lampiran — Pemetaan ke Laravel / Node.js](#12-lampiran--pemetaan-ke-laravel--nodejs)

---

## 1. Tujuan & Ruang Lingkup Dokumen

SRS mendefinisikan **apa** yang harus dibangun; PRD merangkum **fitur & prioritas**. Dokumen ini
mendefinisikan **bagaimana** sistem dibangun secara teknis: struktur basis data final (dengan
index, constraint, dan strategi migrasi), kontrak API lengkap (termasuk skenario error), pola
arsitektur backend, dan keputusan desain yang mengikat seluruh anggota tim agar kode yang
ditulis oleh Front-end Dev, Back-end Dev, dan DB Engineer saling kompatibel tanpa perlu
koordinasi ulang di tiap pertemuan.

Dokumen ini **mengikat** — perubahan struktur tabel, nama endpoint, atau format response harus
disepakati bersama dan dicatat di sini sebelum diimplementasikan, karena Front-end sudah akan
mengasumsikan kontrak yang tertulis di §4.

---

## 2. Gambaran Arsitektur Sistem

### 2.1 Pola Arsitektur

Sistem menggunakan **3-tier layered architecture** dengan pola **MVC (Model-View-Controller)**
yang disederhanakan di sisi backend, dipisah tegas menjadi:

- **Presentation Layer (Frontend):** halaman HTML yang di-render oleh PHP (server-side) untuk
  route halaman (`/`, `/gerakan`, `/gerakan/:id`), ditambah JavaScript sisi klien yang melakukan
  `fetch()` ke API untuk data dinamis (audio state, autoplay, toggle mode tanpa reload).
- **Application Layer (Backend):** Router → Controller → Service (opsional) → Model. Controller
  tidak pernah bicara langsung ke SQL; semua akses data lewat Model.
- **Data Layer:** MySQL diakses eksklusif melalui PDO dengan prepared statement lewat kelas
  `Database` singleton.

```
┌───────────────────────────────────────────────────────────────────┐
│                            CLIENT (Browser)                       │
│  index.php (view) ─── gerakan.php (view) ─── detail.php (view)   │
│  assets/js/{audio-player, autoplay, navigasi}.js  (fetch → API)  │
└──────────────────────────────┬────────────────────────────────────┘
                                │ HTTPS — HTML (SSR) + JSON (AJAX)
┌──────────────────────────────▼────────────────────────────────────┐
│                         APPLICATION LAYER                         │
│  ┌─────────────┐   ┌───────────────────┐   ┌───────────────────┐  │
│  │   Router     │──▶│    Controller      │──▶│      Model        │  │
│  │ (api/*.php)  │   │ GerakanController  │   │ Gerakan.php        │  │
│  │              │   │ BacaanController   │   │ Bacaan.php          │  │
│  │              │   │ KelompokController │   │ Kelompok.php        │  │
│  └─────────────┘   └───────────────────┘   └─────────┬─────────┘  │
│                                                        │ PDO       │
└────────────────────────────────────────────────────────┼───────────┘
                                                          │ Prepared Stmt
┌─────────────────────────────────────────────────────────▼─────────┐
│                            DATA LAYER                              │
│              MySQL 8 — database `tuntunan_sholat`                 │
│     kelompok · kategori · gerakan · bacaan  (lihat §3)            │
└─────────────────────────────────────────────────────────────────────┘
                                                          │
┌─────────────────────────────────────────────────────────▼─────────┐
│                     STATIC ASSET STORAGE                           │
│         public/assets/img/gerakan/  ·  public/assets/audio/bacaan/│
└─────────────────────────────────────────────────────────────────────┘
```

### 2.2 Keputusan Arsitektur Kunci (ADR ringkas)

| # | Keputusan | Alasan | Trade-off |
|---|-----------|--------|-----------|
| AD-01 | Halaman utama di-render server-side (PHP `include` partial), bukan SPA penuh | Lebih sederhana untuk tim tanpa build tool; SEO & load time lebih baik untuk 3 halaman statis | Interaktivitas (autoplay, toggle mode) tetap butuh JS + fetch API |
| AD-02 | Data dinamis (gerakan, bacaan) diambil lewat REST API JSON, bukan langsung di-embed PHP | Memenuhi F-09 (no hardcode) + memungkinkan FE-JS mengambil ulang data saat Next/Prev tanpa reload | Butuh 2 mekanisme render (SSR untuk shell halaman, CSR-fetch untuk konten) |
| AD-03 | Satu koneksi PDO per request via singleton `Database` | Hindari koneksi berulang, konsisten prepared statement | Tidak scalable untuk high concurrency — cukup untuk skala tugas kuliah |
| AD-04 | Tidak ada autentikasi/session pengguna | Sesuai batasan sistem (SRS §14) — aplikasi read-only publik | — |
| AD-05 | Mode aktif disimpan di `sessionStorage` sisi klien, dikirim sebagai query param `?kategori=` | Tidak butuh session server, stateless API | Mode reset jika pindah browser/tab baru — sudah sesuai FE-04 |

### 2.3 Request Flow Ringkas

```
Browser → GET /gerakan/5
   → detail.php (view shell) di-render
   → detail.php memuat detail.js
   → detail.js: fetch('/api/gerakan/5') → GerakanController::show(5) → Gerakan::findById(5) → DB
   → detail.js: fetch('/api/bacaan?id_gerakan=5') → BacaanController::index() → Bacaan::findByGerakan(5) → DB
   → JS merender konten ke DOM (gambar, teks Arab/Latin/terjemahan, audio player)
```

---

## 3. Perancangan Basis Data

### 3.1 Prinsip Desain

- Skema sudah **3NF** (setiap tabel non-kunci hanya bergantung pada primary key): `gerakan`
  tidak menyimpan teks bacaan berulang, `bacaan` tidak menyimpan nama gerakan berulang.
- Semua tabel menggunakan `utf8mb4` agar teks Arab (harakat, huruf sambung) tersimpan benar —
  **jangan** gunakan `utf8` biasa (4-byte character tidak didukung penuh).
- `urutan` disimpan eksplisit di `gerakan` dan `bacaan` (bukan hanya mengandalkan `id`) supaya
  urutan tampil tidak rusak jika ada baris yang dihapus/disisipkan di tengah.
- Tidak ada tabel `users`/auth sesuai batasan sistem — `kelompok` adalah tabel identitas statis
  (idealnya hanya 1 baris).

### 3.2 ERD

```
┌─────────────────┐        ┌─────────────────┐        ┌─────────────────┐        ┌─────────────────┐
│    kelompok      │        │    kategori      │        │    gerakan       │        │     bacaan       │
├─────────────────┤        ├─────────────────┤        ├─────────────────┤        ├─────────────────┤
│ id PK            │        │ id PK            │───1:N─▶│ id PK             │───1:N─▶│ id PK             │
│ nama_kelompok     │        │ nama (enum-like) │        │ id_kategori FK   │        │ id_gerakan FK    │
│ prodi             │        └─────────────────┘        │ nama              │        │ urutan            │
│ mata_kuliah        │        (berdiri sendiri,          │ urutan            │        │ teks_arab         │
│ dosen              │         tidak berelasi)           │ deskripsi         │        │ teks_latin        │
└─────────────────┘                                    │ gambar_url        │        │ terjemahan        │
                                                          │ video_url         │        │ audio_url         │
                                                          │ created_at        │        │ sumber            │
                                                          └─────────────────┘        │ created_at        │
                                                                                       └─────────────────┘
```

**Kardinalitas:**
- `kategori (1) ── (N) gerakan` — satu kategori (dewasa/anak) punya banyak gerakan.
- `gerakan (1) ── (N) bacaan` — satu gerakan bisa punya lebih dari satu bacaan (mis. gerakan
  "Duduk tasyahud akhir" punya bacaan tasyahud + shalawat sebagai 2 baris `bacaan`).
- `kelompok` berdiri sendiri, tidak punya FK ke/dari tabel lain — hanya sumber data header.

### 3.3 DDL Final (dengan Index & Constraint)

```sql
-- ============================================
-- DATABASE: tuntunan_sholat
-- Character set WAJIB utf8mb4 untuk teks Arab
-- ============================================
CREATE DATABASE IF NOT EXISTS tuntunan_sholat
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tuntunan_sholat;

-- --------------------------------------------
-- Tabel: kelompok
-- Idealnya hanya berisi 1 baris (identitas header)
-- --------------------------------------------
CREATE TABLE kelompok (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nama_kelompok VARCHAR(100) NOT NULL,
  prodi         VARCHAR(100) NOT NULL,
  mata_kuliah   VARCHAR(100) NOT NULL,
  dosen         VARCHAR(100) NOT NULL,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- --------------------------------------------
-- Tabel: kategori
-- Nilai tetap: 'dewasa' (id=1), 'anak' (id=2)
-- --------------------------------------------
CREATE TABLE kategori (
  id   INT AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(20) NOT NULL UNIQUE
);

-- --------------------------------------------
-- Tabel: gerakan
-- --------------------------------------------
CREATE TABLE gerakan (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  id_kategori  INT          NOT NULL,
  nama         VARCHAR(100) NOT NULL,
  urutan       SMALLINT     NOT NULL,
  deskripsi    TEXT,
  gambar_url   VARCHAR(255),
  video_url    VARCHAR(255) NULL,
  created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_kategori) REFERENCES kategori(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_kategori_urutan (id_kategori, urutan),
  CONSTRAINT uq_kategori_urutan UNIQUE (id_kategori, urutan)
);

-- --------------------------------------------
-- Tabel: bacaan
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

**Catatan desain index:**
- `idx_kategori_urutan` mempercepat query utama `SELECT ... WHERE id_kategori = ? ORDER BY urutan`
  yang dipanggil di setiap load halaman list gerakan (F-01).
- `uq_kategori_urutan` mencegah dua gerakan punya nomor urut sama dalam satu kategori —
  melindungi integritas data saat DB & Content Engineer input manual.
- `idx_gerakan_urutan` mempercepat `SELECT ... WHERE id_gerakan = ? ORDER BY urutan` (F-02, F-03).
- `ON DELETE CASCADE` di `bacaan` → hapus gerakan otomatis hapus bacaan terkait (hindari orphan
  row). `ON DELETE RESTRICT` di `gerakan` → kategori tidak boleh dihapus jika masih punya
  gerakan (mencegah hapus tidak sengaja yang merusak seluruh mode).

### 3.4 Seed Data & Strategi Migrasi

- File `database/schema.sql` berisi DDL di atas (idempotent dengan `IF NOT EXISTS`).
- File `database/seed.sql` berisi `INSERT` untuk `kelompok`, `kategori`, `gerakan` (×2 kategori),
  `bacaan` — **wajib** teks final terverifikasi HPT, bukan placeholder `[ ]`.
- Urutan eksekusi wajib: `schema.sql` → `seed.sql`. Dokumentasikan perintah ini di README:
  ```bash
  mysql -u <user> -p tuntunan_sholat < database/schema.sql
  mysql -u <user> -p tuntunan_sholat < database/seed.sql
  ```
- **Tidak ada migration tool** (Laravel Migration/Doctrine) di Opsi A — perubahan skema
  dilakukan dengan menulis ulang `schema.sql` dan mendokumentasikan versi di changelog bagian
  bawah file tersebut (`-- v1.1: tambah kolom X, tanggal, alasan`).

---

## 4. Perancangan API

### 4.1 Prinsip Umum

- REST over HTTPS, response selalu **JSON UTF-8**, `Content-Type: application/json`.
- Base path: `/api/`. Tidak ada versioning (`/v1/`) — skala proyek kecil, cukup 5 endpoint.
- Semua response mengikuti **amplop standar**:

```json
// Sukses
{ "status": "success", "data": { ... } }

// Error
{ "status": "error", "message": "Pesan yang jelas untuk ditampilkan/di-debug", "code": "GERAKAN_NOT_FOUND" }
```

- Kode `code` (machine-readable) ditambahkan di atas kontrak SRS agar FE bisa membedakan jenis
  error tanpa parsing string `message`.

### 4.2 Status Code Standar

| HTTP Code | Kapan digunakan |
|-----------|------------------|
| 200 OK | Request berhasil, data ditemukan (termasuk array kosong `[]`) |
| 400 Bad Request | Parameter query tidak valid (mis. `kategori=xyz` bukan `dewasa`/`anak`) |
| 404 Not Found | Resource dengan `id` tertentu tidak ada (`/api/gerakan/999`) |
| 405 Method Not Allowed | Method selain GET dipanggil (API ini read-only) |
| 500 Internal Server Error | Kegagalan koneksi DB / exception tak terduga (jangan expose stack trace ke response) |

### 4.3 Katalog Endpoint

| Method | Endpoint | Query/Path Param | Deskripsi |
|--------|----------|-------------------|-----------|
| GET | `/api/kelompok` | — | Identitas kelompok untuk header |
| GET | `/api/gerakan` | `?kategori=dewasa\|anak` (wajib) | Daftar gerakan sesuai mode, urut `urutan` ASC |
| GET | `/api/gerakan/:id` | path `id` (int) | Detail satu gerakan |
| GET | `/api/bacaan` | `?id_gerakan=:id` (wajib) | Semua bacaan milik satu gerakan, urut `urutan` ASC |
| GET | `/api/health` | — | Health check untuk QA/deployment (lihat §4.5) |

### 4.4 Spesifikasi Detail per Endpoint

#### `GET /api/kelompok`

```json
// 200 OK
{
  "status": "success",
  "data": {
    "nama_kelompok": "Kelompok 1",
    "prodi": "Manajemen Bisnis Syariah",
    "mata_kuliah": "Pengembangan Aplikasi Web",
    "dosen": "Dedy Susanto, S.Pd.I., M.M."
  }
}

// 500 — tabel kosong/DB error
{ "status": "error", "message": "Data kelompok belum tersedia", "code": "KELOMPOK_NOT_CONFIGURED" }
```

#### `GET /api/gerakan?kategori=dewasa`

```json
// 200 OK
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nama": "Berdiri tegak (qiyam) + niat",
      "urutan": 1,
      "deskripsi": "...",
      "gambar_url": "/assets/img/gerakan/01-qiyam.jpg",
      "video_url": null
    }
  ]
}

// 400 — kategori tidak valid atau tidak dikirim
{ "status": "error", "message": "Parameter kategori wajib diisi: dewasa atau anak", "code": "INVALID_KATEGORI" }
```

**Validasi backend (BE-03):** whitelist `kategori` hanya boleh `dewasa` / `anak`, di-mapping ke
`id_kategori` lewat lookup ke tabel `kategori` — **jangan** menerima `id_kategori` mentah dari
client untuk mencegah enumerasi ID sembarangan.

#### `GET /api/gerakan/:id`

```json
// 200 OK — sama seperti struktur item di atas, tapi object tunggal

// 404
{ "status": "error", "message": "Gerakan tidak ditemukan", "code": "GERAKAN_NOT_FOUND" }

// 400 — id bukan angka
{ "status": "error", "message": "ID gerakan tidak valid", "code": "INVALID_ID" }
```

#### `GET /api/bacaan?id_gerakan=2`

```json
// 200 OK
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "urutan": 1,
      "teks_arab": "اللهُ أَكْبَرُ",
      "teks_latin": "Allāhu Akbar",
      "terjemahan": "Allah Maha Besar",
      "audio_url": "/assets/audio/bacaan/02-takbir.mp3",
      "sumber": "HPT Muhammadiyah, Kitab Shalat"
    }
  ]
}

// 200 OK — gerakan tanpa bacaan (mis. gerakan "berdiri ke rakaat berikutnya")
{ "status": "success", "data": [] }

// 400 — id_gerakan tidak dikirim/tidak valid
{ "status": "error", "message": "Parameter id_gerakan wajib diisi", "code": "INVALID_ID_GERAKAN" }
```

**Catatan penting untuk FE:** array kosong `[]` adalah respons **valid** (200), bukan error —
gunakan ini untuk menampilkan pesan "Tidak ada bacaan khusus untuk gerakan ini" alih-alih
toast error (lihat F-03.5 hanya berlaku untuk kegagalan *load file audio*, bukan data kosong).

#### `GET /api/health` (tambahan — bukan di SRS asli, direkomendasikan untuk QA §DEP-06)

```json
{ "status": "success", "data": { "db": "connected", "time": "2026-07-01T10:00:00+07:00" } }
```
Berguna bagi QA & Deployment untuk memverifikasi koneksi DB production tanpa membuka DevTools.

### 4.5 CORS

Karena view (`index.php`, `gerakan.php`, `detail.php`) dan API (`api/*.php`) berada di domain
yang sama (satu deployment PHP), **CORS tidak wajib** untuk Opsi A. Jika tim memisahkan FE
(mis. hosting statis di Vercel) dari BE (Railway/Render), tambahkan header berikut di setiap
response API:

```php
header('Access-Control-Allow-Origin: https://domain-frontend-kalian.com');
header('Access-Control-Allow-Methods: GET');
```

---

## 5. Perancangan Backend (Struktur & Pola)

### 5.1 Struktur Folder Final

```
tuntunan-sholat/
├── public/                        ← document root (di-set di hosting)
│   ├── index.php                  ← view: beranda
│   ├── gerakan.php                ← view: list gerakan
│   ├── detail.php                 ← view: detail gerakan
│   ├── .htaccess                  ← rewrite rules (lihat 5.4)
│   └── assets/
│       ├── css/style.css
│       ├── js/
│       │   ├── api-client.js      ← wrapper fetch() + error handling terpusat
│       │   ├── audio-player.js
│       │   ├── autoplay.js
│       │   └── navigasi.js
│       ├── img/gerakan/
│       └── audio/bacaan/
├── app/
│   ├── config/
│   │   ├── database.php           ← baca .env, expose koneksi PDO
│   │   └── env.php                ← loader sederhana .env → getenv()
│   ├── core/
│   │   ├── Database.php           ← singleton PDO
│   │   ├── Router.php             ← mapping method+path → controller (opsional, atau .htaccess)
│   │   └── Response.php           ← helper json_success()/json_error() (§5.3)
│   ├── models/
│   │   ├── Gerakan.php
│   │   ├── Bacaan.php
│   │   └── Kelompok.php
│   ├── controllers/
│   │   ├── GerakanController.php
│   │   ├── BacaanController.php
│   │   └── KelompokController.php
│   └── partials/
│       ├── header.php             ← render identitas kelompok + toggle mode
│       ├── nav.php
│       └── footer.php
├── api/
│   ├── kelompok.php                ← entry point, panggil KelompokController
│   ├── gerakan.php
│   ├── bacaan.php
│   └── health.php
├── database/
│   ├── schema.sql
│   └── seed.sql
├── docs/
│   ├── SRS.md
│   ├── PRD.md
│   ├── SSD.md                      ← dokumen ini
│   └── laporan/
├── .env.example
├── .gitignore
└── README.md
```

### 5.2 Tanggung Jawab per Layer

| Layer | File | Tanggung Jawab | TIDAK boleh |
|-------|------|-----------------|--------------|
| Entry point | `api/gerakan.php` | Terima request, panggil Controller, kirim Response | Query SQL langsung |
| Controller | `GerakanController.php` | Validasi input (whitelist `kategori`, cast `id` ke int), panggil Model, format Response | Membentuk SQL string manual |
| Model | `Gerakan.php` | Satu-satunya layer yang menyentuh SQL, selalu via prepared statement | Mengetahui format HTTP/JSON |
| Core/Database | `Database.php` | Singleton koneksi PDO, exception handling koneksi | Logika bisnis |

Pola ini memastikan **pembagian peran tim tetap jelas**: Backend Dev fokus di
`controllers/` + `api/`, DB & Content Engineer fokus di `models/` + `database/`, tanpa
tabrakan file saat commit paralel.

### 5.3 Contoh Kontrak Kode (acuan implementasi, bukan kode final)

```php
// app/core/Database.php — Singleton PDO
class Database {
    private static ?PDO $instance = null;

    public static function connect(): PDO {
        if (self::$instance === null) {
            $dsn = 'mysql:host=' . getenv('DB_HOST') . ';dbname=' . getenv('DB_NAME') . ';charset=utf8mb4';
            self::$instance = new PDO($dsn, getenv('DB_USER'), getenv('DB_PASS'), [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            ]);
        }
        return self::$instance;
    }
}
```

```php
// app/models/Gerakan.php — contoh Model, prepared statement wajib (SEC-01)
class Gerakan {
    public static function findByKategori(int $idKategori): array {
        $db = Database::connect();
        $stmt = $db->prepare('SELECT id, nama, urutan, deskripsi, gambar_url, video_url
                               FROM gerakan WHERE id_kategori = :id ORDER BY urutan ASC');
        $stmt->execute(['id' => $idKategori]);
        return $stmt->fetchAll();
    }

    public static function findById(int $id): ?array {
        $db = Database::connect();
        $stmt = $db->prepare('SELECT * FROM gerakan WHERE id = :id');
        $stmt->execute(['id' => $id]);
        $row = $stmt->fetch();
        return $row ?: null;
    }
}
```

```php
// app/core/Response.php — amplop JSON terstandar (§4.1)
class Response {
    public static function success($data, int $httpCode = 200): void {
        http_response_code($httpCode);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'success', 'data' => $data], JSON_UNESCAPED_UNICODE);
    }

    public static function error(string $message, string $code, int $httpCode = 400): void {
        http_response_code($httpCode);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'error', 'message' => $message, 'code' => $code], JSON_UNESCAPED_UNICODE);
    }
}
```

> `JSON_UNESCAPED_UNICODE` **wajib** disertakan — tanpa flag ini, teks Arab akan ter-escape
> menjadi `\uXXXX` di response dan sulit di-debug oleh Front-end Dev.

### 5.4 Routing

Opsi A tidak memakai router framework. Dua pendekatan yang diperbolehkan:

1. **File-based routing** (direkomendasikan, paling sederhana): setiap endpoint = satu file
   PHP di `api/` (`api/gerakan.php` menangani `GET /api/gerakan` dan `GET /api/gerakan/:id`
   dengan membaca `$_GET['id']` atau path info).
2. **`.htaccess` rewrite** jika ingin URL bersih `/api/gerakan/5` tanpa `?id=5`:
   ```apacheconf
   RewriteEngine On
   RewriteRule ^api/gerakan/([0-9]+)$ api/gerakan.php?id=$1 [L,QSA]
   ```

---

## 6. Sequence Diagram — Alur Kritis

### 6.1 Membuka Halaman Detail Gerakan (F-02, UC-02)

```
User          Browser/JS         API (gerakan.php)   Controller        Model            DB
 │  klik kartu    │                      │                  │              │              │
 │───────────────▶│                      │                  │              │              │
 │                │  navigate /gerakan/5 │                  │              │              │
 │                │─────────────────────▶│ (SSR shell)      │              │              │
 │                │                      │                  │              │              │
 │                │  fetch /api/gerakan/5│                  │              │              │
 │                │─────────────────────▶│─────────────────▶│─────────────▶│─────────────▶│
 │                │                      │                  │  validate id │  SELECT ...  │
 │                │                      │                  │              │◀─────────────│
 │                │◀─────────────────────│◀─────────────────│◀─────────────│              │
 │                │  fetch /api/bacaan?id_gerakan=5          │              │              │
 │                │─────────────────────▶│─────────────────▶│─────────────▶│─────────────▶│
 │                │◀─────────────────────│◀─────────────────│◀─────────────│◀─────────────│
 │  render UI     │                      │                  │              │              │
 │◀───────────────│                      │                  │              │              │
```

### 6.2 Autoplay Berurutan (F-06, UC-04)

```
autoplay.js                   audio-player.js              navigasi.js
    │  toggle autoplay = true       │                            │
    │───────────────────────────────▶│ play(audio_url gerakan N)  │
    │                                │                            │
    │                                │  event 'ended'             │
    │◀───────────────────────────────│                            │
    │  if urutan N < 13:                                          │
    │───────────────────────────────────────────────────────────▶│ goToGerakan(N+1)
    │                                                              │  fetch detail+bacaan
    │                                                              │  render + auto play(audio N+1)
    │  if urutan N == 13:                                         │
    │  set autoplay = false, tampilkan indikator selesai           │
```

Implementasi kunci: `audio-player.js` mengekspos event `onEnded(callback)`; `autoplay.js`
mendaftarkan callback yang memanggil `navigasi.js#next()` hanya jika toggle autoplay aktif —
memisahkan tanggung jawab agar F-05 (manual next/prev) dan F-06 (autoplay) memakai fungsi
navigasi yang sama, menghindari duplikasi logika (NF-06.3).

---

## 7. Keamanan

| ID | Implementasi Teknis |
|----|----------------------|
| SEC-01 | Semua query lewat `PDO::prepare()` + bind parameter bernama — **tidak ada** string concatenation SQL di seluruh codebase (audit manual sebelum P3) |
| SEC-02 | Controller memvalidasi: `id` harus `ctype_digit`, `kategori` harus in-array `['dewasa','anak']` sebelum diteruskan ke Model |
| SEC-03 | `.env` di root, dibaca via `getenv()`/`parse_ini_file`, masuk `.gitignore`; `.env.example` di-commit sebagai template |
| SEC-04 | Tidak ada data sensitif tersimpan di `sessionStorage` — hanya string `"dewasa"`/`"anak"` |
| SEC-05 | HTTPS via hosting (Let's Encrypt otomatis di Railway/Render; InfinityFree sediakan opsi Free SSL) |
| Tambahan | Escape output HTML view (`htmlspecialchars()`) untuk data yang di-render server-side di `header.php` (nama kelompok, dsb.) — mencegah XSS jika suatu saat data diedit lewat form |

---

## 8. Performa & Caching

- **Kompresi gambar**: wajib WebP/JPG teroptimasi ≤200KB (sesuai SRS §11.1) — dilakukan manual
  oleh DB & Content Engineer sebelum commit aset, gunakan tools seperti Squoosh/TinyPNG.
- **HTTP caching header** untuk aset statis (gambar/audio), tambahkan di `.htaccess`:
  ```apacheconf
  <FilesMatch "\.(jpg|webp|mp3)$">
    Header set Cache-Control "public, max-age=604800"
  </FilesMatch>
  ```
- **Lazy load** gambar di list gerakan (`loading="lazy"` pada `<img>`) agar 13 kartu tidak
  memuat semua gambar sekaligus saat halaman list dibuka — membantu target ≤5 detik (NF-02.1).
- **N+1 query dihindari**: `GET /api/gerakan?kategori=` mengambil semua 13 baris dalam satu
  query (bukan loop per baris) — sudah tercermin di `Gerakan::findByKategori()`.

---

## 9. Konfigurasi Lingkungan (Environment)

`.env.example` (commit ke repo, isi asli di `.env` lokal/hosting saja):

```
DB_HOST=localhost
DB_NAME=tuntunan_sholat
DB_USER=root
DB_PASS=
APP_ENV=local
```

`app/config/env.php` bertugas memuat `.env` ke `getenv()` di awal setiap request (via
`require` di `public/index.php`, `gerakan.php`, `detail.php`, dan setiap file `api/*.php`).

---

## 10. Strategi Deployment

Mengikuti SRS §12 (DEP-01 s.d. DEP-06):

1. Pilih hosting: **InfinityFree** (PHP+MySQL gratis, paling sederhana untuk Opsi A) atau
   **Railway** (jika butuh env var management lebih baik).
2. Upload isi `public/` sebagai document root; folder `app/`, `database/`, `docs/` diletakkan
   **di luar** document root publik jika hosting mendukung (mencegah source code backend bisa
   diakses langsung via URL) — jika hosting shared tidak mendukung struktur ini, minimal beri
   `.htaccess` yang menolak akses langsung ke `app/`:
   ```apacheconf
   # app/.htaccess
   Deny from all
   ```
3. Import `schema.sql` lalu `seed.sql` ke database production via phpMyAdmin/CLI.
4. Set `.env` production langsung di panel hosting (jangan commit).
5. Uji `GET /api/health` dari luar jaringan kampus untuk pastikan DB production tersambung.
6. Uji akses URL dari 3 perangkat berbeda (mobile/tablet/desktop) — DEP-06.

---

## 11. Konvensi Kode

| Aspek | Aturan |
|-------|--------|
| Penamaan file PHP | PascalCase untuk class (`GerakanController.php`), snake_case untuk view (`index.php` tetap) |
| Penamaan fungsi/method | camelCase (`findByKategori`) |
| Penamaan kolom DB | snake_case (sudah konsisten di skema §3.3) |
| Penamaan JS file/fungsi | kebab-case file, camelCase fungsi |
| Commit message | `[FE/BE/DB] deskripsi singkat` — memudahkan PM audit kontribusi individual (NF-05.2) |
| Branch | `main` = stabil; `feature/nama-fitur` per anggota, merge via PR direview PM |

---

## 12. Lampiran — Pemetaan ke Laravel / Node.js

Jika kelompok memilih Opsi B, struktur konsep di dokumen ini tetap berlaku, hanya
penamaan/tooling yang berubah:

| Konsep di SSD ini | Laravel | Node.js (Express) |
|---------------------|---------|--------------------|
| `app/models/Gerakan.php` | Eloquent Model `Gerakan` | `models/Gerakan.js` (mis. Sequelize/Prisma) |
| `app/controllers/*Controller.php` | `app/Http/Controllers/GerakanController.php` | `controllers/gerakanController.js` |
| `api/gerakan.php` (routing manual) | `routes/api.php` | `routes/gerakan.js` + `app.use()` |
| `database/schema.sql` | Migration files (`php artisan make:migration`) | Migration via Sequelize CLI / Prisma schema |
| `.env` loader manual | Native `.env` support (Laravel) | `dotenv` package |
| `app/core/Response.php` | Laravel `response()->json()` built-in | `res.json()` built-in |
| Prepared statement manual | Query Builder/Eloquent otomatis parameterized | Parameterized query via `mysql2`/ORM |

Kontrak API (§4) dan skema DB (§3) **tidak berubah** — ini yang menjaga Front-end tetap
kompatibel apa pun stack backend yang akhirnya dipilih.

---

*Dokumen SSD ini melengkapi SRS.md dan PRD.md sebagai acuan teknis implementasi.*
*Perubahan struktur DB/API wajib diperbarui di sini sebelum dikerjakan agar tidak memutus kontrak dengan Front-end.*
*Pontianak, 2026*
