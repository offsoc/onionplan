# Network Layer Roadmap

* Status: DRAFT
* Version: v2023.Q2

## Index

[TOC]

## DoS defenses

### The problem

* [Tor is slow right now. Here is what is happening. | The Tor Project](https://blog.torproject.org/tor-network-ddos-attack/)

### Proposal 327

About:

* [proposals/327-pow-over-intro.txt · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt)
* [Proposal: A First Take at PoW Over Introduction Circuits](https://lists.torproject.org/pipermail/tor-dev/2020-April/014215.html)

Status:

* Implemented on Tor 0.4.8.1-alpha as part of the "Onion Services resource
  coalition" sponsored work.
* Mobile clients may not be able to solve fast enough (maybe only the high end
  will). Needs more discussion on how PoW would impact legitimate mobile users
  during an ongoing DoS.

### Relevant DoS-related issues

* [Design a PoW scheme for HS DoS defence (#134) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/134)
* [prop327: Implement PoW over Introduction Circuits (#40634) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40634)
* [Understand code performance of onion services under DoS (#33704) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33704)
* [Research  approaches for improving the availability of services under DoS  (#31223) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/31223)
* [attacker can force intro point rotation by ddos (#26294) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/26294)
* [DoS resistence measures from C tor (#351) · Arti](https://gitlab.torproject.org/tpo/core/arti/-/issues/351)

## Performance improvements

* Needs input from the Network Team for what can be included here.

## Metrics

* Needs input from the Network, Network Health and Metrics Teams for what can be included here.

## Non DoS-related health improvements for Onion Services

Fixes:

* [Make it even harder to become HSDir (#19162) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/19162)
* [We should make HSv3 desc upload less frequent (#163) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/163)
* [Tor  node that is not part of the consensus should not be used as rendezvous  point with the onion service (#33129) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/33129)
* [hs: Do not allow more than one control cell on a circuit (#157) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/157)
* [Long circuit build times when connecting to onion services (#40570) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/40570)

Features, probably only for [arti](https://gitlab.torproject.org/tpo/core/arti/):

* [Verification of onion service integrity (#41041) · Tor Browser](https://gitlab.torproject.org/tpo/applications/tor-browser/-/issues/41041)
* [Proposal: Hidden Service Revocation (#87) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/87)
* ['Hidden' Authenticatd Onion Services (#119) · Tor Specifications](https://gitlab.torproject.org/tpo/core/torspec/-/issues/119)
* [prop224: Implement offline keys for v3 onion services (#29054) · Tor](https://gitlab.torproject.org/tpo/core/tor/-/issues/29054)

## Onion Service support in Arti

See Arti's [1.1.3](https://blog.torproject.org/arti_113_released/) and
[1.1.4](https://blog.torproject.org/arti_114_released/) release notes.

## Relevant issue boards

* [Onion Services in general](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services)
* Onion Services performance issues:
    * [Performance Impact](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=Performance%20Impact)
    * [Performance](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=Performance)
    * [DoS](https://gitlab.torproject.org/groups/tpo/-/boards?label_name[]=Onion%20Services&label_name[]=DoS)

## References

* [Proposal 327: A First Take at PoW Over Introduction Circuits](https://gitlab.torproject.org/tpo/core/torspec/-/blob/main/proposals/327-pow-over-intro.txt).
