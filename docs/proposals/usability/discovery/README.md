# Onion Discovery

## About

This document organizes knowledge about the various proposed service discovery
for Onion Services, including naming systems.

This page is meant to be used by researchers, developers and anyone else
interested in this topic as well as to aid decision-making and roadmapping.

## What is Onion Discovery?

In the context of Onion Services, service discovery means a way that users can
easily get the right .onion address for the site or service they want to
access.

It is basically a way to map the big random-looking onion addresses into human
readable names.

For example you can imagine the following useful map:

    torproject -> http://2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion

That way, users can just write `torproject` in their browser instead of having
to remember that big string.

While it's possible to use the so-called _Naming Systems_ to provide a way for
this discovery, there are also techniques where the regular site (like
`torproject.org`) can itself announce it's .onion counterpart. We call this
broad range of techniques to translate semantically meaningful names into Onion
Services addresses as "Onion Discovery", i.e, Onion Discovery is service
discovery for Onion Services.

There are many proposals out there describing how this discovery can be done,
which are categorized and described below.

## Categorization

There are many ways to sort all proposals, especially by what type of problems
they try to solve. In this documentation they're grouped by:

1. [Address translation][]: links a "traditional" domain name with an Onion
   Service address. Examples:
    * Onion-Location Header.
    * Sauteed Onions.
    * DNS or DNSSEC-based.
    * Alt-Svc.
2. [Onion Names][]: alternative schemes for human-friendly names linked with
   Onion Services. Examples:
    * Ruleset-based (like Secure Drop's list).
    * Blockchain-based (like Namecoin).
    * Other P2P-based (like GNUnet's LSD).

[Address translation]: translation.md
[Onion Names]: onion-names.md

## Coexistence between proposals

It's possible to make proposals to coexist, which needs:

1. For Address translation: **opportunistic lookup** to link human-friendly
   names with Onion Service addresses. We do not have any reason to stick to
   just a single address translation method.  Ideally we could support
   smart/opportunistic/pluggable address discovery, prioritizing some
   discoverability methods and falling back to others; optionally cross-checking
   if different methods returns the same address.
3. For Onion Names: **namespace allocation** for each Onion Name
   implementation.

## Integrations

There are a few of ways that service discovery methods can be integrated in
clients such as Tor Browser:

1. As a client plugin, such as a [WebExtension][].
2. As a proxy middleware, which could translate client requests and then
   forward to the Tor daemon.
3. As a patch or feature implementing service discovery functionality directly
   into the Tor daemon, such as [Proposal 279][].

In theory, all these integration types are non-conflicting and could be used
simultaneously, each one handling it's own set of discovery methods and
namespaces, but for practical and sustainability purposes it may be desirable
to limit these integrations.

One requirement for any integration is that all non-local queries must happen
via Tor for privacy preserving reasons.

[WebExtension]: https://wiki.mozilla.org/WebExtensions

### Proposal 279

[Proposal 279][] -- A Name System API for Tor Onion Services (Tor NS API) -- is
a design on how multiple service discovery resolution approaches can be
integrated, implementing a "___pluggable discoverability___" infrastructure.

As of October 2022 this is still a proposal which need further development
before a decision can be made and to convert it into a full specification.

Some relevant threads on `tor-dev` mailing list contains many suggestions,
ideas and open questions about it:

* 2016 October: [Proposal 274 (sic): A Name System API for Tor Onion Services](https://lists.torproject.org/pipermail/tor-dev/2016-October/011514.html)
* 2017 March:   [Comments on proposal 279 (Name API)](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)
* 2017 April:   [Comments on proposal 279 (Name API)](https://lists.torproject.org/pipermail/tor-dev/2017-April/012126.html)
* 2017 March:   [Prop279 and DNS](https://lists.torproject.org/pipermail/tor-dev/2017-April/012146.html)

While it still needs revision and improvements, some sample implementations of
[Proposal 279][] already appeared:

* [meejah/TorNS: prototype/proof-of-concept to implement Proposition 279 w/o changing Tor](https://github.com/meejah/TorNS)
* [namecoin/StemNS: Implement Proposition 279 (Pluggable Naming) w/o changing Tor (Stem port)](https://github.com/namecoin/StemNS)

They rely on the [Tor Control Protocol][], i.e, they're not patches to
implement the NS API directly into the Tor daemon, but controllers that catches
requests for name resolution and dispatches then to plugins.

Some proof-of-concept (PoC) plugins for [Proposal 279][] also exist:

* [pickfire/banana: Hosts client plugin for Tor NS API](https://github.com/pickfire/banana)
* [namecoin/ncprop279: Bridge between Tor Prop279 (Pluggable Naming) clients and Namecoin](https://github.com/namecoin/ncprop279)
* [namecoin/dns-prop279: Bridge between Tor Prop279 clients and DNS servers](https://github.com/namecoin/dns-prop279) ([info](https://www.namecoin.org/2017/06/21/tor-prop279.html))

Both the [Proposal 279][] prototype implementations and the PoC plugins still
only support the former v2 Rendezvous specification, which means that they
don't work with v3 Onion Services.

Anyway, even if the [Proposal 279][] and it's existing implementations are
under research, they offer a concrete way to build service discovery supporting
many methods and technologies.

Check for the [Proposal 279 fixes and improvements][] appendix for a detailed
analysis in what still needs to be addressed.

[Proposal 279]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/279-naming-layer-api.txt
[Tor Control Protocol]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/control-spec.txt
[Proposal 279 fixes and improvements]: ../../../appendixes/prop279.md

## Official and non-official support

Integrations such as [Proposal 279][] does not state which service discovery
(or naming) systems should be officially supported by Tor and which can only
be used if manually installed and configured by the user.

Currently there's no official policy for deciding which systems can or cannot
be supported, and the following section states some required, desired and
undesired properties that have appeared in many discussions.

## Required, Desired and Dream/Bluesky properties for official support

This is a still incomplete effort to build a common property list to evaluate
proposals with the following types:

* *Required*: basic requirements.
* *Desired*: what would be nice to have.
* *Dream/Bluesky*: what would be great, but currently not practical or achievable.

### Common for both Traditional address translation and Onion Names

Property                       | Type     | Description                                                                                             | Source
-------------------------------|----------|---------------------------------------------------------------------------------------------------------|------------------------------------
Privacy-enhanced queries       | Required | Querying for an address does not leaks user-identifiable information                                    | This document
Self-authentication            | Desired  | Approaches that lose the self-authenticating property should have a high bar for deployment[^self-auth] | This document
Censorship resistance          | Desired  | Censorship-resistant service discovery (censors cannot block lookup)                                    | This document
Human-friendliness             | Required | Support for names that are easy to remember and to type                                                  | [Sauteed Week - Applications][]
Discoverability                | ?        | ?                                                                                                       | [Sauteed Week - Applications][]
Anonymity                      | ?        | ?                                                                                                       | [Sauteed Week - Applications][]
Hijacking resistance           | ?        | ?                                                                                                       | [OnionV3ux - 2018 Mexico Meeting][]
State on client system         | ?        | ?                                                                                                       | [OnionV3ux - 2018 Mexico Meeting][]
Usable                         | ?        | Implementation has good usability                                                                       | [OnionV3ux - 2018 Mexico Meeting][]

[Sauteed Week - Applications]: https://gitlab.torproject.org/rhatto/sauteed-week/-/blob/main/docs/applications.md
[OnionV3ux - 2018 Mexico Meeting]: https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2018/2018MexicoCity/Notes/OnionV3ux
[^self-auth]: That means we're looking for discovery approaches where the
              .onion address is signed by the Onion Service privkey, so it's possible to
              check that the Onion Service operator(s) asserted the relationship between
              their service and the address translation record.

### Address translation specific

Property                       | Type     | Description                                                                                  | Source
-------------------------------|----------|----------------------------------------------------------------------------------------------|-----------------------------------
Enumeration                    | ?        | The system allows to enumerate existing names                                                | [Sauteed Week - Applications][]

### Onion Names specific

Property                       | Type     | Description                                                                                  | Source
-------------------------------|----------|----------------------------------------------------------------------------------------------|-----------------------------------
Non-conflicting                | Required | Implementations should not conflict with each other or existing naming systems               | This document
Global names                   | Required | Globally-consistent mappings                                                                 | This document
Strong integrity guarantees    | Required | Naming system must provide strong authenticity/integrity verifications                       | This document
Distributed name management    | ?        | Naming system should not be centralized                                                      | This document
Certified service discovery    | ?        | There is some way to check the domain authenticity                                           | This document
(Retro-)Compatibility          | ?        | (Backwards-)Compatible with existing naming schemes                                          | This document
Future-proof                   | ?        | Should be future-proof or present scenarios for migrating names to new systems in the future | This document
Anonymous registrations        | Required | Name registration and configuration without disclosing user/service identifiable information | This document
Solves [Zooko's triangle][]    | Desired  | Provides human-meaningful names, system is decentralized and secure                         | This document
Phishing resistance            | Desired  | Naming system offer protections against phishing attacks                                     | [OnionV3ux - 2018 Mexico Meeting][]
Enumeration resistance         | ?        | The naming system cannot provide an (easy) way to enumerate existing names                   | [OnionV3ux - 2018 Mexico Meeting][]

Additional questions that may be converted into wanted/unwanted properties:

1. Who/which system is delegated the authority to create and optionally certify
   Onion Names?
2. Which test is made during certification?
3. Which situations will end up with a human making a decision about whether a
   given address gets to stay on the list or not? Does the solution avoids a
   situation where a human is capable of vetting or not any address?

[Zooko's triangle]: https://en.wikipedia.org/wiki/Zooko's_triangle

## Roadmapping

A roadmap for improving service discovery can be split in two parts:

1. Making sure that clients or the Tor daemon implementations have built-in
   integrations offering an uniform API (such as [Proposal 279][]) for plugging
   service discovery methods.
2. Developing (or enhancing existing) service discovery methods.

Once the first step is done, incremental roadmaps can bring more service
discovery methods into production state.

Depending on the adoption criteria, some of these methods can in the future be
incorporated as officially supported by Tor.

## Further references

### Meeting notes

* [OSUX - Onion service user experience problems](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Amsterdam/Notes/OSUX)
  from the [2017 Amsterdam](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Amsterdam).

* [IntegratingOnions](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Montreal/Notes/IntegratingOnions)
  from the [2017 Montreal Meeting](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Montreal/).

### Procedures

* [Getting an Onion Name for Your SecureDrop](https://securedrop.org/faq/getting-onion-name-your-securedrop/).

### Specs and proposals

* `[HUMANE-HSADDRESSES-REFS]` from [rend-spec-v3](https://spec.torproject.org/rend-spec-v3).
* [Drafting a proposal for mnemonic onion URLs](https://archives.seul.org/or/dev/Dec-2011/msg00034.html).
* The [.onion nym system](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/ideas/xxx-onion-nyms.txt).

### Issues

* HTTPS-Everywhere and phasing out of HTTP-only connections (relevant since the HTTPS-Everywhere deprecation):
  * [Integrate https-everywhere-lib-core (#40458) · Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40458).
  * [Officially support onions in HTTPS-Everywhere (#28005) · Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/28005).
  * [onion everywhere (#19812) · Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/19812).
  * [Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues?scope=all&state=closed&label_name[]=HTTPS%20Everywhere).
  * [Disable Plaintext HTTP Clearnet Connections (#19850) · Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/19850).
