# ACME for Onions Evaluation

* Status: DRAFT
* Version: v2023.Q3

## Index

[TOC]

## Introduction

The [ACME for Onions][] proposal for automating the issuance of X.509
certificates for .onion addresses is composed of a [internet draft][],
a Tor specification ([Proposal 343][]) and reference code.

[ACME for Onions][] is [introduced in the proposals section][] and a suggested
planning for it's implementation is [done in the certificates rodamap
document][]. It consists mainly of:

1. The [internet draft][].
2. The [certbot-onion][] `onion-csr-01` authenticator plugin for [Certbot][].
3. Tor Spec's [Proposal 343][] for the CAA descriptor fields.
4. The needed [changes in C Tor][] codebase implementing the CAA descriptor fields.
5. A reference implementation in [Björn](https://github.com/as207960/bjorn).
6. A reference CA [with the ACME API](https://acme.api.acmeforonions.org).

This document contains an evaluation on the proposal in the point of view
of an implementation plan, and assumes that the reader knows the content
of the [internet draft][].

The main goals here are to:

1. Contribute to the discussion and support the [internet draft][] adoption.
2. Evaluate whether it's possible for Certificate Authorities (CAs) to start
   adopting [ACME for Onions][] by just implementing a subset of the spec.

[ACME for Onions]: https://acmeforonions.org/
[internet draft]: https://datatracker.ietf.org/doc/draft-ietf-acme-onion/00/
[introduced in the proposals section]: ../proposals/usability/certificates.md#acme-for-onions
[done in the certificates rodamap document]: ../scenarios/certificates.md#acme-for-onions-roadmapping
[certbot-onion]: https://pypi.org/project/certbot-onion/
[certbot]: https://certbot.eff.org/
[Proposal 343]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/343-rend-caa.txt
[changes in C Tor]: https://gitlab.torproject.org/tpo/core/tor/-/merge_requests/716

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

This section discusses the [Certification Authority Authorization (CAA)][]
descriptor field.

[Certification Authority Authorization (CAA)]: https://en.wikipedia.org/wiki/DNS_Certification_Authority_Authorization

### Cleverness

It's very clever to implement CAA on the descriptor's first layer of
encryption, and to understand that Onion Service descriptors can be used for
these things for which there are existing DNS records, in order to lookup basic
Onion Service information directly in the descriptor.

### Requirement level

But is CAA really needed for Onion Services?

* For the case of Onion Service impersonation (rogue operators):
  * It's way more difficult to impersonate on .onion than HTTPS. The way to
    effectively do it is to control the Onion Service keys.

  * And basically, if one controls the .onion keys already controls the
    descriptor and hence the `caa` fields. Mandatory CAA check won't prevent
    such attackers from getting a certificate.

  * Maybe an exception would be if the attacker is able to inject arbitrary
    content in an Onion Service (like injecting HTML and custom paths) in order
    to be able to solve a `http-01` challenge for a fake X.509 CSR. But even if that
    succeeds, the attacker could only use this certificate if also controlling the
    Onion Service keys and the service itself. And CT Logs could also play a role
    detecting rogue certificates.

* For the case of rogue Certificate Authorities:
  * Without CAA, it may happen that some rogue DV certificate issued by a rogue
    CA remain undetected, but this certificate will be innocuous since the
    .onion private key is also needed in order to serve an Onion Service
    application through a CA-validated TLS connection.

So, in a first look, it seems that:

* There's no added benefit in having CAA for .onion addresses, but maybe this
  analysis is missing something.

* What happens is that CAs are required to do CAA checking due to a CA/B
  requirement after [ballot 187][] was approved (see the [announcement][]).
  This means that transposing the CAA DNS resource records could be an
  improvement in the future for CAs wishing (or required) to do this check also
  for .onion addresses.

And this check is currently not required for .onion addresses:

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

To be in the safe side, however,

* There's no harm in keeping CAA fields in the IETF spec and in the torspec
  ([prop343][]) for the following reasons:
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
  logic to fetch descriptors directly from the `HSDirs`. Client side logic might
  also increase a bit.

[ballot 187]: https://archive.cabforum.org/pipermail/public/2017-March/009988.html
[announcement]: https://cabforum.org/2017/03/08/ballot-187-make-caa-checking-mandatory/
[RFC 6844]: https://datatracker.ietf.org/doc/html/rfc6844
[RFC 7686]: https://datatracker.ietf.org/doc/html/rfc7686
[prop343]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/343-rend-caa.txt

### Scenarios

This section is a work-in-progress scenario evaluation for ways that CAA
descriptor fields can be checked during issuance/validation or evaluation.

Please also refer to the following related discussions and presentations:

* [Options to get CAA without operating a whole Tor client · Issue #2 · AS207960/acme-onion](https://github.com/AS207960/acme-onion/issues/2)
* [[Acme] Obtaining the Tor hidden service descriptor for draft-ietf-acme-onion](https://mailarchive.ietf.org/arch/msg/acme/LMYC_Ou41E_9RuaVSYPr7SIhCCc/)
* [[cabf\_validation] Draft Minutes of Validation Subcommittee - Sept. 7, 2023](https://lists.cabforum.org/pipermail/validation/2023-September/001927.html)
* [CAA and ACME for Onions](https://magicalcodewit.ch/cabf-2023-09-07-slides/) (slides discussing approaches for checking CAA fields)

#### For the CAA field check

##### 1. Using a memory-safe Tor implementation whenever needed (like Arti)

It's worth note that Tor has a memory safe implementation called [Arti][], which
has Onion Service client support an can be used to get .onion descriptors from
the `HSDirs` whenever (and if) needed.

* Pros:
    * Code safety is ensured.
    * Can be run in a security enclave, away from the main validation logic.
* Cons:
    * Need to bootstrap a Tor client.
    * Complexity involved in fetching a descriptor (timeouts etc).

[Arti]: https://gitlab.torproject.org/tpo/core/arti/

##### 2. Using a special Onion Service descriptor library, reducing the need to bootstrap a full Tor connection

It seems also possible to devise a way to fetch .onion descriptors without
having to bootstrap a Tor connection, but only doing something simpler, like
getting the consensus, calculating the `HSDir` hashring and connecting directly
to one of the relays (single hop) to do a `HSFETCH`.

* Pros:
    * Code safety is ensured even more.
    * Can be run in a security enclave, away from the main validation logic.
    * No need to bootstrap a full Tor connection.
* Cons:
    * Still some complexity involved in fetching a descriptor (timeouts etc).

That could be done by a small set of crates/libraries, way smaller than [Arti][].

This whole descriptor fetching seems to have a very low attack surface, and
could even run in some sort of security enclave, away from the main validation
code.

Would then be mostly a matter of dealing with connectivity issues, similar to
what happens when a DNS zone is unavailable or something like that, yielding
into a validation failure after some attempts.

##### 3. Onion Service descriptor (and hence CAA) being sent directly via the ACME API

There's no practical difference, in terms of CAA, between publishing an
.onion descriptor to the `HSDirs` and sending it directly into the
ACME validation, as some parameter in the API request.

* Pros:
    * No need to use a Tor client at all.
    * No need to rely in `HSDirs` (they don't offer any extra guarantees for
      .onion descriptors).
* Cons:
    * May need an amendment in the [internet draft][].

There's nothing special in the Hidden Service Directory system in terms of being
authoritative of anything. It's a hashring where everybody can upload stuff up
to a given size and formatted according to a given specification. If you have
an [Ed25519][] keypair and other basic requirements (such as a computer, unblocked
internet connection), then you can build and upload a descriptor into the
`HSDir`. It's very different from DNS, where you need credentials etc.  While DNS
is a centralized and hierarchical system, `HSDirs` are decentralized and
non-hierarchical, having the .onion addressing space consisting of
collision-resistant[^collision-resistance] public [Ed25519][] keys. An .onion
address is self-authenticating, and don't need an authoritative service for
doing any additional authentication.

[Ed25519]: https://ed25519.cr.yp.to/

[^collision-resistance]: See [Ed25519][] for details.

So if CAA check is mandatory, there's no difference in an .onion publishing
this descriptor in a `HSDir` an sending it directly into and ACME certificate
request: the same data a Tor daemon would publish to the `HSDir` can instead be
sent directly to the ACME request.

But there's a huge difference: the non-`HSDir` approach is much cheaper for the
CA: everything is already sent into the certificate issuance API request. The
CA won't need to have any Tor software installed, and won't need to reach the
Tor network.

What's interesting here is that this touches in something Aaron Gable from
[Let's Encrypt][] commented right after the Internet Draft was submitted:

> 1. Obviously it's valuable for this draft to standardize a method that is
> already accepted by the CA/BF. But in the long term there's no need to use
> a CSR as the transport mechanism for a random token, a public key, and a
> signature -- moving away from x509 for this would be nice in the long term.
> Probably out-of-scope for this document, but worth discussing.
>
> 2. The primary benefit of the onion-csr-01 method is that it allows the CA
> to perform domain control validation without operating a Tor client.
> However, this benefit is obviated entirely by the need to operate a Tor
> client to check for CAA in the hidden service descriptor. It seems likely
> that there are CAs which have avoided implementing HTTP-01 and TLS-ALPN-01
> for .onion due to the need to operate a Tor client; these same CAs may have
> been willing to implement ONION-CSR-01, but now will not due to the CAA
> mechanism.
>
> -- https://mailarchive.ietf.org/arch/msg/acme/-puOLP_LXNILKIfDjKt1RO-qm5I/

[Let's Encrypt]: https://letsencrypt.org

We are focusing in arguments for 2, but if the descriptor is sent along the
ACME request, then we don't even need a CSR for the transport mechanism (item
1).

And this approach does not only work for `onion-csr-01`, but also for `http-01`
and `tls-alpn-01`, as CAA can be checked _before_ any connection is made
(directly in the API request).

So one approach would be to do the CAA check without fetching a descriptor from a
`HSDir` (since it does not make anything safer, only more complex and expensive),
using the same argument that a CSR is not really necessary either and could be
replace by something else in the future.

This is a good alternative for doing the CAA check without the need to connect
to the Tor network in order to issue an .onion certificate.

Going further down, not everything in the descriptor would be necessary, like
introduction points, Proof of Work parameters, etc: what is mainly needed is
the relevant CAA properties, which could be basically just parameters into the
API call (like `iodef`, `contactemail` and `contactphone`).  This could also
eliminate all the complexities involved for the cases where an Onion Service
descriptor is protected by a layer of Onion Authorization credentials.

But for the sake of _consistence_ with the existing [CA/B baseline
requirements][] and [RFC 6844][], it might be interesting to provide a
descriptor anyway, since it's the equivalent document to a DNS CAA Resource
Record.

This might need an amendment in the Internet Draft, but seems to be the most
efficient thing to do if CAA is going to be specified for Onion Services, being
it a mandatory check or not.

Would adopting this approach make CAA fields in the _published_ Onion Service
descriptors unnecessary? Maybe not: CAA for .onion could be validated during
certificate issuance through the ACME API, but still be available in the .onion
descriptor, as _"CAA records MAY be used by Certificate Evaluators as a
possible indicator of a security policy violation"_[^caa-evaluators].

[^caa-evaluators]: See [RFC 6844][] (CAA Resource Record), Introduction.

##### 4. No check is done

For completeness, the case where no CAA check is done is also considered.

* Pros:
    * Less complexity for both ACME clients and servers.
    * Certificates are issued quickly.
* Cons:
    * During validation:
        * Seems like there's no harm in not doing a check with respect to
            certificate misissuance.
        * It may be easier to flood an ACME server with requests if an attacker
          only need to generate keys, and not publish descriptors; but rate
          limiting can be implemented with other methods.
    * During evaluation:
        * Depends on what is being evaluated; may be harmless if the goal is to
            check certificate misissuance; but may not be good if Certificate
            Evaluators are looking for `iodef`/`contactemail`/`contactphone`
            properties.

#### For the CAA field check requirement

##### 1. CAA check is required during issuance/validation

* Pros:
    * ?
* Cons:
    * May reduce the number of interested CAs in offering automated .onion certification.
    * No additional security improvement for the certification stage.

##### 2. CAA check is not required

* Pros:
    * CAs can start adopting the spec in a faster pace, like implementing onion-csr-01
        without CAA checking.
    * CAA can still be configured by Onion Service operators and checked by
        Certificate Evaluators.
* Cons:
    * ?

### Conclusion

* In summary, an ACME Server offering only the `onion-csr-01` challenge for
  .onion addresses and without the CAA descriptor field check would be way
  easier to implement and to maintain, but without excluding CA's wishing
  to implement the full spec.

* As of September 2023, it may be too early to make CAA checking mandatory for
  .onion, and CAs may need to time adopt the technology incrementally.
  Time is needed to evaluate more the pros and cons with different
  stakeholders.

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
   upcoming [Proof-Of-Work (PoW) defense mechanism][] from [Proposal 327][]
   released on Tor 0.4.8.1-alpha. So the network layer already have protections
   against abuse, but those need to be enabled server side.

[existing DoS protections for Onion Services]: https://community.torproject.org/onion-services/advanced/dos/
[Proof-Of-Work (PoW) defense mechanism]: https://gitlab.torproject.org/tpo/onion-services/onion-support/-/wikis/Documentation/PoW-FAQ
[Proposa 327]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt

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
