#!/bin/bash

# =============================================================================
# Database Setup Script for Tuntunan Sholat App
# Automates MySQL database creation, schema import, and data seeding
# Usage: ./setup-db.sh [mysql_user] [mysql_password]
# =============================================================================

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
MYSQL_USER="${1:-root}"
MYSQL_PASS="${2:-}"
DB_NAME="tuntunan_sholat"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCHEMA_FILE="$SCRIPT_DIR/database/schema.sql"
SEED_FILE="$SCRIPT_DIR/database/seed.sql"

# Print header
echo -e "${BLUE}=========================================="
echo "Database Setup Script"
echo "==========================================${NC}"
echo "Database: $DB_NAME"
echo "User: $MYSQL_USER"
echo "Time: $(date)"
echo "=========================================="
echo ""

# Check if MySQL is accessible
echo -e "${YELLOW}[1/5] Checking MySQL connection...${NC}"
if mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" -e "SELECT 1" >/dev/null 2>&1; then
    echo -e "${GREEN}✓ MySQL connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to MySQL${NC}"
    echo "Please check:"
    echo "  - MySQL service is running"
    echo "  - Username and password are correct"
    echo "  - Run: ./setup-db.sh [username] [password]"
    exit 1
fi

# Check if database files exist
echo -e "\n${YELLOW}[2/5] Checking database files...${NC}"
if [ ! -f "$SCHEMA_FILE" ]; then
    echo -e "${RED}✗ Schema file not found: $SCHEMA_FILE${NC}"
    exit 1
fi
if [ ! -f "$SEED_FILE" ]; then
    echo -e "${RED}✗ Seed file not found: $SEED_FILE${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Database files found${NC}"

# Create database
echo -e "\n${YELLOW}[3/5] Creating database...${NC}"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" <<EOF
DROP DATABASE IF EXISTS $DB_NAME;
CREATE DATABASE $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
EOF

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Database '$DB_NAME' created${NC}"
else
    echo -e "${RED}✗ Failed to create database${NC}"
    exit 1
fi

# Import schema
echo -e "\n${YELLOW}[4/5] Importing schema...${NC}"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" < "$SCHEMA_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Schema imported successfully${NC}"
    
    # Show tables
    echo -e "\nTables created:"
    mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" -e "SHOW TABLES;" | tail -n +2 | sed 's/^/  - /'
else
    echo -e "${RED}✗ Failed to import schema${NC}"
    exit 1
fi

# Import seed data
echo -e "\n${YELLOW}[5/5] Importing seed data...${NC}"
mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" < "$SEED_FILE"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Seed data imported successfully${NC}"
    
    # Show record counts
    echo -e "\nRecord counts:"
    mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" <<SQL | tail -n +2
SELECT 'kategori' as 'Table', COUNT(*) as 'Rows' FROM kategori
UNION ALL SELECT 'kelompok', COUNT(*) FROM kelompok
UNION ALL SELECT 'gerakan', COUNT(*) FROM gerakan
UNION ALL SELECT 'bacaan', COUNT(*) FROM bacaan;
SQL
else
    echo -e "${RED}✗ Failed to import seed data${NC}"
    exit 1
fi

# Verify setup
echo -e "\n${YELLOW}Verifying setup...${NC}"
GERAKAN_COUNT=$(mysql -u"$MYSQL_USER" -p"$MYSQL_PASS" "$DB_NAME" -N -e "SELECT COUNT(*) FROM gerakan WHERE id_kategori=1")

if [ "$GERAKAN_COUNT" -eq 13 ]; then
    echo -e "${GREEN}✓ Setup verified (13 gerakan for dewasa mode)${NC}"
else
    echo -e "${YELLOW}⚠ Warning: Expected 13 gerakan, found $GERAKAN_COUNT${NC}"
fi

# Update .env file if it exists
echo -e "\n${YELLOW}Checking .env configuration...${NC}"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
    # Check if DB_NAME matches
    if grep -q "DB_NAME=$DB_NAME" "$ENV_FILE"; then
        echo -e "${GREEN}✓ .env file already configured correctly${NC}"
    else
        echo -e "${YELLOW}⚠ .env DB_NAME doesn't match $DB_NAME${NC}"
        echo "  Please update .env file manually"
    fi
else
    echo -e "${YELLOW}⚠ .env file not found${NC}"
    echo "  Creating from .env.example..."
    
    if [ -f "$SCRIPT_DIR/.env.example" ]; then
        cp "$SCRIPT_DIR/.env.example" "$ENV_FILE"
        
        # Update DB_NAME in .env
        if [[ "$OSTYPE" == "darwin"* ]]; then
            # macOS
            sed -i '' "s/DB_NAME=.*/DB_NAME=$DB_NAME/" "$ENV_FILE"
        else
            # Linux
            sed -i "s/DB_NAME=.*/DB_NAME=$DB_NAME/" "$ENV_FILE"
        fi
        
        echo -e "${GREEN}✓ .env file created${NC}"
        echo "  Please review and update DB_USER and DB_PASS if needed"
    else
        echo -e "${RED}✗ .env.example not found${NC}"
        echo "  Please create .env manually"
    fi
fi

# Print success summary
echo ""
echo -e "${GREEN}=========================================="
echo "✓ Database Setup Complete!"
echo "==========================================${NC}"
echo ""
echo "Next steps:"
echo "  1. Start your web server (Apache/Nginx)"
echo "  2. Test API: curl http://localhost/sholat-app/backend/api/health.php"
echo "  3. Open frontend: http://localhost/sholat-app/"
echo ""
echo "Database credentials:"
echo "  Host: localhost"
echo "  Database: $DB_NAME"
echo "  User: $MYSQL_USER"
echo "  Charset: utf8mb4"
echo ""

exit 0
