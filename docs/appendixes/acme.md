# ACME for Onions Evaluation

* Status: DRAFT
* Version: v2023.Q2

## Index

[TOC]

## Introduction

The [ACME for Onions][] proposal for automating the issuance of X.509
certificates for .onion addresses is composed of a [internet draft][] and
reference code.

[ACME for Onions][] is [introduced in the proposals section][] and a suggested
planning for it's implementation is [done in the certificates rodamap
document][].

This document contains an evaluation on the proposal in the point of view
of an implementation plan, and assumes that the reader knows the content
of the [internet draft][].

The main concerns here is to evaluate whether it's possible for CA's to start
adopting [ACME for Onions][] by just implementing a subset of the spec.

[ACME for Onions]: https://acmeforonions.org/
[internet draft]: https://datatracker.ietf.org/doc/draft-misell-acme-onion/
[introduced in the proposals section]: ../proposals/usability/certificates.md#acme-for-onions
[done in the certificates rodamap document]: ../roadmaps/certificates.md#acme-for-onions-roadmapping

## Challenges

This section discusses complexities and requirements for each challenge
described in the [internet draft][], and which seems to be aligned with the
current [CA/B baseline requirements][].

### Prioritizing onion-csr-01

If a Certificate Authority (CA) wants to implement ACME for Onions but needs
to prioritize, it seems that the `onion-csr-01` challenge is the best
candidate to begin with, as it:

1. Apparently has lower implementation complexity than the other challenges,
   since it doesn't requires the ACME Server to do requests through Tor and
   does not need to deal with client authorization (well, except for validating
   the CAA, but CAA might not be strictly necessary, see discussion in another
   section below).

2. Allows for wildcard certificates
   (`*.test35n4rit2dzagyzixi7kfktuzns3q464donfggtn5jhflqvwihrqd.onion`),
   according to [CA/B baseline requirements][] Appendix B.

3. Allows for the certificates be obtained in a separate machine away
   from the service. In fact, an Onion Service operator could generate
   the Onion Service keys as well as obtaining or renewing certificates on
   staging/intermediary machines before deploying all these materials into
   production machines.

### Comparing onion-csr-01 with http-01 and tls-alpn-01

In the other hand, both `http-01` and `tls-alpn-01` challenges have an
advantage over `onion-csr-01` in the Onion Service operators point of view,
as they allow for separation of concerns to be easily implemented in cases
where the X.509 certificates are handled by a backend isolated from the Onion
Service proxy, like in the diagram below:

```
┌────────────────────┐    ┌──────────────────────┐
│ Onion Service proxy│    │ HTTPS endpoint       │
│ Onion Service keys ├────┤ X.509 keys and certs │
│ Tor runs here      │    │ certbot runs here    │
└────────────────────┘    └──────────────────────┘
```

The drawbacks in these cases are:

1. A lot more complexities are involved related with doing ACME Server
   requests through the Tor network.

2. Wildcard certificates cannot be issued ([CA/B baseline requirements][]
   Appendix B).

### Conclusion

CAs wishing to start implementing ACME for Onions could begin by offering only
the `onion-csr-01` challenge without CAA (discussed in a separate section).
They could implement `http-01` and `tls-alpn-01` in a later phase, allowing
them to incrementally adopt the spec and reduce the complexity during the
initial implementation, since they would not need to:

* Bother whether client authorization is configured for the Onion Service.

* Deal with complexities involved in doing requests through Tor in the ACME
  Server.

In summary, there's nothing in the draft spec requiring a CA to implement all
the challenges and the CAA check (and it's also not a requirement on [CA/B
baseline requirements][] Appendix B).

Also, even if only `onion-csr-01` is implemented, it would still be possible to
issue "mixed" certs for both .onion and non-onion using different challenges in
the _same_ certbot command line and for a _single_ certificate.

According to the [RFC 8555][] (ACME Standard) Section 4[^acme-challenges],

> Because there are many different ways to validate possession of different
> types of identifiers, the server will choose from an extensible set of
> challenges that are appropriate for the identifier being claimed. The client
> responds with a set of responses that tell the server which challenges the
> client has completed. The server then validates that the client has completed
> the challenges.

[^acme-challenges]: And further detailed on [RFC 8555][] Sections 7.1.4 and 8.

Example: say one controls the following addresses:

1. example.org (the "regular", DNS-based domain name)
2. test35n4rit2dzagyzixi7kfktuzns3q464donfggtn5jhflqvwihrqdonion.example.org (a
   [Sauteed Onions][] identifier)
3. test35n4rit2dzagyzixi7kfktuzns3q464donfggtn5jhflqvwihrqd.onion (the Onion
   Service address)

A _single_ certificate with all these three SANs could be issued, using all
existing challenges (like `http-01`) for the first two SANs and `onion-csr-01`
for the third.

[CA/B baseline requirements]: https://cabforum.org/wp-content/uploads/CA-Browser-Forum-BR-1.8.6.pdf
[RFC 8555]: https://datatracker.ietf.org/doc/html/rfc8555
[Sauteed Onions]: ../proposals/usability/discovery/translation.md#sauteed-onions

## CAA

This section discusses the Certification Authority Authorization (CAA)
descriptor field.

### Cleverness

It's very clever to implement CAA on the descriptor's first layer of
encryption, and to understand that Onion Service descriptors can be used for
these things for which there are existing DNS records, in order to lookup basic
Onion Service information directly in the descriptor.

### Requirement level

But is CAA really needed for Onion Services?

* It's way more difficult to impersonate on .onion than HTTPS. The way to
  effectively do it is to control the Onion Service keys.

* And basically, if one controls the .onion keys already controls the
  descriptor and hence the `caa` fields.

* Maybe an exception would be if the attacker is able to inject arbitrary
  content in an Onion Service (like injecting HTML and custom paths) in order
  to be able to solve a `http-01` challenge for a fake X.509 CSR. But even if that
  succeeds, the attacker could only use this certificate if also controlling the
  Onion Service keys and the service itself. And CT Logs could also play a role
  detecting rogue certificates.

* So in a first look it seems that there's no added benefit in having CAA for
  .onion addresses, but maybe this analysis is missing something.

* What happens is that CAs are are required to do CAA checking due to a CA/B
  requirement after [ballot 187][] was approved (see the [announcement][]).
  This means that transposing the CAA DNS resource records could be an
  improvement in the future for CAs wishing (or required) to do this check also
  for .onion addresses.

* But this check is currently not required for .onion addresses:
    * CAA ([RFC 6844][]) probably does not apply to .onion (an Special-Use Domain Name
      per [RFC 7686][]), since CAA refers to "domains" as "DNS Domain Name" and
      "Domain Name" as "A DNS Domain Name as specified in [STD13]." ([RFC 6844][] section
      2.2). We could argue that CAA does not apply to .onion due to both RFCs 6844
      and 7686.
    * In fact, the [CA/B baseline requirements][] states that:

      > 3.2.2.8 CAA Records
      >
      > As part of the Certificate issuance process, the CA MUST retrieve and
      > process CAA records in accordance with RFC 8659 for each dNSName in the
      > subjectAltName extension that does not contain an Onion Domain Name.

* To be in the safe side, however, there's no harm in keeping CAA fields in
  the IETF spec and in the torspec ([prop343][]) for the following reasons:
    * If CA/B start to recommend or require CAA checking for .onion addresses,
      the specs would already indicate how that can be done.

    * CAA is not only used during certificate issuance.  It also establishes ways
      to contact service operators and to report issues by using the `iodef`,
      `contactemail` and `contactphone` properties (see [RFC 6844][] for details).

    * Retrieving this information by a CA would only need a library that can retrieve and
      decode Onion Service descriptors, so no extreme complexity added in the overall
      certification procedure. But note that currently there's no guarantee that a CA
      would check CAA fields for .onion addresses since currently this is not enforced
      by the current CA/B baseline requirements.

* What matters most during the initial implementation is whether ACME providers
  will be in practice required to do such checking. If they do, then
  implementation complexity might increase, as the ACME Server will need to use
  the Tor network to retrieve the certificate, or at least have some built-in
  logic to fetch descriptors directly from the HSDirs.

[ballot 187]: https://archive.cabforum.org/pipermail/public/2017-March/009988.html
[announcement]: https://cabforum.org/2017/03/08/ballot-187-make-caa-checking-mandatory/
[RFC 6844]: https://datatracker.ietf.org/doc/html/rfc6844
[RFC 7686]: https://datatracker.ietf.org/doc/html/rfc7686
[prop343]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/343-rend-caa.txt

### Conclusion

* In summary, an ACME Server offering only the `onion-csr-01` challenge for
  .onion addresses and without the CAA descriptor field check would be way
  easier to implement and to maintain, but without excluding CA's wishing
  to implement the full spec.

* It also might work to include somewhere (maybe on [prop343][]) that Onion
  Service operators aren't required to set CAA descriptor fields in order
  to have HTTPS certificates issued by ACME Services.

## Security considerations

It's seems hard to define exactly what should be in the spec and what's better
to leave out of it in order not to keep things simple.

But maybe having an additional discussion in the "Security considerations"
section could help implementors to figure out what to do in some cases.

### Service abuse

Maybe it could have an item about service abuse prevention:

1. When ACME Server is listening directly on IP addresses: I understand that ACME spec
   (RFC 8555 Section 10.3) already suggests rate limiting on the server, which
   should work to counter abuses by rate limiting exit nodes for ACME
   requests done through Tor, but that may be sub-optimal. An alternative to
   this situation would be to encourage Certificate Authorities to have their ACME
   API endpoint also via an Onion Service.

2. When ACME Server is listening behind an Onion Service: when doing things
   with Onion Services, rate limiting would not work anymore with IP
   addresses/ranges and it's very cheap to create a huge amount of .onion
   addresses and request certificates for those. What could work instead (and that
   would be worth mentioning) is that implementors would be interested to adopt
   some of the [existing DoS protections for Onion Services][] and specially the
   upcoming [Proof-Of-Work (PoW) defense mechanism][] released on Tor
   0.4.8.1-alpha. So the network layer already have protections against abuse, but
   those need to be enabled server side.

[existing DoS protections for Onion Services]: https://community.torproject.org/onion-services/advanced/dos/
[Proof-Of-Work (PoW) defense mechanism]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt

### On requests through the Tor network

2. Would be worth recommending clients (such as certbot) to make requests to
   the ACME Server only via Tor? In that case, should it also be recommended
   to make connection using an Onion Service endpoint (when available)?

3. In case of Tor-enabled ACME client connections, should it be REQUIRED that
   clients don't reuse the same Tor context (daemon, environment etc) from
   the one running the Onion Service? I.e, launch a new Tor process for the ACME
   client to avoid correlation attacks.

### Conclusion

Even if the security considerations pointed above are not included in a next
version of the [ACME for Onions][]' [internet draft][], they're worth
mentioning and perhaps can be documented somewhere as a reference to
implementors, CAs and Onion Services operators in general.
