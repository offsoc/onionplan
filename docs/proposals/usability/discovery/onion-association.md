# Onion Association

Onion Association proposals are those which basically links a "traditional"
(i.e, DNS-based) domain names with an Onion Service address. Linkage can be
uni or bi-directional.

They might also be referred here as "Traditional Address Translation", to
distinguish then from [Onion Names](onion-names.md).

## Opportunistic discoverability

See [this discussion][] for an example about how opportunistic service
discovery could work.

[this discussion]: https://rhatto.pages.torproject.net/sauteed-week/discovery/

## Transparent versus non-transparent

One question about address translation is whether they should be transparent or
not to the user:

* Shall it be non-transparent, requiring user intervention and indicating that
  an Onion Service is available?
* Or shall it be transparent, automatically redirecting the user to the .onion
  counterpart, at least when the regular address is not available?

Some of the current proposals are non-transparent (Onion-Location, Sauteed
Onions), while others are transparent (Alt-Svc). It's mostly an UX decision
here which does not impact in the core idea of each proposal.

For the transparent address translation, it's important to consider @richard's
remark about having a way to signal to the application that the connection is
encrypted e2e (for websites that are HTTP on an onion service vs HTTP clearnet
websites). Browser cares about this to warn users about mixed-mode content,
whether the page is "secure" etc.

## Overview

Method              | Technology  | Status                            | Main properties
--------------------|-------------|-----------------------------------|---------------------------------
[Onion-Location][]  | HTTP, HTML  | Implemented, officially supported | Usability; easy deployment
[Alt-Svc][]         | HTTP        | Implemented, fully supported      | Transparency
DNS-based discovery | DNS         | Research                          | Ubiquity
[Sauteed Onions][]  | CT Logs     | Research                          | Censorship resistance; usability

## Main properties

Property                       | [Onion-Location][] | [Alt-Svc][] | DNS-based | [Sauteed Onions][]
-------------------------------|--------------------|-------------|-----------|----------------------------
Privacy-enhanced queries       | Yes                | ?           | Yes       | Yes
Self-authentication            | No                 | No          | TBD       | Not in the current proposal
Censorship resistance          | No                 | No          | Some      | Yes
Human-friendliness             | No                 | Yes         | Yes       | Yes
Discoverability                | Yes                | Yes         | Yes       | Yes
Anonymity                      | ?                  | ?           | ?         | ?
Hijacking resistance           | ?                  | ?           | ?         | ?
State on client system         | ?                  | ?           | ?         | ?
Usable                         | Yes                | Yes         | Yes       | Yes

## HTTP Header-based

Where a service announces by some way it's alternative Onion Service address,
like with a HTTP Header (or an HTML meta tag in some cases).

The idea here is that a regular site can announce it's .onion version when
it's offering content to a client.

### Onion-Location

The [Onion-Location][] method was introduced on [Tor Browser 9.5][] as a way
for service operators announce their Onion Services in their regular HTTPS
sites. It's specified under [tor-browser-spec][]'s [Proposal 100][] -
"Onion redirects using Onion-Location HTTP header". The [ticket about
implementing Onion-Location][] also has important discussions about this
specific approach as well as servide discovery in general.

Service discovery happens in the HTTP level, either as an HTTP Header or as an
HTML `<meta>` tag. This means that users need first to access the regular site
in order to discover the .onion address.

In the case of the [Tor Browser][], a special user interface indication show
the available Onion Service address when this is provided by the site, which
allows users to upgrade do the Onion Service version. It's also possible to
configure [Tor Browser][] to automatically upgrade the connection to it's
corresponding Onion Service when the [Onion-Location][] information is
available.

[Onion-Location]: https://community.torproject.org/onion-services/advanced/onion-location/
[Tor Browser 9.5]: https://www.torproject.org/releases/tor-browser-95/
[Tor Browser]: https://tb-manual.torproject.org/
[tor-browser-spec]: https://gitlab.torproject.org/tpo/applications/tor-browser-spec
[Proposal 100]: https://gitlab.torproject.org/tpo/applications/tor-browser-spec/-/blob/main/proposals/100-onion-location-header.txt
[ticket about implementing Onion-Location]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/21952

### Alt-Svc

Similar to [Onion-Location][], the [Alt-Svc][] method also uses an HTTP Header
(the [Alt-Svc Header][]), which means that the user first need to access the
regular site before their browser discovers the alternate Onion Service
address.

But contrary to [Onion-Location][], the [Alt-Svc][] method:

1. Does not support an HTML tag, as it relies entirely in the [Alt-Svc Header][].
2. Is fully transparent: all the discovery and upgrade happens automatically,
   without user intervention.

[Alt-Svc]: https://blog.cloudflare.com/cloudflare-onion-service/
[Alt-Svc Header]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Alt-Svc

## DNS or DNSSEC-based

Another approach for associating regular domains with their .onion counterparts
is to use the Domain Name System (DNS) ([RFC 1035][]) directly and to
optionally take advantage of DNSSEC.

### Using HTTPS records

[RFC 9460][] (from [draft-ietf-dnsop-svcb-https-12][]) introduces a "Service
binding and parameter specification via the DNS (DNS SVCB and HTTPS RRs)".
In other words, it specifies a new [DNS resource record called HTTPS][] that
allows service operators add entries in the DNS specifying various parameters
relates to TLS connections, like those currently done via [HTTP Strict
Transport Security (STS)][].
Check [this article][] for an introduction and [this one][] for an overview
about the HTTPS RRs security benefits and attack surface.

This standard opens the possibility to [use HTTPS records for
Onion Services][] in a way that clients such as Tor Browser to establish HTTPS
connections directly to Onion Services in a transparent way: users would still
be presented to the regular domain name of a service (such as `torproject.org`)
but Tor-capable clients would automatically and transparently upgrade the
connection to the Onion Service version, similar to what the [Alt-Svc][] method
does.

#### Advantages

The advantages of the HTTPS DNS record over the [Alt-Svc][] method are:

1. Service operators would need only to add the `HTTPS` resource record in
   their DNS zone, without the need to change their existing web applications
   to include an [Alt-Svc Header][] in the HTTP responses.
2. TLS connections could benefit from [TLS Encrypted Client Hello (ECH)][] as a
   way of hiding the domain request from a passive adversary when establishing
   connections to remote endpoints. But note that, as of 2024-08, ECH is
   still a draft proposal (although) it's already being [pushed hard and deployed by vendors][]

[TLS Encrypted Client Hello (ECH)]: https://datatracker.ietf.org/doc/draft-ietf-tls-esni/
[pushed hard and deployed by vendors]: https://blog.cloudflare.com/encrypted-client-hello/

#### Disadvantages

As of 2024-08, it seems like major web browsers require queries to be done
through [DNS-over-HTTPS (DoH)][] in other to look for this field. But this
might lead to additional centralization, since [DoH is not widely deployed yet][]
and browsers might come with just a few DoH server options by default.

This is discussed in more detail at:

* [Support Encrypted Client Hello (#42144) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/42144)
* [Think about using DNS over HTTPS for Tor Browser (#30753) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/30753)

[DNS-over-HTTPS (DoH)]: https://en.wikipedia.org/wiki/DNS_over_HTTPS
[DoH is not widely deployed yet]: https://dnsprivacy.org/public_resolvers/#dns-over-https-doh

#### Support

This specification is recent and not all client support may be supporting it,
although the [use of HTTPS resource records][] is increasing.

Firefox support, and hence potential Tor Browser support:

* Recent versions already [shows HTTPS RRs in about:networking][] (added in [this commit][]).
* HTTPS resolution was added on [Firefox 92][]. Related tickets:
    * [1623126 - Implement HTTPSSVC](https://bugzilla.mozilla.org/show_bug.cgi?id=1623126)
    * [1721132 - Enabling HTTPS RR on release](https://bugzilla.mozilla.org/show_bug.cgi?id=1721132)
* But as of March 2024, it seems [only to work through DNS over HTTPS (DoH)][].
* Check [tpo/applications/tor-browser#30753][] about enabling DoH in Tor
  Browser, including benefits and downsides.

Chrome, in the other hand, [seems not to be fully supporting it][], which can
make adoption harder for clients such as [Brave][]. But Safari seems to be
fully supporting it, which means [WebKit][] is probably supporting it, paving
the way for [Onion Browser][] support it as well.

#### Further discussion

Check the [Specs for DNS-based .onion records][] appendix for a detailed
discussion.

[RFC 9460]: https://www.rfc-editor.org/rfc/rfc9460.html
[RFC 1035]: https://datatracker.ietf.org/doc/html/rfc1035
[draft-ietf-dnsop-svcb-https-12]: https://datatracker.ietf.org/doc/draft-ietf-dnsop-svcb-https/12/
[use HTTPS records for Onion Services]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41325
[DNS resource record called HTTPS]: https://developer.mozilla.org/en-US/docs/Glossary/https_rr
[HTTP Strict Transport Security (STS)]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
[this article]: https://www.sobyte.net/post/2022-01/dns-svcb-https/#https-records-overview
[this one]: https://emilymstark.com/2020/10/24/strict-transport-security-vs-https-resource-records-the-showdown.html
[shows HTTPS RRs in about:networking]: https://bugzilla.mozilla.org/show_bug.cgi?id=1667356
[this commit]: https://hg.mozilla.org/integration/autoland/rev/c0e399e7d495
[use of HTTPS resource records]: https://blog.apnic.net/2023/12/18/use-of-https-resource-records/
[Firefox 92]: https://developer.mozilla.org/en-US/docs/Mozilla/Firefox/Releases/92#http
[only to work through DNS over HTTPS (DoH)]: https://serverfault.com/questions/1151933/how-does-a-web-browser-use-a-https-or-svcb-dns-resource-record-rr
[tpo/applications/tor-browser#30753]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/30753
[seems not to be fully supporting it]: https://github.com/Fyrd/caniuse/issues/6091#issuecomment-1819649621
[Brave]: https://brave.com
[WebKit]: https://webkit.org
[Onion Browser]: https://onionbrowser.com

### Specific Onion Service DNS entry

Another way to include Onion Services addresses into the DNS is to standardize
by either:

1. Have a custom Onion Service DNS resource record (like `ONION`).
2. Use the `TXT` record as stated by [RFC 1464][].
3. Use the `SRV` record ([RFC 2782][]).

In any case, currently there seems to be no formal proposal to standardize this
method.

Check the [Specs for DNS-based .onion records][] appendix for a detailed
discussion.

[RFC 1464]: https://www.rfc-editor.org/rfc/rfc1464
[RFC 2782]: https://datatracker.ietf.org/doc/html/rfc2782
[Specs for DNS-based .onion records]: ../../../appendixes/dns.md

## Certificate Transparency (CT Logs) based

[Certificate Transparency][] (CT) is a system compose of many append-only TLS
certificate logs as a way to audit the issuance of digital certificates.

These logs may however be monitored for other purposes, such as to discover
domains and services. With some additional conventions, CT Logs can be used
to establish links between traditional domain names and Onion Service addresses.

[Certificate Transparency]: https://certificate.transparency.dev/

#### Sauteed Onions

The [Sauteed Onions][] proposals is such a method to link regular domains with
Onion Services. It relies on custom DNS entries, CA issued certificates and
[Certificate Transparency][] (CT) Logs:

* [Sauteed Onions][] project page.
* [Sauteed Onions draft paper](https://www.sauteed-onions.org/doc/paper.pdf).
* [Sauteed Onions GitLab group](https://gitlab.torproject.org/tpo/onion-services/sauteed-onions)
  with reference implementations.
* [Sauteed Week](https://rhatto.pages.torproject.net/sauteed-week/)
  ([repository](https://gitlab.torproject.org/rhatto/sauteed-week)),
  a 2022 Tor Hackweek project researching and discussing the proposal.
* [satalite.org/db/index](https://www.satalite.org/db/index): a sample CT Logs database dump.
* [crt.sh | www.sauteed-onions.org](https://crt.sh/?q=www.sauteed-onions.org):
  CT Logs query of an existing sauteed onions certificate.
* [Example Sauteed Onions API Query](https://api.sauteed-onions.org/search?in=blocked.sauteed-onions.org).
* [Attacks on Onion Discovery and Remedies via Self-Authenticating Traditional Addresses](https://dl.acm.org/doi/10.1145/3463676.3485610)
* Check also [TPA issue](https://gitlab.torproject.org/tpo/tpa/team/-/issues/40677) about how to monitor CT Logs.

One of the main advantages of [Sauteed Onions][] over other traditional address
translation techniques is that it may offer additional protection against
internet censorship, as it may be harder to block CT Logs (as they tend to be a
requirement in order to browsers function properly) than the DNS or any site.

[Sauteed Onions]: https://www.sauteed-onions.org
