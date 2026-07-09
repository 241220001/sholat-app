#!/bin/bash

# =============================================================================
# Backend API Test Suite
# Tests all 9 endpoints for sholat-app backend
# Usage: ./test-api.sh [base_url]
# =============================================================================

set -e

# Configuration
BASE_URL="${1:-http://localhost/sholat-app/backend/api}"
FAILED_TESTS=0
PASSED_TESTS=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_test() {
    echo -e "\n${YELLOW}[TEST]${NC} $1"
}

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASSED_TESTS++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAILED_TESTS++))
}

test_endpoint() {
    local name="$1"
    local url="$2"
    local expected_status="$3"
    local expected_pattern="$4"
    
    log_test "$name"
    
    # Make request
    response=$(curl -s -w "\n%{http_code}" "$url")
    body=$(echo "$response" | head -n -1)
    status=$(echo "$response" | tail -n 1)
    
    # Check HTTP status
    if [ "$status" != "$expected_status" ]; then
        log_fail "Expected status $expected_status, got $status"
        echo "Response: $body"
        return 1
    fi
    
    # Check response pattern
    if echo "$body" | grep -q "$expected_pattern"; then
        log_pass "$name - Status $status"
        return 0
    else
        log_fail "Response doesn't match expected pattern"
        echo "Expected pattern: $expected_pattern"
        echo "Response: $body"
        return 1
    fi
}

# Print header
echo "=========================================="
echo "Backend API Test Suite"
echo "=========================================="
echo "Base URL: $BASE_URL"
echo "Time: $(date)"
echo "=========================================="

# Test 1: Health Check
test_endpoint \
    "Health Check" \
    "$BASE_URL/health.php" \
    "200" \
    '"status":"success"'

# Test 2: Kelompok Info
test_endpoint \
    "Kelompok Info" \
    "$BASE_URL/kelompok.php" \
    "200" \
    '"nama_kelompok"'

# Test 3: List Gerakan (Dewasa)
test_endpoint \
    "List Gerakan (Dewasa)" \
    "$BASE_URL/gerakan.php?kategori=dewasa" \
    "200" \
    '"urutan":1'

# Test 4: List Gerakan (Anak)
test_endpoint \
    "List Gerakan (Anak)" \
    "$BASE_URL/gerakan.php?kategori=anak" \
    "200" \
    '"urutan":1'

# Test 5: Detail Gerakan
test_endpoint \
    "Detail Gerakan (ID=1)" \
    "$BASE_URL/gerakan.php?id=1" \
    "200" \
    '"id_kategori"'

# Test 6: Next Gerakan
test_endpoint \
    "Next Gerakan" \
    "$BASE_URL/gerakan.php?next&id_kategori=1&urutan=1" \
    "200" \
    '"urutan":2'

# Test 7: Previous Gerakan
test_endpoint \
    "Previous Gerakan" \
    "$BASE_URL/gerakan.php?prev&id_kategori=1&urutan=2" \
    "200" \
    '"urutan":1'

# Test 8: Total Gerakan
test_endpoint \
    "Total Gerakan" \
    "$BASE_URL/gerakan.php?total&kategori=dewasa" \
    "200" \
    '"total_gerakan":13'

# Test 9: Autoplay Data
test_endpoint \
    "Autoplay Data" \
    "$BASE_URL/gerakan.php?autoplay&kategori=dewasa" \
    "200" \
    '"bacaan"'

# Test 10: Bacaan by Gerakan
test_endpoint \
    "Bacaan for Gerakan 2" \
    "$BASE_URL/bacaan.php?id_gerakan=2" \
    "200" \
    '"teks_arab"'

# Test error handling
echo -e "\n${YELLOW}=========================================="
echo "Error Handling Tests"
echo "==========================================${NC}"

# Test 11: Missing kategori parameter
test_endpoint \
    "Error: Missing kategori" \
    "$BASE_URL/gerakan.php" \
    "400" \
    '"code":"INVALID_KATEGORI"'

# Test 12: Invalid kategori value
test_endpoint \
    "Error: Invalid kategori" \
    "$BASE_URL/gerakan.php?kategori=invalid" \
    "400" \
    '"code":"INVALID_KATEGORI"'

# Test 13: Invalid ID
test_endpoint \
    "Error: Invalid ID" \
    "$BASE_URL/gerakan.php?id=abc" \
    "400" \
    '"code":"INVALID_ID"'

# Test 14: Missing id_gerakan
test_endpoint \
    "Error: Missing id_gerakan" \
    "$BASE_URL/bacaan.php" \
    "400" \
    '"code":"INVALID_ID_GERAKAN"'

# Test 15: No next movement (urutan=13)
test_endpoint \
    "Error: No next gerakan" \
    "$BASE_URL/gerakan.php?next&id_kategori=1&urutan=13" \
    "404" \
    '"code":"NO_NEXT_GERAKAN"'

# Test 16: No previous movement (urutan=1)
test_endpoint \
    "Error: No prev gerakan" \
    "$BASE_URL/gerakan.php?prev&id_kategori=1&urutan=1" \
    "404" \
    '"code":"NO_PREV_GERAKAN"'

# Print summary
echo ""
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASSED_TESTS${NC}"
echo -e "Failed: ${RED}$FAILED_TESTS${NC}"
echo "Total:  $((PASSED_TESTS + FAILED_TESTS))"
echo "=========================================="

# Exit with appropriate code
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed!${NC}"
    exit 1
fi
