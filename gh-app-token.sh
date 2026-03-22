#!/usr/bin/env bash
# gh-app-token.sh
# Usage: ./gh-app-token.sh <pem_path> <app_id> <owner/repo>
set -e

PEM_PATH=$1
APP_ID=$2
REPO=$3

JWT=$(uvx --with pyjwt --with cryptography python3 - << PYEOF
import jwt, time
pem = open("$PEM_PATH").read()
now = int(time.time())
print(jwt.encode({"iat": now - 60, "exp": now + 600, "iss": "$APP_ID"}, pem, algorithm="RS256"))
PYEOF
)

echo "JWT generated, looking up installation..." >&2

INSTALL=$(gh api "/repos/$REPO/installation" \
    --header "Authorization: Bearer $JWT" \
    --header "Accept: application/vnd.github+json")

INSTALL_ID=$(echo "$INSTALL" | jq -r '.id')

if [[ "$INSTALL_ID" == "null" || -z "$INSTALL_ID" ]]; then
    echo "Error: app not installed on $REPO" >&2
    echo "$INSTALL" | jq . >&2
    exit 1
fi

echo "Installation ID: $INSTALL_ID" >&2

gh api "/app/installations/$INSTALL_ID/access_tokens" \
    --method POST \
    --header "Authorization: Bearer $JWT" \
    --header "Accept: application/vnd.github+json" \
    --field "repositories[]=$(echo $REPO | cut -d'/' -f2)" \
    --jq '.token'
