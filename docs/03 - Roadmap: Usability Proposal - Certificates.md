# Onion Plan: Usability Roadmap - Certificates DRAFT Proposal - v2022.Q4

[[_TOC_]]

## Summary

1. All existing [certificate proposals][] are non-conflicting!
2. That means they could be pursued in parallel, so there's no block in here
   for people whishing to invest on any.
3. What _is_ limited though:
    1. Each proposal feasibility.
    2. Available resources.
    3. Results.
4. Then some prioritization/decision is needed.
5. This document presents is a summarized comparison between proposals.
6. This needs further review and discussion.

[certificate proposals]: https://gitlab.torproject.org/tpo/onion-services/onion-support/-/wikis/Documentation/OnionPlan/Usability/Certification

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
