---
name: design-system-generator
description: >
  Generate a DESIGN.md design system file for AI coding agents (Claude Code, Google Stitch, etc.) to use when building UI.
  Use this skill whenever the user wants to create, update, or extract a design system for their project.
  Triggers include: "create a DESIGN.md", "generate a design system", "help me define my design system",
  "I want consistent UI from my AI agent", "create design rules for Claude Code / Stitch / Cursor",
  "extract design from this screenshot/mockup", "my project doesn't have a DESIGN.md",
  "create design guidelines for my app", "design tokens", "UI style guide", any mention of DESIGN.md or design system,
  or when the user uploads a UI screenshot and wants design rules extracted from it.
  Supports WeChat Mini Program, Android App, iOS App, and Web platforms.
---

# Design System Generator

Generate a DESIGN.md that AI coding agents (Claude Code, Google Stitch, etc.) can read to produce consistent, on-brand UI.

## Step 1: Detect Mode

Determine which of these three input modes the user is in:

| Mode | Signal | Action |
|------|--------|--------|
| **Describe** | User describes desired style in words ("I want a dark, minimal look") | Interview → generate |
| **Extract** | User uploads screenshot / mockup / reference image | Extract tokens from image → generate |
| **Bootstrap** | No DESIGN.md exists in project, or user says "I don't have one yet" | Ask key questions → generate opinionated defaults |

All three modes end with the same output: a complete DESIGN.md written to the project root (or presented for download).

---

## Step 2: Detect Platform

Ask or infer the target platform. Then load the corresponding reference file for platform-specific sections and constraints:

| Platform | Reference File | Key Differences |
|----------|---------------|-----------------|
| WeChat Mini Program | `references/miniprogram.md` | rpx units, WeUI components, safe areas, no custom fonts |
| Android App | `references/android.md` | Material You, dp/sp units, touch targets ≥48dp |
| iOS App | `references/ios.md` | SF Pro, pt units, Dynamic Type, SF Symbols, safe areas |
| Web (admin/dashboard) | `references/web.md` | px/rem, responsive breakpoints, Tailwind-friendly tokens |

If the user mentions multiple platforms, generate separate DESIGN.md files for each.

**Always read the platform reference file before generating output.**

---

## Step 3: Interview (if Describe or Bootstrap mode)

Ask only what you don't already know. Keep it conversational — one question at a time if the user seems less technical.

**Required information:**
- Project name and purpose (1 sentence)
- Target platform (if not already known)
- Brand colors (primary, secondary) — hex preferred; if unknown, ask for mood words
- Overall aesthetic: light/dark/auto, density (spacious / balanced / compact)
- Any reference products/apps they like the look of

**Optional but useful:**
- Font preferences (or "use system default")
- Existing logo/icon colors to derive palette from
- Specific components that matter most (tables, charts, forms, cards)

---

## Step 4: Extract (if Extract mode)

When the user provides a screenshot or mockup image:

1. Identify dominant background color → classify as light/dark theme
2. Extract primary accent color (buttons, active states, links)
3. Note secondary/neutral colors (borders, disabled states, backgrounds)
4. Infer typography: serif vs sans-serif, weight, approximate size hierarchy
5. Observe spacing density: tight / medium / spacious
6. Note any distinctive patterns: rounded corners, shadows, gradients, glassmorphism
7. List key components visible: navigation bar, cards, buttons, inputs, tabs

State your extracted values explicitly before writing the DESIGN.md so the user can correct anything.

---

## Step 5: Generate DESIGN.md

Read the platform reference file, then write the full DESIGN.md using the structure defined there.

All DESIGN.md files share this core structure (platform files add/modify sections):

```
# DESIGN.md — [Project Name]

## 1. Project Overview
## 2. Visual Theme & Atmosphere  
## 3. Color Palette
## 4. Typography
## 5. Spacing & Layout
## 6. Component Styles
## 7. Platform-Specific Rules   ← content varies by platform
## 8. Do's and Don'ts
## 9. Agent Prompt Guide        ← ready-to-paste prompts for Claude Code
```

**Section 9 (Agent Prompt Guide) is mandatory** — it gives the user copy-paste prompts like:
> "Using DESIGN.md, build a [component] that follows the primary color palette and card shadow style."

---

## Step 6: Save or Present

- If running in **Claude Code**: write the file to `./DESIGN.md` in the project root and confirm path.
- If running in **Claude.ai**: present the file as a downloadable artifact and tell the user to place it in their project root.

After saving, tell the user:
> "Drop this in your project root. Then in Claude Code, you can say: 'Using DESIGN.md, build me a [screen name]' and it will follow these design rules automatically."

---

## Iteration

If the user wants to update an existing DESIGN.md:
1. Read the current file first
2. Ask what they want to change (new colors? new component? platform change?)
3. Make targeted edits — don't rewrite sections that aren't changing
4. Re-save

---

## Reference Files

- `references/miniprogram.md` — WeChat Mini Program specific structure and constraints
- `references/android.md` — Android App (Material You) structure and constraints
- `references/ios.md` — iOS App (SwiftUI/UIKit, SF Pro, Dynamic Type) structure and constraints
- `references/web.md` — Web admin/dashboard structure and constraints
