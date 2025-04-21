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


# === Configuration ===
INSTANCE_ID="quickstart-instance"
CLUSTER_ID="${INSTANCE_ID}-c1"
STORAGE_TYPE="SSD"
TABLE_NAME="my-table"
COLUMN_FAMILY="cf1"

# --- Dynamic Variables ---
PROJECT_ID=$(gcloud config get-value project 2>/dev/null)
# Check if Project ID was found
if [[ -z "$PROJECT_ID" ]]; then
    echo "${RED_TEXT}ERROR: Could not determine Project ID. Run 'gcloud config set project YOUR_PROJECT_ID'${RESET_FORMAT}"
    exit 1 # Exit if project ID is essential
fi

# --- Determine Zone and Region ---
echo "${BLUE_TEXT}Fetching Compute Zone...${RESET_FORMAT}"
ZONE=$(gcloud config get-value compute/zone 2>/dev/null)

# --- Prompt for Zone if Empty ---
if [[ -z "$ZONE" ]]; then
        echo "${YELLOW_TEXT}Warning: Compute zone not found in gcloud config.${RESET_FORMAT}"
        echo
        read -p "${BLUE_TEXT}Please enter the zone: ${RESET_FORMAT}" ZONE
        if [[ -z "$ZONE" ]]; then
                        echo "${RED_TEXT}ERROR: Zone cannot be empty. Exiting.${RESET_FORMAT}"
        fi
        echo "${GREEN_TEXT}Using manually entered zone: ${WHITE_TEXT}${ZONE}${RESET_FORMAT}"
        echo "${BLUE_TEXT}Setting compute/zone in gcloud config...${RESET_FORMAT}"
        gcloud config set compute/zone $ZONE
fi

REGION=${ZONE%-*} # Removes the last '-' and everything after it

# Check if Region derivation worked (basic check)
if [[ -z "$REGION" ]] || [[ "$REGION" == "$ZONE" ]]; then
                echo "${RED_TEXT}ERROR: Could not derive region from zone '${ZONE}'. Please ensure zone is in a standard format (e.g., region-x). Exiting.${RESET_FORMAT}"
fi

echo "${GREEN_TEXT}Using Project:${RESET_FORMAT} ${WHITE_TEXT}${PROJECT_ID}${RESET_FORMAT}, ${GREEN_TEXT}Region:${RESET_FORMAT} ${WHITE_TEXT}${REGION}${RESET_FORMAT}, ${GREEN_TEXT}Zone:${RESET_FORMAT} ${WHITE_TEXT}${ZONE}${RESET_FORMAT}"
echo

# === Task 1: Create Bigtable instance ===
gcloud bigtable instances create ${INSTANCE_ID} --project=${PROJECT_ID} \
        --display-name="${INSTANCE_ID}" \
        --cluster-config="id=${CLUSTER_ID},zone=${ZONE}" \
        --cluster-storage-type=${STORAGE_TYPE}


# === Task 2: Connect to your instance (Configure cbt) ===
echo "${CYAN_TEXT}Task 2: Configuring cbt...${RESET_FORMAT}"
echo project = ${PROJECT_ID} > ~/.cbtrc
echo instance = ${INSTANCE_ID} >> ~/.cbtrc
echo "${GREEN_TEXT}~/.cbtrc configured.${RESET_FORMAT}"
echo

# === Task 3: Read and write data ===

# Attempt to delete table first in case of prior partial run (optional)
cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" deletetable ${TABLE_NAME} || true # Suppress errors if table doesn't exist

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" createtable ${TABLE_NAME}

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" ls

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" createfamily ${TABLE_NAME} ${COLUMN_FAMILY}

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" ls ${TABLE_NAME}

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" set ${TABLE_NAME} r1 ${COLUMN_FAMILY}:c1="test-value"

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" read ${TABLE_NAME}

cbt -project "${PROJECT_ID}" -instance "${INSTANCE_ID}" deletetable ${TABLE_NAME}

echo "${GREEN_TEXT}Table operations completed.${RESET_FORMAT}"

set +e 

echo
echo "${RED_TEXT}${BOLD_TEXT}Subscribe my Channel (Arcade Crew):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Arcade61432${RESET_FORMAT}"
