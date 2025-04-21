#!/bin/bash
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'
clear


# === Task 2: Connect to your instance (Configure cbt) ===
echo "${CYAN_TEXT}Task 2: Configuring cbt...${RESET_FORMAT}"
echo project = ${PROJECT_ID} > ~/.cbtrc
echo instance = ${INSTANCE_ID} >> ~/.cbtrc
echo "${GREEN_TEXT}~/.cbtrc configured.${RESET_FORMAT}"
echo

# === Task 3: Read and write data ===
echo "${CYAN_TEXT}Task 3: Working with table '${TABLE_NAME}'...${RESET_FORMAT}"

# Attempt to delete table first in case of prior partial run (optional)
echo "${BLUE_TEXT}Attempting to delete table '${TABLE_NAME}' if it exists (ignore errors if not found)...${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" deletetable ${TABLE_NAME} || true # Suppress errors if table doesn't exist

echo "${BLUE_TEXT}Creating table '${TABLE_NAME}'...${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" createtable ${TABLE_NAME}

echo "${BLUE_TEXT}Listing tables:${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" ls

echo "${BLUE_TEXT}Creating column family '${COLUMN_FAMILY}'...${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" createfamily ${TABLE_NAME} ${COLUMN_FAMILY}

echo "${BLUE_TEXT}Listing column families:${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" ls ${TABLE_NAME}

echo "${BLUE_TEXT}Writing data to '${TABLE_NAME}'...${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" set ${TABLE_NAME} r1 ${COLUMN_FAMILY}:c1="test-value"

echo "${BLUE_TEXT}Reading data from '${TABLE_NAME}':${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" read ${TABLE_NAME}

echo "${BLUE_TEXT}Deleting table '${TABLE_NAME}'...${RESET_FORMAT}"
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" deletetable ${TABLE_NAME}

echo "${GREEN_TEXT}Table operations completed.${RESET_FORMAT}"

set +e 
