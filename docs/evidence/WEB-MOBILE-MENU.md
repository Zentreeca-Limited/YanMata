# WEB-02 — Mobile menu background correction

Date: 28 October 2026

## Implemented

- Replaced the undefined/transparent mobile navigation surface with explicit opaque light and dark gradient surfaces.
- Kept the menu above page content with `z-index: 1000`, stronger elevation and an isolated stacking context.
- Added a viewport-bounded maximum height, vertical overflow handling and overscroll containment for short devices.
- Expanded mobile menu links and the Aisha action to full-width, comfortable targets.

## Verification

- `npm run format:check`: passed.
- `npm run typecheck`: passed for public web and admin.
- `npm run build`: public web and admin production builds passed.
- Browser at 390×844, light theme: computed background `rgb(255, 253, 251)`, menu width 358px, `z-index: 1000`, document width 390px.
- Browser at 390×844, dark theme: computed background `rgb(38, 18, 29)` with the dark gradient applied.
- Browser at 360×800: menu remained inside the viewport (x 16px, width 328px, right edge 344px), document width stayed 360px and the menu height stayed below its 704px maximum.
- Visual evidence: [light menu](screenshots/mobile-menu-background-light.png) and [dark menu](screenshots/mobile-menu-background-dark.png).

## Remaining risk

- Browser inspection covered the documented 360px and 390px phone widths. A full screen-reader and keyboard audit remains part of broader accessibility QA.
