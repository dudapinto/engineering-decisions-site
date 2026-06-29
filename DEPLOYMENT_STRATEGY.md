# Deployment Strategy

This repository is the publication target for Engineering Decisions.

The editorial source of truth lives in:

- `../engineering-decisions`

This repository should contain only site-ready published content.

## Recommended model

Use a two-repository POSSE workflow:

- `../engineering-decisions` = writing, notes, references, PT-BR adaptation, LinkedIn variants, editorial pipeline
- `./engineering-decisions-site` = Hugo site, public publish target, deployment source

Do not deploy from the editorial repository.

Deploy from this site repository only.

## Why

This keeps:

- drafts and private ideas out of the public site repository
- deployment simple and repeatable
- rollback easy through git history
- publication independent from research/editorial work

## Publishing workflow

1. Write and edit canonical article in `../engineering-decisions`
2. When article is approved, copy it into this site repo:

```sh
make stage ARTICLE=001-ai-made-code-cheap
```

3. Preview locally:

```sh
make preview
```

4. Commit and push this site repo
5. Deploy this site repo

## Shared hosting option

If using traditional shared hosting, deployment is static:

1. Build site:

```sh
hugo
```

2. Upload contents of `public/` to hosting web root

Typical web root:

- `public_html/`
- or domain document root configured by hosting provider

Possible upload methods:

- SFTP
- FTP
- rsync
- cPanel File Manager

Requirements before publishing:

- final `baseURL` configured in `hugo.yaml`
- final domain decided
- no draft-only content in deployed build
- `hugo` build passes

## Preferred long-term option

Prefer automatic deployment from this repository after commit and push to `main`.

Recommended trigger:

- push to `main` in `engineering-decisions-site`

Recommended deploy shape:

1. GitHub Actions builds site with `hugo`
2. workflow uploads `public/` to shared hosting over SFTP or rsync

This is better than manual upload because it:

- removes repetitive deployment work
- reduces operator error
- keeps deploys consistent
- makes publishing faster

## Important guardrail

Do not auto-deploy from editorial status alone.

Better rule:

- editorial repo decides what is ready
- site repo contains what is public
- deployment happens from site repo only

That keeps the 10-before-launch and 8-buffer-after rules intact.

## Future default

Best expected future setup:

- canonical writing in `../engineering-decisions`
- `make stage ...` copies approved translations into this repo
- push to `main`
- deployment runs automatically from GitHub to hosting
