# Editorial Workflow

This repository is public.

Editorial source of truth lives in sibling repository:

- `../engineering-decisions`

This repository is publication target only.

Preferred deployment target:

- Cloudflare Pages

## POSSE model

Use POSSE here as:

- Publish Own Source: write and maintain canonical article files in `../engineering-decisions`
- Publish Own Site: copy approved article into this Hugo site
- Syndicate Elsewhere: derive LinkedIn and other variants from editorial source repo, not from site repo

This avoids maintaining article content twice.

Published site files use Hugo language suffixes:

- `content/posts/article-slug.en.md`
- `content/posts/article-slug.pt-br.md`

Future translations follow same pattern:

- `content/posts/article-slug.es.md`
- `content/posts/article-slug.fr.md`

Rule:

- Only published articles belong in `content/posts/`.
- Ideas, drafts, review versions, and ready-but-unpublished articles must stay outside git tracking.

## Publishing law

- Before first launch: keep at least 10 `Ready` articles.
- After launch: keep at least 8 `Ready` articles.
- Publishing cadence: 1 article per week.
- If buffer drops below 8, stop publishing and rebuild buffer.

## Writing pipeline

Source process from editorial source-of-truth repo:

Idea -> Question -> Thesis -> Counterarguments -> Evidence -> Business translation -> English article -> Portuguese adaptation -> LinkedIn version -> Publication -> Discussion -> Lessons learned

## Local folder convention

Keep private work in local ignored folder:

- `editorial/ideas/`
- `editorial/drafts/`
- `editorial/review/`
- `editorial/ready/`
- `editorial/published-queue/`

`editorial/` is ignored by git, so public GitHub repo stays limited to published site content.
Use it only as local working cache when needed. Canonical editorial state remains in `../engineering-decisions`.

## Promotion rule

Move article into `content/posts/` only when:

- article is approved for publication
- publish date is decided
- article is intended to be public now

## Publish commands

For local preview as draft:

```sh
make draft ARTICLE=001-ai-made-code-cheap
```

For final site copy:

```sh
make stage ARTICLE=001-ai-made-code-cheap
```

For only a subset of translations:

```sh
make stage ARTICLE=001-ai-made-code-cheap ARTICLE_LANGS="en pt-br"
```

Preview site:

```sh
make preview
```

These commands copy:

- from `../engineering-decisions/03-articles/001-ai-made-code-cheap/article.en.md`
- to `content/posts/ai-made-code-cheap.en.md`

Portuguese publish copies:

- from `../engineering-decisions/03-articles/001-ai-made-code-cheap/article.pt-br.md`
- to `content/posts/ai-made-code-cheap.pt-br.md`

Mode behavior:

- `draft`: auto-detects available `article.<lang>.md` source files and forces local site copies to `draft: true`
- `stage`: auto-detects available `article.<lang>.md` source files and forces local site copies to `draft: false`

Commit and push only after `make stage ...`.

## Deployment

Preferred deployment flow:

1. `make stage ARTICLE=<article-slug>`
2. review with `make preview`
3. commit and push this repository
4. Cloudflare Pages builds and deploys from `main`

Important:

- `make stage` does not publish to internet by itself
- public publication happens only when deployment runs
- local Hugo server rebuilds are local preview only

See [CLOUDFLARE_PAGES.md](/Users/douglaspinto/Developer/engineering-decisions-site/CLOUDFLARE_PAGES.md) for exact setup.

## Canonical article format

To avoid duplicate work, canonical source article should already be valid publish-ready Markdown.

Recommended:

- keep final English article in `article.en.md`
- keep Portuguese adaptation in `article.pt-br.md`
- include Hugo front matter there when article is approved
- keep notes, references, and LinkedIn work beside them in source repo

This way site repo only copies published article instead of re-authoring it.

## Content rule

Every article should:

- cover one idea
- begin with business problem
- end with better decision
- improve CEO/CTO judgment
- prefer clarity, tradeoffs, numbers, and durable principles
