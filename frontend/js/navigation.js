/**
 * navigation.js
 * Handles Next/Previous navigation between gerakan detail pages (F-05)
 * - Reads current gerakan ID from URL
 * - Navigates to next/previous gerakan
 * - Disables buttons at boundaries (gerakan 1 and 13)
 * - Preserves mode (dewasa/anak) across navigation
 */

const TOTAL_GERAKAN = 13;

function getCurrentGerakanId() {
    const params = new URLSearchParams(window.location.search);
    const id = parseInt(params.get("id"), 10);
    return !isNaN(id) && id >= 1 && id <= TOTAL_GERAKAN ? id : 1;
}

function getStoredMode() {
    return sessionStorage.getItem("modeTampilan") || localStorage.getItem("modeTampilan") || "dewasa";
}

function navigateToGerakan(gerakanId) {
    const mode = getStoredMode();
    const targetId = Math.max(1, Math.min(TOTAL_GERAKAN, gerakanId));
    window.location.href = `detail-gerakan.html?id=${targetId}&kategori=${mode}`;
}

function updateNavigationButtons(currentId, prevButton, nextButton) {
    if (!prevButton || !nextButton) {
        return;
    }

    const isFirst = currentId === 1;
    const isLast = currentId === TOTAL_GERAKAN;

    prevButton.disabled = isFirst;
    prevButton.classList.toggle("is-disabled", isFirst);
    prevButton.setAttribute("aria-disabled", String(isFirst));

    if (isFirst) {
        prevButton.setAttribute("aria-label", "Gerakan sebelumnya (tidak tersedia)");
    } else {
        prevButton.setAttribute("aria-label", `Ke gerakan ${currentId - 1}`);
    }

    nextButton.disabled = isLast;
    nextButton.classList.toggle("is-disabled", isLast);
    nextButton.setAttribute("aria-disabled", String(isLast));

    if (isLast) {
        nextButton.setAttribute("aria-label", "Gerakan berikutnya (tidak tersedia)");
    } else {
        nextButton.setAttribute("aria-label", `Ke gerakan ${currentId + 1}`);
    }
}

function setupKeyboardNavigation(currentId) {
    document.addEventListener("keydown", (event) => {
        if (event.target.tagName === "INPUT" || event.target.tagName === "TEXTAREA") {
            return;
        }

        if (event.key === "ArrowLeft" && currentId > 1) {
            event.preventDefault();
            navigateToGerakan(currentId - 1);
        } else if (event.key === "ArrowRight" && currentId < TOTAL_GERAKAN) {
            event.preventDefault();
            navigateToGerakan(currentId + 1);
        }
    });
}

function initNavigation() {
    const prevButton = document.getElementById("prevGerakan");
    const nextButton = document.getElementById("nextGerakan");

    if (!prevButton && !nextButton) {
        return;
    }

    const currentId = getCurrentGerakanId();

    updateNavigationButtons(currentId, prevButton, nextButton);

    if (prevButton) {
        prevButton.addEventListener("click", () => {
            if (currentId > 1) {
                navigateToGerakan(currentId - 1);
            }
        });
    }

    if (nextButton) {
        nextButton.addEventListener("click", () => {
            if (currentId < TOTAL_GERAKAN) {
                navigateToGerakan(currentId + 1);
            }
        });
    }

    setupKeyboardNavigation(currentId);
}

if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initNavigation);
} else {
    initNavigation();
}
