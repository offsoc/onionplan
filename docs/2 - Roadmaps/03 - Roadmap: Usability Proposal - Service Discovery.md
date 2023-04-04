# Usability Roadmap - Service Discovery

* Status: DRAFT
* Version: v2022.Q4
* Companion slides: [2022.Q4/discovery.pdf][] and [2022.Q4/discovery-technical.pdf][].

[2022.Q4/discovery.pdf]: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/blob/main/slides/2022.Q4/discovery.pdf
[2022.Q4/discovery-technical.pdf]: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/blob/main/slides/2022.Q4/discovery-technical.pdf

## Index

[TOC]

## Summary

* **Focus:** ***human-friendly*** names for Onion Services with ***HTTPS
  support***.
* **Goal:** ***coexistence*** between different methods and ***opportunistic
  discovery***.
* **Characteristics**: ***pragmatic, modular, incremental, backwards
  compatible, future-proof and risk-minimizing*** phases.

### Phases

| Phase   | Category            | Method                     | Technology       | Status   |
| ------- | ----------          | --------                   | ------------     | -------- |
| 0       | Address translation | Onion-Location v1, Alt-Svc | HTTP             | Done     |
| 1       | Address translation | DNS-based discovery        | DNS              | Planning |
| 2       | Address translation | Sauteed Onions or other    | CT Logs or other | Research |
| 3       | Onion Names         | ?                          | P2P, Blockchain  | Research |

### Decentralization

| Phase   | Method                     | Technology      | Decentralization                                | Comparative level   |
| ------- | --------                   | ------------    | ------------------                              | ------------------- |
| 0       | Onion-Location v1, Alt-Svc | HTTP            | Centralized (a single point of failure)         | 0                   |
| 1       | DNS-based discovery        | DNS             | Very decentralized, but hierarchical            | 1                   |
| 2       | Sauteed Onions?            | CT Logs         | Decentralized, less hierarchical, but few nodes | 2                   |
| 3       | ?                          | P2P, Blockchain | Decentralized, non-hierarchical, many nodes     | 3                   |

### Censorship resistance

| Phase   | Technology      | Censorship resistance                               | Comparative level   |
| ------- | ------------    | -----------------------                             | ------------------- |
| 0       | HTTP            | Does not work when the site is blocked              | 0                   |
| 1       | DNS             | Site can be blocked, but the DNS entry must not     | 1                   |
| 2       | CT Logs?        | Site and DNS entry can be blocked, CT Logs must not | 2                   |
| 3       | P2P, Blockchain | Should be fully censorship resistant                | 3                   |

### Client support

| Client                                    | Phase 1 (DNS-based addresses)        | Phase 2 (Sauteed Onions?)       | Phase 2 (Onion Names)                                              |
| ----------------------------------------- | ------------------------------------ | ------------------------------- | ------------------------------------------------------------------ |
| Tor Browser                               | Fully supported + UI indicator       | Fully supported + UI indicator  | Fully supported + UI indicator                                     |
| Other web browsers                        | Fully supported                      | Fully supported                 | Fully supported                                                    |
| HTTP clients (curl, wget etc)             | Fully supported                      | Fully supported                 | Fully supported                                                    |
| "VPN-alike" clients (Orbot etc)           | Fully supported if ported to mobile  | Fully supported                 | Fully supported                                                    |
| Onionshare                                | No use case for DNS-based addresses  | No use case for Sauteed Onions  | Could allow human-readable download codes, like [magic-wormhole][] |
| Chat (Briar, Ricochet-Refresh, Quiet etc) | No use case for DNS-based addresses  | No use case for Sauteed Onions  | Could allow human-readable "nicknames" built atop Onion Names      |

[magic-wormhole]: https://pypi.org/project/magic-wormhole/

## Phase 0: where we are right now

We're at Phase 0, but not starting from zero! :)

* We have Onion Services v3!
* We have accumulated lots of discussions, proposals and analyses.

We can try a lean/zen approach to the problem:

* Wait until [draft-ietf-dnsop-svcb-https-11][] (similar to *Alt-Svc*, but in
  the DNS) gets RFC status and Firefox fully implements it (needs risk
  assessment for that).
* Then recommend [HTTP DNS resource records for Onion Services][].

If that works out, it will be a **huge usability improvement without having to
develop anything by ourselves**.

But will it work? And how long we'll have to wait for that?

And how long for all clients to implement this (not just Tor Browser)?

Also, this approach:

* May not work because DNS resolution via SOCKS5 (used by Tor Browser) does not
  currently support arbitrary RR besides basic hostname lookup.
* Could work if Tor Browser starts to use [DNS-over-HTTPS (DoH)][https://www.rfc-editor.org/rfc/rfc8484], which has
  its own set of problems to be considered first (performance impact; reduces
  decentralization; blocking happening at DoH providers; etc); the same for
  [DNS-over-TLS (DoT][], which is not even being considered by Mozilla.
* Seems highly dependent on whether [RFC
  7686][https://www.rfc-editor.org/rfc/rfc7686.html] will be honored by clients
  to either use or skip .onion addresses found in HTTPS DNS records.
* Still needs a further and thorough security analysis to evaluate its security properties,
  attack scenarios and mitigations (see [this initial discussion about HTTPS RRs][]).
* Does not pave a way for Onion Names or opportunist discovery of .onion addresses.

As an alternative, the following roadmap is proposed **without counting on any
further/uncertain upstream improvement and without focusing only on Tor
Browser** or Firefox.

[draft-ietf-dnsop-svcb-https-11]: https://datatracker.ietf.org/doc/draft-ietf-dnsop-svcb-https/11/
[HTTP DNS resource records for Onion Services]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325
[RFC 7686]: https://www.rfc-editor.org/info/rfc7686
[this initial discussion about HTTPS RRs]: https://emilymstark.com/2020/10/24/strict-transport-security-vs-https-resource-records-the-showdown.html
[DNS-over-HTTPS (DoH)]: https://support.mozilla.org/en-US/kb/firefox-dns-over-https
[DNS-over-TLS (DoT)]: https://en.wikipedia.org/wiki/DNS_over_TLS

## Phase 1: Onion Service discovery using DNS

### Description

1. A Tor Name System API (Tor NS API) is implemented, maybe based on [Proposal 279][].
2. The first plugin, DNS-based, is written (`[DNSONION]`).
3. HTTPS is supported automatically via TLS SNI: no need to coordinate with
   Let's Encrypt at this point and Operators can use their existing HTTPS
   certificates, unchanged.

[Proposal 279]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/279-naming-layer-api.txt

### Rationale

1. While its extremely difficult to evaluate all Onion Names and to start
   implementing something, Onion Services remains an incredibly difficult
   usage barrier due to the lack of human-friendly aliases.
2. The Onion Plan Phase 1 proposes the simpler and incremental approach to
   solve this problem, while allowing in the future that both address
   translation and pure Onion Names from multiple implementations to coexist
   (backwards compatible).
3. The DNS is there for ages and has all extensions needed (including DNSSEC)
   for creating uni or bi-directional associations between a regular domain
   names and Onion Service addresses: the DNS is basically a key-value distributed
   and hierarchical datastore. It's far from a perfect or preferred system, but
   it's low hanging fruit compared to other techniques.

### Strengths

1. Can work with existing domain names!
2. Works with the existent HTTPS certificates: no need for an ACME for .onions
   at this stage!
3. Easy for Operators to setup: it's as hard as creating/maintaining Onion
   Services and DNS(SEC) entries.
4. Transparent!
5. Minimum (or even no) changes needed in the Tor Browser codebase.
6. Small changes in the Tor daemon implementation ensures only the
   point-of-contact between the resolver and the Tor daemon needs to be
   implemented there via the Tor NS API.
7. By implementing at the Tor daemon level, applications other than the Tor
   Browser can also benefit from the naming resolution.
8. Small additional code included in the Tor daemon implementations make the
   approach sustainable. All naming resolution plugins can be developed as
   separate projects with small and sustainable codebases.
9. Fully compatible with the current address translation techniques like
   Onion-Location and Alt-Svc.

### Weaknesses

1. Dependent on the DNS.
2. DNS-based resolution via Tor is also prone to censorship, but still more
   resistant than a direct block in the site from the point of view of a Tor
   exit node (which would render the `Onion-Location` and the `Alt-Svc` methods
   useless).
3. Service discovery usually involves additional roundtrips.
4. Do not work with .onion-only sites.

### Opportunities

1. Leverage the existing Domain Name System instead of adopting or building an
   entirely new stack. DNS is fast, scalable and ubiquitous and has the
   security extensions needed for an Onion Service discovery scheme with basic
   protection against censorship.
2. Reuse the existing discussions and proposals about where and how to
   implement alternative naming systems (like [Proposal 279][]).
3. Take advantage of the TLS SNI extension to reuse existing HTTPS certificates
   with Onion Services and should be fully compatible with ECH (Encrypted Client
   Hello) after
   [draft-ietf-tls-esni-15][https://datatracker.ietf.org/doc/draft-ietf-tls-esni/]
   gets approved and implemented.
4. Give time for other implementations to mature ([Sauteed Onions][]; Onion
   Names) while providing to the community a practical way to solve the
   human-readability issue of Onion Service addresses.
5. Give users a *more transparent* way to interact with Onion Services, paving
   the way to make the technology more widespread and seem as another
   communication protocol available on the internet and with stronger privacy and
   anti-censorship guarantees.

[draft-ietf-tls-esni-15]: https://datatracker.ietf.org/doc/draft-ietf-tls-esni
[Sauteed Onions]: https://www.sauteed-onions.org

### Threats

1. Lack of interested funders. Mitigations:
    1. Slower development, focusing on a Proof-of-Concept to attract attention
       and showcase the potential.
2. Lack of developers. Mitigations:
    1. Break the roadmap in smaller actionables so it's easier to split in a
       team and find available developers.
3. Lack of traction:
    1. If the implemented domain discovery method does not get adopted enough,
       it can be phased out (or discouraged) by the end of the evaluation
       period.

### Roadmap

1. Work in a Tor NS API specification: review and finish [Proposal 279][] or
   work on a new one:
    * Decide on open issues.
    * Should be changed to:
        * REQUIRE that plugins use Tor to do their queries if those are made
          outside their local network, to increase privacy and censorship
          resistance.
        * Allow for wildcard plugins enable opportunistic service discovery.
        * Keep the "priority" config in order to allow multiple plugins handling
          discoveries of regular domains using different methods.
2. Implement the Tor NS API on C Tor if it's possible to include that in the C
   Tor roadmap and if there's developer availability for that.
3. Implement address translation plugins:
    * `[DNSONION]` for .onion on DNS(SEC) with the proper verifications (and
      write a standard for it).
4. Build an experimental Tor Browser shipped with a Tor daemon configured with
   `[DNSONION]`.
5. Evaluation period with early adoption and funding campaigns.
6. Implement the Tor NS API on arti, perhaps syncing the roadmap when the
arti team is working in the Rendezvous v3 implementation?

The roadmap for this phase may also includes fixes and low-hanging fruit.

### User stories

#### Operator story 1 (Phase 1)

1. Operator has https://something.example.org with a valid HTTPS certificate.
2. Operator setups an Onion Service.
3. Operator adds a special DNS entry associating `something.example.org` with
   the Onion Service address.
4. Operator ensures that `something.example.org` also responds with the Onion
   Service address (server alias).

#### User story 1 (generic HTTP clients or web browsers using Tor as a socks5h proxy, Phase 1)

1. User asks the HTTP client to access `something.example.org`.
2. Request is passed to the Tor daemon.
3. The Tor daemon uses the Tor DNS API to query for `something.example.org` using
   `[DNSONION]`.
4. `[DNSONION]` checks for a special .onion entry in the DNS; the query MUST
   happen via the Tor network, for privacy considerations but also to avoid
   censorship:
   * If the entry is not found:
     * `[DNSONION]` returns that no entry is found.
     * The connection to `something.example.org` is attempted as usual using an
       exit node.
   * If the entry is found:
     * `[DNSONION]` returns the Onion Service address found.
     * The Tor daemon transparently connects to the Onion Service using HTTPS
       and with the `TLS SNI=something.example.org` correctly like in the [Alt-Svc
       method][], so https://something.example.org happens transparently via an Onion
       Service.
5. That means full HTTPS support:
  * When the Tor NS API returns and Onion Service address and the Tor daemon
    connects to it via HTTPS, TLS SNI happens, which means that the certificate
    does not need to be issued for the .onion address!

#### User story 2 (Tor Browser, Phase 1)

1. Same as the previous user story, with:
2. Additional UI indicator/widget to interact with the technology.

#### User story 3 (Orbot, Phase 1)

1. If Phase 1 is implemented also for mobile clients, the behavior should be
   the same as User story 1.

#### User story 4 (Onionshare, Phase 1)

1. On Phase 1, the user won't have support for accessing shared files or
   folders using address translation, because that would require Onionshare to
   configure regular domain names, which is out of scope.

#### User story 5 (Chat client using Onion Services, Phase 1)

1. On Phase 1, the user won't have support for finding other users via address
   translation, because that would require clients such as Briar, Quiet or
   Ricochet-Refresh to configure regular domain names, which is out of scope.

[Alt-Svc method]: https://blog.cloudflare.com/cloudflare-onion-service/

### Questions

1. In which sense is this better than simply using the `Onion-Location` or the
   `Alt-Svc` headers?
    * DNS queries that happen via Tor are less prone to censorship than trying to
      access the site directly via and exit node (the exit node may be under
      censorship).
    * DNS queries tend to be faster than waiting for HTTP headers.
2. Can this phase be skipped to the next?
    * The `[DNSONION]` plugin can be safely skipped or postponed to a later phase.
    * What is really required in this phase is to implement the Tor NS API which
      may be used in the following phases, but having no plugin at this phase
      won't start solving the usability problem, but instead leaving setting up
      plugins to the community.
3. Why insist on changes in the Tor daemon code instead of focusing just in the
   Tor Browser?
    * Besides the fact the we should avoid implementing new features into C Tor
      in favor of arti, it's harder and harder to keep pace with the Firefox
      codebase during Tor Browser development ([829 open issues for Tor
      Browser][] against [329 for C Tor][] as of 2022-10-12).
    * With the minimum effort needed it's possible to implement the Tor NS API
      directly into the Tor daemon codebases, alleviating the Applications Team
      to keep this logic in a client whose future is not as certain as the daemons.
    * Having the implementation at the daemon level ensures that any client (and
      not only the Tor Browser) can benefit from transparent Onion Service
      discovery.
4. Can the Tor NS API be implemented only on arti?
    * Yes. For a development-centric perspective it might be better to only
      implement it for arti during or after its 1.2.0 roadmap which is focused
      on Onion Services.
    * For an user-centric perspective, what matters most is when Tor Browser
      would benefit from the new feature, be it shipped with C Tor or arti.
    * If the choice is to do whatever is speedier for deployment in the
      mid-term, then implementing first in C Tor might make more sense, but
      depends on the actual schedules for all these integrations.
5. Can we instead implement the Tor NS API outside the Tor daemon
   implementations, using standalone controllers like [TorNS][] and [StemNS][]
   or a wrapper around the Tor daemons?
    * Possibly yes, and that could be easier to implement, since it can be
      easier to find new developers to focus on a new piece of software without
      having to dig deeper into existing codebases.
    * On the other hand, is this a good architecture choice? From a security
      perspective, that would require to expose the `ControlPort` to a naming
      system middleware, which can be unsafe.
6. Can we only implement the Tor NS API in this phase, and skip any plugin
   implementation to a later phase?
    * Yes, but then we would not have anything official and functional to
      ship to users, except if the community commits to write some plugins,
      which is uncertain.
7. What needs to be changed in [Proposal 279][] in order for this plan to work?
    * Check the [Appendix: Proposal 279 fixes and improvements][] document for
      details.
8. How to detect/avoid censorship in the DNS level? How does the
   DNS-based method handle proof of non-existence (`NXDOMAIN` proofs), to
   detect/avoid censorship?
    * Check the [Appendix: Specs for DNS-based .onion records][] document for
      details.
9. How to prevent abuse in the DNS queries? How the DNS-based methods would
   handle an excess of requests?
    * Check the [Appendix: Specs for DNS-based .onion records][] document for
      details.
10. Tor Browser specific:
    1. Would connections be by default and automatically upgraded to the Onion
       Service if the regular one is not available? Or shall it respect the
       "Prioritize .onion sites when known" Tor Browser config and just offer the
       ".onion available" badge?
    2. How will the user know (UX indicators) that the connection is being done
       via Onion Services if the Tor NS API handles everything transparently?
       Can this be inferred by the circuit information or obtained via the Tor control
       protocol? Does it matter at all except for debugging/verification?

[829 open issues for Tor Browser]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues
[329 for C Tor]: https://gitlab.torproject.org/tpo/core/tor/-/issues
[TorNS]: https://github.com/meejah/torns
[StemNS]: https://github.com/namecoin/StemNS
[Appendix: Proposal 279 fixes and improvements]: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/blob/main/docs/05%20-%20Appendix:%20Proposal%20279%20fixes%20and%20improvements.md
[Appendix: Specs for DNS-based .onion records]: https://gitlab.torproject.org/tpo/onion-services/onionplan/-/blob/main/docs/06%20-%20Appendix:%20Specs%20for%20DNS-based%20.onion%20records.md

## Phase 2: Opportunistic Discoverability

### Description

1. An additional Tor NS API plugin is created, implementing [Sauteed Onions][]
   lookups based on CT Logs, or another approach if [Sauteed Onions][] still
   needs more research. But for now the proposal for this phase is to go after
   [Sauteed Onions][].
2. Having both DNS-based and CT Logs-based .onion lookups creates redundancy to
   protect against censorship with the lookups. DNS queries are lighter than CT
   Logs, but less censorship resistant. Combining both, but prioritizing DNS,
   ensures that queries for .onion addresses can be fast for most cases (via DNS)
   and happen with CT Logs only when no entry in the DNS is found.

### Strengths

1. Same strengths from Phase 1, plus:
2. The CT Log method is censorship resistant.
3. Again: minimum (or even no) changes needed in the Tor Browser codebase:
   since queries happen in the Tor daemon, no additional [Sauteed Onions][] Web
   Extension will be needed.
4. Minimum changes needed in the Tor daemons since the Tor NS API should be
   already implemented. Only a new Tor NS API plugin and backend resolvers are
   needed.
5. Again: works with the existent HTTPS infrastructures (no need for an ACME
   for .onions at this stage): Operators only need to include the *sauteed
   onion* `Subject Alt Name` in their existing certificates!

### Weaknesses

1. Dependent on the CT Logs, which requires:
    1. Resources to monitor all .onion certificates.
    2. Additional and scalable middleware for name resolution.
2. Do not work with .onion-only sites.

### Opportunities

1. Leverage the existing CT Logs system, which offers stronger guarantees
   against censorship than the DNS.
2. Reuse the existing discussions and proposals about where and how to
   implement alternative naming systems ([Sauteed Onions][]).
3. Give time for other implementations to mature (Onion Names) while providing
   to the community another way to discover Onion Service addresses.

### Threats

Same as those from the previous phase, plus:

1. The technology gets hard to scale. Mitigations:
    1. Increase the evaluation period to try to optimize.
    2. If the implemented domain discovery method doesn't not scale, it can be
       phased out (or discouraged) by the end of the evaluation period.
2. Privacy concerned Onion Service operators may not want their .onion address
   to be listed in public CT logs.
3. Big onion sites may not want to get a single certificate with both their
   .com name and their onion name in it, because they don't want to spend those
   extra 100 bytes times billions of handshakes per day. Maybe they could show the
   cert just to Tor exit IP addresses, but that is extra complexity too.
5. When the site includes its own Onion-Location header, they can easily remove
   it if the onion site has problems; but if instead Tor Browser users get the
   mapping from the Certificate Transparency log, what if there is a mapping from
   two weeks ago that the site doesn't want people to use anymore? It seems we
   might need some kind of "try the onion but be able to notice if it's not
   working and fall back to the main site" mechanism in the browser.

### Roadmap

1. Implement address translation plugins:
    1. For [Sauteed Onions][], using the latest API version and SCT/certificate
       verification.
2. Implement distributed [Sauteed Onions][] resolvers:
    1. Behind multiple load-balanced Onion-Services?
    2. As a plugin for relays, so exit nodes can perform these queries if their
       Operators want to?
3. Build an experimental Tor Browser shipped with a Tor daemon configured with
   all implemented Tor NS API plugins and built-in set of [Sauteed Onions][]
   resolvers.
4. Evaluation period with early adoption and funding campaigns.

The roadmap for this phase may also includes fixes and low-hanging fruit.

### User stories

#### Operator story 2 (Phase 2)

1. Operator need an additional DNS entry for the *sauteed onion* domain related
   to their existing site. The Operator can then choose to have either the
   `[DNSONION]` entry, the Sauteed Onion DNS entry, or both. Having both should be
   the recommended approach for Operators wishing to make their service more
   censorship resistant.
2. Operators wishing to use Sauteed Onions should include the *sauteed onion*
   domain into their HTTPS certificates as a Subject Alternative Name (SAN),
   which is supported right now by the existing Let's Encrypt infra.

#### User story 6 (generic HTTP clients or web browsers using Tor as a socks5h proxy, Phase 2)

1. User ask the HTTP client to access `something.example.org`.
2. Request is passed to the Tor daemon.
3. The Tor daemon uses the Tor DNS API to query for `something.example.org`
   using `[DNSONION]` or, if that does not succeeds, to the [Sauteed Onions][]
   resolver, falling back to the usual DNS resolution over Tor.
4. If an Onion Service entry is found:
   * The Tor daemon transparently connects to the Onion Service using HTTPS and
     with the TLS `SNI=something.example.org` correctly like in the [Alt-Svc
     method][], so https://something.example.org happens transparently via an Onion
     Service.

#### User story 7 (Tor Browser, Phase 2)

1. Same as the previous user story, with:
2. Additional UI indicator/widget to interact with the technology.

#### User story 8 (Orbot, Phase 2)

1. If Phase 2 is implemented also for mobile clients, the behavior should be
   the same as User story 6.

#### User story 8 (Onionshare, Phase 2)

1. On Phase 2, the user won't have support for accessing shared files or
   folders using address translation, because that would require Onionshare to
   configure Sauteed Onions certificates, which is out of scope.

#### User story 9 (Chat client using Onion Services, Phase 2)

1. On Phase 2, the user won't have support for finding other users via address
   translation, because that would require clients such as Briar, Quiet or
   Ricochet-Refresh to configure Sauteed Onions certificates, which is out of
   scope.

### Questions

1. Can this phase be skipped to the next?
    * Yes, this phase can be safely skipped or postponed as a later phase.
2. Can this phase be developed before the previous?
    * Yes, as long as it includes the Tor NS API implementation.
    * If [Sauteed Onions][] reveals to be more doable first than DNS resolution,
      then makes sense to do it first.
    * But the current evaluation is that the [Sauteed Onions][] design needs to
      solve scalability problems in the query API before being entering a beta
      phase.
3. Can this phase be implemented after or in parallel to others?
    * Yes, this phase can be implemented anytime as long as there is a working
      Tor NS API implementation.
4. Who can operate [Sauteed Onions][] resolvers? Anyone?
    * The [Sauteed Onions][] proposal currently does not specify who can run a
      query node. It could be relays configured to do so or even some distributed
      set of Onion Services.
5. How is the list of available resolvers updated?
    * In the short to mid term: via Tor Browser updates?
    * In the future: via consensus?
6. How much resources we're talking about for each resolver?
    * Needs research an estimation on this.

## Phase 3: Pure Onion Names

### Description

This phase is dedicated to bring "pure" Onion Names, i.e, those that does not
have a regular DNS counterpart, like domains under the special-purpose .onion
TLD.

### Rationale

1. Having Phase 1 and 2 completed means that Users already have a way for
   accessing Onion Services directly using human-friendly names based on the
   regular domain names.
2. So Phase 3 is dedicated to the proper evaluation of naming systems that go
   beyond the DNS, such as those based on blockchain or other distributed
   technology.
3. It's not required that the Tor Community awaits for this Phase before
   implementing their own Tor NS API resolvers. But this phase means that the
   Tor Project might properly evaluate all proposals and establish criteria to
   what can be shipped by default.

### Strengths

1. The previous opportunistic discoverability methods will still work.
2. Any tool that uses Onion Services could benefit from Onion Names, not only
   Tor Browser, like:
   * For tools like Briar and Ricochet, having some kind of "nickname" support
     built atop Onion Names.
   * Onionshare could have human-friendly (and disposable?) handles to share
     content such as `infinity spell glass`.
3. Works also with .onion-only sites.

### Weaknesses

1. Having other discovery methods already implemented might decrease the
   incentives and discourage the adoption of alternative naming systems.

### Opportunities

1. Promote alternatives to the DNS for better decentralization of communication
   technologies.

### Threats

* To be evaluated.

### Roadmap

* To be written.

### User stories

#### Operator story 3 (Phase 3)

1. The operator has additional ways to create human-friendly mappings to Onion
   Services, some of then being independent of DNS entries or HTTPS
   certificates.
2. The operator is not restricted to have a single human-friendly mapping,
   being able to create many mappings using different implementations.

#### User story 10 (generic HTTP clients or web browsers using Tor as a socks5h proxy, Phase 3)

1. User asks the HTTP client to access some address (don't have to be a DNS-based name).
2. Request is passed to the Tor daemon.
3. The Tor daemon uses the Tor DNS API to query for the address based on the available plugins.
4. For DNS-based addreses, story goes like on Phases 1 and 2.
5. For "pure" Onion Names, the appropriate plugin is called. HTTPS certificate
   validation support for this case is not covered in the current proposal.

#### User story 11 (Tor Browser, Phase 3)

1. Same as the previous user story, with:
2. Additional UI indicator/widget to interact with the technology.

#### User story 12 (Orbot, Phase 3)

1. If Phase 2 is implemented also for mobile clients, the behavior should be
   the same as User story 10.

#### User story 13 (Onionshare, Phase 3)

User story considering that Onionshare is updated to support the improvements
in this phase:

1. User sharing files:
  1. User selects files on Onionshare.
  2. User can ask Onionshare to generate a secret code like [magic-wormhole][] does.
  3. User can share either the .onion address or the secret codes to another user.
2. User downloading files:
  1. User may enter the secret code instead of the .onion address to download files.

This user story depends on the existence of a given Onion Name implementation
that allows for such Onion Names registrations.

#### User story 14 (Chat client using Onion Services, Phase 3)

User story considering that Tor-based chat clients are updated to support the
improvements in this phase:

1. Users registers "nicknames" (i.e, Onion Names).
2. Users exchanges their nicknames.
3. Users can add each other on their chat applications using these nicknames
   instead of an .onion address.

This user story depends on the existence of a given Onion Name implementation
that allows for such Onion Names registrations.

### Questions

1. How tools like Briar, Ricochet and Onionshare could automatically create
   Onion Names for nicknames or handles?
2. How to provide HTTPS certs for Onion Names? Does it makes sense to have or
   it's mostly an UX expectation?
