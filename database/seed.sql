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
(1, 'Berdiri tegak (qiyam) + niat',   1,  'Niat', 'assets/img/Qiyam (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Takbiratul ihram',               2,  'Takbiratul ihram', 'assets/img/Takbiratul Ihram (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Bersedekap + doa iftitah',       3,  'Membaca Iftitah', 'assets/img/Qiyam (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Membaca Al-Fatihah + surah',     4,  'Membaca Al-Fatihah', 'assets/img/Qiyam (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Rukuk',                          5,  'Rukuk', 'assets/img/Ruku'' (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'I''tidal',                       6,  'Itidal', 'assets/img/I''tidal (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Sujud pertama',                  7,  'Sujud', 'assets/img/Sujud (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Duduk antara dua sujud',         8,  'Duduk Di antara Dua Sujud', 'assets/img/Duduk di antara dua sujud (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Sujud kedua',                    9,  'Sujud', 'assets/img/Sujud (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Berdiri ke rakaat berikutnya',   10, 'Berdiri', 'assets/img/Takbiratul Ihram (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Duduk tasyahud awal',            11, 'Tasyahud Awal', 'assets/img/Tahiyat (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Duduk tasyahud akhir',           12, 'Tasyahud Akhir', 'assets/img/Tahiyat (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Salam Kanan',                    13, 'Salam', 'assets/img/Salam kanan(Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(1, 'Salam Kiri',                     14, 'Salam', 'assets/img/Salam kiri (Dewasa).jpeg', 'https://www.youtube.com/embed/QtSj1HQeZ24');

-- ------------------------------------------------------------
-- 4) GERAKAN — Mode Anak (id_kategori = 2), struktur identik
-- ------------------------------------------------------------
INSERT INTO gerakan (id_kategori, nama, urutan, deskripsi, gambar_url, video_url) VALUES
(2, 'Berdiri tegak (qiyam) + niat',   1,  'Niat', 'assets/img/Qiyam (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Takbiratul ihram',               2,  'Takbiratul Ihram', 'assets/img/Takbiratul Ihram (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Bersedekap + doa iftitah',       3,  'Membaca Iftitah', 'assets/img/Qiyam (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Membaca Al-Fatihah + surah',     4,  'Membaca Al-Fatihah', 'assets/img/Qiyam (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Rukuk',                          5,  'Rukuk', 'assets/img/Ruku'' (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'I''tidal',                       6,  'Itidal', 'assets/img/I''tidal (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Sujud pertama',                  7,  'Sujud', 'assets/img/Sujud (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Duduk antara dua sujud',         8,  'Duduk Di antara Dua Sujud', 'assets/img/Duduk di antara dua sujud (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Sujud kedua',                    9,  'Sujud', 'assets/img/Sujud (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Berdiri ke rakaat berikutnya',   10, 'Berdiri', 'assets/img/Takbiratul Ihram (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Duduk tasyahud awal',            11, 'Tasyahud Awal', 'assets/img/Tahiyat (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Duduk tasyahud akhir',           12, 'Tasyahud Akhir', 'assets/img/Tahiyat (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Salam Kanan',                    13, 'Salam', 'assets/img/Salam Kanan (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24'),
(2, 'Salam Kiri',                     14, 'Salam', 'assets/img/Salam kiri (Anak).png', 'https://www.youtube.com/embed/QtSj1HQeZ24');

-- ------------------------------------------------------------
-- 5) BACAAN — Mode Dewasa
-- Memakai subquery (SELECT id FROM gerakan WHERE id_kategori=... AND urutan=...)
-- alih-alih hardcode ID auto-increment, agar aman berapa pun ID
-- aslinya di database (lihat catatan §15-§16 dokumen analisis).
-- ⚠️ Teks Arab/Latin/terjemahan WAJIB diverifikasi dari HPT Muhammadiyah
-- sebelum masuk ke database production.
-- ------------------------------------------------------------
INSERT INTO bacaan (id_gerakan, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber) VALUES
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=2),  1, 'اللَّهُ أَكْبَرُ','Allāhu Akbar','Allah Maha Besar', 
'../../assets/audio/takbiratul-ihram.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=3),  1, 'اللَّهُمَّ بَاعِدْ بَيْنِي، وَبَيْنَ خَطَايَايَ، كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ. اللَّهُمَّ نَقِّنِي مِنْ خَطَايَايَ، كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ. اللَّهُمَّ اغْسِلْنِي مِنْ خَطَايَايَ، بِالْمَاءِ، وَالثَّلْجِ، وَالْبَرَدِ.','Allahumma baaid baynii wa bayna khotoyaaya kamaa baaadta baynal masyriqi wal maghrib. Allahumma naqqinii min khotoyaaya kamaa yunaqqots tsaubul abyadhu minad danas. Allahummagh-silnii min khotoyaaya bil maa-iwats tsalji wal barod.','Wahai Allah jauhkanlah antara aku dan kesalahan-kesalahanku sebagaimana engkau jauhkan antara timur dan barat, ya Allah bersihkanlah aku dari kesalahan sebagaimana bersihnya baju putih dari kotoran, ya Allah basuhlah kesalahan-kesalahanku dengan air, salju dan air dingin.', '../../assets/audio/iftitah.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=4),  1, 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ. الرَّحْمَنِ الرَّحِيمِ. مَالِكِ يَوْمِ الدِّينِ. إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ. اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ. صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ، غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ، وَلَا الضَّالِّينَ. آمِينَ.','Bismillaahir-rohmaanir-rohiim. Alhamdulillahir-robbil aalamiin. Ar-rohmaanir-rohiim. Maaliki yawmid-diin. Iyyaaka na budu wa iyyaaka nastaiin. Ihdinash-shiroothol mustaqiim. Shirootholladziina anamta alaihim, ghoiril maghdhuubialaihim waladh-dhoolliin. Amin.','Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah, Tuhan semesta alam. Yang Maha Pengasih lagi Maha Penyayang. Yang menguasai hari pembalasan. Hanya kepada-Mu kami menyembah dan hanya kepada-Mu kami mohon pertolongan. Tunjukkanlah kami ke jalan yang lurus. Yaitu jalan orang-orang yang telah Engkau beri nikmat, bukan jalan mereka yang dimurkai dan bukan pula jalan mereka yang tersesat. Amin.', '../../assets/audio/alfatihah.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=4),  2, '[TEKS ARAB SURAH PENDEK]', '[TEKS LATIN SURAH PENDEK]', '[TERJEMAHAN SURAH PENDEK]', '../../assets/audio/surah-pendek.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=5),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha Suci Engkau, ya Allah. Dan dengan memuji Engkau, ya Allah, aku memohon ampun.', '../../assets/audio/rukuk.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=6),  1, 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ، رَبَّنَا وَلَكَ الْحَمْدُ حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ','Samiallaahu liman hamidah. Rabbanaa wa lakal hamdu hamdan katsiran thayyiban mubaarokan fiih','Ya Allah, Tuhanku, bagiMu segala puji, sepenuh semua langit, sepenuh bumi, dan sepenuh semua apa yang Kau sukai dari sesuatu apapun', '../../assets/audio/itidal.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=7),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha suci Engkau, Ya Allah, dan dengan memuji kepada Engkau, Ya Allah, aku memohon ampun', '../../assets/audio/sujud1.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=8),  1, 'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاجْبُرْنِي وَاهْدِنِي وَارْزُقْنِي','Allaahummaghfirlii warhamnii wajburnii wahdinii warzuqnii','Ya Allah, ampunilah aku, belas kasihanilah aku, cukupilah aku, tunjukilah aku dan berikanlah rezeki kepadaku', '../../assets/audio/duduk-diantara-sujud.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=9),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha suci Engkau, Ya Allah, dan dengan memuji kepada Engkau, Ya Allah, aku memohon ampun', '../../assets/audio/sujud2.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=11), 1, 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ','Attahiyyaatu lillaahi washsholawaatu waththoyyibaat. Assalaamu alaika ayyuhannabiyyu warohmatullaahi wabarokaatuh. Assalaamualainaa waala ibaadillaahi shshoolihiin. Asyhadu anlaa ilaaha illallaah waasyhadu annamuhammadan abduhu warosuuluh','Segala kehormatan, kebahagiaan dan kebagusan adalah kepunyaan Allah, Semoga keselamatan bagi Engkau, ya Nabi Muhammad, beserta rahmat dan kebahagiaan Allah. Mudah-mudahan keselamatan juga bagi kita sekalian dan hamba-hamba Allah yang baik-baik. Aku bersaksi bahwa tiada Tuhan melainkan Allah dan aku bersaksi bahwa Muhammad itu hamba Allah dan utusan-Nya','../../assets/audio/tasyahud-akhir.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=12), 1, 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ','Attahiyyaatu lillaahi washsholawaatu waththoyyibaat. Assalaamu alaika ayyuhannabiyyu warohmatullaahi wabarokaatuh. Assalaamualainaa waala ibaadillaahi shshoolihiin. Asyhadu anlaa ilaaha illallaah waasyhadu annamuhammadan abduhu warosuuluh','Segala kehormatan, kebahagiaan dan kebagusan adalah kepunyaan Allah, Semoga keselamatan bagi Engkau, ya Nabi Muhammad, beserta rahmat dan kebahagiaan Allah. Mudah-mudahan keselamatan juga bagi kita sekalian dan hamba-hamba Allah yang baik-baik. Aku bersaksi bahwa tiada Tuhan melainkan Allah dan aku bersaksi bahwa Muhammad itu hamba Allah dan utusan-Nya','../../assets/audio/tasyahud-akhir.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=12), 2, 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ ، وَبَارِك عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ','Allahumma sholli ala Muhammad wa ala aali Muhammad kamaa shollaita ala Ibroohim wa ala aali Ibrohim, innaka hamidun majiid. Allahumma baarik ala Muhammad wa ala aali Muhammad kamaa baarokta ala Ibrohim wa ala aali Ibrohimm innaka hamidun majiid','Ya Allah, semoga shalawat tercurah kepada Muhammad dan keluarga Muhammad. Seperti rahmat yang tercurah pada Ibrahim dan keluarga Ibrahim. Dan limpahilah berkah atas Nabi Muhammad beserta para keluarganya. Seperti berkah yang Engkau berikan kepada Nabi Ibrahim dan keluarganya. Sesungguhnya Engkau Maha Terpuji lagi Maha Mulia di seluruh alam', '../../assets/audio/tasyahud-sholawat.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=13), 1, 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ','Assalāmu''alaikum wa raḥmatullāh','Semoga keselamatan dan rahmat Allah terlimpah kepada kalian.', '../../assets/audio/salam.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=1 AND urutan=14), 1, 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ','Assalāmu''alaikum wa raḥmatullāh','Semoga keselamatan dan rahmat Allah terlimpah kepada kalian.', '../../assets/audio/salam.mp3','HPT Muhammadiyah, Kitab Shalat');

-- ------------------------------------------------------------
-- 6) BACAAN — Mode Anak
-- Pola sama seperti dewasa (id_kategori=2), terjemahan disederhanakan.
-- Teks bacaan lengkap untuk semua gerakan mengikuti pola yang sama.
-- ------------------------------------------------------------
INSERT INTO bacaan (id_gerakan, urutan, teks_arab, teks_latin, terjemahan, audio_url, sumber) VALUES
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=2),  1, 'اللَّهُ أَكْبَرُ.', 'Allāhu Akbar', 'Allah Maha Besar',
'../../assets/audio/takbiratul-ihram.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=3),  1, 'اللَّهُمَّ بَاعِدْ بَيْنِي، وَبَيْنَ خَطَايَايَ، كَمَا بَاعَدْتَ بَيْنَ الْمَشْرِقِ وَالْمَغْرِبِ. اللَّهُمَّ نَقِّنِي مِنْ خَطَايَايَ، كَمَا يُنَقَّى الثَّوْبُ الْأَبْيَضُ مِنَ الدَّنَسِ. اللَّهُمَّ اغْسِلْنِي مِنْ خَطَايَايَ، بِالْمَاءِ، وَالثَّلْجِ، وَالْبَرَدِ.','Allahumma baaid baynii wa bayna khotoyaaya kamaa baaadta baynal masyriqi wal maghrib. Allahumma naqqinii min khotoyaaya kamaa yunaqqots tsaubul abyadhu minad danas. Allahummagh-silnii min khotoyaaya bil maa-iwats tsalji wal barod.','Ya Allah, jauhkanlah aku dari dosa seperti jauhnya timur dan barat. Bersihkanlah aku dari dosa seperti baju putih yang dicuci bersih.',
'../../assets/audio/iftitah.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=4),  1, 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ. الرَّحْمَنِ الرَّحِيمِ. مَالِكِ يَوْمِ الدِّينِ. إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ. اهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ. صِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ، غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ، وَلَا الضَّالِّينَ. آمِينَ.','Bismillaahir-rohmaanir-rohiim. Alhamdulillahir-robbil aalamiin. Ar-rohmaanir-rohiim. Maaliki yawmid-diin. Iyyaaka na budu wa iyyaaka nastaiin. Ihdinash-shiroothol mustaqiim. Shirootholladziina anamta alaihim, ghoiril maghdhuubialaihim waladh-dhoolliin. Amin.','Dengan menyebut nama Allah yang Maha Pengasih lagi Maha Penyayang. Segala puji bagi Allah, Tuhan semesta alam. Yang Maha Pengasih lagi Maha Penyayang. Yang menguasai hari pembalasan. Hanya kepada-Mu kami menyembah dan hanya kepada-Mu kami mohon pertolongan. Tunjukkanlah kami ke jalan yang lurus. Yaitu jalan orang-orang yang telah Engkau beri nikmat, bukan jalan mereka yang dimurkai dan bukan pula jalan mereka yang tersesat. Amin.', '../../assets/audio/alfatihah.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=4),  2, '[TEKS ARAB SURAH PENDEK]', '[TEKS LATIN SURAH PENDEK]', '[TERJEMAHAN SURAH PENDEK]', '../../assets/audio/surah-pendek.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=5),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha Suci Engkau, ya Allah. Dan dengan memuji Engkau, ya Allah, aku memohon ampun.', '../../assets/audio/rukuk.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=6),  1, 'سَمِعَ اللَّهُ لِمَنْ حَمِدَهُ، رَبَّنَا وَلَكَ الْحَمْدُ حَمْدًا كَثِيرًا طَيِّبًا مُبَارَكًا فِيهِ','Samiallaahu liman hamidah. Rabbanaa wa lakal hamdu hamdan katsiran thayyiban mubaarokan fiih','Allah mendengar orang yang memuji-Nya. Ya Allah, segala puji bagi-Mu.', '../../assets/audio/itidal.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=7),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha Suci Engkau ya Allah, aku memuji-Mu dan memohon ampunan-Mu.', '../../assets/audio/sujud1.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=8),  1, 'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاجْبُرْنِي وَاهْدِنِي وَارْزُقْنِي','Allaahummaghfirlii warhamnii wajburnii wahdinii warzuqnii','Ya Allah, ampunilah aku, sayangi aku, cukupkan kebutuhanku, berilah petunjuk, dan berikanlah rezeki kepadaku.','../../assets/audio/duduk-diantara-sujud.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=9),  1, 'سُبْحَانَكَ اللَّهُمَّ رَبَّنَا وَبِحَمْدِكَ اللَّهُمَّ اغْفِرْ لِي','Subhaanakallah humma rabbanaa wa bihamdikallahummaghfirlii','Maha Suci Engkau ya Allah, aku memuji-Mu dan memohon ampunan-Mu.', '../../assets/audio/sujud2.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=11), 1, 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ','Attahiyyaatu lillaahi washsholawaatu waththoyyibaat. Assalaamu alaika ayyuhannabiyyu warohmatullaahi wabarokaatuh. Assalaamualainaa waala ibaadillaahi shshoolihiin. Asyhadu anlaa ilaaha illallaah waasyhadu annamuhammadan abduhu warosuuluh','Segala hormat, doa, dan kebaikan milik Allah. Keselamatan bagi Nabi Muhammad dan hamba-hamba Allah yang saleh. Aku bersaksi bahwa tidak ada Tuhan selain Allah dan Nabi Muhammad adalah utusan Allah.','../../assets/audio/tasyahud-akhir.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=12), 1, 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ ، السَّلَامُ عَلَيْنَا وَعَلَىٰ عِبَادِ اللَّهِ الصَّالِحِينَ ، أَشْهَدُ أَنْ لَا إِلٰهَ إِلَّا اللَّهُ وَأَشْهَدُ أَنَّ مُحَمَّدًا عَبْدُهُ وَرَسُولُهُ','Attahiyyaatu lillaahi washsholawaatu waththoyyibaat. Assalaamu alaika ayyuhannabiyyu warohmatullaahi wabarokaatuh. Assalaamualainaa waala ibaadillaahi shshoolihiin. Asyhadu anlaa ilaaha illallaah waasyhadu annamuhammadan abduhu warosuuluh','Segala hormat, doa, dan kebaikan milik Allah. Keselamatan bagi Nabi Muhammad dan hamba-hamba Allah yang saleh. Aku bersaksi bahwa tidak ada Tuhan selain Allah dan Nabi Muhammad adalah utusan Allah.','../../assets/audio/tasyahud-akhir.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=12), 2, 'اللَّهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا صَلَّيْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ ، وَبَارِك عَلَىٰ مُحَمَّدٍ وَعَلَىٰ آلِ مُحَمَّدٍ كَمَا بَارَكْتَ عَلَىٰ إِبْرَاهِيمَ وَعَلَىٰ آلِ إِبْرَاهِيمَ ، إِنَّكَ حَمِيدٌ مَجِيدٌ','Allahumma sholli ala Muhammad wa ala aali Muhammad kamaa shollaita ala Ibroohim wa ala aali Ibrohim, innaka hamidun majiid. Allahumma baarik ala Muhammad wa ala aali Muhammad kamaa baarokta ala Ibrohim wa ala aali Ibrohimm innaka hamidun majiid','Ya Allah, limpahkanlah rahmat dan keberkahan kepada Nabi Muhammad dan keluarganya, seperti Engkau memberi rahmat kepada Nabi Ibrahim.','../../assets/audio/tasyahud-sholawat.mp3','HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=13), 1, 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ','Assalāmu''alaikum wa raḥmatullāh','Semoga keselamatan dan rahmat Allah terlimpah kepada kalian.','../../assets/audio/salam.mp3', 'HPT Muhammadiyah, Kitab Shalat'),
((SELECT id FROM gerakan WHERE id_kategori=2 AND urutan=14), 1, 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ','Assalāmu''alaikum wa raḥmatullāh','Semoga keselamatan dan rahmat Allah terlimpah kepada kalian.','../../assets/audio/salam.mp3', 'HPT Muhammadiyah, Kitab Shalat');
