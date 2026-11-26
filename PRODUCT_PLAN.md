# Product Vision & Product Requirements

**Mission:** Reduce avoidable operating costs and guest friction for exactly two industries: restaurants and cinemas.

We are not building a generic QR generator, a menu-only site, or a universal POS. We are building two focused operating systems on a shared platform.

## Restaurant OS
**Problems:** manual order-taking and re-entry, long waits, misheard orders, slow kitchen handoffs, unavailable items not communicated, staff overloaded during rushes, and owners lacking operational visibility.

**Target outcomes:** fewer staff minutes spent on repetitive order-taking; shorter and more transparent waits; fewer order errors; faster kitchen routing; better throughput; measurable operational visibility.

**Candidate capabilities (discovery required):**
- Venue/branch profile, hours, tables and table QR identity.
- Live digital menu, categories, item options, dietary/allergen details and availability.
- Guest dine-in and takeaway ordering from a normal mobile browser.
- Order acceptance, idempotency, kitchen routing, preparation stations and status.
- Waitlist, estimated wait, notifications, seating and table readiness.
- Staff roles, exception handling, audit trail and manager controls.
- Owner insights: queue time, preparation time, staff minutes per transaction, throughput, errors, cancellations and adoption.
- Optional payments, refunds, POS/printer/accounting integrations only after provider and workflow validation.

## Cinema OS
**Problems:** ticket counter queues, unclear seat availability, booking friction, manual entry checks, concession queues, fragmented showtime/seat/ticket operations, and difficult peak-time staffing.

**Target outcomes:** faster booking and entry; fewer seat conflicts and ticket errors; reduced counter pressure; improved concession throughput; better occupancy and operational visibility.

**Candidate capabilities (discovery required):**
- Cinema/location, auditorium and seat-map management.
- Film catalogue and showtime scheduling.
- Accurate seat inventory, atomic temporary holds and booking confirmation.
- Digital tickets with secure, replay-resistant validation.
- Staff scanning, admission and exception workflows.
- Optional concession catalogue and pre-order linked to booking/session.
- Owner insights: occupancy, booking conversion, entry throughput, queue time, concession attachment, refunds and exceptions.
- Optional payments, refunds, ticketing/POS/scanner integrations after validation.

## Shared platform
Multi-tenant identity and roles; public guest experiences without mandatory app installation; branding; QR/shareable links; notifications; audit; reporting; media; secure integrations; resilient retries and observability.

## Product principles
1. Solve expensive, frequent problems first.
2. Observe actual workflows before automating them.
3. Automate routine work while preserving human exception handling.
4. One shared platform, two separate domain models.
5. Never show an order, seat, booking or payment as confirmed until the authoritative transaction succeeds.
6. Design for duplicate taps, weak networks, concurrency, cancellations and provider outages.
7. Measure business value; do not claim savings without baseline and post-launch evidence.

## Problem-to-outcome map
| Problem | Restaurant response | Cinema response | Metric |
|---|---|---|---|
| Queues | Waitlist, QR ordering | Digital booking, entry validation | Median/P90 wait |
| Manual work | Guest self-order, kitchen routing | Online ticketing, scanning | Staff minutes/transaction |
| Errors | Item-level confirmation | Seat conflict/replay prevention | Error/refund rate |
| Delays | Kitchen workflow | Admission/concession flow | Throughput |
| Poor visibility | Service dashboard | Occupancy/operations dashboard | Adoption and KPIs |

## MVP strategy
Choose one complete end-to-end pilot workflow per vertical after discovery.

Restaurant candidate: QR menu → guest submits order → correct kitchen queue receives it → staff updates status → guest sees status → owner sees measured time/workload data.

Cinema candidate: showtime discovery → live seat selection/hold → booking confirmation → secure digital ticket → staff scans and validates entry.

These are candidate slices, not final commitments. Confirm payment, table service, waitlist, concession and integration scope through interviews and technical validation.

## Explicit exclusions until approved
No third target industry; no generic ERP/POS replacement; no delivery marketplace; no cinema content distribution/DRM; no payroll or employee surveillance; no dynamic pricing; no loyalty/advertising marketplace; no unvalidated multi-country compliance claims.

## Success metrics
- Staff minutes per 100 transactions spent taking/re-entering orders or tickets.
- Guest median and P90 waiting time.
- Transactions per staff-hour.
- Error, rework, cancellation, refund and void rates.
- Restaurant order throughput and cinema occupancy/concession attachment.
- Adoption share of eligible transactions.
- Net operating benefit after software, payment, hardware and support costs.
- Product: successful transaction rate, duplicate-write rate, inventory conflict rate, P95 latency, availability, recovery and accessibility.

## Discovery gates
Interview and observe owners, managers, frontline staff and guests in both verticals; map workflows and exceptions; quantify costs; review competitors and existing systems; validate willingness to pay; identify integrations and legal/privacy requirements; select pilot venues; approve PRD, prototype, architecture, threat model and acceptance criteria.

A capability is done only when the end-to-end workflow, failure paths, roles, audit, accessibility, performance, monitoring, support and measurable outcome have been tested.
