# Onion Names

## Index

[TOC]

## About

Onion Names are human-memorable mappings to Onion Service addresses.
Apart from traditional DNS-based domains, Onion Names may be provided by
different systems, taking into account that:

* There may be no ideal solution, so the question is which are acceptable
  solutions that can coexist.
* Each solution needs to have it's own namespace.
* Each implementation can have an it's own adoption cycle (proposal,
  evaluation etc).
* Each solution category/technology (ruleset-based, blockchain-based etc) can
  also have it's own discussion criteria for evaluating proposals.

## Namespace allocation

Regarding namespace allocation, there are many possible options, including (but
not limiting to):

1. Allocate second-level domains atop of the existing `.onion` ([RFC 7686][]), such
   as what happens with [SecureDrop][] Onion Names (`.securedrop.tor.onion`).
2. Use whichever TLD provided by each Onion Names solution.
3. Use a second-level domains atop of the proposed `.alt` top-level
   ([draft-ietf-dnsop-alt-tld-08][]).

There are [discussions][] about whether Onion Names should all be under
`.onion` or have their own namespaces, especially considering
[draft-ietf-dnsop-sutld-ps-03][], [RFC 7686][] and other documents specifying
what's officially supported by internet standard bodies such as IETF and IANA.

In the scope of [Proposal 279][], for instance, it's possible to imagine a
scenario where official allocation happens as second-level namespaces of
`.onion`, while other namespaces could be manually configured by users.

[RFC 7686]: https://www.rfc-editor.org/info/rfc7686
[draft-ietf-dnsop-alt-tld-08]: https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-alt-tld-08
[draft-ietf-dnsop-sutld-ps-03]: https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-sutld-ps-03
[discussions]: https://lists.torproject.org/pipermail/tor-dev/2017-April/012126.html
[Proposal 279]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/279-naming-layer-api.txt

## Overview

Method                     | Technology | Existing namespaces                                         | Status
---------------------------|------------|-------------------------------------------------------------|----------------------------------
Onion Names for Securedrop | Ruleset    | .securedrop.tor.onion                                       | Implemented, officially supported
Namecoin                   | Blockchain | .bit                                                        | Development
Dappy                      | Blockchain | .d                                                          | Research
Stacks                     | Blockchain | ?                                                           | Research
Kusama                     | Blockchain | ?                                                           | Research
Unstoppable Domains        | Blockchain | .crypto .nft .x .wallet .bitcoin .dao .888 .zil .blockchain | Research
Ethereum Name Service      | Blockchain | .eth                                                        | Research
Handshake                  | Blockchain | -                                                           | Research
Oxen Name System           | Blockchain | ?                                                           | Research
Dapp                       | Blockchain | .dapp                                                       | Research
GNU Name System            | P2P        | .gns                                                        | Research
IPFS                       | P2P        | ?                                                           | Research
OnioNS                     | Other      | .tor?                                                       | Research
OnioDNS                    | Other      | .o                                                          | Research
Dirauth-based              | Other      | ?                                                           | Research
File-based                 | Other      | -                                                           | Research
Tor Browser addon          | Other      | -                                                           | Research

## Ruleset-based

* Ruleset-based Onion Names depends on trust, which is delegated in that
  namespace to the organization managing the ruleset.
* Criteria about who controls each ruleset can be:
  * User-based: equivalent to sharing bookmarks. Trust the authors. But how to
    assign namespaces?
  * Organization/federation based: like [SecureDrop][]: list instances from a widely
    known and relevant platform. Trust the organization. How could be a criteria
    and process for a widely known and relevant organization to have it's ruleset
    namespace?

### Onion Names for SecureDrop

[Onion Names for SecureDrop](https://securedrop.org/news/introducing-onion-names-securedrop/).
is the first implementation of a ruleset-based approach and is maintained by
[SecureDrop][].

It's limited in the namespace it can use, so it does not conflict with other
discovery methods.

It was [originally implemented using HTTPS-Everywhere][], and since mid-2022
it's is [integrated in Tor Browser
core](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40458)
and there's a proposal to edit (and maybe share) rulesets directly in the Tor
Browser interface.

The rulesets are maintained in [this
repository](https://github.com/freedomofpress/securedrop-https-everywhere-ruleset).

[SecureDrop]: https://securedrop.org
[originally implemented using HTTPS-Everywhere]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/28005

### User-supplied petnames

Another proposal for rulesets is to [rely on user-supplied petnames instead of
onion addresses in URL
bar](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40845).

## Blockchain-based

### Namecoin

Namecoin is a fork of Bitcoin:

* [Namecoin timeline for the Tor Browser](https://forum.torproject.net/t/are-there-projected-timelines-for-namecoin-support-being-extended-in-anyway/414)
* [Namecoin for TLS certificate validation](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/33568)
* [Namecoin Threat Model](https://www.namecoin.org/dot-bit/security-model/)
* [Discussion on how merged mining works](https://bitcoin.stackexchange.com/questions/273/how-does-merged-mining-work),
  [this comment](https://bitcoin.stackexchange.com/questions/273/how-does-merged-mining-work#comment59897_275) in special.
* [namecoin/proposals: Standards and Best Practices](https://github.com/namecoin/proposals)

#### Description

Namecoin holds names in a blockchain. Name registration costs a virtual unit, denominated in namecoins.

#### Security Properties

* Privacy-enhanced queries: full-node clients and FBR-C clients (full block
  receive for current registrations) do not generate network traffic on lookups
* Globally unique names
* Backed by computational proof-of-work
* Purely distributed control of names (does not rely on Tor directory
  authorities or Tor relays)
* Authenticated denial-of-existence for full-node clients and FBR-C clients
  (full block receive for current registrations).

#### Drawbacks

* It is non-trivial to anonymously acquire Namecoins, which reduces the privacy
  of domain registration.
* Registrations are only pseudonymous unless Namecoin is used in conjunction
  with an anonymous blockchain such as Monero; decentralized exchanges between
  Monero and Namecoin are not yet deployed, so Monero to Namecoin exchanges
  require some counterparty risk.
* Full-node clients must download the blockchain, which may be impractical for
  some users, and becomes less usable as transaction volume increases.
* No authenticated denial-of-existence for clients that only download block
  headers (this can be fixed with a future softfork).
* Doesn't scale: it grows more secure but less usable as it becomes more
  popular.

### Dappy

* [Dappy – Secure name system powered by blockchain](https://dappy.tech/)
* [Initial message on tor-dev mailing list](https://lists.torproject.org/pipermail/tor-dev/2022-March/014720.html).
* [Subsequent thread on tor-dev mailing list](https://lists.torproject.org/pipermail/tor-dev/2021-December/014717.html).

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Stacks (former Blockstack)

* [Blockstack: A Global Naming and Storage System Secured by Blockchains | USENIX](https://www.usenix.org/conference/atc16/technical-sessions/presentation/ali)
* [Blockstack :A decentralized naming and Storage system using blockchain](https://medium.com/coinmonks/blockstack-a-decentralized-naming-and-storage-system-using-blockchain-445ff60190f7)
* [Stacks - DeFi, NFTs, Apps, and Smart Contracts for Bitcoin](https://www.stacks.co/)
* [Stacks blockchain - Wikipedia](https://en.wikipedia.org/wiki/Stacks_blockchain)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Kusama

* [Kusama, Polkadot's Canary Network](https://kusama.network/)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Unstoppable Domains

* [Unstoppable Domains](https://unstoppabledomains.com/)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Ethereum Name Service (ENS)

* [Ethereum Name Service](https://ens.domains/)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### CONIKS

* [CONIKS](https://coniks-sys.github.io/) website.
* [CONIKS Paper: Bringing Key Transparency to End Users](https://eprint.iacr.org/2014/1004)
  ([USENIX mirror](https://www.usenix.org/system/files/conference/usenixsecurity15/sec15-paper-melara.pdf)).

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Handshake

* [Handshake](https://handshake.org/)
* [Handshake Domains: Blockchain Powered DNS Is Here, But Should You Use It?](https://www.howtogeek.com/devops/handshake-domains-blockchain-powered-dns-is-here-but-should-you-use-it/)
* [Feature request: TB support Handshake (#40356) · Issues · The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40356)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Oxen Name System (ONS)

* [Using Oxen Name System (ONS) - Oxen Docs](https://docs.oxen.io/using-the-oxen-blockchain/using-oxen-name-system)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Dapp

* [DappReg - secure your .dapp name now](https://dappreg.com/)
* [ODAR.io - Oped Dapp (decentralized apps) Registry Official Homepage](https://odar.io/)

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

## Based on other technologies

### The GNU Name System (GNS)

#### Description

GNS uses a hierarchical system of directed graphs. Each user is node in the graph and they manage their own zone:

* [The GNU Name System](https://lsd.gnunet.org/lsd0001/)
* [The GNU Name System](https://www.ietf.org/id/draft-schanzen-gns-10.html) (IETF)
* [draft-schanzen-gns-10 - The GNU Name System](https://datatracker.ietf.org/doc/draft-schanzen-gns/)
* [The GNU Name System](https://tools.ietf.org/id/draft-schanzen-gns-01.html)

#### Security Properties

* Peer-to-peer design.
* Individuals are in charge of name management.
* Resistant to large-scale Sybil attack.
* Resistant to large-scale computational attack.

#### Drawbacks

* No guarantee that names are globally unique.
* Difficult to choose a trustworthy zone.
* The selection of a trustworthy zone centralizes the system.

### InterPlanetary Naming System

#### Description

A naming system for IPFS. Can suit for .onion too.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### OnioNS

The Onion Name System, a New DNS for Tor Onion Services:

* Documentation:
  * [Jesse-V/OnioNS-literature: The Onion Name System - academic literature](https://github.com/Jesse-V/OnioNS-literature)
  * [thesis.pdf](https://raw.githubusercontent.com/Jesse-V/OnioNS-literature/master/thesis/thesis.pdf)
  * [conference.pdf](https://raw.githubusercontent.com/Jesse-V/OnioNS-literature/master/conference/conference.pdf)
* Code:
  * [Jesse-V/OnioNS-server: The Onion Name System - networking protocols](https://github.com/Jesse-V/OnioNS-server)
  * [Jesse-V/OnioNS-client: The Onion Name System - Tor Browser integration](https://github.com/Jesse-V/OnioNS-client)
  * [Jesse-V/OnioNS-HS: The Onion Name System - hidden service functionality](https://github.com/Jesse-V/OnioNS-HS)
  * [Jesse-V/OnioNS-common: The Onion Name System - common dependency](https://github.com/Jesse-V/OnioNS-common)
  * [Jesse-V/OnioNS-www: The Onion Name System - project website](https://github.com/Jesse-V/OnioNS-www)
  * [Jesse-V/tor-launcher: Fork of tor-launcher, adapted for OnioNS-client](https://github.com/Jesse-V/tor-launcher)

#### Description

OnioNS, pronounced "onions", is a privacy-enhanced and metadata-free DNS for
Tor onion services. It is also backwards-compatible with traditional .onion
addresses, does not require any modifications to the Tor binary or network, and
there are no central authorities in charge of the domain names. OnioNS was
specifically engineered to solve the usability problem with onion services.

This project was described in the paper "The Onion Name System: Tor-Powered
Decentralized DNS for Tor Onion Services", which was accepted into PoPETS 2017.
OnioNS also supports load-balancing at a name level. Development currently
takes place on Github.

#### Security Properties

* Anonymous registrations - OpenPGP key is optional, no personal information
  required.
* Privacy-enhanced queries - uses 6-hop circuits.
* Strong integrity - server responses are verified with a Merkle tree.
* Decentralized control - a random set of 127 periodically-rotating Tor nodes
  manage names and publishes the Merkle tree root.
* Globally-unique domain names with consistent mappings.
* Support for authenticated denial-of-existence responses.
* Server-server communication uses circuits.
* Preloaded with reserved names to avoid phishing attacks.
* Uses the latest block in Bitcoin as a CSPRNG.
* Resistant to Sybil attacks.
* Resistant to computational attacks.

#### Drawbacks

* Users must install the software into the Tor Browser.
* Requires participation from Tor relay administrators.
* Users must trust a selection of Tor relays, Tor directory authorities, and
  Bitcoin during a query.

### OnionDNS

* [OnionDNS: A Seizure-Resistant Top-Level Domain](https://www.cise.ufl.edu/~traynor/papers/scaife-cns15.pdf)
  ([DOI](https://doi.org/10.1007/s10207-017-0391-z)).

#### Description

To be written.

#### Security Properties

To be evaluated.

#### Drawbacks

To be evaluated.

### Centralized first-come-first-served name cache run by a dirauth

#### Description

Just run a NamingAuth on the network where HSes can go and register their names.
Clients can query the NamingAuth direct, and can also add alternative naming auths.

A bit like the [I2P naming system](https://geti2p.net/hosts.txt)?

#### Security Properties

* Simple and easy.

#### Drawbacks

* Centralized

### Files with aliases

#### Description

Just hosts-like files with pairs `<human-readable name> <identifier>`. Widespread in [I2P][].

[I2P]: https://geti2p.net

#### Security Properties

* Simple.
* Name resolution is done locally.

#### Drawbacks

* Centralized.
* Latent.
* Involves trust to everyone involved in list making.
* Markable. Malicious service can give different users different aliases.

### Tor Browser addon for .onion bookmarks

#### Description

Basically introduce the workflow where our users are supposed to bookmark their
onions so that they remember them next time.

A smart addon here could do it automatically for the users, or something.

#### Security Properties

To be evaluated.

#### Drawbacks

* Need to keep list (or hashes) of visited onions on the client's machine.

### Human Friendly Memorable Mappings

#### Description

This approach is currently just a few ideas in how to encode .onion addresses
using symbols that are easier to memorize:

* Whole phrases as checksums?
* Generating images from the addresses? With an algorithm with special
  statistical properties to ensure acceptable security (like enough variance in
  the generated images).
* Checksums used together with [vanity addresses][]? So people could memorize just
  the checksum and the vanity portion of the address, like a sequence of emojis
  plus a 6 to 8 chars word. In that case, how long should be the emoji sequence?

[vanity addresses]: https://community.torproject.org/onion-services/advanced/vanity-addresses/

#### Security Properties

Far from being used to show a limitation in the Onion Service technology, the
difficulty to represent an .onion address in a human-friendly way could
actually show it's strength.

We can compare the Onion Service address space, or just the "Onion Space", with
other addressing systems, applications and mappings.

The following table is a rough sketch that attempts to summarize some
"human-friendly mappings" and it's applications:

| Applications           | Address space size     | Example mapping type    | Example mapping size   | Collision-resistance               |
| ---------------------- | ---------------------- | ----------------------- | ---------------------- | ---------------------------------- |
| IPv4, Tor bridge lines |   32 bits              | Symbols/Emojis          | 4                      | Total with enough symbols/emojis   |
| [Geocoding][]          |  ~48 bits (?)          | Base32                  | 9                      | Fails for nearby addresses         |
| [Geocoding][]          |  ~48 bits (?)          | Word tuples             | 3 - 5                  | Fails for nearby addresses         |
| Tor Onion Services v2  |   80 bits              | ?                       | ?                      | ?                                  |
| IPv6                   |  128 bits              | ?                       | ?                      | ?                                  |
| Tor Onion Services v3  | ~256 bits              | ?                       | ?                      | ?                                  |

Space size:

* Mapping size refers to the number of elements in the symbol space needed to
  represent (or to be a sufficiently secure checksum for) an address.
* Emojis currently falls in the 32 bit space range (smaller than "street space"
  addressing, i.e, it's a space smaller than our geographic space); emojis can in
  theory be used to represent (or summarize) longer sequences, but that depends
  on both the emoji set size and the maximum length an average user could
  memorize.
* Base32 and word tuples are useful for representing geographic locations in
  a small string, such as an URL parameter. They can be human-memorable if the
  coordinates aren't too precise.
* We don't have anything (as far as I'm aware) from Onion Services v2 onwards.
  I've heard about some people memorizing .onion v2 addresses, but that's not
  a comfortable thing to do for everyone.
* The Onionspace is way bigger than the IPv6 space, so why it's a hard problem
  to create a human-memorable "checksum" or alias!

Onion Names versus other mappings:

* If the human friendly mapping fully represents (i.e. unambiguously, uniquely)
  the address, it's basically equivalent with an Onion Name (of the same
  size?), and effectively works as an alias to that address. In that case,
  the Onion Name has an advantage over other mappings since it can have
  a meaning related to the Onion Service purpose.
* But if the mapping only partially represents the address, it works mainly as
  a "checksum", and that case the mapping is not collision-resistant, as it's
  possible to find two or more addresses having the same mapping.

Collision-resistance:

* For geocoding, collisions depends on the grid resolution when it's done as a
  mapping over a discrete grid. Depending on the grid partition algorithm and
  the resolution in use, points in the surface of earth that are close enough to
  each other tend to have similar (or even the same) representation.

[Geocoding]: https://en.wikipedia.org/wiki/Geocode

#### Drawbacks

This needs further research, to answer questions such as:

* What is the length range (and symbol space size) to consider as inside the
  "human friendly" region?
