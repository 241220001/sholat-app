/**
 * autoplay.js
 * Handles autoplay functionality for sequential gerakan playback (F-06)
 * - Toggle autoplay on/off
 * - Auto-play audio when page loads (if autoplay is enabled)
 * - Auto-advance to next gerakan when audio ends
 * - Stop automatically at gerakan 13
 * - Visual indicator when autoplay is active
 */
// TOTAL_GERAKAN, getCurrentGerakanId(), getStoredMode() dipakai dari navigation.js
// navigation.js WAJIB di-load SEBELUM autoplay.js di HTML

const AUTOPLAY_STORAGE_KEY = "autoplayEnabled";

function isAutoplayEnabled() {
    return sessionStorage.getItem(AUTOPLAY_STORAGE_KEY) === "true";
}

function setAutoplayEnabled(enabled) {
    sessionStorage.setItem(AUTOPLAY_STORAGE_KEY, String(enabled));
}

function navigateToNextGerakan(currentId) {
    if (currentId >= TOTAL_GERAKAN) {
        setAutoplayEnabled(false);
        return;
    }

    const mode = getStoredMode();
    const nextId = currentId + 1;
    window.location.href = `detail-gerakan.html?id=${nextId}&kategori=${mode}`;
}

function updateAutoplayUI(toggleButton, badge, enabled) {
    if (toggleButton) {
        toggleButton.classList.toggle("is-active", enabled);
        toggleButton.setAttribute("aria-pressed", String(enabled));
        toggleButton.setAttribute("aria-label", enabled ? "Matikan autoplay" : "Aktifkan autoplay");
        
        const toggleText = toggleButton.querySelector(".autoplay-toggle-text");
        if (toggleText) {
            toggleText.textContent = enabled ? "Autoplay Aktif" : "Autoplay";
        }
    }

    if (badge) {
        badge.classList.toggle("is-autoplay-active", enabled);
        
        if (enabled) {
            badge.setAttribute("aria-label", "Autoplay sedang berjalan");
        } else {
            badge.removeAttribute("aria-label");
        }
    }
}

function setupAutoplayListeners(audioElement, currentId) {
    if (!audioElement) {
        return;
    }
    setupAudioAutoplay(audioElement, currentId);
    setupAudioEndedListener(audioElement, currentId);
}

function setupAudioAutoplay(audioElement, currentId) {
    if (!audioElement || !isAutoplayEnabled()) {
        return;
    }

    const playPromise = audioElement.play();

    if (playPromise !== undefined) {
        playPromise
            .then(() => {
                console.log("Autoplay audio started");
            })
            .catch((error) => {
                console.warn("Autoplay prevented by browser:", error);
                
                const notification = document.getElementById("autoplayNotification");
                if (notification) {
                    notification.textContent = "Klik di mana saja untuk memulai autoplay";
                    notification.classList.add("is-visible");

                    const startAutoplay = () => {
                        audioElement.play();
                        notification.classList.remove("is-visible");
                        document.removeEventListener("click", startAutoplay);
                    };

                    document.addEventListener("click", startAutoplay, { once: true });
                }
            });
    }
}

function setupAudioEndedListener(audioElement, currentId) {
    if (!audioElement) {
        return;
    }

    audioElement.addEventListener("ended", () => {
        if (!isAutoplayEnabled()) {
            return;
        }

        if (currentId >= TOTAL_GERAKAN) {
            setAutoplayEnabled(false);
            
            const notification = document.getElementById("autoplayNotification");
            if (notification) {
                notification.textContent = "Autoplay selesai - Anda telah menyelesaikan semua gerakan";
                notification.classList.add("is-visible");
                
                setTimeout(() => {
                    notification.classList.remove("is-visible");
                }, 4000);
            }
            
            return;
        }

        const delay = 800;
        setTimeout(() => {
            navigateToNextGerakan(currentId);
        }, delay);
    });
}

function initAutoplay() {
    const toggleButton = document.getElementById("autoplayToggle");
    const badge = document.getElementById("activeModeBadge") || document.querySelector(".active-mode-badge");
    const audioElement = document.getElementById("bacaanAudio") || document.querySelector("audio");
    const currentId = getCurrentGerakanId();

    const enabled = isAutoplayEnabled();
    updateAutoplayUI(toggleButton, badge, enabled);

    if (toggleButton) {
        toggleButton.addEventListener("click", () => {
            const newEnabled = !isAutoplayEnabled();
            setAutoplayEnabled(newEnabled);
            updateAutoplayUI(toggleButton, badge, newEnabled);

            const audio = document.getElementById("bacaanAudio") || document.querySelector("audio");
            if (newEnabled && audio && audio.paused) {
                audio.play();
            } else if (!newEnabled && audio && !audio.paused) {
                audio.pause();
            }
        });
    }

    if (audioElement) {
        setupAudioAutoplay(audioElement, currentId);
        setupAudioEndedListener(audioElement, currentId);
    }

    const params = new URLSearchParams(window.location.search);
    if (params.get("autoplay") === "true") {
        setAutoplayEnabled(true);
        updateAutoplayUI(toggleButton, badge, true);
    }
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initAutoplay);
} else {
    initAutoplay();
}
