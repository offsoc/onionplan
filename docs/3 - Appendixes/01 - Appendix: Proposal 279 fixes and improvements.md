# Proposal 279 fixes and improvements

This is a list of open questions and suggestions for [Proposal 279][], which
can be eventually included in the Section 3 of the proposal or converted to
actionable ticket issues.

This can be useful either if [Proposal 279][] is selected as the specification
for the Tor Name System API (Tor NS API) or if another specification is to be
written.

[TOC]

[Proposal 279]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/279-naming-layer-api.txt

## Allocation

The following allocation criteria might be more related to governance -- what
is accepted by Tor and is officially supported -- than to be specific
requirements on [Proposal 279][].

If that's the case, then these criteria should be enforced only for "official"
or "supported" implementations (and leaving the users and operators to
configure their [own non-standard resolution schemes][] on their systems):

* [ ] Require all address suffixes to end with .onion (Sections 2.1, 3.1 and
      elsewhere) (initial discussion: [require-suffixes-end][]).
* [ ] Reserve part of the namespace (Section 2.1 and elsewhere)
      (initial discussion: [reserve-namespace][]).
  * [ ] For standardized namespaces (like `.onion)`.
  * [ ] Some for experimental or local ones (like `.x.onion)`.
* [ ] Distinguish names that are supposed to be global from ones that aren't
      (Section 2.1 and elsewhere) (initial discussion: [distinguish-names][]).
* [ ] Require that the second-level domain be 10 characters or less, to avoid
      confusion with existing onion addresses (Section 3.1) (initial discussion:
      [require-second-level][]).
  * [ ] Reasoning for limiting domain size:
    * [ ] Cannot conflict with the existing .onion service address syntax.
  * [ ] Suggestions for limiting domain size:
    * [ ] Use a base limit (like 10 chars).
    * [ ] Smaller than the size of the public key.
    * [ ] Exclude domains with exactly the size of the public key.
* [ ] Make credible arguments that whatever exists under ".onion" is somehow
      cryptographic, attested by certs, blockchains, and shit like that, rather
      than "authorities" to avoid issues with DNSOP
      (initial discussion: [credible-arguments][]).
* [ ] Require the use of restricted (maybe DNS-compliant) syntax, including but
      not limited to (initial discussion: [restricted-syntax][]).
  * [ ] Acceptable max length, max label length, charset and composition.
  * [ ] Declare a registry of short, valid labels, in the second-from-right position in the name.
  * [ ] Reserve "tor" and "name" in that registry (ie: .tor.onion, .name.onion).
* [ ] Support for [internationalized domain names][].

[own non-standard resolution schemes]: https://lists.torproject.org/pipermail/tor-dev/2017-April/012172.html
[require-suffixes-end]: https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html
[reserve-namespace]: https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html
[distinguish-names]: https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html
[require-second-level]: https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html
[credible-arguments]: https://lists.torproject.org/pipermail/tor-dev/2017-April/012171.html
[restricted-syntax]: https://lists.torproject.org/pipermail/tor-dev/2017-April/012171.html
[internationalized domain names]: https://en.wikipedia.org/wiki/Internationalized_domain_name

## Syntax

* [ ] Require that the suffixes be distinct (Section 2.3)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
* [ ] Drop the "priority" configuration field, but that might break opportunistic discovery (Section 2.3)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
      Alternativelly, just make a priority based on the ordering, but in that case specify if it's ascending or descending
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012078.html)).
* [ ] Require that the TLDs actually begin with a dot (Section 2.3)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
* [ ] Optional argument to specify if the name resolution method should fallback for a regular DNS query at the exit node
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011524.html)).

## Algorithm

* [ ] Require that the algorithm do not apply recursivelly (Section 2.3.1)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
* [ ] Query IDs:
  * [ ] Require that query IDs must be unique (Section 2.5.1)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
        Over which scope? Who enforces that?
  * [ ] Require that query IDs must be non-negative integers (Section 2.5.1)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
  * [ ] Decide if query IDs can be arbitrarily large (Section 2.5.1)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
  * [ ] Sufficient information should be passed in the RESOLVE line to allow
        the lookups relying on network traffic for different requests to be
        stream-isolated in the same way that the connections to the resulting addresses
        would be stream-isolated
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011518.html)).
* [ ] Input and output sanitization:
  * [ ] Should tor check the <tld> based on regex
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012078.html))?
  * [ ] How should it reponds when <tld> is .a.b
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012078.html))?
  * [ ] Can it accept '\*' (without dot) or '.on\*' as <tld>
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012078.html))?
  * [ ] Do not allow the algorithm to produce non-onion addresses (Sections 2.5.1 and 2.5.3)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
  * [ ] Subdomains should be supported.
  * [ ] Handling of `.exit` and `.noconnect`
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-April/012128.html)),
        or disallow it's usage in the NS API.
* [ ] Results and failures:
  * [ ] The result should indeed be optional on failure (Section 2.5.1)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
  * [ ] Specify what exactly clients and plugins will do if they receive an
        unrecognized message, or a malformed message (Sections 2.5.1 and 2.5.2)
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
  * [ ] Allow multiple onion services addresses or multiple IP addresses to be
        returned, for purposes of load balancing or failover
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011518.html)).
  * [ ] Allow a name plugin to return an IP address or ICANN-based DNS name as an alternative to an onion service address
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011518.html)).
        If that's the case, why not then allow the name plugin to return
        arbitrary names, implementing recursion, but failing if a loop is detected? One
        approach for the matter: in the first version of the spec/implementation, only
        allow Onion Service addresses to be returned, like a simple mapping. Further
        versions can be expanded to other addresses and to even include recursion.
  * [ ] Think about what to do with disagreements in the discovery methods. Should plugins evaluating
        a given namespace to accept the first valid result or always try to fetch all matching plugins
        and compare the results?

## Implementation

* [ ] Decide if `stdin/stdout` is the wait to go, considering portability (Windows and mobile) (Section 2)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
      Discussion points to adopting TCP instead, which could be done with a
      simple protocol or using a RESTful API (listening on localhost only by
      default). Libraries to build REST APIs are available in most languages and
      should work in most system environments, including Windows and mobile and
      without needing support for subprocesses. Using REST would also make
      environment variables unneeded.
* [ ] How a client (such as Tor Browser) could determine if a given site is
      being retrieved via an Onion Service if it's not .onion
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011516.html))?
* [ ] Have a standard external way to just do a name-to-onion query
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011516.html)).
* [ ] For petnames (i.e, local aliases), there may be certificate errors when accessing content via HTTPs
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011516.html)).
      This seems like a minor issue, since petnames are somehow a corner case and not the main goal right now.
* [ ] Use `MapAddress` for at least the prototype implementation
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011517.html)).
* [ ] If some of the requirements and features are not feasible to the initial
      implementation, write the specification in a way that it can still support
      them in future versions.

## Security

* [ ] Decide about the cache policy, considering potential cache-related timing
      attacks. Possible decide for a "no caching" rule (Section 2.5.3)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
* [ ] Check for Tor Browser security implications
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)), such as:
  * [ ] Risks like probing to see whether the user has certain extensions installed or names mapped.
        Maybe .hosts.onion should only be allowed in the address bar, not in HREF attributes et al
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html))?
  * [ ] Determine what happens with attacker-controlled names in HTML, like the
        attacker including codes that fetches content from petname domains. Are
        attackers allowed to query the user's local naming setup, even in an indirect
        way, or does the magic only happen for names that are typed directly into the
        URL bar
        ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011516.html))?
* [ ] Add a security notes section for how to write plugins that aren't
      dangerous: a bad plugin potentially breaks user anonymity
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2017-March/012077.html)).
* [ ] Require that external queries happen through Tor
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011515.html)).
* [ ] Require that any external query happen on a new Tor circuit (stream isolation)
      ([initial discussion](https://lists.torproject.org/pipermail/tor-dev/2016-October/011515.html)).

## Misc

* [ ] [Section 3 (Discussion)](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/279-naming-layer-api.txt#L400) points from Proposal 279.
