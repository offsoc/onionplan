---
title: Onion Plan retrospective and perspectives
subtitle: 2024 Portugal meeting
date: 2024-05-21
institute: Tor Project - https://torproject.org
upstream: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/issues/29
author:
  - name: Silvio Rhatto
slides:
    #aspect-ratio: 169
    font-size: 11pt
    table-of-contents: false

---

# Intro

## Session goals

1. Inform the community about what we've done, what we plan to do,
   the challenges ahead and the open questions about Onion Services.
2. And then get some input from people :)

## Onion Plan?

* **What**: The Onion Plan is an _applied research_ to _help and facilitate_
  Onion Services improvement.
* **Why**: discussions often gets easily dispersed and buried; there's a need
  to keep track of many options and how to translate those into funding
  projects.
* **How**: collecting and analyzing proposals; building roadmap scenarios.
* **Who**: it's a multi-team effort and everyone can collaborate. Currently
  it's happening mostly on Community and Network teams.
* **When**: discussions on Onion Service improvements happens for years and
  years; we started organizing it during 2022.

# Overview

## Tracks

The Onion Plan is mostly split into four tracks:

1. Outreach.
2. Usability.
3. Tooling.
4. Network Layer.

## Updates

* The current presentation builds up on the previous slides available at
  [https://gitlab.torproject.org/tpo/onion-services/onionplan/-/tree/main/slides][]

![ ](2024.Q2/images/slides.png){ width=150px height=150 }

* Watch out for many QR codes ahead!

[https://gitlab.torproject.org/tpo/onion-services/onionplan/-/tree/main/slides]: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/tree/main/slides

# Retrospective

## Outreach

* Onion Services Ecosystem.
* New Featured Onions.
* 20th Years blog post? Many reasons to celebrate :)

[https://community.torproject.org/onion-services/ecosystem]: https://community.torproject.org/onion-services/ecosystem/
[https://community.torproject.org/onion-services/ecosystem/research]: https://community.torproject.org/onion-services/ecosystem/research/

## Outreach - The Ecosystem

* We unified almost all docs into the Onion Services Ecosystem:
  [https://community.torproject.org/onion-services/ecosystem][].

![ ](2024.Q2/images/ecosystem.png){ width=150px height=150px }

* Onion Plan now have a canonical location:
  [https://community.torproject.org/onion-services/ecosystem/research][].

## Outreach - Featured Onions

* Amnesty International now available as .onion:
  [http://amnestyl337aduwuvpf57irfl54ggtnuera45ygcxzuftwxjvvmpuzqd.onion][] (and fits well in a QR code!):

![ ](2024.Q2/images/amnesty.png){ width=150px height=150px }

* Another major project is about to release it's onionsite.

[http://amnestyl337aduwuvpf57irfl54ggtnuera45ygcxzuftwxjvvmpuzqd.onion]: http://amnestyl337aduwuvpf57irfl54ggtnuera45ygcxzuftwxjvvmpuzqd.onion/

## Outreach - 20 years again?

Year | Event
-----|---------------------------------------------------------------------------
2003 | Hidden Service draft spec ([rendezvous][])
2004 | Hidden Service initial implementation on tor 0.0.6pre1 - 2004-04-08

We missed the opportunity last year, but it's still time to celebrate the 20th years anniversary!

Shall we make a blog post?

[rendezvous]: https://gitlab.torproject.org/tpo/core/tor/-/commit/3d538f6d702937c23bec33b3bdd62ff9fba9d2a3

## Usability

* Onion Discovery Research.
* Quality Assurance for Onion Services in Tor Browser.

## Usability - Onion Discovery

* Research project proposal to investigate how Tor improve Onion Services'
  discoverability (duration: 2 years).

* Goals: provide roadmap scenarios, studies, reports and guidelines supporting
  this technology, ready to be used by Tor to implement the functionality.

* Non-goals: do the actual Onion Discovery implementation in Tor.

* Technical and governance criteria for evaluating proposals.

* Detailed study/evaluation/report for relevant service discovery proposals.

* Study and/or spec for an Onion Discovery subsystem for Tor, with
  suggestions in how applications like Tor Browser and Tor VPN can use it.

* Roadmap scenarios for implementing one or more proposals, ready to use by the
  Network and Application Teams to plan ahead.

## Usability - Tor Browser Onion QA

* The TB .onion QA started informally in the beginning of 2023, then was
  included on Sponsor 145.

* Goals: checking that Tor Browser is working as expected with Onion Services,
  and reporting otherwise.

* Around 8 security issues were identified, and 1 about documentation.

* Most of the findings are still confidential tickets until they get a fix.

* We were unable to setup the planned "Faulty Onions" project to provide test
  Onion Services with different errors to check how Tor Browser and other
  clients handles them.

## Tooling

* Onionspray: a fork from EOTK.
* Oniongroove: working prototype in Arti (experimental).
* Certificate updates (quick summary on ACME for Onions).

## Tooling - Onionspray

* An onionsite manager based on EOTK.
* Why we forked?
* Improvements: MetricsPort, DoS protections, Circuit ID exporting,
  Onionbalance v3 support, revamped docs, improved installation, security
  updates.

## Tooling - Oniongroove

* The next generation onionsite manager.
* Basic prototype implemented using Arti, OpenResty/Lua and some Python.
* Modularized architecture could allow us to support many backends and
  deployment strategies.
* [https://community.torproject.org/onion-services/ecosystem/apps/web/oniongroove][]

[https://community.torproject.org/onion-services/ecosystem/apps/web/oniongroove]: https://community.torproject.org/onion-services/ecosystem/apps/web/oniongroove/

## Tooling - Certificates

* ACME for Onions ([draft-ietf-acme-onion][]) is a priority for Onion Services.
* Quick summary from Q's session in the morning.

[draft-ietf-acme-onion]: https://datatracker.ietf.org/doc/draft-ietf-acme-onion/

## Network Layer

* PoW has arrived!
* Onion Services in Arti: status update.
* Onionprobe: improved dashboard.
* Some numbers.

## Network Layer - PoW

* Blog post: [Introducing Proof-of-Work Defense for Onion
  Services](https://blog.torproject.org/introducing-proof-of-work-defense-for-onion-services/).
* FAQ: [https://community.torproject.org/onion-services/ecosystem/technology/pow][].
* C Tor:
  * Still not much idea on adoption.
  * Needs further testing.
  * Need to figure out how to have load balancing with PoW: [tpo/onion-services/onionbalance#13][].
* Arti:
  * Much of the work is done.
  * Needs the final integration.

[tpo/onion-services/onionbalance#13]: https://gitlab.torproject.org/tpo/onion-services/onionbalance/-/issues/13
[https://community.torproject.org/onion-services/ecosystem/technology/pow]: https://community.torproject.org/onion-services/ecosystem/technology/pow/

## Network Layer - Onion Services in Arti

* Basic server-side functionality is implemented.
* Vanguards implemented: lite enabled by default, full also supported.
* Upcoming work:
  * Basic DoS protections (memory-based).
  * Client authentication.
  * Single hop mode.
  * Working towards feature-parity.
* What we need:
  * More people trying out and reporting bugs:
    * Especially people that wants to build applications with Onion Services.
    * Especially adventurous and security-wise people.

## Network Layer - Onionprobe

Onionprobe -- an Onion Services monitoring tool "from the outside" -- got an enhanced dashboard:

![ ](2024.Q2/images/dashboard.png){ height=60% width=60% }

## Network Layer - some numbers

* Lowest, average and max. latencies (descriptor fetches and full connections)
  for the onionsites we monitor. Ongoing DoS and HSDirs being a bottleneck sometimes.
* We could discuss how to get better diagnostics and improve the situation.

![ ](2024.Q2/images/latencies.png){ width=111px height=171px }

# Perspectives

## 2025-2030 Strategy

Adapted from the slides presented by Isabela and Micah at the 2024-04-10
All-Hands:

* Future-proofing and resilience: enhancements such as advanced metrics,
  circuit timeouts and profiling implemented; Onionprobe ported to Arti;
  Development work completed to ensure Onion Services remain secure in the
  post-quantum computing era, safeguarding privacy and confidentiality.

* Performance improvements: scalability, latency and resilience.

* Expanding adoption: crucial dependencies for expanding adoption such as Onion
  names and service discovery; Onionspray has replaced EOTK; ACME for Onions
  (certificates for Onion Services is free and widely available).

* Usability research has been completed to identify and address areas for
  improving user experience.

* Clarity exists around the implementation of Oniongroove for streamlining its
  functionality and effectiveness.

## What else?

We could consider an ambitious scenario:

* Onion Discovery prototypes. Risk to not achieve this until 2030: high. But we
  may have conditions to start this from 2027 onwards.

# Q&A

:)
