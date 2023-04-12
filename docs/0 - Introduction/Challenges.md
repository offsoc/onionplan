# The challenges

## Index

[TOC]

## Objectives

<!--
***Have you ever considered that we work with one of the coolest technologies?***
***And that our job consists in making it even cooler?***
-->

**Imagine** a **communication technology** that has:

1. Built-in resistance against surveillance, censorship and denial of service.
2. Built-in end-to-end encryption.
3. A huge address space (maybe bigger than IPv6) without allocation authority.
4. Support for multiple, pluggable naming systems.
5. And that also works as an anonymization layer.

<!--
We may call this technology **Enhanced Onion Services**,

Onion Services is not just an anonymization technology, but much more than
that: it's a communication layer that can offer *protection against
surveillance, censorship and DoS* with *built-in anonymity in the Onion Service
protocol*.
-->

## What is still missing?

While some of these properties are already implemented for [Tor Onion
Services][], there are still some building blocks and enhancements
still missing:

1. Built-in DoS resistance.
2. Pluggable discoverability (multiple naming systems).
3. Many other enhancements in usability and tooling.

The rest of this research deals with **how to get these in place**!

## Current context

As of December 2022,

* The usability improvements of Onion Services still presents outstanding
  challenges that are being discussed for years. Now that the [protocol v3][] is
  successfully deployed, it may be the time to think in the roadmap for the next
  steps.
* There's a common feeling similar to when the privacy-aware internet was
  moving from HTTP to HTTPS, but now with Onion Services! Perhaps not in the
  same scale, but still related in terms of scope.
* But the roadmap seems to be stalled, not only for the lack of developers but
  also because we're missing a "perfect" solution that we never (and may never)
  find.
* There's no Onion Service team at Tor: right now Onion Service
  development is split in multiple teams with their own existing roadmaps.
* At the same time, Tor cannot be responsible for things like domain issuance:
  it cannot be authoritative (Tor just makes the software, don't run the
  network and cannot issue Onion Names) and it's a non-profit (cannot have a
  revenue out of Onion Names issuance), which makes even harder to decide who
  else could be responsible (or finding solutions that do not rely on any
  authoritative instance) for it and how development could be sustained.

Converging the planning, the fundraising strategy and an adoption campaign can
help put things moving forward again.

[Tor Onion Services]: https://community.torproject.org/onion-services/
[protocol v3]: https://spec.torproject.org/rend-spec-v3
