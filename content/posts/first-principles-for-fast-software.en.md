---
title: "First Principles for Fast Software"
date: 2026-06-29T15:00:00-03:00
draft: false
description: "A short note on performance discipline, clarity, and avoiding accidental complexity."
summary: "Fast software usually starts with fewer moving parts, direct measurements, and explicit tradeoffs."
tags:
  - performance
  - architecture
  - engineering
ShowToc: true
TocOpen: false
---

Speed rarely starts with cleverness. It starts with fewer layers, fewer round trips, and fewer guesses.

## Measure Before Explaining

Most performance folklore survives because teams explain systems they have not measured. Measure latency, allocations, query count, payload size, and cold-start behavior before inventing reasons.

## Remove Work First

Best optimization is deleted work. Smaller responses beat compressed large responses. One query beats cached query fan-out. Static pages beat dynamic pages when content barely changes.

## Prefer Mechanical Sympathy

Choose tools that fit problem shape. Flat files beat infrastructure for small publishing sites. Straightforward HTML beats client-side hydration when page is mostly text. Clarity often improves speed because system does less.

## Make Tradeoffs Explicit

Every fast path costs something: flexibility, abstraction, convenience, or operator time. Write decision down. Future changes go better when original trade was intentional instead of accidental.
