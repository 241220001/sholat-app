# Tuntunan Tata Cara Sholat

Aplikasi web edukasi pembelajaran tata cara sholat sesuai sunnah Rasulullah ﷺ dengan rujukan Himpunan Putusan Tarjih (HPT) Muhammadiyah.

[![PHP Version](https://img.shields.io/badge/PHP-7.4%2B-blue.svg)](https://php.net/)
[![MySQL](https://img.shields.io/badge/MySQL-5.7%2B-orange.svg)](https://mysql.com/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Database Setup](#database-setup)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Troubleshooting](#troubleshooting)
- [Credits](#credits)
- [License](#license)

---

## Overview

**Tuntunan Tata Cara Sholat** adalah aplikasi web responsif yang menyajikan 13 gerakan sholat secara terstruktur dengan:

- **4 Lapisan Bacaan**: Teks Arab berharakat, transliterasi Latin, terjemahan Indonesia, audio MP3
- **2 Mode Tampilan**: Dewasa (formal, lengkap) dan Anak (visual, ringkas)
- **Referensi HPT Muhammadiyah**: Konten verified sesuai keputusan Tarjih
- **Autoplay Mode**: Putar otomatis semua gerakan berurutan
- **Navigasi Intuitif**: Previous/Next dengan progress indicator

### Screenshots

| Beranda | List Gerakan | Detail Gerakan |
|---------|--------------|----------------|
| ![Beranda](docs/screenshot-home.png) | ![List](docs/screenshot-list.png) | ![Detail](docs/screenshot-detail.png) |

*(Screenshots will be added after final deployment)*

---

## Features

### Core Features

1. **Gerakan Sholat Lengkap**
   - 13 gerakan urut (qiyam sampai salam)
   - Deskripsi detail per gerakan
   - Gambar ilustrasi per gerakan

2. **Bacaan 4-Lapis**
   - Teks Arab berharakat (font khusus)
   - Transliterasi Latin (pelafalan)
   - Terjemahan Indonesia
   - Audio MP3 bacaan

3. **Mode Dewasa & Anak**
   - Dewasa: Konten lengkap, formal
   - Anak: Penjelasan sederhana, visual ramah
   - Toggle switch di header

4. **Autoplay**
   - Putar semua gerakan otomatis
   - Audio play otomatis
   - Progress indicator
   - Stop di gerakan terakhir

5. **Navigasi**
   - Previous/Next buttons
   - Mini sidebar (desktop)
   - URL routing support

6. **Responsive Design**
   - Mobile-first (≤480px)
   - Tablet (481-1024px)
   - Desktop (>1024px)

### Technical Features

- RESTful API architecture
- CORS enabled
- UTF-8mb4 support (Arabic diacritics)
- Prepared statements (SQL injection protection)
- Environment-based configuration

---

## Tech Stack

### Backend

| Component | Technology |
|-----------|------------|
| Language | PHP 7.4+ (Native) |
| Database | MySQL 5.7+ |
| Web Server | Apache (XAMPP) |
| API Style | RESTful JSON |

### Frontend

| Component | Technology |
|-----------|------------|
| Markup | HTML5 |
| Styling | CSS3 (Custom) |
| Logic | Vanilla JavaScript |
| Fonts | Google Fonts (Poppins, Inter, Amiri) |
| Icons | Lucide Icons |

### Development Tools

| Tool | Purpose |
|------|---------|
| XAMPP | Local development stack |
| Git | Version control |
| Postman | API testing |
| VS Code | Code editor |

---

## Prerequisites

Before installing, ensure you have:

### Required

- [ ] XAMPP (or any PHP+MySQL stack)
  - Apache server
  - MySQL database
  - PHP 7.4 or higher
- [ ] Git (for cloning repository)
- [ ] Modern web browser (Chrome/Firefox/Edge)

### Optional

- [ ] Postman (for API testing)
- [ ] VS Code (recommended editor)
- [ ] Node.js (if using build tools)

---

## Installation

### 1. Clone Repository

```bash
# Clone from GitHub
git clone https://github.com/241220001/sholat-app.git

# Navigate to project
cd sholat-app
```

Or download ZIP from GitHub and extract.

### 2. Start XAMPP

1. Open XAMPP Control Panel
2. Start **Apache** service
3. Start **MySQL** service
4. Verify both show green "Running" status

### 3. Configure Environment

```bash
# Copy environment template
cp .env.example .env

# Edit .env with your settings
```

`.env` file contents:
```ini
DB_HOST=localhost
DB_NAME=tuntunan_sholat
DB_USER=root
DB_PASS=
```

**Note:** `DB_PASS=` is empty by default for XAMPP. Add password if changed.

### 4. Setup Database

See [Database Setup](#database-setup) section below.

### 5. Access Application

Open browser and navigate to:
```
http://localhost/sholat-app/
```

API Base URL:
```
http://localhost/sholat-app/backend/api/
```

---

## Database Setup

### Option A: Using phpMyAdmin (GUI)

1. Open phpMyAdmin: `http://localhost/phpmyadmin/`
2. Click **SQL** tab
3. Copy and paste contents of `database/schema.sql`
4. Click **Go** to execute
5. Repeat for `database/seed.sql`

### Option B: Using Command Line

```bash
# Login to MySQL
mysql -u root -p

# Create database and tables
source database/schema.sql

# Insert seed data
source database/seed.sql

# Exit
EXIT;
```

### Option C: Using XAMPP MySQL Console

1. Open XAMPP → MySQL → Console
2. Enter MySQL monitor
3. Run commands from Option B

### Database Structure

```
tuntunan_sholat
├── kategori (2 rows: dewasa, anak)
├── kelompok (1 row: group identity)
├── gerakan (26 rows: 13 per kategori)
└── bacaan (22-24 rows: readings per gerakan)
```

### Verify Setup

```bash
# Test database connection
curl http://localhost/sholat-app/backend/api/health.php

# Expected response:
# {"status":"success","data":{"message":"Koneksi database berhasil!"}}
```

---

## Configuration

### Environment Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `DB_HOST` | MySQL host | `localhost` | Yes |
| `DB_NAME` | Database name | `tuntunan_sholat` | Yes |
| `DB_USER` | MySQL username | `root` | Yes |
| `DB_PASS` | MySQL password | `` (empty) | No |

### Application Config

Edit `database/seed.sql` to customize:

```sql
-- Update group identity
UPDATE kelompok SET
  nama_kelompok = 'Your Group Name',
  prodi = 'Your Program',
  mata_kuliah = 'Your Course',
  dosen = 'Lecturer Name'
WHERE id = 1;
```

### CORS Configuration

File: `backend/api/*.php`

```php
// Allow all origins (development)
header("Access-Control-Allow-Origin: *");

// Restrict to specific domain (production)
// header("Access-Control-Allow-Origin: https://yourdomain.com");
```

---

## Project Structure

```
sholat-app/
├── .env.example          # Environment template
├── .gitignore           # Git ignore rules
├── Design.md            # UI/UX design specifications
├── README.md           # This file
│
├── assets/             # Static assets
│   ├── audio/         # MP3 audio files
│   │   ├── *.mp3     # Movement audio recordings
│   │   └── bacaan/   # Reading-specific audio
│   └── img/          # Images
│       ├── *.jpg    # Adult mode images
│       └── *.png    # Kids mode images
│
├── backend/           # PHP API (MVC Architecture)
│   ├── api/          # API entry points (routing)
│   │   ├── bacaan.php
│   │   ├── gerakan.php
│   │   ├── health.php
│   │   └── kelompok.php
│   ├── config/      # Configuration files
│   ├── controllers/ # Request handlers
│   │   ├── BacaanController.php
│   │   ├── GerakanController.php
│   │   └── KelompokController.php
│   ├── core/        # Core utilities
│   │   ├── Database.php
│   │   └── Response.php
│   └── models/      # Data access layer
│       ├── Bacaan.php
│       ├── Gerakan.php
│       └── Kelompok.php
│
├── database/          # Database scripts
│   ├── schema.sql   # Table structure
│   └── seed.sql     # Initial data
│
├── docs/             # Documentation
│   ├── API.md       # Backend API documentation
│   ├── PRD.md       # Product Requirements
│   └── SRS.md       # Software Requirements
│
└── frontend/         # Client-side code
    ├── css/         # Stylesheets
    │   └── style.css
    ├── js/          # JavaScript
    │   ├── autoplay.js
    │   ├── main.js
    │   └── navigation.js
    └── pages/       # HTML pages
        ├── index.html
        ├── daftar-gerakan.html
        └── detail-gerakan.html
```

---

## API Documentation

Complete API documentation available in [`docs/API.md`](docs/API.md)

### Quick Reference

**Base URL:** `http://localhost/sholat-app/backend/api`

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health.php` | GET | Database health check |
| `/kelompok.php` | GET | Group identity info |
| `/gerakan.php?kategori={dewasa\|anak}` | GET | List all movements |
| `/gerakan.php?id={id}` | GET | Movement details |
| `/gerakan.php?next&id_kategori={id}&urutan={n}` | GET | Next movement |
| `/gerakan.php?prev&id_kategori={id}&urutan={n}` | GET | Previous movement |
| `/gerakan.php?total&kategori={dewasa\|anak}` | GET | Total movements count |
| `/gerakan.php?autoplay&kategori={dewasa\|anak}` | GET | Autoplay data (nested) |
| `/bacaan.php?id_gerakan={id}` | GET | Readings for movement |

### Example Requests

```bash
# Health check
curl http://localhost/sholat-app/backend/api/health.php

# List adult mode movements
curl "http://localhost/sholat-app/backend/api/gerakan.php?kategori=dewasa"

# Movement details
curl "http://localhost/sholat-app/backend/api/gerakan.php?id=2"

# Readings for takbir
curl "http://localhost/sholat-app/backend/api/bacaan.php?id_gerakan=2"
```

---

## Development

### Local Development Setup

1. Ensure XAMPP Apache + MySQL running
2. Clone repository to `htdocs` folder
3. Configure `.env` file
4. Setup database (see [Database Setup](#database-setup))
5. Access `http://localhost/sholat-app/`

### Code Structure

**Backend (MVC Pattern):**

- **Models** (`models/`): Database queries, data access
- **Controllers** (`controllers/`): Business logic, request handling
- **API** (`api/`): Entry points, routing, validation
- **Core** (`core/`): Utilities (Database, Response helpers)

### Coding Standards

- **PHP**: PSR-4 inspired (classes, namespaces where appropriate)
- **JavaScript**: ES6+ syntax, async/await for API calls
- **CSS**: Custom properties (variables), BEM naming convention
- **HTML**: Semantic elements, accessibility attributes

### Branching Strategy

```
main ───────────────────────────────────────→
  └── backend ──── commits ──── push ──→ PR
       └── feature-branch ──→ PR to backend
```

- `main`: Production-ready code
- `backend`: Backend development branch
- Feature branches: `feature/xxx`, `fix/xxx`

### Commit Messages

Follow conventional commits:

```
feat: add autoplay endpoint
fix: remove debug code from controller
docs: add API documentation
refactor: simplify database connection
```

---

## Testing

### Manual API Testing

**Health Check:**
```bash
curl http://localhost/sholat-app/backend/api/health.php
# Expected: {"status":"success","data":{"message":"Koneksi database berhasil!"}}
```

**List Gerakan:**
```bash
curl "http://localhost/sholat-app/backend/api/gerakan.php?kategori=dewasa"
# Expected: Array of 13 movements
```

**Error Handling:**
```bash
curl "http://localhost/sholat-app/backend/api/gerakan.php"
# Expected: {"status":"error","message":"Parameter kategori wajib diisi","code":"INVALID_KATEGORI"}
```

### Postman Collection

Import `docs/postman-collection.json` (to be created) into Postman for comprehensive API testing.

### Browser Testing

Test frontend functionality:

1. Open `http://localhost/sholat-app/`
2. Toggle Dewasa/Anak mode
3. Navigate to List Gerakan
4. Click any movement card
5. Test audio playback
6. Test Next/Previous navigation
7. Test Autoplay toggle
8. Resize browser for responsive testing

### Test Checklist

- [ ] Health endpoint returns 200
- [ ] Kelompok returns group info
- [ ] Gerakan list returns 13 items per kategori
- [ ] Gerakan detail returns complete data
- [ ] Next/Prev navigation works
- [ ] Bacaan returns readings array
- [ ] Autoplay returns nested data structure
- [ ] Error responses follow standard format
- [ ] Frontend loads correctly
- [ ] Mode toggle switches content
- [ ] Audio plays correctly
- [ ] Responsive layout works on mobile/tablet

---

## Deployment

### Production Requirements

- Web server with PHP support (Apache/Nginx)
- MySQL 5.7+ database
- PHP 7.4+ with extensions:
  - pdo_mysql
  - json
  - mbstring
- SSL certificate (HTTPS)

### Deployment Steps

1. **Upload Files**
   ```bash
   # Via FTP/SFTP or Git
   git clone https://github.com/241220001/sholat-app.git /var/www/sholat-app
   ```

2. **Configure Environment**
   ```bash
   # Create .env with production values
   cp .env.example .env
   
   # Edit with production database credentials
   nano .env
   ```

3. **Setup Database**
   ```bash
   # Create database
   mysql -u username -p -e "CREATE DATABASE tuntunan_sholat CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
   
   # Import schema and seed
   mysql -u username -p tuntunan_sholat < database/schema.sql
   mysql -u username -p tuntunan_sholat < database/seed.sql
   ```

4. **Configure Web Server**

   **Apache (.htaccess):**
   ```apache
   RewriteEngine On
   RewriteCond %{REQUEST_FILENAME} !-f
   RewriteCond %{REQUEST_FILENAME} !-d
   RewriteRule ^(.*)$ frontend/index.html [QSA,L]
   ```

   **Nginx:**
   ```nginx
   location / {
       try_files $uri $uri/ /frontend/index.html;
   }
   ```

5. **Set Permissions**
   ```bash
   # Backend files
   chmod -R 755 backend/
   
   # Assets (writable for uploads if needed)
   chmod -R 755 assets/
   ```

6. **Security Hardening**
   ```apache
   # .htaccess in backend/
   # Restrict direct access to PHP files
   <FilesMatch "\.(php|ini|log|sh)$">
       Order Allow,Deny
       Deny from all
   </FilesMatch>
   
   # Allow only API endpoints
   <Location "/backend/api/">
       Order Allow,Deny
       Allow from all
   </Location>
   ```

### Recommended Hosting

- Shared hosting with cPanel (simplest)
- VPS (DigitalOcean, Vultr, Linode)
- Cloud (AWS Lightsail, GCP)

---

## Troubleshooting

### Common Issues

**1. "Database connection failed"**

```
Error: {"status":"error","message":"Koneksi database gagal","code":"DB_ERROR"}
```

**Solution:**
- Ensure MySQL is running (XAMPP Control Panel)
- Check `.env` credentials match your MySQL setup
- Verify database `tuntunan_sholat` exists

**2. "File .env tidak ditemukan"**

```
Error: {"status":"error","message":"File .env tidak ditemukan","code":"ENV_NOT_FOUND"}
```

**Solution:**
- Copy `.env.example` to `.env`
- Ensure file is in project root directory

**3. Empty data arrays `[]`**

- Database tables are empty
- Run seed data: `database/seed.sql`
- Verify via phpMyAdmin

**4. Arabic text displays as `???` or `□□`**

- Database charset issue
- Ensure database uses `utf8mb4`
- Re-run `schema.sql` to recreate tables

**5. Audio files not playing**

- Check file paths in database match actual file locations
- Verify MP3 files exist in `assets/audio/`
- Ensure web server serves audio MIME types

**6. CORS errors in browser console**

- Backend doesn't have CORS headers
- Verify `backend/api/*.php` includes CORS headers
- Check for typos in origin URL

**7. "404 Not Found" on API endpoints**

- Apache mod_rewrite not enabled
- Check `.htaccess` file exists in `backend/`
- Enable `AllowOverride All` in Apache config

### Debug Mode

Add to `backend/core/Database.php` for verbose errors:

```php
// In catch block
error_reporting(E_ALL);
ini_set('display_errors', 1);
echo $e->getMessage();
```

**Warning:** Disable in production!

---

## Credits

### Development Team

| Role | Name | NIM |
|------|------|-----|
| Backend Developer | [Your Name] | [Your NIM] |
| Frontend Developer | [Name] | [NIM] |
| Database Engineer | [Name] | [NIM] |
| UI/UX Designer | [Name] | [NIM] |

**Course:** AIK 4 - Pengembangan Aplikasi Web  
**Institution:** Program Studi Manajemen Bisnis Syariah · FAI · Universitas Muhammadiyah Pontianak  
**Lecturer:** Dedy Susanto, S.Pd.I., M.M. (NIDN. 1128048303)

### Resources

- **Bacaan Reference:** Himpunan Putusan Tarjih (HPT) Muhammadiyah, Kitab Shalat
- **Audio Source:** Muhammadiyah Yogyakarta (for audio recordings)
- **Design Tokens:** Based on SRS.md §5.1 and PRD.md §8

### Technologies

- [PHP](https://php.net/) - Backend language
- [MySQL](https://mysql.com/) - Database
- [XAMPP](https://www.apachefriends.org/) - Development stack
- [Poppins](https://fonts.google.com/specimen/Poppins) - Heading font
- [Inter](https://fonts.google.com/specimen/Inter) - Body font
- [Amiri](https://fonts.google.com/specimen/Amiri) - Arabic text font
- [Lucide Icons](https://lucide.dev/) - Icon set

---

## License

MIT License

```
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Support

For issues and questions:

- **GitHub Issues:** [Report a bug](https://github.com/241220001/sholat-app/issues)
- **Documentation:** [docs/API.md](docs/API.md)
- **Requirements:** [docs/SRS.md](docs/SRS.md)

---

## Acknowledgments

Special thanks to:

- Dedy Susanto, S.Pd.I., M.M. as course lecturer
- Muhammadiyah for HPT reference materials
- All team members for dedication and hard work

---

**Built with ❤️ for Islamic education**

*Pontianak, 2026*
