# Editorial Workflow

This repository is public.

Editorial source of truth lives in sibling repository:

- `../engineering-decisions`

This repository is publication target only.

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

## Content rule

Every article should:

- cover one idea
- begin with business problem
- end with better decision
- improve CEO/CTO judgment
- prefer clarity, tradeoffs, numbers, and durable principles
