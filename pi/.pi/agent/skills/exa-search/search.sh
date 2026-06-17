#!/usr/bin/env bash
set -euo pipefail

# Exa search + content extraction
# Usage:
#   search.sh "query"                  # Search with highlights (default 5 results)
#   search.sh "query" -n 10            # More results
#   search.sh "query" --content        # Include full page text
#   search.sh "query" --url-only       # Just URLs, no content
#   search.sh --content <url>          # Extract content from a URL

API_KEY="${EXA_API_KEY:?EXA_API_KEY not set}"

if [ $# -eq 0 ]; then
    echo "Usage: $0 <query> [options]"
    echo "  -n <num>      Number of results (default: 5, max: 20)"
    echo "  --content     Include full text content (up to 3000 chars per result)"
    echo "  --url-only    Only show URLs, no content"
    echo "  --type <t>    Search type: auto, fast, instant, deep (default: auto)"
    echo ""
    echo "  $0 --content <url>    Extract content from a specific URL"
    exit 1
fi

# Content extraction mode
if [ "$1" = "--content" ]; then
    URL="$2"
    curl -s -X POST 'https://api.exa.ai/contents' \
        -H "x-api-key: $API_KEY" \
        -H 'Content-Type: application/json' \
        -d "{\"urls\": [\"$URL\"], \"text\": {\"maxCharacters\": 5000}}" |
    jq -r '.results[0] | "URL: \(.url)\n---\n\(.text)"'
    exit 0
fi

# Parse arguments
QUERY="$1"
shift
NUM_RESULTS=5
INCLUDE_CONTENT=false
URL_ONLY=false
SEARCH_TYPE="auto"

while [ $# -gt 0 ]; do
    case "$1" in
        -n) NUM_RESULTS="$2"; shift 2 ;;
        --content) INCLUDE_CONTENT=true; shift ;;
        --url-only) URL_ONLY=true; shift ;;
        --type) SEARCH_TYPE="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

# Build request body
if [ "$INCLUDE_CONTENT" = true ]; then
    BODY="{\"query\": $(echo "$QUERY" | jq -Rs .), \"type\": \"$SEARCH_TYPE\", \"numResults\": $NUM_RESULTS, \"contents\": {\"highlights\": true, \"text\": {\"maxCharacters\": 3000}}}"
elif [ "$URL_ONLY" = true ]; then
    BODY="{\"query\": $(echo "$QUERY" | jq -Rs .), \"type\": \"$SEARCH_TYPE\", \"numResults\": $NUM_RESULTS}"
else
    BODY="{\"query\": $(echo "$QUERY" | jq -Rs .), \"type\": \"$SEARCH_TYPE\", \"numResults\": $NUM_RESULTS, \"contents\": {\"highlights\": true}}"
fi

# Execute search
RESPONSE=$(curl -s -X POST 'https://api.exa.ai/search' \
    -H "x-api-key: $API_KEY" \
    -H 'Content-Type: application/json' \
    -d "$BODY")

# Check for errors
ERROR=$(echo "$RESPONSE" | jq -r '.error // empty')
if [ -n "$ERROR" ]; then
    echo "Error: $ERROR"
    exit 1
fi

# Display results - simpler approach
echo "$RESPONSE" | jq -r '.results[] | "---", "Title: \(.title // "Untitled")", "Link: \(.url)", "", (.highlights // [] | .[]), "", (.text // "")'
