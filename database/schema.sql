-- ============================================================
-- DATABASE : tuntunan_sholat
-- Engine   : InnoDB (wajib untuk FOREIGN KEY & transaksi)
-- Charset  : utf8mb4 (WAJIB agar teks Arab berharakat tersimpan
--            & tampil dengan benar)
-- Sumber   : Analisis & Perancangan Database - Aplikasi Web
--            Tuntunan Tata Cara Sholat, §11
-- Versi    : v1.0
-- ============================================================

CREATE DATABASE IF NOT EXISTS tuntunan_sholat
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE tuntunan_sholat;

-- ------------------------------------------------------------
-- Tabel: kelompok
-- Idealnya hanya berisi 1 baris (identitas header)
-- ------------------------------------------------------------
CREATE TABLE kelompok (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama_kelompok VARCHAR(100) NOT NULL,
  prodi         VARCHAR(100) NOT NULL,
  mata_kuliah   VARCHAR(100) NOT NULL,
  dosen         VARCHAR(100) NOT NULL,
  created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabel: kategori
-- Nilai tetap: id=1 'dewasa', id=2 'anak'
-- ------------------------------------------------------------
CREATE TABLE kategori (
  id   INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  nama VARCHAR(20) NOT NULL,
  CONSTRAINT uq_kategori_nama UNIQUE (nama),
  CONSTRAINT chk_kategori_nama CHECK (nama IN ('dewasa','anak'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabel: gerakan
-- Satu baris per gerakan sholat per kategori
-- ------------------------------------------------------------
CREATE TABLE gerakan (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_kategori  INT UNSIGNED NOT NULL,
  nama         VARCHAR(100) NOT NULL,
  urutan       SMALLINT UNSIGNED NOT NULL,
  deskripsi    TEXT NULL,
  gambar_url   VARCHAR(255) NULL,
  video_url    VARCHAR(255) NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
              ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_gerakan_kategori
    FOREIGN KEY (id_kategori) REFERENCES kategori(id)
    ON DELETE RESTRICT ON UPDATE CASCADE,

  CONSTRAINT uq_kategori_urutan UNIQUE (id_kategori, urutan),
  CONSTRAINT chk_gerakan_urutan CHECK (urutan BETWEEN 1 AND 14),

  INDEX idx_kategori_urutan (id_kategori, urutan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- Tabel: bacaan
-- Satu gerakan bisa punya 0..N bacaan (relasi opsional)
-- ------------------------------------------------------------
CREATE TABLE bacaan (
  id           INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  id_gerakan   INT UNSIGNED NOT NULL,
  urutan       SMALLINT UNSIGNED NOT NULL,
  teks_arab    TEXT NULL,
  teks_latin   TEXT NULL,
  terjemahan   TEXT NULL,
  audio_url    VARCHAR(255) NULL,
  sumber       VARCHAR(150) NULL,
  created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
              ON UPDATE CURRENT_TIMESTAMP,

  CONSTRAINT fk_bacaan_gerakan
    FOREIGN KEY (id_gerakan) REFERENCES gerakan(id)
    ON DELETE CASCADE ON UPDATE CASCADE,

  CONSTRAINT uq_gerakan_urutan UNIQUE (id_gerakan, urutan),
  CONSTRAINT chk_bacaan_urutan CHECK (urutan >= 1),

  INDEX idx_gerakan_urutan (id_gerakan, urutan)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- v1.0: skema awal (kelompok, kategori, gerakan, bacaan)