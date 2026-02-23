#!/bin/bash

API_URL="http://localhost:8080"
USERNAME="testuser_$(date +%s)"
EMAIL="${USERNAME}@example.com"
PASSWORD="Password123!"

echo ">>> Registering user..."
REGISTER_RES=$(curl -s -X POST $API_URL/auth/register \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME\", \"email\": \"$EMAIL\", \"password\": \"$PASSWORD\"}")

echo "Response:"
echo $REGISTER_RES | jq .

echo -e "\n>>> Logging in..."
LOGIN_RES=$(curl -s -X POST $API_URL/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"username\": \"$USERNAME\", \"password\": \"$PASSWORD\"}")

echo "Response:"
echo $LOGIN_RES | jq .

ACCESS_TOKEN=$(echo $LOGIN_RES | jq -r .access_token)
REFRESH_TOKEN=$(echo $LOGIN_RES | jq -r .refresh_token)

echo -e "\n>>> Accessing protected profile..."
PROFILE_RES=$(curl -s -X GET $API_URL/api/profile \
  -H "Authorization: Bearer $ACCESS_TOKEN")

echo "Response:"
echo $PROFILE_RES | jq .

echo -e "\n>>> Refreshing token..."
REFRESH_RES=$(curl -s -X POST $API_URL/auth/refresh \
  -H "Content-Type: application/json" \
  -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}")

echo "Response:"
echo $REFRESH_RES | jq .

NEW_ACCESS_TOKEN=$(echo $REFRESH_RES | jq -r .access_token)

echo -e "\n>>> Accessing protected profile with new token..."
PROFILE_RES2=$(curl -s -X GET $API_URL/api/profile \
  -H "Authorization: Bearer $NEW_ACCESS_TOKEN")

echo "Response:"
echo $PROFILE_RES2 | jq .

echo -e "\n>>> Logging out..."
LOGOUT_RES=$(curl -s -i -X POST $API_URL/auth/logout \
  -H "Content-Type: application/json" \
  -d "{\"refresh_token\": \"$REFRESH_TOKEN\"}")

echo "Response headers/body:"
echo "$LOGOUT_RES"
