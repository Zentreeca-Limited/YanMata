# Phase 10 — age-inclusive editorial photography

Date: 28 October 2026  
Work item: WEB-03

## Implemented

- Preserved the distinctive illustrated hero while adding four original high-definition editorial photographs to the public website.
- Added age-diverse Nigerian/West African representation across adolescence, adulthood, menopause, later life, private mobile use and specialist support.
- Integrated a responsive life-stage gallery, later-life portrait, specialist-support visual and YanMata Mobile lifestyle image.
- Added descriptive alternative text, responsive crops, overlays with readable contrast and an explicit illustrative-image disclosure in the specialist section.
- Avoided names, endorsements, credentials, hospital branding, visible patient information and claims that photographed people are YanMata users or partners.
- Converted the generated PNG source set to WebP at quality 84. Final public assets total approximately 632 KB, compared with approximately 8.5 MB for the generated PNG sources.

## Image generation provenance

- Mode: built-in `image_gen` tool.
- Use case: `photorealistic-natural`.
- Final prompt set:
  1. Premium wide editorial scene of four Nigerian/West African women spanning adolescence through later life in a warm contemporary Nigerian courtyard; dignified, candid and non-medical; aubergine/rose/cream palette; no text, logos, endorsements or partnership implications.
  2. Premium environmental portrait of a Nigerian woman in her early 60s journaling at home; graceful aging, calm natural light and no frailty stereotypes, text, logos or testimonial implication.
  3. Premium editorial scene of a Nigerian female healthcare professional providing private digital support in an unbranded workspace; no readable screen, patient data, credentials, names, logos or partnership claim.
  4. Premium lifestyle scene of an adult Nigerian woman privately using a smartphone at home; unreadable screen, no pregnancy cues, text, logos or testimonial implication.
- Final project assets:
  - `apps/web/public/images/editorial/lifelong-wellbeing.webp`
  - `apps/web/public/images/editorial/later-life-wellbeing.webp`
  - `apps/web/public/images/editorial/specialist-support.webp`
  - `apps/web/public/images/editorial/mobile-wellbeing.webp`

## Verification

- `npm run format:check` — passed.
- `npm run --workspace=@yanmata/web build` — passed; TypeScript and Vite production build completed successfully.
- Desktop visual inspection at 1440px covered the life-stage gallery, specialist-support layout and mobile-download panel.
- Compact visual inspection at 500px covered stacked life-stage images and the mobile-download panel. No observed horizontal overflow, text collision or unusable store controls.

## Evidence

- `docs/evidence/screens/editorial-web/life-stages-desktop.png`
- `docs/evidence/screens/editorial-web/life-stages-mobile.png`
- `docs/evidence/screens/editorial-web/specialist-desktop.png`
- `docs/evidence/screens/editorial-web/download-desktop.png`
- `docs/evidence/screens/editorial-web/download-mobile.png`

## Remaining review

- Generated people are fictional illustrative subjects. Confirm the final image-release and AI-generated-media disclosure approach with legal/brand reviewers before launch.
- Continue to avoid presenting any image subject as a real user, clinician, reviewer, partner or testimonial source.

