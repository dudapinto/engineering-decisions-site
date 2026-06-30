# Cloudflare Pages

Preferred deployment target for this project.

Why:

- free tier is enough for this site shape
- Hugo is supported directly
- GitHub integration is native
- deploy on push removes manual upload work
- static multilingual output fits Pages well

## Recommended model

- `../engineering-decisions` = editorial source of truth
- `./engineering-decisions-site` = public site source
- Cloudflare Pages deploys from `engineering-decisions-site`

Do not deploy from the editorial repository.

## Recommended workflow

1. Write in `../engineering-decisions`
2. Prepare local draft copy:

```sh
make draft ARTICLE=<article-slug>
```

3. Preview locally:

```sh
make preview
```

4. Prepare final site copy:

```sh
make stage ARTICLE=<article-slug>
```

5. Commit and push this repository
6. Cloudflare Pages deploys from `main`

## Cloudflare Pages setup

Create project from existing GitHub repository:

- repository: `dudapinto/engineering-decisions-site`
- production branch: `main`
- root directory: repository root
- build command: `hugo -b $CF_PAGES_URL`
- build output directory: `public`

Why `-b $CF_PAGES_URL`:

- Cloudflare injects `CF_PAGES_URL`
- Hugo can use that URL for canonical and absolute links in each deployment environment
- this is especially useful before final custom domain is locked

## Branch deployment controls

Recommended settings:

- automatic production branch deployments: enabled
- production branch: `main`
- preview branch deployments: `None`

Reason:

- prevents accidental public preview URLs for non-production branches
- keeps publication tied to intentional pushes on `main`

If preview deployments are useful later, switch to custom preview branches instead of all branches.

## Hugo version

If needed, set project environment variable:

- `HUGO_VERSION=<desired-version>`

Use same value for Production and Preview environments if preview deployments are ever enabled.

## Custom domain

When ready to launch:

1. choose final domain
2. add custom domain in Cloudflare Pages
3. update `baseURL` in `hugo.yaml`
4. push a new deploy

Until then, keep current placeholder or temporary project URL strategy.

## What actually makes content public

These actions do **not** make article public on internet:

- editing in Obsidian
- `make draft`
- `make preview`
- `make stage`

Article becomes public only when:

1. staged content is committed in this repo
2. pushed to `main`
3. Cloudflare Pages finishes deployment

## Manual fallback

If Pages is unavailable, fallback remains possible:

```sh
make build
```

Then deploy contents of `public/` somewhere else.

## Notes

- Cloudflare Pages official Hugo guide says Hugo build command is `hugo` with output directory `public`
- official guide also recommends `hugo -b $CF_PAGES_URL` when using Hugo `baseURL` for absolute URLs
- Cloudflare branch controls support turning preview deployments off with `None`
