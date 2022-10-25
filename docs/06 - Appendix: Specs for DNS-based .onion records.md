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
   2. Cons: proposal might not get approved and the field stays as a non-standard.
2. Use`TXT` records ([RFC 1464][]):
   1. Pros:
      1. Minimum work on specs.
      2. Supported by existing software.
   2. Cons:
      1. It's not a dedicated resource record.
      2. Might need a RFC anyways (even if stays as a *Proposed standard* or *Informational*).
3. Use a custom `ONION`RR by submitting an RFC proposal to the IETF.
   1. Pros:
      1. It's a dedicated resource record.
      2. More flexibility?
   2. Cons:
      1. May take a long time to be a standard.
      2. Even if gets approved, may take time for software to implement (ossification)?

[proposed HTTPS record]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325
[RFC 1464]: https://www.rfc-editor.org/rfc/rfc1464

## Censorship resistance

Consider the following additional measures against censorship in the DNS level:

* Assume that any exit node may fail in the DNS resolution.
* Do 2-3 circuit resolution (multiple DNS queries from different "perspectives"
  -- exit nodes) in the `[DNSONION]` NS plugin. Then check results against one
  another to detect inconsistencies. This can minimize the probability of failed
  resolutions.
* Automatic reportback of resolution errors. But what qualifies as an "error"?
* Support DNSSEC authenticated `NXDOMAIN`responses somehow.
* Enhanced Network Health scanners for DNS resolution issues.

## Security and privacy considerations

Consider also:

1. The analysis made by the [DoHoT project][], which is from a different scope
   but might have common points to consider.

[DoHoT project]: https://github.com/alecmuffett/dohot
