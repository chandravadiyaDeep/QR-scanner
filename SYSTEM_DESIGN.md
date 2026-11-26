# System Design — Restaurant OS and Cinema OS

## Experience model
One shared account/platform foundation with two differentiated business experiences. Business onboarding selects restaurant or cinema; vocabulary, workflows, permissions and reports remain domain-specific.

## Restaurant guest journey
1. Scan table QR or open venue link.
2. Confirm correct venue, branch and table context.
3. Browse current menu, prices, dietary/allergen information and availability.
4. Add items/options and review.
5. Submit once and receive accepted, pending or failed state.
6. Track preparation/ready/served status where enabled.
7. Request staff assistance at any point.

## Restaurant staff and owner
Staff see prioritised live orders, route/prepare/update them by role, and handle unavailable items, changes and exceptions with audit history. Managers configure branches, tables, menus, hours and roles; monitor wait, preparation, throughput, cancellations, bottlenecks and adoption.

## Cinema guest journey
1. Open cinema link or QR.
2. Select film, language/format, date and showtime.
3. View accurate auditorium seat map.
4. Select seats and acquire temporary hold.
5. Complete approved booking/payment flow.
6. Receive digital ticket with secure validation credential.
7. Present ticket at entry; optionally pre-order concessions.

## Cinema staff and owner
Staff scan tickets and see valid, used, cancelled, expired or unknown states distinctly. They resolve exceptions with role checks and audit. Managers configure films, showtimes, auditoriums and seat maps; monitor occupancy, booking conversion, entry throughput, concession attachment, refunds and exceptions.

## Shared interaction standards
Mobile-first, accessible, multilingual-ready; clear confirmation before irreversible actions; no false success while pending; explicit loading/empty/error/retry/offline states; glanceable staff workflows; human support path; no mandatory app installation for core guest journeys.

## Operational state machines
Define allowed transitions, actor permissions, timestamps and audit for restaurant order, payment, kitchen fulfilment, waitlist and seating; cinema seat hold, booking, payment, ticket, admission and concession fulfilment. Never conflate these states.

## Reporting
Show time window, denominator and data freshness. Separate actuals from estimates. Do not label estimated labour savings as realised savings. Compare baseline and post-adoption periods with comparable days, hours and volumes.

## UX validation
Test in busy conditions on older devices, small screens and weak networks. Include accessibility, scanning conditions, multilingual content, support and exception handling.
