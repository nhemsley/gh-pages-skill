# gh-pages-skill

Claude skill for pushing files to GitHub Pages using ephemeral GitHub App tokens.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/nhemsley/gh-pages-skill/main/gh-app-token.sh \
  -o ~/.local/bin/gh-app-token && chmod +x ~/.local/bin/gh-app-token
```

## Usage

```sh
gh-app-token ~/.config/claude-deploy/private-key.pem <APP_ID> <owner/repo>
```

Paste the token into Claude. Done.

## Setup

See [docs/github-app-setup.md](docs/github-app-setup.md) for one-time GitHub App configuration.

## Using with a GitHub Organization

A few gotchas that will bite you:

**Installing the App on an org**
The GitHub App must be explicitly installed on each org. From the App page:
`github.com/settings/apps/<app-name>/installations` → Install → select the org.

If the org doesn't appear, you may not be an owner. Check:
`github.com/orgs/<org>/people`

**Transferring repos to an org**
`gh repo transfer` requires you to be an admin of the target org *and* the repo. If it fails, just recreate:
```sh
gh repo create <org>/<repo> --public
```
Then push fresh — it's usually less friction than fighting permissions.

**App approval for orgs**
Some orgs require third-party app approval before installation. Check:
`github.com/organizations/<org>/settings/oauth_application_policy`

**Multiple accounts**
Avoid multiple GitHub accounts if possible — auth switching is a headache. Use orgs under your main account instead. A `mousechief` contributor account for theatre is fine, but own everything under one login.
