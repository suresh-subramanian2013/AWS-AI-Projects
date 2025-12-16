#!/bin/bash

# IT Support Chatbot - Test Script
# This script tests the deployed chatbot API with various queries

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if API endpoint is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: API endpoint URL required${NC}"
    echo "Usage: ./test-chatbot.sh <API_ENDPOINT_URL>"
    echo "Example: ./test-chatbot.sh https://abc123.execute-api.us-east-1.amazonaws.com/dev/chat"
    exit 1
fi

API_ENDPOINT="$1"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}IT Support Chatbot - API Testing${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""
echo -e "API Endpoint: ${GREEN}${API_ENDPOINT}${NC}"
echo ""

# Function to test a query
test_query() {
    local query="$1"
    local description="$2"
    
    echo -e "${BLUE}Test: ${description}${NC}"
    echo -e "Query: ${query}"
    echo ""
    
    response=$(curl -s -X POST "${API_ENDPOINT}" \
        -H "Content-Type: application/json" \
        -d "{\"query\": \"${query}\"}")
    
    # Check if response is valid JSON
    if echo "$response" | jq empty 2>/dev/null; then
        echo -e "${GREEN}✓ Response received${NC}"
        echo "$response" | jq -r '.response' | head -c 500
        echo ""
        echo "..."
        echo ""
    else
        echo -e "${RED}✗ Invalid response${NC}"
        echo "$response"
        echo ""
    fi
    
    echo "----------------------------------------"
    echo ""
}

# Test 1: Password Reset
test_query "How do I reset my password?" "Password Reset Query"

# Test 2: AWS Troubleshooting
test_query "My EC2 instance won't start. What should I do?" "AWS EC2 Troubleshooting"

# Test 3: Onboarding
test_query "I'm a new employee. How do I get access to AWS?" "New Employee Onboarding"

# Test 4: S3 Access Issue
test_query "I'm getting an Access Denied error when trying to access S3. How can I fix this?" "S3 Access Troubleshooting"

# Test 5: Password Policy
test_query "What are the password requirements?" "Password Policy Query"

# Test 6: Lambda Troubleshooting
test_query "My Lambda function is timing out. What could be the issue?" "Lambda Timeout Issue"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}Testing Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
