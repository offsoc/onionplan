# Usability Roadmap - Certificates

* Status: DRAFT
* Version: v2023.Q2

## Index

[TOC]

## Executive Summary

1. All existing [certificate proposals][] are non-conflicting!
2. That means they could be pursued in parallel, so there's no block in here
   for people wishing to invest on any.
3. What _is_ limited though:
    1. Each proposal feasibility.
    2. Available resources.
    3. Results.
4. Then some prioritization/decision is needed.
5. This document presents a summarized comparison between proposals.
6. This needs further review and discussion.

[certificate proposals]: ../1%20-%20Proposals/Usability/Certification.md

## Development cycle

Development can be split into the following levels:

1. Engineering: work to implement the proposal at the client side in various
   places (clients, libraries, standards etc).
2. Operation: work to implement the proposal at the server side (i.e, the
   certification infrastructure where issuance happens, if applicable).
3. Governance: what takes to bring the implementation upstream or to be widely
   adopted.

Level requirement:

* While some proposals might need all three to be successful, some might only
  need engineering and governance work.
* Proposals that are only engineered may remain in a prototype stage.

## Effort

Effort estimates the amount of work involved for each level.

Proposal                              | Engineering effort       | Operation effort        | Governance effort       | Overall assessment
--------------------------------------|--------------------------|-------------------------|-------------------------|--------------------
Existing CA validation                | None (already done)      | None (already there)    | None (already done)     | None
ACME for .onion                       | High                     | Medium                  | High                    |
Self-signed X.509 for .onion          | Very High                | None                    | Very High               |
Same Origin Onion Certificates (SOOC) | High                     | None                    | Very High               |
DANE for .onion                       | High                     | None                    | Very High               |
Onion-only CAs                        | Low                      | High                    | High                    |

## Challenge

Estimate the difficulty in solving open questions while implementing a given proposal.

Proposal                              | Engineering challenge    | Operation challenge     | Governance challenge    | Overall assessment
--------------------------------------|--------------------------|-------------------------|-------------------------|--------------------
Existing CA validation                | None (already done)      | None (already there)    | None (already done)     | None
ACME for .onion                       | Low                      | Low                     | Medium (adoption)       |
Self-signed X.509 for .onion          | High                     | None                    | High                    |
Same Origin Onion Certificates (SOOC) | Low                      | None                    | High                    |
DANE for .onion                       | Low                      | None                    | High                    |
Onion-only CAs                        | High                     | High                    | High                    |

## Risk

Estimates the risk involved in the proposal not be successfully implemented in a given level.

Proposal                              | Engineering risks        | Operation risks         | Governance risks        | Overall assessment
--------------------------------------|--------------------------|-------------------------|-------------------------|--------------------
Existing CA validation                | None (already done)      | None (already there)    | None (already done)     | None
ACME for .onion                       | Low                      | Low                     | Medium                  |
Self-signed X.509 for .onion          | High                     | None                    | ?                       |
Same Origin Onion Certificates (SOOC) | Low                      | None                    | ?                       |
DANE for .onion                       | High                     | None                    | ?                       |
Onion-only CAs                        | Low                      | Medium                  | ?                       |

## Requirements and prioritizations

1. Prioritize what can be done without client or library modifications, as
   these are harder to implement, maintain, upstream and standardize.
2. Consider the _paths of least resistance_ when pursuing a solution.

## Enhancements for the Tor Browser

Additionally to implementing new methods for HTTPS certification, users could
benefit from Tor Browser improvements in the UI widgets responsible for
displaying connection security information.

#### Enhanced User Interface (UI) indicators

Announcing that a connection "is secure" can have ambiguous meanings depending
on how it's presented. Maybe it will be intrinsically ambiguous if presented by
a single piece of user interface, since at this level the user can't know if
the "connection is secure" because of the Onion Service connection and also for
the additional HTTPS connection:

1. The Onion Service connection is kind of _self-authenticating_ since the
   public key and the URL are tied together and the connection is peer-to-peer
   encrypted. But at the same time _it's not self-authenticating_ since there's no
   intrinsic way to authenticate the onionsite with the entity it declares to
   represent. This further authentication needs to be done externally, with
   many existing ways.

2. In the other hand, HTTPS certificates use an entirely different model of
   Certificate Authority-based authentication, where an authenticated
   relationship is established between the site and a DNS-based name -- or
   sometimes also with legal documents in case of Extended Validation (EV)
   certs are used. A TLS connection is also peer-to-peer encrypted, but the
   authentication is somehow "external" and "hierarchical" (in the sense that it
   depends on an external and hierarchical chain of trust implemented with
   built-in Certificate Authorities keys in a browser).

While each model works satisfactorily well on their application domains, mixing
both together in a single bit of UX may generate different, often ambiguous
interpretations.

### Different scenarios

As pointed by [this comment about previously-tested scenarios][], some
additional results could be considered to expand the [current behavior][], like
the following:

Scenario Name                        | Result
-------------------------------------|------------------------------------------
HTTP  Onion                          | Onion Icon
HTTPS Onion Self-Signed              | Onion Icon + connection security details
HTTPS Onion Self-Signed [SOOC][]     | Onion Icon + connection security details
HTTPS Onion Unknown CA               | Onion Icon + connection security details
HTTPS Onion EV                       | Onion Icon + EV Name
HTTPS Onion Wrong Domain             | Onion Warning Icon, Warning Splash Screen
HTTPS Onion Expired Self-Signed Cert | Onion Warning Icon, Warning Splash Screen
HTTP(S) Onion + HTTP  Script         | Onion Slash Icon
HTTP(S) Onion + HTTP  Content        | Onion Warning Icon
HTTP(S) Onion + HTTPS Content        | Onion Icon
HTTPS   Onion + HTTP  Form           | Onion Icon + Warning Popup on Form Submit

Perhaps the Onion Icon could be customized to have a different appearance
according to the scenario.

It's also important to discuss whether to [disable self-signed certificate
warnings when visiting .onion sites][], considering the consequences for the
choice, as certificates are important to authenticate that a site really
belongs to the expected peer etc.

[current behavior]: https://support.torproject.org/onionservices/onionservices-5/
[SOOC]: https://github.com/alecmuffett/onion-dv-certificate-proposal/blob/master/text/draft-muffett-same-origin-onion-certificates.txt
[this comment about previously-tested scenarios]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410#note_2616846
[disable self-signed certificate warnings when visiting .onion sites]: https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/13410
