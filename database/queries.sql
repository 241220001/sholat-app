-- ============================================================
-- QUERY BACKEND: tuntunan_sholat
-- Kumpulan query siap pakai untuk layer Model (PDO prepared
-- statement — ganti :placeholder sesuai driver yang dipakai)
-- ============================================================

-- (a) Daftar gerakan berdasarkan kategori (list, F-01)
SELECT id, nama, urutan, gambar_url, video_url
FROM gerakan
WHERE id_kategori = :id_kategori
ORDER BY urutan ASC;

-- (b) Detail satu gerakan (F-02)
SELECT id, id_kategori, nama, urutan, deskripsi, gambar_url, video_url
FROM gerakan
WHERE id = :id;

-- (c) Seluruh bacaan suatu gerakan (F-02, F-03)
SELECT id, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber
FROM bacaan
WHERE id_gerakan = :id_gerakan
ORDER BY urutan ASC;

-- (d) Identitas kelompok (F-08)
SELECT nama_kelompok, prodi, mata_kuliah, dosen
FROM kelompok
ORDER BY id ASC
LIMIT 1;

-- (e) Data autoplay (F-06) — gerakan + bacaan sekaligus, 1 kategori
SELECT
  g.id            AS gerakan_id,
  g.nama          AS gerakan_nama,
  g.urutan        AS gerakan_urutan,
  g.gambar_url,
  g.video_url,
  b.id            AS bacaan_id,
  b.urutan        AS bacaan_urutan,
  b.teks_arab,
  b.teks_latin,
  b.terjemahan,
  b.audio_url,
  b.sumber
FROM gerakan g
LEFT JOIN bacaan b ON b.id_gerakan = g.id
WHERE g.id_kategori = :id_kategori
ORDER BY g.urutan ASC, b.urutan ASC;

-- (f) Gerakan berikutnya (Next, F-05)
SELECT id, nama, urutan
FROM gerakan
WHERE id_kategori = :id_kategori AND urutan > :urutan_sekarang
ORDER BY urutan ASC
LIMIT 1;

-- (g) Gerakan sebelumnya (Previous, F-05)
SELECT id, nama, urutan
FROM gerakan
WHERE id_kategori = :id_kategori AND urutan < :urutan_sekarang
ORDER BY urutan DESC
LIMIT 1;

-- (h) Total jumlah gerakan (indikator "gerakan X dari 14")
SELECT COUNT(*) AS total_gerakan
FROM gerakan
WHERE id_kategori = :id_kategori;

-- (i) Gerakan pertama (urutan = 1, dipakai saat autoplay mulai)
SELECT id, nama, urutan, gambar_url, video_url
FROM gerakan
WHERE id_kategori = :id_kategori
ORDER BY urutan ASC
LIMIT 1;

-- (j) Gerakan terakhir (urutan = MAX, deteksi akhir autoplay / disable tombol Next)
SELECT id, nama, urutan, gambar_url, video_url
FROM gerakan
WHERE id_kategori = :id_kategori
ORDER BY urutan DESC
LIMIT 1;