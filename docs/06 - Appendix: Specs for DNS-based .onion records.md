# Appendix: Specs for DNS-based .onion records

Documents a alternatives and requirements to be considered when creating an
specification for Onion Services address entries using the DNS.

[[_TOC_]]

## Requirements

1. DNSSEC should be mandatory?
2. Resolution should happen only via DNS-over-HTTPS (DoH)?
3. Support for bi-directionality?
4. Entry(es) should be signed using the Onion Service private key?
5. Entry(es) should signed using the HTTPS private key?
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
2. Use`TXT` records ([RFC 1464][]):
   1. Pros:
      1. Minimum work on specs.
      2. Supported by existing software.
      3. Syntax can easily allow for many fields like versioning.
      4. May allow multiple records pointing to different Onion Service
         addresses for implementing load balancing at the DNS level.
   2. Cons:
      1. It's not a dedicated resource record.
      2. Might need a RFC anyways (even if stays as a *Proposed standard* or *Informational*).
3. Use `SRV` records ([RFC 2782][]):
  1. Pros:
      1. Minimum work on specs. Can be similar to the [convention used][] by [OnionRouter][]:
         `_onion._tcp.example.com. 3600 IN SRV 0 5 443 testk4ae7qr6nhlgahvyicxy7nsrmfmhigtdophufo3vumisvop2gryd.onion.`.
      2. Could be used for load balancing: multiple `SRV` entries for
         `example.org` for different Onion Service endpoints.
  2. Cons:
      1. The `service` field from the `SRV` record are meant (by [RFC 2782][])
         to indicate services already [assigned by IANA][], something that does
         not make sense to do with Onion Services. Then, if adopting `SRV` record,
         would we be respecting or perverting the RFC? Is this a concern at all?
      2. Using the `service` field for Onion Services would assume implicitly
         that it should be accessed by some protocol like `https`. How to
         accommodate entries for `http` for even other services? One solution is to use
         a composite `service` fields like `onion-https`, `onion-http` etc, exactly like
         the [convention user][] by [Onion Router][].
3. Use a custom `ONION` RR by submitting an RFC proposal to the IETF.
   1. Pros:
      1. It's a dedicated resource record.
      2. More flexibility?
   2. Cons:
      1. May take a long time to be a standard.
      2. Even if gets approved, may take time for software to implement (ossification)?

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

## Security and privacy considerations

Consider also:

1. The analysis made by the [DoHoT project][], which is from a different scope
   but might have common points to consider.

[DoHoT project]: https://github.com/alecmuffett/dohot
