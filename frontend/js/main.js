const modeButtons = document.querySelectorAll("[data-mode]");
const startLearning = document.getElementById("startLearning");
const activeModeBadge = document.getElementById("activeModeBadge");
const movementGrid = document.getElementById("movementGrid");
const groupFields = {
    nama_kelompok: document.getElementById("groupName"),
    prodi: document.getElementById("groupProgram"),
    mata_kuliah: document.getElementById("groupCourse"),
    dosen: document.getElementById("groupLecturer"),
};

// MOCK DATA - ganti ke fetch() asli setelah backend/api/gerakan.php selesai
const mockGerakan = [
{ id: 1, nama: "Qiyam", urutan: 1, deskripsi: "Berdiri tegak menghadap kiblat sebelum memulai sholat.", gambar_url: "/assets/img/Qiyam (Dewasa).jpeg", video_url: null },
    { id: 2, nama: "Takbiratul Ihram", urutan: 2, deskripsi: "Mengangkat kedua tangan dan membaca takbir pembuka sholat.", gambar_url: "/assets/img/Takbiratul ihram (Dewasa).jpeg", video_url: null },
    { id: 3, nama: "Bersedekap", urutan: 3, deskripsi: "Meletakkan tangan kanan di atas tangan kiri saat berdiri.", gambar_url: "/assets/img/Qiyam (Dewasa).jpeg", video_url: null },
    { id: 4, nama: "Berdiri Baca Al-Fatihah", urutan: 4, deskripsi: "Membaca Al-Fatihah dan bacaan sholat saat berdiri.", gambar_url: "/assets/img/Qiyam (Dewasa).jpeg", video_url: null },
    { id: 5, nama: "Rukuk", urutan: 5, deskripsi: "Membungkukkan badan dengan punggung rata dan tumakninah.", gambar_url: "/assets/img/Ruku' (Dewasa).jpeg", video_url: null },
    { id: 6, nama: "I'tidal", urutan: 6, deskripsi: "Bangkit dari rukuk hingga berdiri tegak kembali.", gambar_url: "/assets/img/I'tidal (Dewasa).jpeg", video_url: null },
    { id: 7, nama: "Sujud Pertama", urutan: 7, deskripsi: "Sujud pertama dengan tujuh anggota sujud menempel tempat sujud.", gambar_url: "/assets/img/Sujud (Dewasa).jpeg", video_url: null },
    { id: 8, nama: "Duduk Antara Dua Sujud", urutan: 8, deskripsi: "Duduk iftirasy sejenak di antara dua sujud.", gambar_url: "/assets/img/Tahiyat (Dewasa).jpeg", video_url: null },
    { id: 9, nama: "Sujud Kedua", urutan: 9, deskripsi: "Sujud kedua dengan tumakninah sebelum bangkit.", gambar_url: "/assets/img/Sujud (Dewasa).jpeg", video_url: null },
    { id: 10, nama: "Berdiri Rakaat Berikutnya", urutan: 10, deskripsi: "Bangkit berdiri untuk melanjutkan rakaat berikutnya.", gambar_url: "/assets/img/Qiyam (Dewasa).jpeg", video_url: null },
    { id: 11, nama: "Tasyahud Awal", urutan: 11, deskripsi: "Duduk membaca tasyahud awal pada rakaat kedua.", gambar_url: "/assets/img/Tahiyat (Dewasa).jpeg", video_url: null },
    { id: 12, nama: "Tasyahud Akhir", urutan: 12, deskripsi: "Duduk akhir sebelum menutup sholat dengan salam.", gambar_url: "/assets/img/Tahiyat (Dewasa).jpeg", video_url: null },
    { id: 13, nama: "Salam", urutan: 13, deskripsi: "Menoleh ke kanan dan kiri untuk mengakhiri sholat.", gambar_url: "/assets/img/Salam kiri (Dewasa).jpeg", video_url: null },
];

function getStoredMode() {
    const params = new URLSearchParams(window.location.search);
    const queryMode = params.get("kategori");
    const storedMode = sessionStorage.getItem("modeTampilan") || localStorage.getItem("modeTampilan");
    return queryMode === "anak" || storedMode === "anak" ? "anak" : "dewasa";
}

function setMode(mode) {
    const selectedMode = mode === "anak" ? "anak" : "dewasa";

    modeButtons.forEach((button) => {
        const isActive = button.dataset.mode === selectedMode;
        button.classList.toggle("is-active", isActive);
        button.setAttribute("aria-pressed", String(isActive));
        button.setAttribute("aria-label", isActive ? `Mode ${button.textContent} aktif` : `Ganti ke mode ${button.textContent}`);
    });

    if (startLearning) {
        startLearning.href = `daftar-gerakan.html?kategori=${selectedMode}`;
    }

    if (activeModeBadge) {
        activeModeBadge.classList.add("is-changing");
        window.setTimeout(() => {
            activeModeBadge.textContent = selectedMode === "anak" ? "Mode Anak" : "Mode Dewasa";
            activeModeBadge.classList.remove("is-changing");
        }, 120);
    }

    sessionStorage.setItem("modeTampilan", selectedMode);
}

async function loadGroupIdentity() {
    try {
        const response = await fetch("/backend/api/kelompok.php");
        const payload = await response.json();

        if (payload.status !== "success" || !payload.data) {
            return;
        }

        Object.entries(groupFields).forEach(([key, element]) => {
            if (element && payload.data[key]) {
                element.textContent = payload.data[key];
            }
        });
    } catch (error) {
        return;
    }
}

function renderSkeleton() {
    if (!movementGrid) {
        return;
    }

    movementGrid.innerHTML = Array.from({ length: 13 }, () => `
        <article class="skeleton-card" aria-hidden="true">
            <div class="skeleton-layout">
                <div class="skeleton-thumb"></div>
                <div class="skeleton-content">
                    <div class="skeleton-line short"></div>
                    <div class="skeleton-line medium"></div>
                    <div class="skeleton-line"></div>
                </div>
            </div>
        </article>
    `).join("");
}

function renderState(title, message, icon = "□") {
    if (!movementGrid) {
        return;
    }

    movementGrid.innerHTML = `
        <div class="movement-state" role="status">
            <div>
                <div class="movement-state-icon" aria-hidden="true">${icon}</div>
                <strong>${title}</strong>
                <span>${message}</span>
            </div>
        </div>
    `;
}

function renderMovements(items) {
    if (!movementGrid) {
        return;
    }

    if (!items.length) {
        renderState("Data gerakan belum tersedia", "Silakan coba lagi setelah data gerakan tersedia dari API.");
        return;
    }

    movementGrid.innerHTML = items
        .sort((first, second) => first.urutan - second.urutan)
        .map((item) => `
            <a class="movement-card" href="detail-gerakan.html?id=${encodeURIComponent(item.id)}" aria-label="Gerakan ${item.urutan}: ${item.nama}, buka detail">
                <img class="movement-thumb" src="${item.gambar_url}" alt="Thumbnail gerakan ${item.nama}">
                <span class="movement-card-body">
                    <span class="movement-order">${String(item.urutan).padStart(2, "0")}</span>
                    <span class="movement-name">${item.nama}</span>
                    <span class="movement-description">${item.deskripsi}</span>
                </span>
                <span class="movement-chevron" aria-hidden="true">›</span>
            </a>
        `).join("");
}

async function fetchMovements(mode) {
    try {
        const response = await fetch(`/backend/api/gerakan.php?kategori=${encodeURIComponent(mode)}`);
        const payload = await response.json();

        if (!response.ok || payload.status !== "success" || !Array.isArray(payload.data)) {
            throw new Error(payload.message || "Response API gerakan tidak valid.");
        }

        return payload.data;
    } catch (error) {
        if (mockGerakan.length) {
            return mockGerakan;
        }

        throw error;
    }
}

async function loadMovements(mode) {
    if (!movementGrid) {
        return;
    }

    movementGrid.classList.add("is-changing");
    renderSkeleton();

    try {
        const items = await fetchMovements(mode);
        window.setTimeout(() => {
            renderMovements(items);
            movementGrid.classList.remove("is-changing");
        }, 200);
    } catch (error) {
        renderState("Gagal memuat gerakan", "Periksa koneksi atau coba muat ulang halaman.", "!");
        movementGrid.classList.remove("is-changing");
    }
}

modeButtons.forEach((button) => {
    button.addEventListener("click", () => {
        setMode(button.dataset.mode);
        loadMovements(button.dataset.mode);
    });
});

const initialMode = getStoredMode();
setMode(initialMode);
loadGroupIdentity();
loadMovements(initialMode);
