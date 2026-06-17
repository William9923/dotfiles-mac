---
name: exa-search
description: Web search and content extraction via the Exa API. Use for searching documentation, finding code examples, reading articles, or fetching page content.
---

# Exa Search

Web search and content extraction using the [Exa API](https://exa.ai). Requires no browser — just the API key set as `EXA_API_KEY` in your environment.

## Setup

The `EXA_API_KEY` is exported from `~/.zsh_secrets` (see `zsh/.zsh_secrets.example`). No additional setup needed.

Requires `curl` and `jq` (both available on your system).

## Search

```bash
{baseDir}/search.sh "query"                        # Basic search (5 results)
{baseDir}/search.sh "query" -n 10                  # More results (max 20)
{baseDir}/search.sh "query" --content              # Include full text content
{baseDir}/search.sh "query" --url-only             # Just URLs and titles
{baseDir}/search.sh "query" --type deep            # Deep search (slower, more thorough)
{baseDir}/search.sh "query" --type fast            # Fast search (faster, less depth)
```

### Options

- `-n <num>` — Number of results (default: 5, max: 20)
- `--content` — Include full page text (up to 3000 chars per result)
- `--url-only` — Show only URLs and titles, skip content
- `--type <type>` — Search type: `auto` (default), `fast`, `instant`, `deep`, `deep-lite`

## Extract Page Content

```bash
{baseDir}/search.sh --content https://example.com/article
```

Fetches a URL and returns the parsed text content (up to 5000 chars). Great for reading documentation, articles, or API references.

## Output Format

```
--- Result 1 ---
Title: Page Title
Link: https://example.com/page
Highlights:
  Relevant excerpt from the page...

--- Result 2 ---
Title: Another Page
Link: https://example.com/other
Highlights:
  Another relevant excerpt...
```

With `--content`, each result also includes full text:

```
Text:
  Full page text starting here...
```

## When to Use

- Searching for documentation or API references
- Looking up facts or current information
- Fetching content from specific URLs
- Finding code examples or tutorials
- Any task requiring web search without interactive browsing

## Notes

- Exa provides query-relevant highlights by default (token-efficient)
- Use `--content` when you need broader context from a page
- Use `--url-only` when you only need to discover relevant pages
- Deep search (`--type deep`) is better for complex queries but takes longer (4-15s)
