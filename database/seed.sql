-- ============================================================
-- SEED DATA: tuntunan_sholat
-- WAJIB dijalankan setelah schema.sql, urutan tidak boleh diubah:
--   1. kategori  2. kelompok  3. gerakan  4. bacaan
-- Placeholder bertanda [ ... ] WAJIB diverifikasi/diisi ulang
-- sebelum masuk ke database production (lihat §15 dokumen analisis).
-- ============================================================

USE tuntunan_sholat;

-- ------------------------------------------------------------
-- 1) KATEGORI (wajib pertama — direferensikan FK gerakan)
-- ------------------------------------------------------------
INSERT INTO kategori (nama) VALUES
('dewasa'),
('anak');

-- ------------------------------------------------------------
-- 2) KELOMPOK (identitas header — PLACEHOLDER, lengkapi dulu)
-- ------------------------------------------------------------
INSERT INTO kelompok (nama_kelompok, prodi, mata_kuliah, dosen) VALUES
('Kelompok 1',
    'Teknik Informatika',
    'AIK 4',
    'Dedy Susanto, S.Pd.I., M.M.');

-- ------------------------------------------------------------
-- 3) GERAKAN — Mode Dewasa (id_kategori = 1)
-- ------------------------------------------------------------
INSERT INTO gerakan (id_kategori, nama, urutan, deskripsi, gambar_url, video_url) VALUES
(1, 'Berdiri tegak (qiyam) + niat',   1,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/01-qiyam.jpg', NULL),
(1, 'Takbiratul ihram',               2,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/02-takbir.jpg', NULL),
(1, 'Bersedekap + doa iftitah',       3,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/03-sedekap.jpg', NULL),
(1, 'Membaca Al-Fatihah + surah',     4,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/04-fatihah.jpg', NULL),
(1, 'Rukuk',                          5,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/05-rukuk.jpg', NULL),
(1, 'I''tidal',                       6,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/06-itidal.jpg', NULL),
(1, 'Sujud pertama',                  7,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/07-sujud1.jpg', NULL),
(1, 'Duduk antara dua sujud',         8,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/08-duduk.jpg', NULL),
(1, 'Sujud kedua',                    9,  '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/09-sujud2.jpg', NULL),
(1, 'Berdiri ke rakaat berikutnya',   10, '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/10-berdiri.jpg', NULL),
(1, 'Duduk tasyahud awal',            11, '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/11-tasyahud-awal.jpg', NULL),
(1, 'Duduk tasyahud akhir',           12, '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/12-tasyahud-akhir.jpg', NULL),
(1, 'Salam',                          13, '[DESKRIPSI - lengkapi]', '/assets/img/gerakan/13-salam.jpg', NULL);

-- ------------------------------------------------------------
-- 4) GERAKAN — Mode Anak (id_kategori = 2), struktur identik
-- ------------------------------------------------------------
INSERT INTO gerakan (id_kategori, nama, urutan, deskripsi, gambar_url, video_url) VALUES
(2, 'Berdiri tegak (qiyam) + niat',   1,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/01-qiyam.jpg', NULL),
(2, 'Takbiratul ihram',               2,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/02-takbir.jpg', NULL),
(2, 'Bersedekap + doa iftitah',       3,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/03-sedekap.jpg', NULL),
(2, 'Membaca Al-Fatihah + surah',     4,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/04-fatihah.jpg', NULL),
(2, 'Rukuk',                          5,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/05-rukuk.jpg', NULL),
(2, 'I''tidal',                       6,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/06-itidal.jpg', NULL),
(2, 'Sujud pertama',                  7,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/07-sujud1.jpg', NULL),
(2, 'Duduk antara dua sujud',         8,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/08-duduk.jpg', NULL),
(2, 'Sujud kedua',                    9,  '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/09-sujud2.jpg', NULL),
(2, 'Berdiri ke rakaat berikutnya',   10, '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/10-berdiri.jpg', NULL),
(2, 'Duduk tasyahud awal',            11, '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/11-tasyahud-awal.jpg', NULL),
(2, 'Duduk tasyahud akhir',           12, '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/12-tasyahud-akhir.jpg', NULL),
(2, 'Salam',                          13, '[DESKRIPSI RAMAH ANAK - lengkapi]', '/assets/img/gerakan/anak/13-salam.jpg', NULL);

-- ------------------------------------------------------------
-- 5) BACAAN — Mode Dewasa
-- Memakai subquery (SELECT id FROM gerakan WHERE id_kategori=... AND urutan=...)
-- alih-alih hardcode ID auto-increment, agar aman berapa pun ID
-- aslinya di database (lihat catatan §15-§16 dokumen analisis).
-- ⚠️ Teks Arab/Latin/terjemahan WAJIB diverifikasi dari HPT Muhammadiyah
-- sebelum masuk ke database production.
-- ------------------------------------------------------------
INSERT INTO bacaan (id_gerakan, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber) VALUES
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=2),  1, '[TEKS ARAB TAKBIR]',      'Allāhu Akbar',                      '[TERJEMAHAN]', '/assets/audio/bacaan/02-takbir.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=3),  1, '[TEKS ARAB IFTITAH]',     '[LATIN IFTITAH]',                   '[TERJEMAHAN]', '/assets/audio/bacaan/03-iftitah.mp3',        'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=4),  1, '[TEKS ARAB FATIHAH]',     '[LATIN FATIHAH]',                   '[TERJEMAHAN]', '/assets/audio/bacaan/04-fatihah.mp3',        'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=5),  1, '[TEKS ARAB RUKUK]',       '[LATIN TASBIH RUKUK]',              '[TERJEMAHAN]', '/assets/audio/bacaan/05-rukuk.mp3',          'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=6),  1, '[TEKS ARAB ITIDAL]',      '[LATIN ITIDAL]',                    '[TERJEMAHAN]', '/assets/audio/bacaan/06-itidal.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=7),  1, '[TEKS ARAB TASBIH SUJUD]','[LATIN TASBIH SUJUD]',              '[TERJEMAHAN]', '/assets/audio/bacaan/07-sujud1.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=8),  1, '[TEKS ARAB DUDUK]',       '[LATIN DOA DUDUK ANTARA DUA SUJUD]','[TERJEMAHAN]', '/assets/audio/bacaan/08-duduk.mp3',          'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=9),  1, '[TEKS ARAB TASBIH SUJUD]','[LATIN TASBIH SUJUD]',              '[TERJEMAHAN]', '/assets/audio/bacaan/09-sujud2.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=11), 1, '[TEKS ARAB TASYAHUD AWAL]','[LATIN TASYAHUD AWAL]',            '[TERJEMAHAN]', '/assets/audio/bacaan/11-tasyahud-awal.mp3',  'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=12), 1, '[TEKS ARAB TASYAHUD AKHIR]','[LATIN TASYAHUD AKHIR]',          '[TERJEMAHAN]', '/assets/audio/bacaan/12-tasyahud-akhir-1.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=12), 2, '[TEKS ARAB SHALAWAT]',    '[LATIN SHALAWAT]',                  '[TERJEMAHAN]', '/assets/audio/bacaan/12-tasyahud-akhir-2.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=13), 1, '[TEKS ARAB SALAM]',       'Assalāmu''alaikum wa raḥmatullāh',  '[TERJEMAHAN]', '/assets/audio/bacaan/13-salam.mp3',          'HPT Muhammadiyah, Kitab Shalat');

-- ------------------------------------------------------------
-- 6) BACAAN — Mode Anak
-- Pola sama seperti dewasa (id_kategori=2), terjemahan disederhanakan.
-- Baris di bawah baru contoh 1 (takbir) — WAJIB dilengkapi penuh
-- untuk 11 baris bacaan lain mengikuti pola yang sama (lihat §15).
-- ------------------------------------------------------------
INSERT INTO bacaan (id_gerakan, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber) VALUES
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=2),  1, '[TEKS ARAB TAKBIR]', 'Allāhu Akbar', '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/02-takbir.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=3),  1, '[TEKS ARAB IFTITAH]',     '[LATIN IFTITAH]',                   '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/03-iftitah.mp3',        'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=4),  1, '[TEKS ARAB FATIHAH]',     '[LATIN FATIHAH]',                   '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/04-fatihah.mp3',        'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=5),  1, '[TEKS ARAB RUKUK]',       '[LATIN TASBIH RUKUK]',              '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/05-rukuk.mp3',          'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=6),  1, '[TEKS ARAB ITIDAL]',      '[LATIN ITIDAL]',                    '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/06-itidal.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=7),  1, '[TEKS ARAB TASBIH SUJUD]','[LATIN TASBIH SUJUD]',              '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/07-sujud1.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=8),  1, '[TEKS ARAB DUDUK]',       '[LATIN DOA DUDUK ANTARA DUA SUJUD]','[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/08-duduk.mp3',          'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=9),  1, '[TEKS ARAB TASBIH SUJUD]','[LATIN TASBIH SUJUD]',              '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/09-sujud2.mp3',         'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=11), 1, '[TEKS ARAB TASYAHUD AWAL]','[LATIN TASYAHUD AWAL]',            '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/11-tasyahud-awal.mp3',  'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=12), 1, '[TEKS ARAB TASYAHUD AKHIR]','[LATIN TASYAHUD AKHIR]',          '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/12-tasyahud-akhir-1.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=12), 2, '[TEKS ARAB SHALAWAT]',    '[LATIN SHALAWAT]',                  '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/12-tasyahud-akhir-2.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=13), 1, '[TEKS ARAB SALAM]',       'Assalāmu''alaikum wa raḥmatullāh',  '[TERJEMAHAN RINGKAS ANAK]', '/assets/audio/bacaan/anak/13-salam.mp3',          'HPT Muhammadiyah, Kitab Shalat');
-- TODO: lengkapi baris bacaan mode anak untuk urutan 3,4,5,6,7,8,9,11,12(x2),13
-- mengikuti pola yang sama seperti blok mode dewasa di atas.