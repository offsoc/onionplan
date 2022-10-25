# Onion Plan: Health Roadmap DRAFT Proposal - v2022.Q4

[[_TOC_]]

## DoS defenses

* Focus on needed develop to mitigate DoS.
* Needs input from the Network Team for what can be included here.
* Might include deliverables from the "Onion Services resource coalition"
  project.

## Performance improvements

* Needs input from the Network Team for what can be included here.

## Metrics

* Needs input from the Network Health Team for what can be included here.

## Relevant DoS-related issues

* [Design a PoW scheme for HS DoS defence (#134) · Issues · The Tor Project / Core / Tor Specifications · GitLab](https://gitlab.torproject.org/tpo/core/torspec/-/issues/134 "Design a PoW scheme for HS DoS defence")
* [prop327: Implement PoW over Introduction Circuits (#40634) · Issues · The Tor Project / Core / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/40634 "prop327: Implement PoW over Introduction Circuits")
* [Understand code performance of onion services under DoS (#33704) · Issues · The Tor Project / Core / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/33704 "Understand code performance of onion services under DoS")
* [Research  approaches for improving the availability of services under DoS  (#31223) · Issues · The Tor Project / Core / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/31223 "Research approaches for improving the availability of services under DoS")
* [attacker can force intro point rotation by ddos (#26294) · Issues · The Tor Project / Core / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/26294 "attacker can force intro point rotation by ddos")
* [DoS resistence measures from C tor (#351) · Issues · The Tor Project / Core / Arti · GitLab](https://gitlab.torproject.org/tpo/core/arti/-/issues/351 "DoS resistence measures from C tor")

Check also the [Onion Service DoS issue
queue](https://gitlab.torproject.org/groups/tpo/-/issues/?sort=created_date&state=opened&label_name%5B%5D=DoS&label_name%5B%5D=Onion%20Services&first_page_size=20).

## Non DoS-related health improvements for Onion Services

Fixes:

* [Make it even harder to become HSDir (#19162) · Issues · The Tor Project / Core / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/19162 "Make it even harder to become HSDir")
* [We should make HSv3 desc upload less frequent (#163) · Issues · The Tor Project / Core / Tor Specifications · GitLab](https://gitlab.torproject.org/tpo/core/torspec/-/issues/163 "We should make HSv3 desc upload less frequent")
* [Tor  node that is not part of the consensus should not be used as rendezvous  point with the onion service (#33129) · Issues · The Tor Project / Core  / Tor · GitLab](https://gitlab.torproject.org/tpo/core/tor/-/issues/33129 "Tor node that is not part of the consensus should not be used as rendezvous point with the onion service")
* [hs: Do not allow more than one control cell on a circuit (#157) · Issues · The Tor Project / Core / Tor Specifications · GitLab](https://gitlab.torproject.org/tpo/core/torspec/-/issues/157 "hs: Do not allow more than one control cell on a circuit")

Features, probably only for [arti](https://gitlab.torproject.org/tpo/core/arti/):

* [\[Feature  proposal\] Verification of onion service integrity (#41041) · Issues ·  The Tor Project / Applications / Tor Browser · GitLab](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41041 "[Feature proposal] Verification of onion service integrity")
* [Proposal: Hidden Service Revocation (#87) · Issues · The Tor Project / Core / Tor Specifications · GitLab](https://gitlab.torproject.org/tpo/core/torspec/-/issues/87 "Proposal: Hidden Service Revocation")
* ['Hidden' Authenticatd Onion Services (#119) · Issues · The Tor Project / Core / Tor Specifications · GitLab](https://gitlab.torproject.org/tpo/core/torspec/-/issues/119 "'Hidden' Authenticatd Onion Services")
* [prop224: Implement offline keys for v3 onion services (#29054)](https://gitlab.torproject.org/tpo/core/tor/-/issues/29054 "prop224: Implement offline keys for v3 onion services")

## References

* [Proposal 327: A First Take at PoW Over Introduction Circuits](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt).
