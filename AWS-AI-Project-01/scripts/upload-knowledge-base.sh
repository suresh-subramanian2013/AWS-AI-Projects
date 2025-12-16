#!/bin/bash

# Upload Knowledge Base Documents to S3
# This script uploads all knowledge base markdown files to the S3 bucket

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if bucket name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: S3 bucket name required${NC}"
    echo "Usage: ./upload-knowledge-base.sh <S3_BUCKET_NAME>"
    echo "Example: ./upload-knowledge-base.sh it-support-chatbot-knowledge-base-123456789"
    exit 1
fi

BUCKET_NAME="$1"
KNOWLEDGE_BASE_DIR="../knowledge-base"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Uploading Knowledge Base to S3${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "Bucket: ${GREEN}${BUCKET_NAME}${NC}"
echo -e "Source: ${GREEN}${KNOWLEDGE_BASE_DIR}${NC}"
echo ""

# Check if knowledge base directory exists
if [ ! -d "$KNOWLEDGE_BASE_DIR" ]; then
    echo -e "${RED}Error: Knowledge base directory not found: ${KNOWLEDGE_BASE_DIR}${NC}"
    exit 1
fi

# Upload each markdown file
for file in "$KNOWLEDGE_BASE_DIR"/*.md; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        echo -e "${BLUE}Uploading: ${filename}${NC}"
        
        aws s3 cp "$file" "s3://${BUCKET_NAME}/${filename}" \
            --content-type "text/markdown" \
            --metadata "uploaded-by=script,upload-date=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✓ Successfully uploaded ${filename}${NC}"
        else
            echo -e "${RED}✗ Failed to upload ${filename}${NC}"
            exit 1
        fi
        echo ""
    fi
done

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}All files uploaded successfully!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Verify uploads:"
echo "aws s3 ls s3://${BUCKET_NAME}/"
