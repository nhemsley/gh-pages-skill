# GitHub App Setup for Claude Deploy

One-time setup to allow Claude to push to GitHub repos using ephemeral 1hr tokens. No long-lived credentials.

## 1. Create the GitHub App

Go to: `github.com/settings/apps/new`

Fill in:
- **GitHub App name**: `claude-deploy` (or anything)
- **Homepage URL**: `https://github.com` (placeholder is fine)
- **Webhook**: uncheck **Active**

Under **Permissions → Repository permissions**:
- **Contents**: Read & write

Under **Where can this GitHub App be installed**:
- `Only on this account`

Click **Create GitHub App**.

Note your **App ID** at the top of the App page.

## 2. Generate a Private Key

On the App page, scroll to **Private keys** → **Generate a private key**.

A `.pem` file downloads. Keep it somewhere safe (e.g. `~/.config/claude-deploy/private-key.pem`).

## 3. Install the App on a Repo

On the App page: **Install App** → your org/account → **Only select repositories** → pick the target repo → **Install**.

Repeat this step for each repo you want Claude to be able to push to.

## 4. Get a Token (per session)

Run `gh-app-token.sh` locally:

```sh
./gh-app-token.sh ~/.config/claude-deploy/private-key.pem <APP_ID> <owner/repo>
```

Paste the token into Claude. Claude pushes via:
```
https://x-access-token:<TOKEN>@github.com/<owner>/<repo>.git
```

Token expires in 1 hour.

## 5. Files

- `gh-app-token.sh` — generates the token (requires `uvx`, `gh`, `jq`)
- `SKILL.md` — Claude skill that uses the token to push

## Troubleshooting

| Error | Cause | Fix |
|-------|-------|-----|
| `404 Not Found` on installation lookup | App not installed on repo | Step 3 above |
| `422 Validation Failed` on deploy key | Malformed public key format | Use `Encoding.OpenSSH` not `Encoding.Raw` |
| `403 Forbidden` from proxy | Container can't reach `api.github.com` | Run token script locally, paste token |
| JWT errors | Clock skew or wrong App ID | Check App ID, `iat` uses `now - 60` buffer |
