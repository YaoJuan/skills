# iOS App — DESIGN.md Reference

## Platform Constraints

| Constraint | Rule |
|-----------|------|
| Units | `pt` for all layout/spacing. 1pt = 2px on @2x, 3px on @3x. Never use px |
| Touch Targets | Minimum 44×44pt for all interactive elements (Apple HIG) |
| Fonts | SF Pro (system default) or custom via `UIFont(name:size:)`. Use Dynamic Type for text scaling |
| Components | Prefer UIKit / SwiftUI native components — they handle accessibility and dark mode automatically |
| Safe Areas | Always respect `safeAreaInsets` — top (Dynamic Island / notch) and bottom (home indicator) |
| Dark Mode | Support via `UIColor.label`, `UIColor.systemBackground` semantic colors, or Asset Catalog dark variants |
| Haptics | Use `UIImpactFeedbackGenerator` for meaningful interactions |

---

## DESIGN.md Structure for iOS App

```markdown
# DESIGN.md — [Project Name] (iOS App)

## 1. Project Overview
[One sentence: product purpose and target user]

## 2. Visual Theme
- Style: [Native iOS / Custom branded / Minimal / Rich media]
- Theme: [Light only / Dark only / Follow system]
- Density: [Spacious / Standard / Compact]
- Design reference: [Similar to: Notes, Linear, Craft, Notion, etc.]

## 3. Color System

Define in Asset Catalog with light/dark variants, or as SwiftUI Color extensions.

| Name | Light Hex | Dark Hex | Usage |
|------|-----------|----------|-------|
| primary | #XXXXXX | #XXXXXX | Buttons, links, active states, tint color |
| primaryMuted | #XXXXXX | #XXXXXX | Selected backgrounds, chips |
| background | #FFFFFF | #000000 | Root view background |
| secondaryBackground | #F2F2F7 | #1C1C1E | Grouped table bg, sheet bg |
| tertiaryBackground | #FFFFFF | #2C2C2E | Cards inside grouped bg |
| surface | #FFFFFF | #1C1C1E | Cards, modals |
| separator | #C6C6C8 | #38383A | List dividers |
| label | #000000 | #FFFFFF | Primary text |
| secondaryLabel | #3C3C43/60% | #EBEBF5/60% | Secondary text |
| tertiaryLabel | #3C3C43/30% | #EBEBF5/30% | Placeholder, disabled |
| success | #34C759 | #30D158 | Active, confirmed |
| warning | #FF9500 | #FF9F0A | Caution states |
| error | #FF3B30 | #FF453A | Destructive, errors |

Prefer Apple semantic colors where possible:
- `UIColor.label` / `Color.primary`
- `UIColor.systemBackground` / `Color(UIColor.systemBackground)`
- `UIColor.systemGroupedBackground`

## 4. Typography (SF Pro + Dynamic Type)

Font: SF Pro (system) — access via `.system()` in SwiftUI or `UIFont.preferredFont(forTextStyle:)` in UIKit

| Style | Default pt | Weight | SwiftUI | Usage |
|-------|-----------|--------|---------|-------|
| largeTitle | 34pt | Regular | `.largeTitle` | Navigation large title |
| title1 | 28pt | Regular | `.title` | Screen titles |
| title2 | 22pt | Regular | `.title2` | Section titles |
| title3 | 20pt | Regular | `.title3` | Card headings |
| headline | 17pt | Semibold | `.headline` | List item titles |
| body | 17pt | Regular | `.body` | Primary content |
| callout | 16pt | Regular | `.callout` | Secondary content |
| subheadline | 15pt | Regular | `.subheadline` | Supporting text |
| footnote | 13pt | Regular | `.footnote` | Metadata, captions |
| caption1 | 12pt | Regular | `.caption` | Labels, timestamps |
| caption2 | 11pt | Regular | `.caption2` | Smallest labels |

Always use Dynamic Type — never hardcode font sizes. This respects user accessibility settings.

## 5. Spacing System

Base unit: 4pt

| Token | pt | Usage |
|-------|-----|-------|
| space-1 | 4pt | Tight inline gaps |
| space-2 | 8pt | Icon-to-text spacing |
| space-3 | 12pt | Small component padding |
| space-4 | 16pt | Standard padding (HIG default) |
| space-5 | 20pt | Card padding |
| space-6 | 24pt | Section spacing |
| space-8 | 32pt | Major layout gaps |

Standard horizontal margin: 16pt (matches UITableView inset default)
List row height: 44pt (single line, HIG minimum)
Navigation bar height: 44pt + status bar

## 6. Component Specs

### Buttons
- Primary (filled): `primary` background, white label, 10pt corner radius, 44pt min height
- Secondary (tinted): `primaryMuted` background, `primary` text
- Bordered: `primary` border 1pt, `primary` text, clear background
- Destructive: `error` color text or background
- All buttons must have 44pt minimum touch target

### Cards
- Background: `surface`
- Corner radius: 12pt
- Shadow (light): `0 2pt 8pt rgba(0,0,0,0.08)`
- Shadow (dark): none (use subtle border instead)
- Padding: 16pt

### Navigation
- Use `NavigationStack` (iOS 16+) or `NavigationView`
- Large title style for root screens
- Inline title style for detail screens
- Back button: system default (don't replace unless necessary)

### Lists / Tables
- Use `List` in SwiftUI or `UITableView` with `.insetGrouped` style
- Row min height: 44pt
- Accessory: chevron for navigation, checkmark for selection
- Swipe actions: destructive in red, others in `primary`

### Tab Bar
- Max 5 items
- Icon size: 25×25pt (SF Symbols preferred)
- Selected tint: `primary`
- Unselected: `tertiaryLabel`

### Sheets / Modals
- Use `.sheet` or `.fullScreenCover`
- Drag indicator for bottom sheets
- Corner radius: 10pt (system default for sheets)

### Input Fields
- Use `TextField` with `.roundedBorder` style or custom
- Height: 44pt
- Corner radius: 8pt
- Border: `separator` color, 1pt
- Focus: `primary` tint on cursor

## 7. Platform-Specific Rules

- Always use SF Symbols for icons — consistent weight with adjacent text
- Respect Dynamic Island / notch — don't place interactive elements in top 44pt + status bar area
- Bottom content must account for home indicator: `safeAreaInsets.bottom` (typically 34pt on notchless, varies)
- Support both portrait and landscape unless explicitly single-orientation
- Implement `preferredColorScheme` override only if the app has a built-in theme switcher
- Use `@Environment(\.colorScheme)` to adapt custom colors in SwiftUI

## 8. Do's and Don'ts

**Do:**
- Use SF Symbols — they scale with Dynamic Type automatically
- Use semantic colors (`Color.primary`, `UIColor.label`) as the default layer
- Support both light and dark mode from day one
- Provide haptic feedback on meaningful actions (confirm, error, selection)
- Test on smallest supported device (iPhone SE)

**Don't:**
- Don't hardcode font sizes — use Dynamic Type styles
- Don't use `px` — always `pt`
- Don't create custom nav bars unless absolutely necessary
- Don't block the safe area with content
- Don't use more than 2 custom fonts

## 9. Agent Prompt Guide

**Quick color reference:**
- Primary: [PRIMARY_HEX]
- Background: [BG_HEX]
- Surface: [SURFACE_HEX]

**Ready-to-use prompts:**

Build a screen (SwiftUI):
> "Using DESIGN.md, build a [ScreenName] SwiftUI view. Apply the color system using Asset Catalog names, use Dynamic Type text styles from the typography table, and follow the spacing tokens and component specs."

Build a component:
> "Using DESIGN.md, create a reusable [ComponentName] SwiftUI view with parameters: [xxx]. Match the card/button specs and use semantic colors for dark mode support."

UIKit version:
> "Using DESIGN.md, implement [ScreenName] in UIKit. Use UIColor semantic colors, preferredFont(forTextStyle:) for Dynamic Type, and follow the spacing and component specs."

Fix consistency:
> "Review this SwiftUI view against DESIGN.md. Replace any hardcoded colors with Asset Catalog references, fix font sizes to use Dynamic Type styles, and ensure safe area is respected."
```

---

## Extraction Tips (for screenshot mode)

When analyzing an iOS App screenshot:
- Check for Dynamic Island (pill at top) or notch → determine device generation
- SF Pro font is very distinctive — thin, rounded terminals, excellent legibility
- Standard iOS grouped list has `#F2F2F7` background with white cells
- Tab bar at bottom with thin SF Symbol icons → native UITabBarController
- Rounded rectangles everywhere → iOS 16+ design language (corner radius ~12pt)
- If buttons have filled capsule shape → likely SwiftUI `.buttonStyle(.borderedProminent)`
