# Delivery plan

Planning baseline: 27 October 2026. Owner: Zentreeca Limited. Product: YanMata. Pilot: Jos, Plateau State. User confirms access to clinical reviewers (doctors and nurses in public/private hospitals); named reviewers, credentials and capacity remain to be recorded. Hospital affiliation does not create a requirement for facility integration or institutional partnerships.

## 1. Intended outcome

Build a cohesive public website, Android/iOS Flutter application, React administration/specialist portal and Laravel backend. Deliver a real, testable product using synthetic demo fixtures before collecting health data from pilot participants. Maintain a long-term life-stage roadmap while concentrating initial delivery on a small set of safe, useful journeys.

Confirmed audience: ages 9 onward, from puberty through the end of life, with no upper age limit. Design and implementation must include younger users from the foundation; an adult-only product is not the agreed scope. Facility directories, hospital referrals, facility search and facility appointment booking are out of scope. Specialists interact with users inside YanMata. Planning assumptions: English first, Hausa next after professional translation and local review; invited verified professionals; no open peer-to-peer messaging. Age-appropriate consent, access and safeguarding procedures still need definition before live enrolment.

## 2. Grant fit and immediate deadline

UNICEF's call lists 11 November 2026 as the deadline and emphasises frontier technology, open-source commitment, a functional prototype and eligible company registration. The Jotform specifies 23:59 CET, which is also 23:59 Lagos time on that date. Target submission on 10 November to leave a buffer. Source links: SOURCES.md.

Position the proposal primarily around informed reproductive health access, with wellbeing and safety as supporting outcomes. Candidate frontier contribution: multilingual semantic retrieval over a clinically approved educational corpus, returning sourced material with a controlled explanation and in-platform specialist-support pathway. Establish actual usefulness through evaluation; a conventional tracker alone may not demonstrate the requested frontier technology contribution. Do not add blockchain without a concrete need.

The application needs a repository link, truthful prototype/testing status, company/team details, funding request, milestones and a real-team product demonstration video of at most two minutes. No AI-generated presenters or synthetic demo footage. Confirm legal registration in an eligible country and willingness/rights to open-source. Do not claim eligibility, hospital partnerships, testing results or impact until evidenced.

## 3. Scope by release

| Capability | Grant product slice | Pilot release | Later expansion |
|---|---|---|---|
| Public React site | Brand, product, learning, privacy, Jos pilot information | Reviewed live content, in-platform specialist information, support | Additional languages/regions |
| Accounts/privacy | Real auth, consent, private local journal, optional sync | Recovery, export/deletion, device/session management | Refined age-appropriate access and accessibility |
| Tracking | Period/symptom/mood entry, history, offline queue and sync | Reviewed estimates, conflict resolution, reminders | Life-stage-specific programmes |
| Learning | Sourced articles/video metadata, save/download, admin publishing | Captioned media, review expiry, Hausa review | Expanded curriculum and audio |
| Professional access | Synthetic verified-specialist workflow, request and asynchronous message exchange | Credential verification, assignment, consented access, staffed response hours | In-platform video sessions where operationally justified |
| Admin mobile | Draft/edit/upload and submit; permitted publishing using same API rules | Review and publishing roles, audit trail | Full operational tooling as needed |
| Intelligence | Bounded sourced retrieval on approved sample content, if evaluable in time | Independent clinical/safety evaluation before public enablement | Validated personalised support; clinical models only with evidence |
| Products | Document future scope from supplied handoff | Optional vetted product information | Marketplace only after seller, payment, returns and medicines review |

Non-negotiable exclusions from initial live release: diagnostic cancer percentages, hormone diagnosis from symptom logs, fertility/contraception guarantees, autonomous treatment advice, unmoderated adult-to-child contact, unstaffed emergency-service promises. These exclusions address specific risks in the initial visual concept, not a removal of the broader wellbeing vision.

## 4. Life-stage content model

- Early puberty/body literacy (from age 9): carefully reviewed body changes, hygiene and help-seeking; decide guardian/child access with safeguarding and legal review before enabling child accounts.
- Puberty/adolescence: first periods, variable cycles, cramps, emotional wellbeing, bodily autonomy and access to trusted care.
- Adult menstrual/reproductive wellbeing: symptoms, irregular cycles, clinician-reviewed education about possible causes and in-platform specialist support rather than diagnosis.
- Pregnancy/postpartum: optional pathways, qualified review and in-platform specialist support; no automatic inference from missed periods.
- Perimenopause/menopause and later adulthood: changes in cycles, sleep, wellbeing, healthy ageing and preventive-care education.
- Later life through end of life: dignity, comfort, emotional wellbeing, accessible education and appropriate specialist conversations. Any palliative-care content requires qualified review; YanMata does not operate a facility referral service.

Users choose relevant topics and can change them. Collect only necessary information; do not require extensive reproductive/family histories to read an article.

## 5. Delivery sequence and gates

Dates below are a compressed planning target, not a guarantee. Assumes dedicated engineering capacity, rapid clinical review and available Apple/Firebase/hosting accounts. Reduce optional scope if dependencies slip; do not replace backend behaviour with fake interactions.

| Window | Work | Exit evidence |
|---|---|---|
| 27–29 Oct | Product decisions, brand system, high-fidelity priority screens, architecture/API contracts | Tokens, screen/state inventory, reviewed content sample, age-appropriate onboarding and safeguarding process |
| 29 Oct–2 Nov | Scaffold API/web/admin/mobile, auth, local DB, consent, seeded demo | Both platforms build; API permissions tested; seeded isolated environment runs |
| 2–6 Nov | Tracking, reconnect sync, CMS publication, professional request/message slice | Cross-device end-to-end recordings; offline/retry tests; publication appears on mobile |
| 6–9 Nov | Notification states, accessibility, retrieval evaluation if feasible, deployment hardening | Physical-device results; bounded AI evidence or explicit disabled status; defect register |
| 9–10 Nov | Rehearse real-team demo, capture actual results, finish proposal/repository | Reproducible setup, demo script, accessible repository, factual video and answers |
| 11 Nov | Submission buffer | Human checks and submits final application |
| Following 8–12 weeks | Clinical/safeguarding/privacy reviews, security testing, pilot preparation and limited rollout | All production gates below satisfied; timeline re-estimated after foundation work |
| Months 4–6 | Measure Jos pilot, improve accessibility and Hausa content | Consented evaluation, corrected content, documented usage and specialist-support outcomes |
| Months 7–12 | Expand validated pathways and specialist availability | Outcome-led release decisions, specialist participation agreements, sustainability evidence |

## 6. Production acceptance gates

- Named clinical lead approves content, escalation copy, age-appropriate pathways and estimate limitations. Review deadlines and withdrawal process work.
- Documented data inventory, consent/legal basis assessment, child-safeguarding protocol, retention schedule, processor review and Nigeria-specific legal review completed. No assertion that software alone provides compliance.
- Independent security assessment; no unresolved critical/high findings; ownership/access tests, staff MFA, signed media, secret scanning and restore drill pass.
- Offline create/edit/delete, device migration, duplicate/reordered events, stale cursors, revoked consent and two-device conflicts behave as specified.
- Android/iOS physical-device foreground/background/terminated notification tests pass under supported OS conditions; permission denial and OS suppression are explained honestly.
- Provider verification, response hours, complaint handling, safeguarding escalation and content moderation have named operational owners.
- Mobile accessibility and web WCAG 2.2 AA review; low-end Android and poor-network performance checks; no stale emergency or specialist contact information.
- Monitoring, alerts, rollback, backups, deletion processing and incident runbooks exercised in staging. Store privacy declarations accurately describe collected data.

## 7. Team and indicative grant allocation

Required roles: product/design lead; Flutter engineer; Laravel engineer; React engineer; QA/security/DevOps capacity; clinical lead and safeguarding/privacy adviser. Some roles may be combined, but clinical decisions need qualified ownership. No staffing or budget is confirmed.

Illustrative USD 100,000 / 12-month allocation for planning only: engineering 42,000; design/accessibility 12,000; clinical review/safeguarding/localisation 14,000; pilot research/specialist operations 12,000; security/privacy assessment 8,000; hosting/devices/tooling 5,000; contingency 7,000. Obtain quotes and actual staffing estimates before submitting a funding amount.

## 8. Outcomes and risks

Track education comprehension, successful offline task completion, successful in-platform specialist engagement, content freshness, user-reported privacy confidence and accessibility task success. Define denominators, consent and baseline before recruiting. Do not equate downloads with health outcomes; do not invent impact numbers. Avoid collection of sensitive research fields unless necessary and approved.

Principal delivery risks: short grant window, unresolved minor-access protocol, unverified reviewer capacity, inherited code security, mobile background restrictions, unsuitable AI answers, insufficient specialist capacity and open-source ownership. Mitigate through narrow vertical slices, explicit gates, selective reuse, real-device testing, reviewed retrieval corpus, verification dates and licensing audit.

Next decisions: age-appropriate consent/access rules; named clinical/safeguarding leads; verified participating specialists; hosting/data region; open-source licence; staffing and budget; brand spelling/pronunciation and local-language preference. These block specific release steps, not documentation or safe foundation work.
