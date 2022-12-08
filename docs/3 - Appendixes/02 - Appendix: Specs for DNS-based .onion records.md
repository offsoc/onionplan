# Specs for DNS-based .onion records

Documents options, requirements etc to be considered when creating a
specification for Onion Services address entries using the DNS.

<!--[[_TOC_]]-->

## Requirements

1. DNSSEC should be mandatory?
2. Resolution should happen only via DNS-over-HTTPS (DoH) or DNS-over-TLS (DoT)?
3. Support for bi-directionality?
4. Entries should be signed using the Onion Service private key?
5. Entries should signed using the HTTPS private key?
6. Should implement additional censorship resistance measures?

## Record types

Alternatives:

1. Adopt the [proposed HTTPS record][], in the hope that it gets approved so no
   need for an additional record is needed.
    1. Pros:
        1. No need to work on specs.
        2. Reuses an existing an compatible proposal.
    2. Cons:
        1. Proposal might not get approved and the field stays as a non-standard.
        2. Seems highly dependent on whether [RFC 7686][] will be honored by clients to
           either use or skip .onion addresses found in HTTPS DNS records.
        3. Still needs a further and thorough security analysis to evaluate it's
           security properties, attack scenarios and mitigations (see [this
           initial discussion about HTTPS RRs][]).
        4. Cannot include a signature from the .onion key (no Onion Service
           self-authentication property).
2. Use`TXT` records ([RFC 1464][]):
    1. Pros:
        1. Minimum work on specs.
        2. Supported by existing software.
        3. Syntax could allow for many fields like versioning.
        4. May allow multiple records pointing to different Onion Service
           addresses for implementing load balancing at the DNS level.
        5. May include an optional field for port/service like in the `SRV` field.
        6. May include a signature from the .onion key, which preserves the Onion
           Services' self-authentication property.
    2. Cons:
        1. It's not a dedicated resource record.
        2. It does not limit by service: a `TXT` record point to an Onion Service
           would work for any protocol (HTTP, SMTP etc). Could cause trouble if a
           service is not well supported by the service discovery approach; would
           not support different .onion addresses for different services.
        3. Might need a RFC anyways (even if stays as a *Proposed standard* or *Informational*).
3. Use `SRV` records ([RFC 2782][]):
    1. Pros:
        1. Minimum work on specs. Can be similar to the [convention used][] by [OnionRouter][]:
           `_onion._tcp.example.com. 3600 IN SRV 0 5 443 testk4ae7qr6nhlgahvyicxy7nsrmfmhigtdophufo3vumisvop2gryd.onion.`.
        2. Could be used for load balancing: multiple `SRV` entries for
           `example.org` for different Onion Service endpoints.
        3. Different services from the same domain could have distinct .onion addresses.
        4. Fine-grained control of supported services/ports.
    2. Cons:
        1. The `service` field from the `SRV` record are meant (by [RFC 2782][])
           to indicate services already [assigned by IANA][], something that does
           not make sense to do with Onion Services. Then, if adopting `SRV` record,
           would we be respecting or perverting the RFC? Is this a concern at all?
        2. Using the `service` field for Onion Services would assume implicitly
           that it should be accessed by some protocol like `https`. How to
           accommodate entries for `http` for even other services? One solution is to use
           a composite `service` fields like `onion-https`, `onion-http` etc, exactly like
           the [convention used][] by [Onion Router][].
        3. Cannot include a signature from the .onion key (no Onion Service
           self-authentication property).
3. Use a custom `ONION` RR by submitting an RFC proposal to the IETF.
    1. Pros:
        1. It's a dedicated resource record.
        2. More flexibility?
        3. Syntax could allow for many fields like versioning.
        4. May allow multiple records pointing to different Onion Service
           addresses for implementing load balancing at the DNS level.
        5. May include an optional field for port/service like in the `SRV` field.
        6. May include a signature from the .onion key, which preserves the Onion
           Services' self-authentication property.
    2. Cons:
        1. A lot more work involved in drafting a standard and evaluating all corner cases.
        2. May take a long time to be a standard.
        3. Even if gets approved, may take time for software to implement (ossification)?

[proposed HTTPS record]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325
[this initial discussion about HTTPS RRs]: https://emilymstark.com/2020/10/24/strict-transport-security-vs-https-resource-records-the-showdown.html
[RFC 7686]: https://www.rfc-editor.org/info/rfc7686
[RFC 1464]: https://www.rfc-editor.org/rfc/rfc1464
[RFC 2782]: https://datatracker.ietf.org/doc/html/rfc2782
[convention used]: https://github.com/ehloonion/onionmx/blob/master/SRV.md
[OnionRouter]: https://github.com/ehloonion/onionrouter
[assigned by IANA]: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml

## Censorship resistance

Consider the following additional measures against censorship in the DNS level:

* Assume that any exit node may fail in the DNS resolution.
* Do 2-3 circuit resolution (multiple DNS queries from different "perspectives"
  -- exit nodes) in the `[DNSONION]` NS plugin. Then check results against one
  another to detect inconsistencies. This can minimize the probability of failed
  resolutions:
  * Doing 3 lookups in the DNS may bring problems: lots broken DNS resolvers in
    exit nodes and also can have an impact in the network (by tripling the
    number or DNS requests).
  * As an alternative, we could consider an algorithm that do 3 lookups only if
    a first lookup results in invalid response such as `NXDOMAIN`.

* Automatic reportback of resolution errors. But what qualifies as an "error"?
* Support DNSSEC authenticated `NXDOMAIN`responses somehow.
* Enhanced Network Health scanners for DNS resolution issues.

## Alleviating excessive roundtrips

A downside for opportunistic discovery is that it involves additional
roundtrip.

It's possible to alleviate this by considering behaviors controlled by an user
setting, like the following:

1. The service discovery feature is disabled (by default?).

2. The feature can be enabled and will look for .onion on the DNS (or
   any other methods) only if the site is unreachable.

3. Feature is enabled for the whole browsing experience: whenever a
   stream for domains (and not IPs) opens, DNS resolution happens, with the
   benefit of automatic discovery but with the downside of an additional
   DNS roundtrip (and an additional circuit to make that roundtrip) at every
   (uncached) request.

## Security and privacy considerations

### Keeping the self-authentication property

It's important to devise a scheme where DNS records for Onion Services keep
the self-authentication property of .onion addresses.

That could be implemented by signing somehow the DNS entry using the Onion
Service private key.

### DNSSEC requirement

This section discusses whether DNSSEC should be mandatory:

1. Could it be optional when TLS is enforced and the Onion Service DNS entry
   is signed by the .onion? What's the trade-off here?

### DNS amplification attacks (DoS)

The following attack scenario needs to be considered when devising a DNS-based
resolution procedure (quoting @ahf from an e-mail exchange):

> Currently the Tor network's DNS capabilities only allows A, AAAA, and PTR
> (reverse DNS) resolution and not any other objects. The amplification ratio
> between request and response is interesting here because large DNS objects
> can potentially be used to DoS an exit-relay if an adversary is able to make
> many tiny requests that yields a very large response towards the resolving
> Exit node and thus fill up its inbound network connection.

### Other security considerations

Consider also:

1. The analysis made by the [DoHoT project][], which is from a different scope
   but might have common points to consider.

[DoHoT project]: https://github.com/alecmuffett/dohot

## Implementation considerations

### Specifications

Relevant [Tor specifications][] for DNS resolution:

* [Tor Protocol Specification][]: section "6.4. Remote hostname lookup".
* [Tor's extensions to the SOCKS protocol][]: section "2. Name lookup".

[Tor specifications]: https://gitlab.torproject.org/tpo/core/torspec
[Tor Protocol Specification]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/tor-spec.txt
[Tor's extensions to the SOCKS protocol]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/socks-extensions.txt

### DNS record

1. Need to check the response size for a query on a non-existent TXT record, to
   evaluate the cost of always doing this kind of query.
2. Need to draft a `TXT` record format:
    * Woudn't need to include the '.onion' extension.
    * Could encode the .onion address using base64.
    * Could include a signature by the .onion service itself, signing:
        * Hash with the DNS.
        * The .onion address itself.
    * Could include port/service (optional field).

### Client side versus exit node side resolution

Where should DNS queries happen?

1. With the current approach (DNS queries happens at the exit nodes):
    * Pros:
        * May rely only on the exit node's system for name resolution,
          alleviating the need for the Tor relay code to have it's own DNS
          client implementation.
        * Can detect DNS censorship happening at the exit node perspective.
    * Cons:
        * No guarantees for bypassing eventual censorship at the DNS level
          happening at the exit node perspective.
2. DNS query originating at the client side as an alternative approach:
    * Pros:
        * ?
    * Cons:
        * DNS is a [pretty error-prone protocol to implement][].
        * Requires a lot of work and touching lots of parts at each Tor
          implementation.
        * If not implemented at the Tor client, would need to be implemented in
          a per-client basis. Firefox already supports it, but requires more
          evaluation and work (as of Dec 2022) to make it work at the Tor Browser.

Then, after an initial analysis, it seems to be that **the best approach is to
leave resolution at the exit node**.

But **that may conflict if DNS-over-HTTPS (DoH) is enabled on clients** such as
Tor Browser (see next section).

[pretty error-prone protocol to implement]: https://gitlab.torproject.org/tpo/core/tor/-/issues/33687#note_2510496

### DNS-over-HTTPS (DoH) or DNS-over-TLS (DoT) support

Whether DoH or DoT should be used for resolution?

* For queries originating at the exit node:
    * This may be up to the exit node operator to decide and configure her
      system do do so?
    * If Tor has it's own DNS client (apart from the system's native
      implementation), shall this be mandatory?
* For queries originating at the client side:
    * Would possibly be a requirement to use DNS over TCP (or also over TLS /
      HTTPS) if UDP is still unsupported.

Some relevant issues with complement or may impact this discussion:

* For core Tor:
    * [Create rotating DNS DoH/DoT server list option Trr Core Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33687)
* For Tor Browser:
    * [Using HTTPS records for onion services](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325),
      which is not exactly about but may require DoH in the client side in order to work.
    * [Think about using DNS over HTTPS for Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/30753)
    * [DoH/TRR disabled by network.dns.disabled makes it unsafe to test DoH](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40034)
    * [Disable various ESR78 features via prefs](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40048)
    * [Firefox's integration with Cloudflare for DNS-over-HTTPS](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/31671)
    * [Review Mozilla 1730418: Blocked network requests still reach a custom DoH resolver](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41123)
* For documentation in general:
    * [Add question: "What's the difference between Tor and DoH (DNS over HTTPS)?" to HTTPS section](https://gitlab.torproject.org/tpo/web/support/-/issues/65)
    * [Add What's the difference between Tor and DoH by highflyer910](https://github.com/torproject/support/pull/67)

### C Tor

Currently (as of 2022-11), DNS resolution at C Tor exit nodes happens in the
following way:

In `tor/src/feature/relay/dns.c`:

* `launch_resolve()`, which uses:
* `launch_one_resolve()`, which calls:
* [libevent's DNS resolution functions][] (at [evdns.c][]), which currently does not support:
    * TCP lookups.
    * DNSSEC.
    * Arbitrary record types.

[libevent's DNS resolution functions]: https://libevent.org/libevent-book/Ref9_dns.html
[evdns.c]: https://github.com/libevent/libevent/blob/master/evdns.c

### Arti

Currently (as of 2022-11), [Arti][] does not have relay implementation (and
hence no DNS resolution at the exit nodes).

[Arti]: https://gitlab.torproject.org/tpo/core/arti/
