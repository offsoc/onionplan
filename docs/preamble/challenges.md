# Onion Service research challenges

## About

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

1. Pluggable discoverability (multiple naming systems).
2. Many other enhancements in usability and tooling.

The rest of this research deals with **how to get these in place**!

## Current context

As of September 2023,

* The usability improvements of Onion Services still presents outstanding
  challenges that are being discussed for years. Now that the [protocol v3][] is
  successfully deployed, it's a good time to think in the roadmap scenarios
  for the next steps.
* There's a common feeling similar to when the privacy-aware internet was
  moving from HTTP to HTTPS, but now with Onion Services! Perhaps not in the
  same scale, but still related in terms of scope.
* For some desired features, the roadmap seems to be stalled, not only for the
  lack of developers but also because we're missing a "perfect" solution that
  we never (and may never) find.
* Now there's an Onion Service Working Group at Tor, which takes care of
  converging Onion Service development happening on multiple teams.
* In terms of governance, Tor cannot be responsible for things like domain issuance:
  it cannot be authoritative (Tor just makes the software, don't run the
  network and cannot issue Onion Names) and it's a non-profit (cannot have a
  revenue out of Onion Names issuance), which makes even harder to decide who
  else could be responsible (or finding solutions that do not rely on any
  authoritative instance) for it and how development could be sustained.
* Part of The Onion Plan was incorporated into Tor's Strategic Plan for 2023:
    * _Goal 2 (product) - Objective 2 (any person on the planet be able to use Tor
      to access any online service)_:
        * Key Result 1 - _Health of onion services its improved, onion names plan
          draft is concluded_.

Converging the planning, the fundraising strategy and an adoption campaign can
help put things moving forward again.

[Tor Onion Services]: https://community.torproject.org/onion-services/
[protocol v3]: https://spec.torproject.org/rend-spec-v3
