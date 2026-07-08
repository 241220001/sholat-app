# Design.md — Design Prompts per Halaman
## Aplikasi Web Tuntunan Tata Cara Sholat

**Format:** 3 prompt desain terpisah dan **self-contained** — masing-masing bisa langsung
ditempel satu per satu ke v0 / Lovable / Bolt.new / Claude Code tanpa perlu konteks tambahan.
**Sumber kebenaran token desain:** SRS.md §5.1, PRD.md §8 — semua warna/font/komponen di bawah
ini **bukan desain baru**, melainkan operasionalisasi dari token yang sudah disepakati tim.

**Isi dokumen:**
1. Fondasi Desain Bersama (dibaca dulu — konteks untuk ketiga prompt)
2. Prompt A — Halaman Beranda
3. Prompt B — Halaman List Gerakan
4. Prompt C — Halaman Detail Gerakan

---

## 0. Fondasi Desain Bersama

Bagian ini **diulang secara ringkas di setiap prompt** (bukan hanya di sini) supaya tiap prompt
tetap portable saat dipisah dan ditempel ke tool AI yang berbeda. Baca dulu untuk konteks
menyeluruh sebelum masuk ke prompt per halaman.

**Nada visual:** aplikasi edukasi ibadah — harus terasa **tenang, hormat, dan terpercaya**,
bukan playful/startup. Untuk mode Anak, nada bergeser ke **ramah dan hangat** tanpa jadi kekanakan
berlebihan (tetap harus terlihat sebagai aplikasi belajar sholat, bukan game).

**Palet warna dasar (light mode — wajib):**

| Token | HEX | Peran |
|-------|-----|-------|
| Primary | `#0F6E56` | Hijau teal islami — CTA utama, link aktif, ikon interaktif |
| Secondary | `#085041` | Hijau gelap — hover state primary, teks pada surface primary |
| Accent | `#BA7517` | Amber emas — highlight, badge mode aktif, elemen dekoratif |
| Background | `#F1EFE8` | Krem hangat — background halaman |
| Surface | `#FFFFFF` | Putih — card, modal, header bar |
| Success | `#2E7D4F` | (turunan primary, lebih cerah) konfirmasi audio berhasil dimuat |
| Warning | `#B8860B` | (turunan accent) peringatan non-kritis |
| Danger | `#791F1F` | Merah gelap — toast error, empty state ikon |
| Text Primary | `#2C2C2A` | Hampir hitam — body text |
| Text Muted | `#5F5E5A` | Abu tengah — label, caption, terjemahan |
| Border | `#D3D1C7` | Abu terang — pemisah card, input border |
| Hover Overlay | `rgba(15,110,86,0.08)` | Overlay hover di atas surface putih |

**Dark mode (opsional, turunan — tidak wajib di P1–P3 tapi disiapkan tokennya):**

| Token | HEX |
|-------|-----|
| Dark Background | `#1C1C1A` |
| Dark Surface | `#262622` |
| Dark Primary | `#2FA187` (dicerahkan agar kontras cukup di background gelap) |
| Dark Text Primary | `#F1EFE8` |
| Dark Text Muted | `#B8B6AE` |
| Dark Border | `#3A3A35` |

**Tipografi:**

| Elemen | Font | Ukuran | Weight | Catatan |
|--------|------|--------|--------|---------|
| Heading | Poppins | 24–32px | 600 | Judul halaman, nama gerakan |
| Body | Inter | 16px | 400 | Paragraf umum |
| Teks Arab | Amiri atau Scheherazade New | min 28px, line-height 1.8 | 400 | **Jangan** pernah di bawah 24px — ini konten ibadah, harus terbaca jelas |
| Transliterasi Latin | Inter | 16px | 400 italic | |
| Terjemahan | Inter | 14px | 400 | Warna Text Muted |
| Label kecil / caption | Inter | 12px | 400 | Sumber HPT, timestamp audio |
| Tombol | Inter | 16px | 600 | |

**Grid & Spacing:** basis 8px grid (4px untuk micro-spacing). Border radius: 8px (tombol/input),
12px (card), 16px (modal). Shadow: `0 2px 8px rgba(44,44,42,0.08)` default card,
`0 6px 16px rgba(44,44,42,0.14)` saat hover/elevated.

**Breakpoint (mobile-first, wajib):**
- Mobile: `≤480px` — 1 kolom, bottom-sticky navigation
- Tablet: `481px–1024px` — 2 kolom grid untuk list gerakan
- Desktop: `>1024px` — sidebar list + panel detail berdampingan

**Ikon:** gaya outline/rounded, konsisten satu keluarga (rekomendasi: Lucide/Feather), stroke
1.5–2px, ukuran 20–24px di UI, 32px untuk aksi utama (play/pause). Hindari ikon filled solid
kecuali untuk status aktif (mis. mode toggle terpilih).

**Ilustrasi:** flat/minimal dengan palet warna di atas untuk mode Anak (ilustrasi gerakan sholat
ramah anak); untuk mode Dewasa gunakan fotografi/ilustrasi realistis-sederhana, bukan kartun.

**Fotografi/Imagery:** untuk gambar gerakan sholat gunakan foto/ilustrasi dengan pencahayaan
hangat, komposisi bersih (background netral), tanpa elemen yang mengalihkan perhatian dari
gerakan yang diperagakan.

---

## 1. Prompt A — Halaman Beranda (`/`)

### 1. Project Overview

Rancang halaman **Beranda** untuk aplikasi web edukasi "Tuntunan Tata Cara Sholat" — sebuah
aplikasi pembelajaran ibadah berbasis web yang menyajikan 13 gerakan sholat sesuai sunnah,
dengan rujukan Himpunan Putusan Tarjih (HPT) Muhammadiyah. Halaman ini adalah **pintu masuk**
aplikasi: pengguna memilih mode tampilan (Dewasa/Anak) dan memulai pembelajaran. Halaman harus
membangun kepercayaan sejak detik pertama — sumber konten kredibel, tampilan bersih dan hormat
terhadap topik ibadah.

### 2. Target Users

- **Dewasa/umum & mahasiswa**: butuh kredibilitas sumber, akses cepat ke konten lengkap, tidak
  ingin visual berlebihan.
- **Orang tua** yang membuka aplikasi untuk anak mereka: perlu toggle mode Anak yang jelas
  terlihat sejak Beranda.
- **Anak usia sekolah dasar**: butuh visual yang mengundang tapi tetap tenang, tombol besar
  mudah diketuk.
- **Dosen/penilai**: mengevaluasi kelengkapan fitur dan identitas kelompok — header identitas
  harus langsung terlihat tanpa scroll.

### 3. Design Goals

- **Bisnis/akademik**: identitas kelompok (nama, prodi, mata kuliah, dosen) harus terlihat jelas
  di atas fold untuk penilaian.
- **UX**: pengguna baru harus bisa memahami cara kerja aplikasi (pilih mode → mulai belajar)
  dalam <5 detik tanpa instruksi tertulis panjang.
- **Kepercayaan**: rujukan HPT Muhammadiyah ditampilkan sebagai penanda kredibilitas, bukan
  disembunyikan di footer.

### 4. Visual Style

**Calm & Trustworthy Islamic Educational** — clean, warm-minimalist, mirip nada visual
aplikasi kesehatan/edukasi premium (bukan e-commerce, bukan gamified). Elemen dekoratif geometris
Islami (pola bermotif sangat halus, opacity rendah) boleh dipakai sebagai aksen background,
**tidak** boleh mengganggu keterbacaan teks.

### 5. Color Palette

Gunakan palet dari §0 Fondasi Desain Bersama di atas persis — jangan buat palet baru:
Primary `#0F6E56`, Secondary `#085041`, Accent `#BA7517`, Background `#F1EFE8`,
Surface `#FFFFFF`, Success `#2E7D4F`, Warning `#B8860B`, Danger `#791F1F`,
Text Primary `#2C2C2A`, Text Muted `#5F5E5A`, Border `#D3D1C7`,
Hover overlay `rgba(15,110,86,0.08)`. Dark mode (opsional): Background `#1C1C1A`,
Surface `#262622`, Primary `#2FA187`, Text Primary `#F1EFE8`.

### 6. Typography

Heading: Poppins 600, 28–32px untuk judul hero, 24px untuk sub-judul. Body: Inter 400, 16px.
Tombol: Inter 600, 16px. Caption/identitas kelompok di header: Inter 400, 12–14px, warna
Text Muted. Line-height heading 1.3, body 1.6.

### 7. Layout

**Desktop (>1024px):** hero dua kolom — kiri teks + CTA + toggle mode, kanan ilustrasi/foto
gerakan sholat. Max container width 1200px, padding horizontal 64px. Header identitas kelompok
full-width di atas hero, sticky.

**Tablet (481–1024px):** hero jadi satu kolom, ilustrasi di atas, teks+CTA di bawah, container
padding 32px.

**Mobile (≤480px):** stack penuh vertikal — header (compact, identitas bisa collapse jadi 1
baris kecil), hero image, judul, deskripsi singkat, toggle mode besar (min 44px tinggi), CTA
full-width sticky di bagian bawah viewport pertama.

### 8. Components

- **Header/Navbar** (sticky top): logo/nama app kiri, identitas kelompok (nama kelompok · prodi
  · mata kuliah · dosen) tengah/kanan dalam ukuran kecil, toggle mode Dewasa/Anak di ujung kanan.
- **Hero section**: judul besar ("Belajar Tata Cara Sholat Sesuai Sunnah"), sub-judul (rujukan
  HPT Muhammadiyah), CTA primer "Mulai Belajar" (button besar, warna Primary), ilustrasi/foto.
- **Toggle Mode** (Dewasa/Anak): switch dua-state dengan label jelas dan badge indikator warna
  Accent saat aktif.
- **Trust badge**: baris kecil "Sumber: Himpunan Putusan Tarjih (HPT) Muhammadiyah" dengan ikon
  centang/buku, warna Text Muted, posisi dekat CTA.
- **Footer** (opsional, ringan): tautan repo/README, tidak perlu kompleks.

### 9. UX Behavior

- Hover CTA: warna Primary → Secondary, transisi 150ms ease-out, sedikit elevasi shadow.
- Toggle mode: perubahan visual instan (tanpa reload), badge mode aktif fade-in 200ms.
- Focus state: outline 2px warna Primary dengan offset 2px untuk semua elemen interaktif
  (keyboard navigation).
- CTA "Mulai Belajar" klik → navigasi ke `/gerakan` membawa parameter mode yang sedang aktif.

### 10. Accessibility

WCAG AA: kontras teks minimal 4.5:1 di atas Background `#F1EFE8` (Text Primary `#2C2C2A` sudah
memenuhi). Semua tombol/toggle min 44×44px touch target. `aria-label` pada toggle mode
("Ganti ke mode Anak" / "Ganti ke mode Dewasa"). Struktur heading semantik: `h1` untuk judul
hero, tidak boleh loncat ke `h3` tanpa `h2`. Semua gambar punya `alt` deskriptif.

### 11. Responsive Rules

Mobile-first CSS. Breakpoint persis seperti §0: `≤480px`, `481–1024px`, `>1024px`. Uji orientasi
landscape mobile — CTA sticky tidak boleh menutupi konten hero saat landscape (kurangi tinggi
hero image di breakpoint ini).

### 12. Design System

8px grid spacing scale (8/16/24/32/48/64). Border radius 8px tombol, 16px card besar (hero
image container). Shadow: default `0 2px 8px rgba(44,44,42,0.08)`. Ikon outline 24px (Lucide
style). Badge mode: pill shape, radius full, padding 4px 12px.

### 13. UI Components Style

Tombol primer: bg `#0F6E56`, teks putih, radius 8px, min-height 44px, padding 12px 24px.
Tombol sekunder: border 1px `#0F6E56`, teks Primary, transparan. Toggle switch: track abu
`#D3D1C7`, thumb putih dengan shadow, warna track aktif Primary.

### 14. Motion Design

Durasi standar 150–250ms, easing `ease-out` untuk masuk, `ease-in` untuk keluar. Hero image
fade+slide-up 400ms saat halaman load (sekali saja, tidak berulang). Tidak ada animasi loop
yang mengganggu (hindari parallax berat/auto-carousel).

### 15. User Flow

`Buka URL` → `Lihat Beranda (header identitas + hero)` → `Pilih mode (opsional, default
Dewasa)` → `Klik "Mulai Belajar"` → `Navigasi ke List Gerakan`.

### 16. Screens

Hanya 1 screen dalam prompt ini: **Beranda**. (List Gerakan dan Detail Gerakan ada di Prompt B
dan C.)

### 17. Icons

Outline/rounded, stroke 1.5–2px, style Lucide/Feather. Ikon yang dipakai di halaman ini: toggle
mode (user/child icon), ikon buku/centang untuk trust badge, chevron untuk CTA.

### 18. Illustrations

Mode Dewasa: foto/ilustrasi semi-realistis siluet orang sholat, warna selaras palet (hijau/amber
sebagai aksen, bukan warna dominan). Mode Anak: ilustrasi flat ramah anak, garis tebal, warna
lebih cerah tapi tetap dalam keluarga palet yang sama.

### 19. Images

Gaya fotografi/ilustrasi hangat, pencahayaan lembut, komposisi bersih tanpa distraksi. Hindari
foto stok generik yang tidak relevan dengan konteks ibadah.

### 20. Final AI Prompt

Design a calm, trustworthy homepage for an Islamic prayer (sholat) tutorial web application
called "Tuntunan Tata Cara Sholat". The page must feel warm, respectful, and educational —
not playful or e-commerce-like. Use a sticky top header containing a small group-identity bar
(group name · study program · course name · lecturer name) plus a two-state toggle switch for
"Dewasa" (Adult) / "Anak" (Kids) display mode positioned at the far right. Build a two-column
hero on desktop (left: headline "Belajar Tata Cara Sholat Sesuai Sunnah", a subheadline
mentioning the content is verified against Himpunan Putusan Tarjih (HPT) Muhammadiyah, a large
primary CTA button "Mulai Belajar", and a small trust badge with a checkmark/book icon citing
the HPT source; right: a warm, clean illustration or photo of a person performing prayer,
rendered in a semi-realistic style for adult mode). On tablet, stack the illustration above the
text. On mobile (≤480px), stack everything vertically with a large, easily tappable mode toggle
and a full-width sticky CTA button at the bottom of the first viewport. Use this exact color
system: primary #0F6E56, secondary #085041, accent (amber gold) #BA7517, background (warm
cream) #F1EFE8, surface white #FFFFFF, success #2E7D4F, warning #B8860B, danger #791F1F, text
primary #2C2C2A, text muted #5F5E5A, border #D3D1C7, hover overlay rgba(15,110,86,0.08); prepare
a dark mode variant with background #1C1C1A, surface #262622, primary #2FA187, text primary
#F1EFE8. Typography: Poppins Semibold for headings (28–32px desktop, 24px mobile), Inter
Regular 16px for body text, Inter Semibold 16px for buttons. Use an 8px spacing grid, 8px border
radius on buttons, 16px radius on the hero image container, soft shadow 0 2px 8px
rgba(44,44,42,0.08) on elevated elements. Buttons and the mode toggle must be at least 44×44px
for touch accessibility, with visible 2px primary-color focus outlines for keyboard navigation,
WCAG AA contrast throughout, and descriptive alt text on all imagery. Use outline-style icons
(Lucide/Feather aesthetic, 1.5–2px stroke). Keep motion subtle: 150–250ms ease-out transitions
on hover/toggle states and a single 400ms fade-and-slide-up entrance for the hero image on page
load — no looping or parallax animation. The overall impression should be that of a premium,
calm educational health/wellness app rather than a marketing landing page.

---

## 2. Prompt B — Halaman List Gerakan (`/gerakan`)

### 1. Project Overview

Rancang halaman **List Gerakan** yang menampilkan 13 gerakan sholat secara berurutan (qiyam →
salam) dalam format kartu yang dapat diklik, menyesuaikan mode tampilan aktif (Dewasa/Anak).
Halaman ini adalah hub navigasi utama sebelum pengguna masuk ke detail tiap gerakan.

### 2. Target Users

Sama dengan §2 Fondasi — penekanan tambahan: pengguna di halaman ini sedang dalam mode "memindai
cepat" (scanning) untuk menemukan gerakan yang ingin dipelajari, sehingga **kejelasan urutan
nomor** dan **kemudahan klik/tap** jadi prioritas utama di atas estetika dekoratif.

### 3. Design Goals

Pengguna harus bisa melihat seluruh 13 gerakan (atau sebagian besar tanpa scroll berlebihan di
desktop) dan langsung memahami urutannya. Loading state dan empty state harus terasa halus,
tidak membuat pengguna berpikir aplikasi rusak saat data sedang diambil dari API.

### 4. Visual Style

Sama dengan Prompt A: calm & trustworthy islamic educational, minimalist card-grid.

### 5. Color Palette

Identik §0: Primary `#0F6E56`, Secondary `#085041`, Accent `#BA7517`, Background `#F1EFE8`,
Surface `#FFFFFF`, Danger `#791F1F`, Text Primary `#2C2C2A`, Text Muted `#5F5E5A`,
Border `#D3D1C7`. Nomor urut pada tiap kartu gunakan Accent `#BA7517` sebagai warna aksen badge.

### 6. Typography

Nama gerakan pada kartu: Poppins 600, 16–18px. Nomor urut (badge): Inter 600, 14px. Caption
mode aktif di header: Inter 400, 12px.

### 7. Layout

**Mobile (≤480px):** grid 1 kolom, kartu full-width, tinggi konsisten ~120px, thumbnail gambar
di kiri (80×80px) + teks di kanan.

**Tablet (481–1024px):** grid 2 kolom, gap 16px, kartu vertikal (gambar di atas, teks di bawah).

**Desktop (>1024px):** grid 3 kolom (atau sidebar-list style jika ingin konsisten dengan panel
detail — rekomendasikan grid 3 kolom untuk halaman list mandiri ini), gap 24px, max container
1200px.

Header sticky identik Prompt A (identitas kelompok + toggle mode) tetap tampil di halaman ini.

### 8. Components

- **Header** (reuse dari Beranda — sticky, identitas + toggle mode).
- **Grid kartu gerakan** (13 items): tiap kartu berisi badge nomor urut, thumbnail gambar,
  nama gerakan, chevron/ikon panah kecil di kanan menandakan "bisa diklik".
- **Skeleton Loading**: 13 placeholder card dengan shimmer animation saat fetch API berlangsung.
- **Empty State**: ilustrasi sederhana + teks "Data gerakan belum tersedia" jika API
  mengembalikan array kosong (kasus data belum di-seed).
- **Badge mode aktif**: kecil, dekat header, menegaskan mode Dewasa/Anak yang sedang tampil.

### 9. UX Behavior

- Hover kartu (desktop): elevasi shadow naik dari `0 2px 8px` ke `0 6px 16px`, translateY(-2px),
  transisi 150ms.
- Tap kartu (mobile): efek pressed ringan (scale 0.98, 100ms) sebelum navigasi ke detail.
- Skeleton: shimmer loop 1.2s, warna base `#E8E6DE` ke `#F1EFE8`, berhenti otomatis saat data
  API tiba (skeleton diganti kartu asli, bukan fade tiba-tiba — gunakan crossfade 200ms).
- Toggle mode di halaman ini: memicu refetch data dan re-render grid dengan skeleton singkat
  (<500ms) sebagai transisi, bukan reload halaman penuh.

### 10. Accessibility

Setiap kartu adalah elemen fokus-able (`tabindex`, keyboard `Enter` = klik). `aria-label` per
kartu: "Gerakan {nomor}: {nama gerakan}, buka detail". Kontras badge nomor (Accent di atas
Surface putih) diverifikasi ≥4.5:1 — jika Accent `#BA7517` terlalu terang untuk teks putih kecil,
gunakan teks gelap `#2C2C2A` di atas badge Accent, bukan putih.

### 11. Responsive Rules

Grid harus reflow tanpa horizontal scroll di semua breakpoint (§0). Skeleton count menyesuaikan
kolom aktif (1/2/3) agar layout tidak "melompat" saat data asli masuk.

### 12. Design System

Card radius 12px, shadow default `0 2px 8px rgba(44,44,42,0.08)`, hover
`0 6px 16px rgba(44,44,42,0.14)`. Badge nomor: pill/circle 28px diameter, bg Accent, font 14px
600. Spacing internal card: padding 16px, gap antar elemen internal 8px.

### 13. UI Components Style

Kartu: border 1px `#D3D1C7` (subtle, opsional jika shadow sudah cukup membedakan dari
background), background Surface putih, radius 12px. Chevron icon: outline, 16px, warna
Text Muted, posisi kanan-tengah kartu.

### 14. Motion Design

Hover/press transitions 150ms ease-out. Skeleton shimmer 1.2s linear infinite (berhenti saat
data tiba). Crossfade skeleton→konten 200ms ease-in-out. Saat toggle mode berganti, grid lama
fade-out 150ms sebelum grid baru (dengan skeleton singkat) fade-in.

### 15. User Flow

`Datang dari Beranda (mode terbawa)` → `Lihat 13 kartu (skeleton → konten)` →
`Klik salah satu kartu` → `Navigasi ke Detail Gerakan (`/gerakan/:id`)`. Alur alternatif:
`Toggle mode di header` → `Grid refetch & re-render sesuai mode baru`.

### 16. Screens

Hanya 1 screen: **List Gerakan**, dengan 3 state: loading (skeleton), populated (13 kartu),
empty (data kosong).

### 17. Icons

Chevron-right kecil per kartu, ikon badge nomor bisa berupa angka polos (bukan ikon), ikon
"image placeholder" (outline) untuk skeleton sebelum thumbnail asli dimuat.

### 18. Illustrations

Empty state: ilustrasi flat minimal (mis. buku terbuka kosong / rak kosong) dalam satu warna
(Text Muted) di atas Background, tidak mencolok, kesan "belum ada data" bukan "error fatal".

### 19. Images

Thumbnail tiap kartu: crop persegi/4:3 dari foto gerakan yang sama dengan halaman detail,
konsisten pencahayaan dan gaya di seluruh 13 gerakan (jangan campur gaya foto berbeda-beda).

### 20. Final AI Prompt

Design a "List of Prayer Movements" grid page for an Islamic prayer tutorial web app. The page
displays exactly 13 sequential, clickable cards representing prayer movements (from standing/
qiyam to the final salam), adapting content to an active "Dewasa" (Adult) / "Anak" (Kids)
display mode. Reuse a sticky top header showing a compact group-identity bar and a mode toggle
switch. Each card must show: a small circular sequence-number badge (accent gold #BA7517
background with dark #2C2C2A text for AA contrast), a square thumbnail image on the left (or top
on tablet), the movement name in Poppins Semibold 16–18px, and a small right-aligned chevron
icon indicating it's clickable. Layout: single column full-width cards on mobile (≤480px) with an
80×80px thumbnail beside the text; 2-column grid on tablet (481–1024px) with vertical card
layout (image on top); 3-column grid on desktop (>1024px), max container width 1200px, 24px gap.
Cards use white surface #FFFFFF, 12px border radius, subtle shadow 0 2px 8px
rgba(44,44,42,0.08) at rest, elevating to 0 6px 16px rgba(44,44,42,0.14) with a 2px upward
translate on hover (150ms ease-out transition), and a slight scale-down press state (0.98
scale, 100ms) on mobile tap. Implement a skeleton loading state: 13 shimmering placeholder cards
(shimmer color sweeping from #E8E6DE to #F1EFE8, 1.2s linear infinite loop) matching the active
column count, crossfading into real content over 200ms once data arrives — never show a blank
screen while fetching. Implement an empty state (shown only if the data array is empty): a
minimal flat single-tone illustration (using text-muted #5F5E5A) with the message "Data gerakan
belum tersedia", calm and non-alarming rather than an error screen. Use the same base color
system as the rest of the app — primary #0F6E56, background #F1EFE8, surface #FFFFFF, text
primary #2C2C2A, text muted #5F5E5A, border #D3D1C7, danger #791F1F — with Poppins for headings/
card titles and Inter for body/labels. Every card must be keyboard-focusable with a visible 2px
primary-color focus ring and an aria-label reading "Gerakan {number}: {name}, buka detail",
meeting WCAG AA contrast throughout. When the user toggles the Dewasa/Anak mode switch, fade out
the current grid (150ms), briefly show skeleton cards, then fade in the refetched grid (150ms) —
no full page reload.

---

## 3. Prompt C — Halaman Detail Gerakan (`/gerakan/:id`)

### 1. Project Overview

Rancang halaman **Detail Gerakan** — halaman paling kompleks di aplikasi ini. Menampilkan satu
gerakan sholat secara lengkap: gambar, bacaan 4-lapis (Arab, transliterasi Latin, terjemahan,
audio), opsi video, navigasi Next/Previous antar-gerakan, dan toggle autoplay yang memutar
gerakan+audio secara berurutan otomatis. Ini adalah **halaman inti pembelajaran** — kualitas
desainnya paling menentukan pengalaman belajar pengguna.

### 2. Target Users

Sama dengan §2 Fondasi. Tambahan penting: pengguna di halaman ini kemungkinan sedang **mengikuti
bacaan sambil melihat layar berulang-ulang** (menghafal) — teks Arab harus sangat nyaman dibaca
dalam waktu lama, dan kontrol audio harus mudah dijangkau tanpa mengalihkan mata dari teks.

### 3. Design Goals

Memaksimalkan keterbacaan teks Arab (ukuran, line-height, kontras) di atas segalanya. Kontrol
navigasi (Next/Prev, autoplay, audio) harus selalu terjangkau (sticky) tanpa menutupi konten
bacaan. Transisi antar-gerakan (baik manual maupun autoplay) harus terasa mulus, tidak
menyebabkan "flash" konten kosong.

### 4. Visual Style

Sama dengan Prompt A & B, dengan penekanan lebih besar pada **hierarki tipografi teks Arab**
sebagai elemen visual utama halaman — bukan gambar, bukan tombol.

### 5. Color Palette

Identik §0. Tambahan penggunaan spesifik: Success `#2E7D4F` untuk indikator audio sedang
diputar (mis. waveform/progress bar aktif), Danger `#791F1F` khusus untuk toast error "Audio
gagal dimuat" (F-03.5), Accent `#BA7517` untuk indikator badge "Autoplay Aktif" (pulsing).

### 6. Typography

Teks Arab: Amiri/Scheherazade New, **minimal 28px**, line-height 1.8, warna Text Primary
`#2C2C2A`, alignment kanan (RTL-aware) di dalam blok teksnya sendiri meskipun layout halaman
tetap LTR. Transliterasi Latin: Inter italic 16px, Text Muted. Terjemahan: Inter 14px, Text
Muted. Sumber (HPT): Inter 12px, Text Muted, dengan ikon kecil buku/citation.

### 7. Layout

**Mobile (≤480px):** stack vertikal — gambar gerakan di atas (aspect ratio 4:3, max-height
40vh agar tidak mendominasi viewport), lalu blok bacaan (Arab → Latin → terjemahan → sumber),
lalu audio player, tombol "Tonton Video" (jika ada). Navigasi Next/Prev + toggle autoplay
**sticky di bawah**, selalu terlihat.

**Tablet (481–1024px):** mirip mobile namun dengan padding lebih lega, gambar bisa 16:9 lebih
lebar, teks Arab bisa naik ke 32px.

**Desktop (>1024px):** **layout dua panel** — panel kiri (sidebar, ~30% lebar) menampilkan mini
list 13 gerakan (scrollable, gerakan aktif di-highlight) agar pengguna bisa lompat langsung
tanpa kembali ke halaman list; panel kanan (~70%) menampilkan konten detail penuh seperti di
atas. Navigasi Next/Prev muncul sebagai tombol besar di kiri-kanan panel konten (bukan sticky
bottom, karena ruang vertikal desktop cukup luas) atau tetap sticky di bawah panel kanan —
pilih salah satu, konsisten dengan floating button style di §0.

### 8. Components

- **Header** (reuse, sticky top, identitas + toggle mode — mode di sini juga memicu refetch
  konten gerakan yang sedang dibuka, mempertahankan posisi urutan yang sama).
- **Gambar gerakan**: rounded 12px, dengan overlay tipis di sudut menampilkan nomor urut
  ("5/13") agar pengguna selalu tahu posisinya.
- **Blok bacaan 4-lapis**: card terpisah atau grouped section dengan pemisah halus antar-lapis
  (border-top 1px `#D3D1C7`).
- **Audio Player** (custom, bukan native browser default): tombol Play/Pause besar (min 48px,
  warna Primary, bentuk lingkaran), progress bar horizontal (track abu, fill Primary), label
  durasi (mm:ss / mm:ss), tombol Replay (ikon kecil di samping).
- **Tombol "Tonton Video"**: sekunder style, ikon play-circle outline, hanya render jika
  `video_url` tidak null.
- **Modal Video**: overlay gelap `rgba(28,28,26,0.7)`, konten video center, tombol close (X)
  di pojok kanan-atas modal, radius 16px pada container video.
- **Navigasi Next/Previous**: dua tombol (ikon panah + label "Sebelumnya"/"Berikutnya"),
  disabled state jelas (opacity 40%, cursor not-allowed) di gerakan pertama/terakhir.
- **Toggle Autoplay**: switch dengan badge "Autoplay Aktif" ber-animasi pulsing halus saat aktif.
- **Toast error**: pojok kanan-bawah, bg Danger dengan teks putih, auto-dismiss 3 detik, ikon
  warning outline.
- **Mini sidebar list** (desktop only): list 13 item ringkas (nomor+nama), item aktif diberi
  latar Primary dengan opacity rendah + border-left 3px Primary.

### 9. UX Behavior

- Play audio: tombol berubah dari ikon play → pause instan, progress bar mulai bergerak smooth
  (update tiap 250ms, bukan per-frame agar tidak berat).
- Audio selesai (`ended` event): jika autoplay aktif, transisi ke gerakan berikutnya dengan
  crossfade konten 200ms, lalu audio baru auto-play. Jika autoplay tidak aktif, tombol kembali
  ke ikon play, progress bar reset ke 0.
- Klik Next/Prev manual: audio yang sedang berjalan (jika ada) langsung berhenti (F-03.6),
  konten baru fade-in 200ms.
- Modal video: buka dengan scale+fade 200ms dari tombol asal, tutup dengan reverse animation
  atau klik area overlay gelap di luar video.
- Autoplay di gerakan ke-13 selesai: badge "Autoplay Aktif" hilang dengan fade, toggle otomatis
  kembali ke posisi off, tampilkan pesan singkat "Selesai — 13 gerakan telah dipelajari" (toast
  atau inline banner, bukan alert blocking).

### 10. Accessibility

Teks Arab kontras dan ukuran adalah prioritas aksesibilitas nomor satu di halaman ini —
verifikasi rasio kontras Text Primary di atas Surface ≥7:1 jika memungkinkan (di atas standar
AA 4.5:1, karena ini teks ibadah yang dibaca berulang). Audio player: `aria-label` pada tombol
play/pause yang berubah sesuai state ("Putar bacaan" / "Jeda bacaan"). Tombol Next/Prev disabled
punya `aria-disabled="true"` dan tetap dapat dijangkau screen reader dengan penjelasan alasan
disabled. Modal video: focus trap di dalam modal saat terbuka, `Esc` key menutup modal.

### 11. Responsive Rules

Sidebar mini-list desktop **disembunyikan sepenuhnya** (bukan di-collapse jadi hamburger) di
tablet/mobile — gunakan halaman List Gerakan terpisah sebagai gantinya untuk navigasi non-linear
di layar kecil, sesuai breakpoint §0. Sticky bottom nav di mobile tidak boleh menutupi audio
player — beri padding-bottom pada konten setinggi sticky nav.

### 12. Design System

Card/section radius 12–16px. Audio player track height 6px, radius full (pill). Tombol
Next/Prev: radius 8px, min-height 48px (lebih besar dari standar 44px karena ini kontrol utama
halaman). Badge nomor urut pada gambar: pill kecil, bg `rgba(28,28,26,0.6)`, teks putih 12px.

### 13. UI Components Style

Progress bar audio: track `#D3D1C7`, fill gradasi halus dari Primary ke Secondary (opsional,
atau solid Primary saja untuk kesederhanaan), thumb/handle tidak perlu terlihat kecuali saat
hover/drag (jika seek diaktifkan). Toggle autoplay: sama style dengan toggle mode di header
(konsistensi), namun warna aktif Accent (bukan Primary) agar berbeda secara visual dari toggle
mode.

### 14. Motion Design

Transisi antar-gerakan (manual maupun autoplay): crossfade 200ms ease-in-out pada seluruh blok
konten (gambar+teks), **bukan** slide/swipe yang bisa terasa lambat saat autoplay berjalan
cepat berturut-turut. Progress bar audio: update linear tanpa easing (representasi waktu nyata).
Badge "Autoplay Aktif": pulsing scale 1→1.05→1 loop 1.5s, halus, tidak mengganggu.

### 15. User Flow

`Datang dari List Gerakan (klik kartu) atau dari Next/Prev gerakan sebelumnya` →
`Lihat gambar + bacaan 4-lapis` → `(Opsional) Putar audio` →
`(Opsional) Aktifkan Autoplay → berjalan otomatis hingga gerakan 13 → berhenti otomatis` →
`(Opsional) Klik "Tonton Video" → modal terbuka → tutup modal` →
`Klik Next/Prev manual kapan saja → pindah gerakan, audio berhenti`.

### 16. Screens

Hanya 1 screen: **Detail Gerakan**, dengan sub-state: audio idle/playing/error,
autoplay on/off, video modal open/closed, posisi gerakan pertama (Prev disabled) / tengah /
terakhir (Next disabled).

### 17. Icons

Play/Pause (filled circle untuk tombol utama audio — pengecualian dari aturan outline karena
ini kontrol primer yang perlu sangat jelas), Replay (outline, panah melingkar), Video-play
(outline circle), Close/X (outline, untuk modal), Chevron-left/right (outline, Next/Prev),
Warning (outline, untuk toast error).

### 18. Illustrations

Gambar gerakan adalah foto/ilustrasi realistis-sederhana (mode Dewasa) atau ilustrasi flat
ramah anak (mode Anak) — bukan ikon generik. Tidak ada ilustrasi dekoratif tambahan yang bisa
mengalihkan fokus dari bacaan.

### 19. Images

Foto/ilustrasi gerakan: rasio 4:3 (mobile/tablet) atau 16:9 (desktop panel kanan), resolusi
cukup untuk retina display, kompresi WebP, pencahayaan konsisten antar-13 gerakan (lihat SSD.md
§8 untuk spesifikasi optimasi file).

### 20. Final AI Prompt

Design the "Prayer Movement Detail" page — the core learning screen of an Islamic prayer
tutorial web app, showing one of 13 sequential prayer movements with a 4-layer recitation
display (Arabic text, Latin transliteration, Indonesian translation, and an audio player),
adapting to an active "Dewasa" (Adult) / "Anak" (Kids) mode. On mobile (≤480px), stack
vertically: a rounded 12px movement image (4:3 ratio, max 40vh height) with a small "5/13"
position badge overlay in the corner, followed by the recitation block (large Arabic text using
Amiri or Scheherazade New at minimum 28px with 1.8 line-height and near-7:1 contrast against the
background for extended reading comfort, italic Latin transliteration at 16px, Indonesian
translation at 14px in muted gray, and a small HPT Muhammadiyah source citation with a book
icon), then a custom audio player (large circular primary-green play/pause button ≥48px, a
horizontal progress bar with a rounded track, current/total duration labels, and a replay
button), then a secondary "Tonton Video" button with a play-circle icon (only rendered if a
video URL exists). Keep Next/Previous navigation and an autoplay toggle switch sticky at the
bottom of the viewport at all times, with disabled states at 40% opacity on the first/last
movement. On desktop (>1024px), use a two-panel layout: a 30%-width scrollable sidebar listing
all 13 movements (active item highlighted with a light primary-green background and a 3px left
border), and a 70%-width detail panel containing everything described above. When audio
playback ends while autoplay is active, crossfade the entire content block (image + text) over
200ms into the next movement and auto-start its audio; when autoplay reaches movement 13, fade
out an "Autoplay Aktif" pulsing badge and show a calm inline completion message. Manual
Next/Previous clicks must immediately stop any playing audio and crossfade content in 200ms.
Implement a video modal with a dark rgba(28,28,26,0.7) overlay, a centered 16px-radius video
container, a close (X) button top-right, focus trap while open, and Esc-to-close behavior. On
audio load failure, show a bottom-right toast using the danger color #791F1F with a warning icon
that auto-dismisses after 3 seconds. Use the app's established color system — primary #0F6E56,
secondary #085041, accent #BA7517, background #F1EFE8, surface #FFFFFF, success #2E7D4F, danger
#791F1F, text primary #2C2C2A, text muted #5F5E5A, border #D3D1C7 — with Poppins for headings
and Inter for body/UI text, an 8px spacing grid, 12–16px border radius on cards and images, and
subtle 150–250ms ease-out transitions throughout (no slide/swipe transitions between movements,
crossfade only). Ensure WCAG AA-or-better contrast everywhere, 44px+ touch targets (48px for the
primary audio control), full keyboard operability, and descriptive aria-labels on all audio and
navigation controls whose accessible names update with their current state (e.g., "Putar bacaan"
vs "Jeda bacaan").

---

*Design.md ini konsisten dengan token yang telah ditetapkan di SRS.md §5.1 dan PRD.md §8 — jangan
ubah palet warna/tipografi di sini tanpa memperbarui kedua dokumen tersebut juga, agar Front-end
Dev, DB & Content Engineer, dan QA punya satu sumber kebenaran yang sama.*
*Pontianak, 2026*
