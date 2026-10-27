# Design direction and screen contract

Status: Phase 01 public/admin/mobile layouts, shared semantic colours and original vector symbol are implemented. See ../evidence/PHASE-01.md for inspected layouts and remaining accessibility/identity work.

## Brand

YanMata by Zentreeca Limited. Suggested tone: calm, capable, warm and discreet. Suggested headline: “Care for every chapter of you.” Validate name, spelling, pronunciation and language meaning with local users before final identity. Do not imply UNICEF endorsement or use its logo without authorisation.

Retain the reference's plum/lilac warmth and culturally relevant illustrations, with more whitespace, stronger type and clearer hierarchy. Feminine character comes from colour, illustration, tone and thoughtful care; avoid childish pink overload, beauty expectations or pregnancy as the default. Include varied ages, skin tones, body types and disabilities. Co-design with women and girls under appropriate research safeguards.

Proposed semantic palette: plum primary #56327A; blush surface #F8E8EE; lilac surface #F1ECFA; teal accent #24766C; warm background #FFFCF8; ink #241D2E; muted text #625B6B; error #B42335. These are initial tokens, not certified accessible combinations: measure all text/control states for WCAG 2.2 AA before acceptance. Warnings use icon/text, not colour alone.

Implemented fonts are locally bundled Manrope (mobile/headings), DM Sans (web body) and system Georgia (web editorial accents). Font licences accompany the assets. Confirm font licences and small-device readability. Base body 16 logical pixels, generous line-height, 8-point spacing rhythm with 4-point exceptions, 16–24 radius cards, restrained elevation, minimum 48 logical-pixel main tap targets. Support 200% text scaling and reduced motion. Use semantic tokens, not per-screen hard-coded values.

Logo deliverables: original vector symbol/wordmark, horizontal/stacked layouts, monochrome/light/dark, SVG/PDF masters, transparent PNG exports up to 4096px, iOS/Android adaptive icon variants, favicon, clear-space/minimum-size and brand guide. Explore abstract growth/protection/connection with subtle Y form; compare to the supplied silhouette concept. Preserve a recognisable small-size icon. Generated concept art, if used later, needs a refined vector master and ownership checks.

## Mobile information architecture

Five primary tabs: **Today, Track, Learn, Care, You**. This deliberately makes education first-class and moves future shopping out of primary navigation. It revises the handoff's Home/Track/Services/Products/More arrangement; record user feedback before locking. Staff mode is explicit and permission-gated within You, with a persistent role indicator.

| Area | Required screens |
|---|---|
| Start | Welcome, explore without account, optional age/topic selection, privacy explanation, registration/sign-in/recovery, consent |
| Today | Gentle greeting, private check-in, optional cycle summary, one relevant learning card, care shortcut |
| Track | Calendar/list, period log, symptom/mood/sleep/energy entry, history, detail/edit, uncertainty-aware insights, conflict resolution |
| Learn | Topics/life stages, search, article with sources/reviewer/date, captioned video/transcript, saved/downloaded items |
| Care | In-platform specialist profiles and availability, support request, consented sharing, conversation, reporting/help; no facility search, maps or hospital referrals |
| You | Profile/topics, privacy/consent, app lock, notifications/quiet hours, devices, export/delete, language/accessibility, support |
| Staff mobile | Draft list/editor, media upload/progress, review feedback, submit, publish for authorised role, audit status |

Every screen requires appropriate loading, empty, validation, network failure, offline, permission denied and unavailable states. Tracking includes “not enough information” and “no period tracking needed”; do not assume a 28-day cycle. Give instant local save feedback and distinguish “saved on this device” from “synced”. Protect sensitive details on shared screens; show generic notification previews.

## Public website

Pages: Home; How YanMata Works; Life Stages; Learn index/detail; Meet Our Specialists (verified public professional information only); Safety & Privacy; About Zentreeca; Jos Pilot/Contact; legal policies and accessibility. Home composition: clear benefit and authentic illustration → three core journeys → life-stage education → clinical review process → privacy/offline explanation → Jos pilot → download/pilot CTA. Only show store badges when real releases exist. Never invent testimonials, user counts, certifications or hospital endorsements.

Design at 360/390 mobile, 768 tablet and 1440 desktop, with fluid layouts between. Prioritise fast text/content delivery, responsive images, captions and no autoplay video. Health journal and private conversation routes must never become publicly indexable.

## React administration and specialist portal

Role-specific navigation: overview, content/review queue, media, specialists, support requests/messages, announcements, safeguarding reports, access/audit and settings. Use a calm functional UI sharing brand tokens; tables need filters, accessible pagination, empty states and clear status labels. No health-record access from a generic user-management screen. Content editor visibly separates draft, review and public revision. Show audience, source, reviewer, review deadline and publication preview before publish.

## Design acceptance

Produce clickable flows for welcome → private check-in; offline tracking → sync; sourced learning → in-platform specialist support; admin/mobile draft → review → publication. Capture mobile light/dark themes if both are implemented, text scaling, keyboard, long content and low-bandwidth conditions. Validate contrast and focus order, screen readers, reduced motion and 48px targets. Compare screenshots against token/component baselines before merging. Keep page-specific visual changes documented, with rationale and new baseline evidence. Do not replace interaction design with decorative gradients alone.

## Lifelong experience requirements

Design for ages 9 onward, with age-appropriate language and privacy explanations for early puberty, adolescence, adulthood, menopause and later life. Topics and life stage are user-adjustable; age alone must not imply menstruation, pregnancy or sexual activity. Include older-user accessibility, comfortable reading, clear navigation and dignity in end-of-life wellbeing content. No location permission is needed for facility discovery because facility discovery is out of scope.
