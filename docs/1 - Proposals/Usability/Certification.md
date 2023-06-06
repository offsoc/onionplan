# Certification

## Index

[TOC]

## About

This document tracks existing procedures or proposals for integrating and
validating TLS/HTTPS certificates for Onion Services.

While some depends on [Certificate Authorities][] (CA) model, others rely on
alternative certification and validation procedures that does not require
built-in certificate chains in the client software or reliance on financial
transactions.

[Certificate Authorities]: https://en.wikipedia.org/wiki/Certificate_authority

## Benefits

It may be argued that Onion Services connections are already
_self-authenticated_, -- since the public key and the URL are tied together and
the connection is peer-to-peer encrypted --, and thus making the need for HTTPS
pointless, or at most giving only an impression on users of additional security.

But having valid HTTPS connection in Onion Services could enable many other
enhancements, such as:

1. Some browser features are available only with HTTPS, like [Content Security
   Policy][] (CSP) and [Secure cookies][].

2. Allows for the usage of [HTTP/2][], since some browsers only support it if on
   HTTPS[^http3-availability].

2. It could be argued that this is also security-in-depth by having yet another
   layer of encryption atop of other existing encryption layers. Even if the
   theoretical gain in terms of interception and tampering resistance is not
   relevant, it would still allow for service operators to split their encryption
   keys in different servers -- like one with the Onion Service keys and a backend
   having the TLS keys, thus making a compromise in one of the servers exposing
   only the cryptographic material of one of the communication layers.

The following discussion is not yet conclusive, and the problem space may be
hard to solve.

[Secure cookies]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies#security
[Content Security Policy]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP
[HTTP/2]: https://en.wikipedia.org/wiki/HTTP/2
[HTTP/3]: https://en.wikipedia.org/wiki/HTTP/3

[^http3-availability]: But not [HTTP/3][] yet, since it uses UDP not available
                       via Tor (as of 2023-05).

## Overview

Proposal                              | Certification                                         | Validation                                        | Status
--------------------------------------|-------------------------------------------------------|---------------------------------------------------|-----------------------------------------------
Existing CA validation                | CA/B Baseline Requirements for .onion                 | CA chain                                          | Implemented, fully supported
ACME for .onion                       | CA/B Baseline Requirements for .onion                 | CA chain                                          | Proposed specification
Self-signed certificates              | Self-signed certificate                               | None                                              | Depends on per-application support
Self-signed X.509 from .onion         | Signed by a "CA" derived from the .onion private key  | Check if cert is issued by the .onion private key | Proof-of-concept, no browser integration
Same Origin Onion Certificates (SOOC) | Self-signed certs                                     | Skip for .onion addresses when conditions match   | Proposal (not yet submitted for specification)
DANE for .onion                       | Self-signed certs                                     | DNSSEC                                            | Concept, no proposal yet
Onion-only CAs                        | Checks SAN and an .onion signature in an extension    | CA chain                                          | Concept, no proposal yet

### Main pros and cons

Proposal                              | Pros                                    | Cons
--------------------------------------|-----------------------------------------|---------------------------------------------------------------------------------------------------------
Existing CA validation                | None (already implemented)              | None (already implemented)
ACME for .onion                       | No need for client/lib implementation   | Depends on a CA willing to implement
Self-signed X.509 for .onion          | No CA-reliance for .onion, self-auth.   | Very hard to maintain and standardize, currently Ed25519 is unsupported by major browsers
Same Origin Onion Certificates (SOOC) | No CA-reliance for .onion               | Very hard to maintain and standardize
DANE for .onion                       | No CA-reliance for any domain or .onion | Very hard to implement and maintain
Onion-only CAs                        | Simplify CA-reliance                    | Needs to convince existing CAs or trusted parties to maintain a whole CA organization and infrastructure

### Main implementation characteristics

Proposal                              | Implementation level                       | Additional requirements
--------------------------------------|--------------------------------------------|-------------------------
Existing CA validation                | Procedure happens at the CA side           |
ACME for .onion                       | Procedure happens at the CA side           |
Self-signed X.509 for .onion          | Client or TLS library                      |
Same Origin Onion Certificates (SOOC) | Client or TLS library                      |
DANE for .onion                       | Client                                     | Portable DNSSEC library
Onion-only CAs                        | Client or TLS (only needs CA installation) |

## Existing CA validation

The [CA/Browser Forum][], a [consortium that produces guidelines for X.509
(TLS/HTTPS) certification][], created [validation rules for Onion Service v2
addresses][] (in 2015), later [extended for Onion Services v3][] (in 2020),
standardizing the way [Certificate Authorities][] can issue certificates for
.onion addresses and supports wildcards.

Only a few commercial providers currently provide this service[^existing-certifiers].

[^existing-certifiers]: As of January 2023, there are only two CAs issuing
                        certificates for .onion domains:
                        [DigiCert providing only Extended Validation (EV) certs][]
                        and [HARICA providing only Domain Validated (DV) certs][].

The Appendix B of the [CA/B Baseline Requirements][] (current [repository
version][]) for the Issuance and Management of Publicly‐Trusted Certificates
(since Version 1.7.4, released in 2021) establishes two validation methods to ensure
that someone request the certificate really control a given .onion address:

1. An "Agreed‑Upon Change to Website", where the service operator must include
   some secret at the `/.well‐known/pki‐validation` in the site.
2. Checking of a Certificate Signing Request (CSR) signed by the Onion Service
   private key and containing an specific cryptographic nonce (i.e, a shared
   secret to be used only once), like using the [onion-csr][] tool.

Note that both methods does not require that operators disclose the location of
the Onion Service, nor them need to have a regular site for the service using
DNS. Validation can either happen by accessing directly the Onion Service or
by using the service private key to sign a CSR.

But still commercial CAs (or financial institution) may still collect
identifiable information during the purchase of the certificates.

[CA/Browser Forum]: https://cabforum.org
[consortium that produces guidelines for X.509 (TLS/HTTPS) certification]: https://en.wikipedia.org/wiki/CA/Browser_Forum
[validation rules for Onion Service v2 addresses]: https://cabforum.org/2015/02/18/ballot-144-validation-rules-dot-onion-names/
[extended for Onion Services v3]: https://cabforum.org/2020/02/20/ballot-sc27v3-version-3-onion-certificates/
[DigiCert providing only Extended Validation (EV) certs]: https://www.digicert.com/blog/ordering-a-onion-certificate-from-digicert
[HARICA providing only Domain Validated (DV) certs]: https://harica.gr/en/Products/SSL
[CA/B Baseline Requirements]: https://cabforum.org/wp-content/uploads/CA-Browser-Forum-BR-1.8.4.pdf
[repository version]: https://github.com/cabforum/servercert/blob/main/docs/BR.md
[onion-csr]: https://github.com/HARICA-official/onion-csr

## ACME for .onion (CA-validated)

In general, getting certificates from CAs supporting the [CA/B Baseline
Requirements][] for .onion addresses is still a manual, or in the best-case
scenario, semi-automated task.

The Automatic Certificate Management Environment (ACME) standard ([RFC 8555][])
solves part of the automation problem, but currently (as of 2022) it does not
support the methods for validating Onion Services.

Having support for .onion address in the ACME standard is the first step for
projects like [Let's Encrypt][] to offer free certificates for Onion Services,
without financial transactions.

Existing proposals to bring ACME for Onion Services are discussed below.

[RFC 8555]: https://www.rfc-editor.org/rfc/rfc8555
[Let's Encrypt]: https://letsencrypt.org/

### ACME Onion Identifier Validation Extension

* [draft-suchan-acme-onion-00][] - Automated Certificate Management Environment (ACME) Onion Identifier Validation Extension:
    * [Relevant mail threads](https://mailarchive.ietf.org/arch/browse/acme/?q=draft-suchan-acme-onion-00.txt)
    * [orangepizza/acme-onion-doc: docs about standardize handling onion address in acme context](https://github.com/orangepizza/acme-onion-doc)

[draft-misell-acme-onion-00]: https://datatracker.ietf.org/doc/draft-misell-acme-onion/

### ACME for Onions

* [draft-misell-acme-onion-00][] - Automated Certificate Management Environment (ACME) Extensions for ".onion" Domain Names:
    * [ACME for .onion domains](https://acmeforonions.org/)
    * [AS207960/acme-onion](https://github.com/AS207960/acme-onion)
    * [Work funded by OTF](https://www.opentech.fund/internet-freedom-news/april-2023/#acme)

[draft-suchan-acme-onion-00]: https://datatracker.ietf.org/doc/draft-suchan-acme-onion/

## Self-signed certificates

This proposal consists in basically allowing for the use of self-signed
certificates with Onion Services:

1. For the Tor Browser and other software maintained by Tor, this would consist
   in [disabling self-signed certificate warnings when visiting .onion
   sites][].
2. For third party software, this would probably require patches or
   documentation instructing users to accept non-CA signed certificates when
   accessing Onion Services, which is very hard to provide and to maintain
   for a wide ranging of tools.

This proposal _would not provide_:

1. _A self-authentication mechanism_ (since the certificate is self-signed).
   This have a huge weight since an important piece of security provided
   by HTTPS is not just end-to-end encryption but also authentication.

Supporting self-signed certificates with Onion Services has a huge gain,
but also introduces an authentication complexity. That's why proper UI
indicators and hints are needed:

1. For the encryption state of the site (HTTP and various HTTPS situations).
2. For the authentication state of the site, telling how it was (not)
   authenticated.

There are already sketches for [different scenarios][] for how various user
interface hints and indicators could exist for Tor Browser and other software
maintained by Tor, as well as existing certificate proposals that can change
the certificate landscape for Onion Services in the future, which could be
adopted by operators instead of relying on self-signed certs.

But all these enhancements would still limit the practical application domain
of this proposal, since it would be readily available only to a small set
of applications like Tor Browser, except if by pursuing some standardization
such as the SOOC proposal below.

[disabling self-signed certificate warnings when visiting .onion sites]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410
[different scenarios]: ../1%20-%20Roadmaps/02%20-%20Roadmap:%20Usability%20Proposal%20-%20Certificates.md

## Self-signed X.509 from .onion (self-signed by the .onion address)

Another option for having HTTPS in Onion Services that may be available in the
future is to use Onion Service keypair to self-validate an HTTPS certificate:

* The [Onion x509][] is an example in how a CA self-signed by an .onion could
  be constructed.
* There's also a ticket requesting to [add support for self-signed HTTPS onion
  sites derived from onion service's ed25519 key][].

For an overview of Ed25519, check [How do Ed5519 keys work?][]. For details
about how Tor implements Ed25519, check [prop220][] (and [rend-spec-v3.txt][]
for how it implements at the Onion Services level).

This proposal has the advantage to not rely on Certificate Authorities, but the
disadvantage that needs additional logic both server and client side to make it
work, since a CA would needed to be installed for every visited Onion Service
using this scheme.

It's important to note that the current (as of 2023-04-04) Onion Services v3
specification does not allow the Master Onion Service identity key to be used
for purposes other than generating blinded signing keys (see Section 1.9 from
the [rend-spec-v3.txt][]):

> Master (hidden service) identity key -- A master signing keypair
>   used as the identity for a hidden service.  This key is long
>   term and not used on its own to sign anything; it is only used
>   to generate blinded signing keys as described in [KEYBLIND]
>   and [SUBCRED]. The public key is encoded in the ".onion"
>   address according to [NAMING].
>   KP_hs_id, KS_hs_id.

Also, while [many TLS libraries support the Ed25519 signing scheme][] used for
certificates (like in [OpenSSL since version 1.1.1][]), [major web browsers
still does not support][] it (as of 2022-12)[^X25519-vs-Ed25519], probably because
they're not supported[^Ed25519-CA-support] by the current (as of 2022-12) [CA/B
Baseline Requirements][]:

> 6.1.1.3 Subscriber Key Pair Generation
>
> The CA SHALL reject a certificate request if one or more of the following
> conditions are met:
>
> 1. The Key Pair does not meet the requirements set forth in Section 6.1.5
>    and/or Section 6.1.6;
>
> [...]
>
> 6.1.5 Key sizes
>
> For RSA key pairs the CA SHALL:
>
> • Ensure that the modulus size, when encoded, is at least 2048 bits, and;
> • Ensure that the modulus size, in bits, is evenly divisible by 8.
>
> For ECDSA key pairs, the CA SHALL:
>
> • Ensure that the key represents a valid point on the NIST P‐256, NIST P‐384
>   or NIST P‐521 elliptic curve.
>
> No other algorithms or key sizes are permitted.

In summary, implementing this proposal would require pushing at least two
specification changes:

1. A ballot with CA/B Forum about including Ed25519 support.
2. An update in the Onion Services v3 spec, allowing the Onion Service identity
   keys to either:
    1. Also act as Certificate Authority root keys for the service.
    2. Derive long-term (1 year) blinded keys to be used as a Certificate
       Authority for the service, maybe using the same approach described by
       Appendix A (`[KEYBLIND]`) from [rend-spec-v3.txt][] but covering the needed
       use case of a long-term key, i.e, depending in a long-term nonce and not in
       `[TIME-PERIODS]`.

It's also important to avoid using the Onion Service key directly as the HTTPS
certificate. That would:

* Expose the Onion Service secret key material to more software than it's
  needed, like a web server.
* Make it very difficult to manage offline Onion Service master keys.

Instead, it's better to use the Onion Service keypair to act as a CA that then
certifies a separate key pair to be used with HTTPS.

Similar to the self-signed certificate proposal, this approach would have
limited adoption if only as small number of applications implement it -- such
as the Tor Browser --, except if endorsed by many stakeholders in the form of a
specification -- like the SOOC proposal discussed below.

[^X25519-vs-Ed25519]: They usually just support [X25519][], which is a key agreement scheme no to be confused with [Ed25519][].
[^Ed25519-CA-support]: Check [Request For CertBot To Support The Signing of Ed25519 Certificates][]
                       and [Support Ed25519 and Ed448][] threads for details.

[Onion x509]: https://gitlab.torproject.org/ahf/onion-x509
[add support for self-signed HTTPS onion sites derived from onion service's ed25519 key]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/18696
[How do Ed5519 keys work?]: https://blog.mozilla.org/warner/2011/11/29/ed25519-keys/
[prop220]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/220-ecc-id-keys.txt
[rend-spec-v3.txt]: https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/rend-spec-v3.txt
[major web browsers still does not support]: https://security.stackexchange.com/questions/236931/whats-the-deal-with-x25519-support-in-chrome-firefox
[many TLS libraries support the ED25519 signing scheme]: https://ianix.com/pub/ed25519-deployment.html#ed25519-tls
[OpenSSL since version 1.1.1]: https://blog.pinterjann.is/ed25519-certificates.html
[X25519]: https://cryptopp.com/wiki/X25519
[Ed25519]: http://ed25519.cr.yp.to
[Request For CertBot To Support The Signing of Ed25519 Certificates]: https://community.letsencrypt.org/t/request-for-certbot-to-support-the-signing-of-ed25519-certificates/157638
[Support Ed25519 and Ed448]: https://community.letsencrypt.org/t/support-ed25519-and-ed448/69868/6

## Same Origin Onion Certificates (SOOC)

The [Same Origin Onion Certificates][] (SOOC) proposal aims to specify when "in
very limited circumstances, we shall not care about signatures at all",
allowing clients to [disable self-signed certificate warnings when visiting
.onion sites][].

The main difference between the SOOC proposal and to simply start allowing
self-signed certificates is that SOOC is aimed to be an IETF proposal that
could gain momentum and hence have a greater chance to be adopt by many
different vendors.

See [the SOOC document][] for details.

[Same Origin Onion Certificates]: https://github.com/alecmuffett/onion-dv-certificate-proposal
[disable self-signed certificate warnings when visiting .onion sites]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410
[the SOOC document]: https://docs.google.com/document/d/1xE5eaDMiOKphDxijK9tfIWHUB-h-fTG8tb3laofXLSc/edit#heading=h.dphbi0rss5tj

## DANE for .onion

Another option is to use [DNS-based Authentication of Named Entities][] (DANE),
with DNS records like this to associate an Onion Service address with a given
HTTPS certificate's public key hash:

    _443._tcp.testk4ae7qr6nhlgahvyicxy7nsrmfmhigtdophufo3vumisvop2gryd.onion. TSLA 3 1 1 AB9BEB9919729F3239AF08214C1EF6CCA52D2DBAE788BB5BE834C13911292ED9

In order for that to work, logic should be implemented in the client software.

Drawbacks:

1. Service operators must update this record whenever a new certificate is issued.
2. Has some [limits for wildcard certificates on specific ports][].
3. DANE is not widely supported, especially by web browsers.
4. It would only work for service operators willing to publish the .onion address in the DNS.

[DNS-based Authentication of Named Entities]: https://en.wikipedia.org/wiki/DNS-based_Authentication_of_Named_Entities
[limits for wildcard certificates on specific ports]: https://datatracker.ietf.org/doc/html/rfc6698#appendix-A.2.1.3

## Onion-only CAs

This proposal consists of:

1. Having .onion-only CAs with name constraints (only allowing issuance for
   .onion). Services available both via DNS-based and .onion domains will need
   to have two TLS certificates in order to use this approach -- one certificate
   for the DNS-based domain (as usual) and another only for the .onion address.
2. Certification procedure would be automated, so generated .onion addresses
   could easily have it's certificates issued by this special type of CA.
3. Certification would then happen by checking a signature in a CSR and
   comparing the Subject Alternative Name (SAN). Signature must be validated by
   the .onion address in the SAN.
4. So this type of CA would be mainly a basic notary that attests signatures and
   issues a corresponding certificate.
5. The name constraint for this type of CA ensures that it only issues
   certificates for .onion domains.

Security considerations:

* Suppose there's a malicious or bugged CA of this type that issues a
   certificate containing a SAN for `$address1.onion` but:
    1. Without checking whether the CSR has a signature made by
       `$address1.onion`'s private key.
    2. Or if allowing that another, unrelated `$address2.onion` actually signs
       this CSR.
* Even if that's the case, i.e, the CA wrongly issued a certificate for
   `$address1.onion` that did not match the requirements, this certificate
   won't work in practice, since in a successful Onion Service TLS connection
   to `$address1.onion` the following must happen:
    1. The underlying Tor Rendezvous connection should ensure that the
       client is connected to `$address1.onion` (Onion Services connections
       are self-authenticated by the .onion address).
    2. The Onion Service should then offer it's TLS certificate, which would
       not be the malicious one (except if the service is already compromised,
       but in that case the attacker would not need to forge an invalid certificate
       anyway...).
    3. Then the client's TLS library tests whether the certificate chain can be
       verified and any SAN in the presented certificate matches `$address1.onion`,
       among other checks (such as expiration).
* That said, the work done by this special type of CA is only to _expand the
  self-authentication property_ from the .onion address into a certificate. So
_the attack surface of this special type of CA may be inherently low_.

Implementation considerations:

* Since [Ed25519][] certificates probably won't be supported by major
  browsers/clients in the foreseeable future (see discussion above at the
  [Self-signed X.509 for .onion][] section), issuance should probably follow the
  Appendix B of the [CA/B Baseline Requirements][].
* The entire certification procedure could happen via Onion Services.
* Actually the whole CA infrastructure (website, APIs, OCSP etc) could be
  interacted only via Onion Services, to reduce the attack surface and protect
  the service location.
* Important to consider whether would be possible to organizations setup and
  maintain a Onion-only CA that's as most automated as possible, including root
  certificate packaging/distribution/rotation.

Pros:

1. Easy to implement on the client side (just need to install the CA).
2. Easy to implement and maintain on Tor-native applications such as Tor
   Browser and the Tor VPN.
3. Possibly lowest attack surface than with regular CAs!
4. Largest certification expiration dates could be used (like one year).

Cons:

1. Might not be easy to find CAs willing to do this, or to a new one to be
   formed for this purpose.
2. Might need a merge request to include this method in the [CA/B Baseline
   Requirements][], if wider acceptance is intended.
3. No guarantees that these special CAs would be installed among all clients
   and libraries.
4. Need additional security analysis.

Open questions:

0. Need to check if [Certificate Revocation Lists (CRLs)][] are needed,
   and how to handle it.
1. Need to figure out how [OCSP][] and [OCSP Stapling][] could happen. OSCP
   connection could be available behind an Onion Service.
2. Does sending certificates to [CT Logs][] still makes sense for this special
   type of certification?
3. Needs built-in DoS/service abuse protection:
    * An idea for that: implement a simple PoW by additionally requiring that
      service operators provide a proof-ownership of another .onion address
      made by an specific vanity address (like limited to 5 or 6 chars).

References:

* [Proposal for Bring Accessible TLS Supports to All Onion Services][], where
  this idea is initially written and discussed with the possibility for some
  clients to have _only_ this type of CA installed (but in that case it might
  not accept valid certificates issued by regular CAs, with advantages and
  disadvantages)

[Certificate Revocation Lists (CRLs)]: https://en.wikipedia.org/wiki/Certificate_revocation_list
[OCSP]: https://en.wikipedia.org/wiki/Online_Certificate_Status_Protocol
[OCSP Stapling]: https://en.wikipedia.org/wiki/OCSP_stapling
[CT Logs]: https://certificate.transparency.dev/
[Self-signed X.509 for .onion]: self-signed-x509-for-onion-self-signed-by-the-onion-address
[Proposal for Bring Accessible TLS Supports to All Onion Services]: https://gitlab.torproject.org/tpo/core/torspec/-/issues/171

## Further references

### Meeting notes

* [IntegratingOnions](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Montreal/Notes/IntegratingOnions)
  from [2017 Montreal Meeting](https://gitlab.torproject.org/tpo/team/-/wikis/meetings/2017/2017Montreal/).

### Blog posts

* [Facebook, hidden services, and https certs | The Tor Project](https://blog.torproject.org/facebook-hidden-services-and-https-certs/):
    * Part four: what do we think about an https cert for a .onion address?
    * Part five: What remains to be done?

### Related issues

* [.onion indicator for non-self-signed but non-trusted sites (#27636) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/27636)

## Notes
