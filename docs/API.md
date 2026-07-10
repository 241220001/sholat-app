# API Documentation
## Aplikasi Web Tuntunan Tata Cara Sholat

**Version:** 1.0  
**Base URL:** `http://localhost/sholat-app/backend/api/`  
**Environment:** Production URL akan berbeda sesuai deployment  
**Last Updated:** 2026-07-09

---

## Table of Contents

1. [Overview](#overview)
2. [Response Format](#response-format)
3. [Error Handling](#error-handling)
4. [Endpoints](#endpoints)
   - [Health Check](#1-health-check)
   - [Kelompok Info](#2-kelompok-info)
   - [List Gerakan](#3-list-gerakan)
   - [Detail Gerakan](#4-detail-gerakan)
   - [Next Gerakan](#5-next-gerakan)
   - [Previous Gerakan](#6-previous-gerakan)
   - [Total Gerakan](#7-total-gerakan)
   - [Autoplay Data](#8-autoplay-data)
   - [Bacaan by Gerakan](#9-bacaan-by-gerakan)
5. [Integration Examples](#integration-examples)
6. [Database Schema Reference](#database-schema-reference)

---

## Overview

REST API untuk aplikasi pembelajaran tata cara sholat dengan 2 mode tampilan (Dewasa/Anak). Backend dibangun dengan PHP native + MySQL, menggunakan arsitektur MVC sederhana.

**Key Features:**
- 13 gerakan sholat berurutan per kategori
- Bacaan 4-lapis (Arab, Latin, terjemahan, audio)
- Navigation (next/previous)
- Autoplay mode data
- CORS enabled untuk frontend terpisah

**Tech Stack:**
- PHP 7.4+ (native, no framework)
- MySQL 5.7+ dengan charset utf8mb4
- PDO untuk database access
- JSON response format

---

## Response Format

### Success Response

```json
{
  "status": "success",
  "data": {
    // Response payload varies by endpoint
  }
}
```

**HTTP Status Code:** `200 OK`

### Error Response

```json
{
  "status": "error",
  "message": "Human-readable error description",
  "code": "ERROR_CODE_CONSTANT"
}
```

**HTTP Status Codes:**
- `400 Bad Request` - Invalid parameters
- `404 Not Found` - Resource not found
- `405 Method Not Allowed` - Wrong HTTP method
- `500 Internal Server Error` - Server/database error

---

## Error Handling

### Common Error Codes

| Code | HTTP Status | Meaning | Solution |
|------|-------------|---------|----------|
| `METHOD_NOT_ALLOWED` | 405 | Non-GET request | Use GET method only |
| `INVALID_KATEGORI` | 400 | kategori parameter salah | Use 'dewasa' or 'anak' |
| `INVALID_ID` | 400 | ID parameter tidak valid | Provide numeric ID |
| `INVALID_ID_GERAKAN` | 400 | id_gerakan tidak valid | Provide numeric id_gerakan |
| `INVALID_PARAMS` | 400 | Required params missing | Check endpoint requirements |
| `GERAKAN_NOT_FOUND` | 404 | Gerakan tidak ditemukan | Verify ID exists in database |
| `KATEGORI_NOT_FOUND` | 404 | Kategori tidak ada | Database seed issue |
| `NO_NEXT_GERAKAN` | 404 | Sudah gerakan terakhir | Expected at urutan=13 |
| `NO_PREV_GERAKAN` | 404 | Sudah gerakan pertama | Expected at urutan=1 |
| `KELOMPOK_NOT_CONFIGURED` | 500 | Data kelompok kosong | Run database seed |
| `SERVER_ERROR` | 500 | Internal error | Check logs, DB connection |
| `DB_ERROR` | 500 | Database connection failed | Verify MySQL running |
| `ENV_NOT_FOUND` | 500 | .env file missing | Create .env from .env.example |

---

## Endpoints

### 1. Health Check

**Purpose:** Verify database connection status

**Endpoint:** `GET /backend/api/health.php`

**Parameters:** None

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "message": "Koneksi database berhasil!"
  }
}
```

**Error Response:**
```json
{
  "status": "error",
  "message": "Koneksi database gagal",
  "code": "DB_ERROR"
}
```

**cURL Example:**
```bash
curl http://localhost/sholat-app/backend/api/health.php
```

**Use Case:** Frontend app startup check, monitoring, CI/CD health verification

---

### 2. Kelompok Info

**Purpose:** Get group identity information for header display

**Endpoint:** `GET /backend/api/kelompok.php`

**Parameters:** None

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "nama_kelompok": "Kelompok 1",
    "prodi": "Teknik Informatika",
    "mata_kuliah": "AIK 4",
    "dosen": "Dedy Susanto, S.Pd.I., M.M."
  }
}
```

**Error Response:**
```json
{
  "status": "error",
  "message": "Data kelompok belum tersedia",
  "code": "KELOMPOK_NOT_CONFIGURED"
}
```

**cURL Example:**
```bash
curl http://localhost/sholat-app/backend/api/kelompok.php
```

**Use Case:** Display in application header/footer (Design.md §1.8 - header identitas)

**Notes:**
- Returns first row from `kelompok` table (should only have 1 row)
- Data is static after seeding

---

### 3. List Gerakan

**Purpose:** Get all 13 movements for a specific category (Dewasa/Anak)

**Endpoint:** `GET /backend/api/gerakan.php?kategori={kategori}`

**Parameters:**

| Name | Type | Required | Values | Description |
|------|------|----------|--------|-------------|
| `kategori` | string | **Yes** | `dewasa` or `anak` | Display mode |

**Success Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nama": "Berdiri tegak (qiyam) + niat",
      "urutan": 1,
      "deskripsi": "[DESKRIPSI - lengkapi]",
      "gambar_url": "/assets/img/gerakan/01-qiyam.jpg",
      "video_url": null
    },
    {
      "id": 2,
      "nama": "Takbiratul ihram",
      "urutan": 2,
      "deskripsi": "[DESKRIPSI - lengkapi]",
      "gambar_url": "/assets/img/gerakan/02-takbir.jpg",
      "video_url": null
    }
    // ... 11 more items (total 13)
  ]
}
```

**Error Responses:**

Missing kategori parameter:
```json
{
  "status": "error",
  "message": "Parameter kategori wajib diisi: dewasa atau anak",
  "code": "INVALID_KATEGORI"
}
```

Invalid kategori value:
```json
{
  "status": "error",
  "message": "Parameter kategori wajib diisi: dewasa atau anak",
  "code": "INVALID_KATEGORI"
}
```

**cURL Examples:**
```bash
# Gerakan dewasa
curl "http://localhost/sholat-app/backend/api/gerakan.php?kategori=dewasa"

# Gerakan anak
curl "http://localhost/sholat-app/backend/api/gerakan.php?kategori=anak"
```

**Use Case:** Display movement list page (Design.md Prompt B - Halaman List Gerakan)

**Notes:**
- Always returns exactly 13 items (1 per urutan)
- Sorted by `urutan` ASC
- `video_url` may be `null` if no video available
- Image paths are relative to project root

---

### 4. Detail Gerakan

**Purpose:** Get detailed information for a single movement by ID

**Endpoint:** `GET /backend/api/gerakan.php?id={id}`

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id` | integer | **Yes** | Gerakan ID from database |

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "id_kategori": 1,
    "nama": "Berdiri tegak (qiyam) + niat",
    "urutan": 1,
    "deskripsi": "[DESKRIPSI - lengkapi]",
    "gambar_url": "/assets/img/gerakan/01-qiyam.jpg",
    "video_url": null
  }
}
```

**Error Responses:**

Invalid ID parameter:
```json
{
  "status": "error",
  "message": "ID gerakan tidak valid",
  "code": "INVALID_ID"
}
```

Gerakan not found:
```json
{
  "status": "error",
  "message": "Gerakan tidak ditemukan",
  "code": "GERAKAN_NOT_FOUND"
}
```

**cURL Example:**
```bash
curl "http://localhost/sholat-app/backend/api/gerakan.php?id=5"
```

**Use Case:** Display detail gerakan page (Design.md Prompt C)

**Notes:**
- Returns `id_kategori` field (1=dewasa, 2=anak)
- Includes all gerakan fields
- Used for detail page display

---

### 5. Next Gerakan

**Purpose:** Get the next movement in sequence for navigation

**Endpoint:** `GET /backend/api/gerakan.php?next&id_kategori={id_kategori}&urutan={urutan}`

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id_kategori` | integer | **Yes** | Category ID (1=dewasa, 2=anak) |
| `urutan` | integer | **Yes** | Current movement sequence number |

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "id": 2,
    "nama": "Takbiratul ihram",
    "urutan": 2
  }
}
```

**Error Responses:**

Missing or invalid parameters:
```json
{
  "status": "error",
  "message": "Parameter id_kategori dan urutan wajib diisi dan berupa angka",
  "code": "INVALID_PARAMS"
}
```

No next movement (already at urutan=13):
```json
{
  "status": "error",
  "message": "Tidak ada gerakan berikutnya",
  "code": "NO_NEXT_GERAKAN"
}
```

**cURL Examples:**
```bash
# Get movement after qiyam (urutan=1) in dewasa category
curl "http://localhost/sholat-app/backend/api/gerakan.php?next&id_kategori=1&urutan=1"

# Get movement after rukuk (urutan=5) in anak category
curl "http://localhost/sholat-app/backend/api/gerakan.php?next&id_kategori=2&urutan=5"
```

**Use Case:** 
- Detail page "Next" button navigation (Design.md §3.15 user flow)
- Autoplay progression logic

**Notes:**
- Returns minimal data (id, nama, urutan only)
- Returns 404 when called with urutan=13 (expected behavior)
- Frontend should disable "Next" button at urutan=13

---

### 6. Previous Gerakan

**Purpose:** Get the previous movement in sequence for navigation

**Endpoint:** `GET /backend/api/gerakan.php?prev&id_kategori={id_kategori}&urutan={urutan}`

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id_kategori` | integer | **Yes** | Category ID (1=dewasa, 2=anak) |
| `urutan` | integer | **Yes** | Current movement sequence number |

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "id": 1,
    "nama": "Berdiri tegak (qiyam) + niat",
    "urutan": 1
  }
}
```

**Error Responses:**

Missing or invalid parameters:
```json
{
  "status": "error",
  "message": "Parameter id_kategori dan urutan wajib diisi dan berupa angka",
  "code": "INVALID_PARAMS"
}
```

No previous movement (already at urutan=1):
```json
{
  "status": "error",
  "message": "Tidak ada gerakan sebelumnya",
  "code": "NO_PREV_GERAKAN"
}
```

**cURL Examples:**
```bash
# Get movement before takbir (urutan=2) in dewasa category
curl "http://localhost/sholat-app/backend/api/gerakan.php?prev&id_kategori=1&urutan=2"

# Get movement before sujud (urutan=7) in anak category
curl "http://localhost/sholat-app/backend/api/gerakan.php?prev&id_kategori=2&urutan=7"
```

**Use Case:** 
- Detail page "Previous" button navigation
- User wants to review earlier movements

**Notes:**
- Returns minimal data (id, nama, urutan only)
- Returns 404 when called with urutan=1 (expected behavior)
- Frontend should disable "Previous" button at urutan=1

---

### 7. Total Gerakan

**Purpose:** Get total count of movements for a category

**Endpoint:** `GET /backend/api/gerakan.php?total&kategori={kategori}`

**Parameters:**

| Name | Type | Required | Values | Description |
|------|------|----------|--------|-------------|
| `kategori` | string | **Yes** | `dewasa` or `anak` | Display mode |

**Success Response:**
```json
{
  "status": "success",
  "data": {
    "total_gerakan": 13
  }
}
```

**Error Responses:**

Missing or invalid kategori:
```json
{
  "status": "error",
  "message": "Parameter kategori wajib diisi: dewasa atau anak",
  "code": "INVALID_KATEGORI"
}
```

Category not found in database:
```json
{
  "status": "error",
  "message": "Kategori tidak ditemukan",
  "code": "KATEGORI_NOT_FOUND"
}
```

**cURL Examples:**
```bash
# Count dewasa movements
curl "http://localhost/sholat-app/backend/api/gerakan.php?total&kategori=dewasa"

# Count anak movements
curl "http://localhost/sholat-app/backend/api/gerakan.php?total&kategori=anak"
```

**Use Case:** 
- Display "X of 13" progress indicator
- Validate navigation boundaries
- UI badge showing total movements

**Notes:**
- Always returns 13 for both categories (by design)
- Useful for frontend pagination/progress UI
- Can be called once on app init and cached

---

### 8. Autoplay Data

**Purpose:** Get all movements with nested bacaan data for autoplay feature

**Endpoint:** `GET /backend/api/gerakan.php?autoplay&kategori={kategori}`

**Parameters:**

| Name | Type | Required | Values | Description |
|------|------|----------|--------|-------------|
| `kategori` | string | **Yes** | `dewasa` or `anak` | Display mode |

**Success Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "nama": "Berdiri tegak (qiyam) + niat",
      "urutan": 1,
      "gambar_url": "/assets/img/gerakan/01-qiyam.jpg",
      "video_url": null,
      "bacaan": []
    },
    {
      "id": 2,
      "nama": "Takbiratul ihram",
      "urutan": 2,
      "gambar_url": "/assets/img/gerakan/02-takbir.jpg",
      "video_url": null,
      "bacaan": [
        {
          "id": 1,
          "urutan": 1,
          "teks_arab": "[TEKS ARAB TAKBIR]",
          "teks_latin": "Allahu Akbar",
          "terjemahan": "[TERJEMAHAN]",
          "audio_url": "/assets/audio/bacaan/02-takbir.mp3",
          "sumber": "HPT Muhammadiyah, Kitab Shalat"
        }
      ]
    }
    // ... 11 more items (total 13)
  ]
}
```

**Error Responses:**

Missing or invalid kategori:
```json
{
  "status": "error",
  "message": "Parameter kategori wajib diisi: dewasa atau anak",
  "code": "INVALID_KATEGORI"
}
```

Category not found:
```json
{
  "status": "error",
  "message": "Kategori tidak ditemukan",
  "code": "KATEGORI_NOT_FOUND"
}
```

**cURL Examples:**
```bash
# Autoplay data for dewasa mode
curl "http://localhost/sholat-app/backend/api/gerakan.php?autoplay&kategori=dewasa"

# Autoplay data for anak mode
curl "http://localhost/sholat-app/backend/api/gerakan.php?autoplay&kategori=anak"
```

**Use Case:** 
- Autoplay feature (Design.md §3.9 - toggle autoplay)
- Load all data in one request for sequential playback
- Reduce HTTP requests during autoplay mode

**Notes:**
- Returns all 13 movements with nested bacaan arrays
- Single JOIN query (gerakan LEFT JOIN bacaan)
- Response size: ~4-5KB
- Some movements have empty bacaan arrays (e.g., qiyam has no bacaan)
- Bacaan arrays sorted by urutan ASC

---

### 9. Bacaan by Gerakan

**Purpose:** Get all bacaan (readings) for a specific movement

**Endpoint:** `GET /backend/api/bacaan.php?id_gerakan={id_gerakan}`

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `id_gerakan` | integer | **Yes** | Gerakan ID from database |

**Success Response:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "urutan": 1,
      "teks_arab": "[TEKS ARAB TAKBIR]",
      "teks_latin": "Allahu Akbar",
      "terjemahan": "[TERJEMAHAN]",
      "audio_url": "/assets/audio/bacaan/02-takbir.mp3",
      "sumber": "HPT Muhammadiyah, Kitab Shalat"
    }
  ]
}
```

**Empty Response (gerakan has no bacaan):**
```json
{
  "status": "success",
  "data": []
}
```

**Error Responses:**

Missing or invalid id_gerakan:
```json
{
  "status": "error",
  "message": "Parameter id_gerakan wajib diisi dan harus berupa angka",
  "code": "INVALID_ID_GERAKAN"
}
```

**cURL Examples:**
```bash
# Get bacaan for takbiratul ihram (gerakan id=2)
curl "http://localhost/sholat-app/backend/api/bacaan.php?id_gerakan=2"

# Get bacaan for rukuk (gerakan id=5)
curl "http://localhost/sholat-app/backend/api/bacaan.php?id_gerakan=5"

# Get bacaan for qiyam (gerakan id=1) - returns empty array
curl "http://localhost/sholat-app/backend/api/bacaan.php?id_gerakan=1"
```

**Use Case:** 
- Display 4-layer reading on detail page (Design.md Prompt C)
- Load bacaan separately from gerakan data
- Audio player data source

**Notes:**
- Returns array (0 to N bacaan per gerakan)
- Most movements have 1 bacaan, tasyahud akhir has 2 (tasyahud + shalawat)
- Empty array is valid response (not error)
- Sorted by urutan ASC
- Audio files are MP3 format

---

## Integration Examples

### Frontend Vanilla JavaScript

```javascript
// Base API URL configuration
const API_BASE = 'http://localhost/sholat-app/backend/api';

// Fetch gerakan list
async function fetchGerakanList(kategori) {
  try {
    const response = await fetch(`${API_BASE}/gerakan.php?kategori=${kategori}`);
    const json = await response.json();
    
    if (json.status === 'success') {
      return json.data;
    } else {
      throw new Error(json.message);
    }
  } catch (error) {
    console.error('Failed to fetch gerakan:', error);
    return [];
  }
}

// Fetch gerakan detail with bacaan
async function fetchGerakanDetail(id) {
  try {
    const [gerakanRes, bacaanRes] = await Promise.all([
      fetch(`${API_BASE}/gerakan.php?id=${id}`),
      fetch(`${API_BASE}/bacaan.php?id_gerakan=${id}`)
    ]);
    
    const gerakan = await gerakanRes.json();
    const bacaan = await bacaanRes.json();
    
    if (gerakan.status === 'success' && bacaan.status === 'success') {
      return {
        ...gerakan.data,
        bacaan: bacaan.data
      };
    }
  } catch (error) {
    console.error('Failed to fetch detail:', error);
    return null;
  }
}

// Navigation with error handling
async function navigateNext(idKategori, urutan) {
  try {
    const response = await fetch(
      `${API_BASE}/gerakan.php?next&id_kategori=${idKategori}&urutan=${urutan}`
    );
    const json = await response.json();
    
    if (json.status === 'success') {
      window.location.href = `/detail-gerakan.html?id=${json.data.id}`;
    } else if (json.code === 'NO_NEXT_GERAKAN') {
      alert('Sudah mencapai gerakan terakhir');
    }
  } catch (error) {
    console.error('Navigation error:', error);
  }
}

// Health check on app init
async function checkAPIHealth() {
  try {
    const response = await fetch(`${API_BASE}/health.php`);
    const json = await response.json();
    return json.status === 'success';
  } catch (error) {
    console.error('API health check failed:', error);
    return false;
  }
}
```

### Error Handling Pattern

```javascript
async function apiCall(endpoint, params = {}) {
  const queryString = new URLSearchParams(params).toString();
  const url = `${API_BASE}/${endpoint}?${queryString}`;
  
  try {
    const response = await fetch(url);
    const json = await response.json();
    
    if (json.status === 'success') {
      return { success: true, data: json.data };
    } else {
      return { 
        success: false, 
        error: json.message, 
        code: json.code 
      };
    }
  } catch (error) {
    return { 
      success: false, 
      error: 'Network error or server unavailable',
      code: 'NETWORK_ERROR'
    };
  }
}

// Usage
const result = await apiCall('gerakan.php', { kategori: 'dewasa' });
if (result.success) {
  displayGerakan(result.data);
} else {
  showError(result.error, result.code);
}
```

### Autoplay Implementation

```javascript
async function startAutoplay(kategori) {
  // Load all data once
  const response = await fetch(
    `${API_BASE}/gerakan.php?autoplay&kategori=${kategori}`
  );
  const json = await response.json();
  
  if (json.status !== 'success') return;
  
  const gerakanList = json.data;
  let currentIndex = 0;
  
  async function playNext() {
    if (currentIndex >= gerakanList.length) {
      alert('Autoplay selesai - 13 gerakan telah dipelajari');
      return;
    }
    
    const gerakan = gerakanList[currentIndex];
    displayGerakan(gerakan);
    
    // Play audio if exists
    if (gerakan.bacaan.length > 0 && gerakan.bacaan[0].audio_url) {
      const audio = new Audio(gerakan.bacaan[0].audio_url);
      audio.addEventListener('ended', () => {
        currentIndex++;
        setTimeout(playNext, 500); // 500ms delay before next
      });
      audio.play();
    } else {
      // No audio, auto-advance after 3 seconds
      setTimeout(() => {
        currentIndex++;
        playNext();
      }, 3000);
    }
  }
  
  playNext();
}
```

---

## Database Schema Reference

### Table: kategori

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `id` | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT | Category ID |
| `nama` | VARCHAR(20) | UNIQUE, CHECK(dewasa\|anak) | Category name |

**Seed Data:**
- id=1: 'dewasa'
- id=2: 'anak'

---

### Table: kelompok

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `id` | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT | Group ID |
| `nama_kelompok` | VARCHAR(100) | NOT NULL | Group name |
| `prodi` | VARCHAR(100) | NOT NULL | Study program |
| `mata_kuliah` | VARCHAR(100) | NOT NULL | Course name |
| `dosen` | VARCHAR(100) | NOT NULL | Lecturer name |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Update timestamp |

**Notes:** Should contain exactly 1 row (singleton table)

---

### Table: gerakan

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `id` | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT | Movement ID |
| `id_kategori` | INT UNSIGNED | FOREIGN KEY → kategori(id) | Category reference |
| `nama` | VARCHAR(100) | NOT NULL | Movement name |
| `urutan` | SMALLINT UNSIGNED | CHECK(1-13), UNIQUE per kategori | Sequence number |
| `deskripsi` | TEXT | NULL | Movement description |
| `gambar_url` | VARCHAR(255) | NULL | Image path |
| `video_url` | VARCHAR(255) | NULL | Video path (optional) |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Update timestamp |

**Indexes:**
- `idx_kategori_urutan` on (id_kategori, urutan)

**Constraints:**
- `UNIQUE(id_kategori, urutan)` - prevents duplicate sequence numbers
- `CHECK(urutan BETWEEN 1 AND 13)` - validates sequence range

---

### Table: bacaan

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `id` | INT UNSIGNED | PRIMARY KEY, AUTO_INCREMENT | Bacaan ID |
| `id_gerakan` | INT UNSIGNED | FOREIGN KEY → gerakan(id) CASCADE | Movement reference |
| `urutan` | SMALLINT UNSIGNED | CHECK(>=1), UNIQUE per gerakan | Sequence within movement |
| `teks_arab` | TEXT | NULL | Arabic text with diacritics |
| `teks_latin` | TEXT | NULL | Latin transliteration |
| `terjemahan` | TEXT | NULL | Indonesian translation |
| `audio_url` | VARCHAR(255) | NULL | MP3 audio path |
| `sumber` | VARCHAR(150) | NULL | HPT reference source |
| `created_at` | TIMESTAMP | DEFAULT CURRENT_TIMESTAMP | Creation timestamp |
| `updated_at` | TIMESTAMP | ON UPDATE CURRENT_TIMESTAMP | Update timestamp |

**Indexes:**
- `idx_gerakan_urutan` on (id_gerakan, urutan)

**Constraints:**
- `UNIQUE(id_gerakan, urutan)` - prevents duplicate bacaan per movement
- `ON DELETE CASCADE` - deletes bacaan when gerakan is deleted

**Charset:** utf8mb4 (required for Arabic diacritics)

---

## API Development Notes

### CORS Configuration
All API endpoints have CORS enabled:
```php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type");
```

Production deployment should restrict origins to specific domains.

### Database Connection
- Uses PDO with prepared statements (SQL injection protection)
- Connection config in `.env` file (not committed to repo)
- utf8mb4 charset for Arabic text support
- Error mode: PDO::ERRMODE_EXCEPTION

### Security Considerations
- All endpoints use GET method only (read-only API)
- No authentication required (public educational content)
- No rate limiting implemented (consider for production)
- SQL injection prevented via PDO prepared statements
- XSS protection: JSON output is structured data (not HTML)

### Performance
- Database indexes on foreign keys and sort columns
- LEFT JOIN used for autoplay (single query for all data)
- No caching implemented (consider Redis/Memcached for production)
- Response compression not enabled (consider gzip for production)

### Testing
All endpoints tested successfully on 2026-07-09:
- ✓ Health check returns 200
- ✓ Kelompok returns group identity
- ✓ All gerakan endpoints functional
- ✓ Bacaan endpoint returns correct data structure
- ✓ Error responses follow documented format

---

**Documentation Version:** 1.0  
**Backend Version:** 1.0  
**Last Tested:** 2026-07-09  
**Status:** Production Ready (pending seed data completion)

For seed data completion, refer to `database/seed.sql` and replace `[PLACEHOLDER]` markers with actual HPT Muhammadiyah content.

