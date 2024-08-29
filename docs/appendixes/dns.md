# Specs for DNS-based .onion records

* Status: DRAFT
* Version: v2024.Q3

Documents options, requirements etc to be considered when creating a
specification for Onion Services address entries using the DNS.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED",  "MAY", and "OPTIONAL" in this document are to
be interpreted as described in [BCP 14](https://www.rfc-editor.org/info/bcp14).

## Requirements

1. DNSSEC should be mandatory?
2. Resolution should happen only via [DNS-over-HTTPS (DoH)][] or [DNS-over-TLS (DoT)][]?
3. Support for bi-directionality?
4. Entries should be signed using the Onion Service private key?
5. Entries should signed using the HTTPS private key?
6. Should implement additional censorship resistance measures?
7. Should this be [coupled with TLS ECH][] (Encrypted Client Hello) to hide the domain
   request from a passive adversary when establishing connections to remote endpoints?

[DNS-over-HTTPS (DoH)]: https://support.mozilla.org/en-US/kb/firefox-dns-over-https
[DNS-over-TLS (DoT)]: https://en.wikipedia.org/wiki/DNS_over_TLS
[coupled with TLS ECH]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/42144

## Record types

Alternatives:

1. Adopt the [proposed HTTPS record][] which is now [RFC 9460][], so no
   additional record type is needed.
    1. Pros:
        1. No need to work on specs.
        2. Reuses an existing an compatible proposal.
    2. Cons:
        1. Seems highly dependent on whether [RFC 7686][] will be honored by clients to
           either use or skip .onion addresses found in HTTPS DNS records.
        2. Still needs a further and thorough security analysis to evaluate it's
           security properties, attack scenarios and mitigations (see [this
           initial discussion about HTTPS RRs][]).
        3. Cannot include a signature from the .onion key (no Onion Service
           self-authentication property).
        4. As of 2024-08-29, it seems like major web browsers require queries
           to be done through [DNS-over-HTTPS (DoH)][] in other to look for
           this field.
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
           the [convention used][] by [OnionRouter][].
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
[RFC 9460]: https://datatracker.ietf.org/doc/rfc9460/
[RFC 7686]: https://www.rfc-editor.org/info/rfc7686
[RFC 1464]: https://www.rfc-editor.org/rfc/rfc1464
[RFC 2782]: https://datatracker.ietf.org/doc/html/rfc2782
[convention used]: https://github.com/ehloonion/onionmx/blob/master/SRV.md
[OnionRouter]: https://github.com/ehloonion/onionrouter
[assigned by IANA]: https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml

## Implementation considerations

### Specifications

Relevant [Tor specifications][] for DNS resolution:

* [Tor Protocol Specification][]: section "6.4. Remote hostname lookup".
* [Tor's extensions to the SOCKS protocol][]: section "2. Name lookup".

[Tor specifications]: https://gitlab.torproject.org/tpo/core/torspec
[Tor Protocol Specification]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/tor-spec.txt
[Tor's extensions to the SOCKS protocol]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/socks-extensions.txt

### DNS record

1. Need to draft a record format:
    1. Without the `.onion` suffix in the response, since it may be
       redundant.
    2. The Onion Service public key (i.e, it's base address) using an encoding
       like base64 instead of base32, and without padding, reducing the record
       size up to 20%.
    3. Include a signature by the .onion service itself, signing:
        * The hash with the DNS.
        * The .onion address itself.
    4. Include port/service (optional field).

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
        * Additional logic is needed to allow the exit node should check or
          favor an existing .onion DNS record, since this is something more for
          the client to control (at the Tor NS API level).
2. DNS query originating at the client side as an alternative approach:
    * Pros:
        * Easier to implement the Tor NS API, as easilly allows the client
          configuration to control how the opportunistic discovery should
          happen: no need to signal/negotiate that to the exit node.
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
Tor Browser (see next section). And it may be **harder to guess** if the exit
node should favor an existing .onion record for a site.

[pretty error-prone protocol to implement]: https://gitlab.torproject.org/tpo/core/tor/-/issues/33687#note_2510496

### DNSSEC

To be taken into account if choosing the DNSSEC pathway:

1. Possible ways to distribute the DNSSEC root zone keys still need to be
   discussed.

2. A DNSSEC stapling mechanism could make safer to use DNSSEC.

3. A DNSSEC chaining mechanism could reduce the number of queries and
   responses. There are specs out there in different stages of maturity:
    * [RFC 9102 - TLS DNSSEC Chain Extension](https://datatracker.ietf.org/doc/html/rfc9102)
    * [draft-shore-tls-dnssec-chain-extension-02](https://datatracker.ietf.org/doc/html/draft-shore-tls-dnssec-chain-extension)
    * [draft-ietf-tls-dnssec-chain-extension-00](https://datatracker.ietf.org/doc/html/draft-ietf-tls-dnssec-chain-extension-00)
    * [draft-ietf-dnsop-edns-chain-query-02](https://datatracker.ietf.org/doc/html/draft-ietf-dnsop-edns-chain-query-02)

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
    * [Create rotating DNS DoH/DoT server list option Trr Core Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33687).
* For Tor Browser:
    * [Using HTTPS records for onion services](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325),
      which is not exactly about but may require DoH in the client side in order to work.
    * [Think about using DNS over HTTPS for Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/30753).
    * [DoH/TRR disabled by network.dns.disabled makes it unsafe to test DoH](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40034).
    * [Disable various ESR78 features via prefs](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/40048).
    * [Firefox's integration with Cloudflare for DNS-over-HTTPS](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/31671).
    * [Review Mozilla 1730418: Blocked network requests still reach a custom DoH resolver](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41123).
* For documentation in general:
    * [Add question: "What's the difference between Tor and DoH (DNS over HTTPS)?" to HTTPS section](https://gitlab.torproject.org/tpo/web/support/-/issues/65).
    * [Add What's the difference between Tor and DoH by highflyer910](https://github.com/torproject/support/pull/67).

### C Tor

Currently (as of 2022-11), DNS resolution at C Tor exit nodes happens in the
following way:

In `tor/src/feature/relay/dns.c`:

* `launch_resolve()`, which uses:
    * `launch_one_resolve()`, which calls:
        * [libevent's DNS resolution functions][] (at [evdns.c][]), which currently does not support:
            * TCP lookups.
            * DNSSEC.
            * Arbitrary record types (`TXT`, `SRV`, `HTTPS` etc).

[libevent's DNS resolution functions]: https://libevent.org/libevent-book/Ref9_dns.html
[evdns.c]: https://github.com/libevent/libevent/blob/master/evdns.c

### Arti

Currently (as of 2022-11), [Arti][] does not have relay implementation (and
hence no DNS resolution at the exit nodes).

[Arti]: https://gitlab.torproject.org/tpo/core/arti/

### Both C Tor and arti

* It's worth noting that implementing the DNS discovery mechanism could
  also bring enhancements to the general DNS support for the Tor network
  as a positive side effect / low hanging fruit.

* It would be possible to write the implementation for both C Tor and arti
  using [ldns](https://www.nlnetlabs.nl/projects/ldns/about/), which "supports
  all low-level DNS and DNSSEC operations. It also defines a higher level API
  which allows a programmer to for instance create or sign packets".

## Performance considerations

### Query and response size

1. DNS record size should be designed to the minimum.

2. Need to check also the response size limit.

3. A practical research is needed to check the response size for a query on a
   non-existent record, to evaluate the cost of always doing this kind of
   query.

### Alleviating excessive roundtrips

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

### Onion Service identity key usage

It's important to note that the current (as of 2023-04-04) Onion Services v3
specification does not allow the Master Onion Service identity key to be used
for purposes other than generating blinded signing keys (see Section 1.9 from
the [rend-spec-v3][]):

> Master (hidden service) identity key -- A master signing keypair
>   used as the identity for a hidden service.  This key is long
>   term and not used on its own to sign anything; it is only used
>   to generate blinded signing keys as described in [KEYBLIND]
>   and [SUBCRED]. The public key is encoded in the ".onion"
>   address according to [NAMING].
>   KP_hs_id, KS_hs_id.

Having the Onion Service master identity key to sign the DNS zone would require
an update in the Onion Services v3 spec, allowing the Onion Service identity to
also be used to:

1. Sign the required DNS entries.
2. Derive long-term (1 year?) blinded keys to be used to sign the DNS, maybe
   using the same approach described by Appendix A (`[KEYBLIND]`) from
   [rend-spec-v3][] but covering the needed use case of a long-term key, i.e,
   depending in a long-term nonce and not in `[TIME-PERIODS]`.

[rend-spec-v3]: https://spec.torproject.org/rend-spec-v3

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

### Onion Service address leakage into the DNS

This approach does leak info to the DNS, but the whole point in doing this is
to publish the relationship between a regular domain and the .onion address for
operators that want to have this feature.

This behavior MUST be documented and DNS-based address discovery MUST be
OPTIONAL.

### Other security considerations

Consider also:

1. The analysis made by the [DoHoT project][], which is from a different scope
   but might have common points to consider.

[DoHoT project]: https://github.com/alecmuffett/dohot

## Censorship considerations

### Censorship resistance

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
  And what would characterize a "match" in the discovery procedure?
* Support DNSSEC authenticated `NXDOMAIN`responses somehow.
* Enhanced Network Health scanners for DNS resolution issues.

### Censorship techniques

Existing censorship techniques should also be evaluated to determine the
overall resistance of the DNS method, like those discussed on
[Section 5.1.1. DNS Interference from draft-irtf-pearg-censorship-10][]

Some of these techniques could be mitigated by relying on [DNS-over-HTTPS
(DoH)][] and [DNS-over-TLS (DoT)][].

[Section 5.1.1. DNS Interference from draft-irtf-pearg-censorship-10]: https://datatracker.ietf.org/doc/html/draft-irtf-pearg-censorship#name-dns-interference

## References

### DoH and ECH

* [Support Encrypted Client Hello (#42144) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/42144#note_3068126)
* [Think about using DNS over HTTPS for Tor Browser (#30753) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/30753)

### SOCKS

* [RFC 1928 - SOCKS Protocol Version 5](https://www.ietf.org/rfc/rfc1928.txt).
* [How does SOCK 5 proxy-ing of DNS work in browsers? - Stack Overflow](https://stackoverflow.com/questions/33099569/how-does-sock-5-proxy-ing-of-dns-work-in-browsers).
* For Firefox:
    * [Network.proxy.socks remote dns - MozillaZine Knowledge Base](http://kb.mozillazine.org/Network.proxy.socks_remote_dns).
    * [ssh - How to do DNS through a proxy in Firefox? - Super User](https://superuser.com/questions/103593/how-to-do-dns-through-a-proxy-in-firefox).
